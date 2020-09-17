Require Import coqutil.Z.Lia.
Require Import coqutil.Word.Naive.
Require Import coqutil.Word.Properties.
Require Import coqutil.Z.HexNotation. Require Coq.Strings.String. Open Scope string_scope.
Require Import Coq.Lists.List. Import ListNotations.
Require Import riscv.Utility.InstructionCoercions. Open Scope ilist_scope.
Require Import riscv.Spec.Machine.
Require Import riscv.Spec.Decode.
Require Import riscv.Spec.PseudoInstructions.
Require Import riscv.Utility.RegisterNames.
Require Import Coq.ZArith.BinInt.
Require Import riscv.Utility.Utility.
Require Import riscv.Platform.Memory.
Require Import riscv.Platform.MinimalCSRsDet.
Require Import riscv.Platform.Run.
Require Import riscv.Utility.Monads.
Require Import riscv.Utility.MonadNotations.
Require Import riscv.Utility.MkMachineWidth.
Require Import riscv.Utility.Encode.
Require Import coqutil.Map.Interface.
Require Import riscv.Utility.Words32Naive.
Require Import riscv.Utility.DefaultMemImpl32.
Require Import coqutil.Map.Z_keyed_SortedListMap.
Require Import riscv.Utility.ExtensibleRecords. Import HnatmapNotations. Open Scope hnatmap_scope.
Require coqutil.Map.SortedList.
Require Import riscv.Platform.LogInstructionTrace.

(* note: these numbers must fit into a 12bit immediate, and should be small if we want to simulate
   execution inside Coq *)
Definition main_start: Z := 0.
Definition handler_start: Z := 32.
Definition handler_stack_start: Z := 512.
Definition heap_start: Z := 640.

(* mem[heap_start+8] := mem[heap_start] * mem[heap_start+4] *)
Definition main_insts := [[
  Lw t1 zero heap_start;
  Lw t2 zero (heap_start+4);
  Mul t3 t1 t2;
  Sw zero t3 (heap_start+8)
]].

(* a3 := a1 * a2
   without using mul, but with a naive loop:
   a3 := 0;
   while (0 != a1) {
     a3 := a3 + a2;
     a1 := a1 - 1;
   } *)
Definition softmul_insts := [[
  Addi a3 zero 0;
  Beq zero a1 16;
  Add a3 a3 a2;
  Addi a1 a1 (-1);
  J (-12)
]].

(* We also save the constant register 0 on the stack, so that we can conveniently index into an
   array of all registers *)
Definition all_reg_names: list Register := List.unfoldn (Z.add 1) 32 0.

Definition save_regs_insts(addr: Z) :=
  @List.map Register Instruction (fun r => Sw zero r (addr + 4 * r)) all_reg_names.
Definition restore_regs_insts(addr: Z) :=
  @List.map Register Instruction (fun r => Lw r zero (addr + 4 * r)) all_reg_names.

(* TODO write encoder (so far there's only a decoder called CSR.lookupCSR) *)
Definition MTVal: MachineInt := 835.
Remark MTVal_correct: CSR.lookupCSR MTVal = CSR.MTVal. reflexivity. Qed.
Definition MEPC: MachineInt := 833.
Remark MEPC_correct: CSR.lookupCSR MEPC = CSR.MEPC. reflexivity. Qed.

Definition handler_insts :=
  save_regs_insts handler_stack_start ++ [[
  Csrr t1 MTVal                    ; (* t1 := the invalid instruction i that caused the exception *)
  Srli t1 t1 5                     ; (* t1 := t1 >> 5                                             *)
  Andi s3 t1 (31*4)                ; (* s3 := i[7:12]<<2   // (rd of the MUL)*4                   *)
  Srli t1 t1 8                     ; (* t1 := t1 >> 8                                             *)
  Andi s1 t1 (31*4)                ; (* s1 := i[15:20]<<2  // (rs1 of the MUL)*4                  *)
  Srli t1 t1 5                     ; (* t1 := t1 >> 5                                             *)
  Andi s2 t1 (31*4)                ; (* s2 := i[20:25]<<2  // (rs2 of the MUL)*4                  *)
  Lw a1 s1 handler_stack_start     ; (* a1 := stack[s1]                                           *)
  Lw a2 s2 handler_stack_start       (* a2 := stack[s2]                                           *)
  ]] ++ softmul_insts ++ [[          (* a3 := softmul(a1, a2)                                     *)
  Sw s3 a3 handler_stack_start       (* stack[s3] := a3                                           *)
  ]] ++ restore_regs_insts handler_stack_start ++ [[
  Csrr t1 MEPC                     ;
  Addi t1 t1 4                     ;
  Csrw t1 MEPC                     ; (* MEPC := MEPC + 4                                          *)
  Mret
  ]].

Definition input1: Z := 5.
Definition input2: Z := 13.

Definition initial_datamem: Mem := Eval vm_compute in
      let m := map.of_tuple (Memory.footprint (word.of_Z handler_stack_start) 300)
                            (HList.tuple.unfoldn id 300 Byte.x00) in
      let m := unchecked_store_bytes 4 m (word.of_Z heap_start) (LittleEndian.split 4 input1) in
      unchecked_store_bytes 4 m (word.of_Z (heap_start+4)) (LittleEndian.split 4 input2).

Definition putProgram(m: Mem)(addr: Z)(prog: list Instruction): Mem :=
  unchecked_store_byte_list (word.of_Z addr) (RiscvMachine.Z32s_to_bytes (List.map encode prog)) m.

Definition initial_mem: Mem := Eval vm_compute in
  putProgram (putProgram initial_datamem main_start main_insts) handler_start handler_insts.

Definition FieldNames: natmap Type := MinimalCSRsDet.Fields (natmap.put nil exectrace ExecTrace).

Definition State: Type := hnatmap FieldNames.

Notation Registers := (@SortedList.rep (Zkeyed_map_params (@Naive.rep 32))).

Definition initial_regs: Registers :=
  map.of_tuple (HList.tuple.unfoldn (Z.add 1) 31 1) (HList.tuple.unfoldn id 31 (word.of_Z 0)).

Definition initial_state: State := HNil
  [regs := initial_regs]
  [pc := word.of_Z 0]
  [nextPc := word.of_Z 4]
  [mem := initial_mem]
  [log := nil]
  [csrs := map.put map.empty CSRField.MTVecBase (handler_start/4)]
  [exectrace := nil].

Instance IsRiscvMachine: RiscvProgram (StateAbortFail State) word :=
  AddExecTrace FieldNames (MinimalCSRsDet.IsRiscvMachine FieldNames).

(* success flag * final state *)
Fixpoint run(fuel: nat)(s: State): bool * State :=
  match fuel with
  | O => (true, s)
  | S fuel' => match Run.run1 RV32I s with
               | (Some _, s') => run fuel' s'
               | (None, s') => (false, s')
               end
  end.

Definition trace(fuel: nat): bool * ExecTrace :=
  match run fuel initial_state with
  | (isSuccess, final) => (isSuccess, final[exectrace])
  end.

(* fails, but that's excpected because it runs past the last instruction of main into unmapped memory
Eval vm_compute in trace 1000. *)

Goal Memory.loadWord initial_state[mem] (word.of_Z (heap_start+8)) = Some (LittleEndian.split 4 0).
Proof. reflexivity. Qed.

Goal Memory.loadWord initial_state[mem] (word.of_Z (heap_start+8)) =
     Some (LittleEndian.split 4 0).
Proof. reflexivity. Qed.

Goal Memory.loadWord (snd (run 1000 initial_state))[mem] (word.of_Z (heap_start+8)) =
     Some (LittleEndian.split 4 (input1 * input2)).
Proof. vm_compute. reflexivity. Qed.
