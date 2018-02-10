(* Need to define MachineInt = Int64? Int32 *)
(* Need to define Register *)
Require Import Coq.Bool.Sumbool.
Require Import Coq.omega.Omega.
Require Import bbv.WordScope.
Require Import riscv.Decidable.
Require Import bbv.DepEqNat.
Require Import riscv.RiscvBitWidths.

Definition opcode_LOAD      := WO~0~0~0~0~0~1~1.
Definition opcode_LOAD_FP   := WO~0~0~0~0~1~1~1.
Definition opcode_MISC_MEM  := WO~0~0~0~1~1~1~1.
Definition opcode_OP_IMM    := WO~0~0~1~0~0~1~1.
Definition opcode_AUIPC     := WO~0~0~1~0~1~1~1.
Definition opcode_OP_IMM_32 := WO~0~0~1~1~0~1~1.
Definition opcode_STORE     := WO~0~1~0~0~0~1~1.
Definition opcode_STORE_FP  := WO~0~1~0~0~1~1~1.
Definition opcode_AMO       := WO~0~1~0~1~1~1~1.
Definition opcode_OP        := WO~0~1~1~0~0~1~1.
Definition opcode_LUI       := WO~0~1~1~0~1~1~1.
Definition opcode_OP_32     := WO~0~1~1~1~0~1~1.
Definition opcode_MADD      := WO~1~0~0~0~0~1~1.
Definition opcode_MSUB      := WO~1~0~0~0~1~1~1.
Definition opcode_NMSUB     := WO~1~0~0~1~0~1~1.
Definition opcode_NMADD     := WO~1~0~0~1~1~1~1.
Definition opcode_OP_FP     := WO~1~0~1~0~0~1~1.
Definition opcode_BRANCH    := WO~1~1~0~0~0~1~1.
Definition opcode_JALR      := WO~1~1~0~0~1~1~1.
Definition opcode_JAL       := WO~1~1~0~1~1~1~1.
Definition opcode_SYSTEM    := WO~1~1~1~0~0~1~1.
Definition funct3_LB  := WO~0~0~0.
Definition funct3_LH  := WO~0~0~1.
Definition funct3_LW  := WO~0~1~0.
Definition funct3_LD  := WO~0~1~1.
Definition funct3_LBU := WO~1~0~0.
Definition funct3_LHU := WO~1~0~1.
Definition funct3_LWU := WO~1~1~0.
Definition funct3_FENCE   := WO~0~0~0.
Definition funct3_FENCE_I := WO~0~0~1.
Definition funct3_ADDI  := WO~0~0~0.
Definition funct3_SLLI  := WO~0~0~1.
Definition funct3_SLTI  := WO~0~1~0.
Definition funct3_SLTIU := WO~0~1~1.
Definition funct3_XORI  := WO~1~0~0.
Definition funct3_SRLI  := WO~1~0~1.
Definition funct3_SRAI  := WO~1~0~1.
Definition funct3_ORI   := WO~1~1~0.
Definition funct3_ANDI  := WO~1~1~1.
Definition funct7_SLLI  := WO~0~0~0~0~0~0~0.
Definition funct7_SRLI  := WO~0~0~0~0~0~0~0.
Definition funct7_SRAI  := WO~0~1~0~0~0~0~0.
Definition funct6_SLLI  := WO~0~0~0~0~0~0.
Definition funct6_SRLI  := WO~0~0~0~0~0~0.
Definition funct6_SRAI  := WO~0~1~0~0~0~0.
Definition funct3_SB := WO~0~0~0.
Definition funct3_SH := WO~0~0~1.
Definition funct3_SW := WO~0~1~0.
Definition funct3_SD := WO~0~1~1.
Definition funct3_ADD  := WO~0~0~0.
Definition funct7_ADD  := WO~0~0~0~0~0~0~0.
Definition funct3_SUB  := WO~0~0~0.
Definition funct7_SUB  := WO~0~1~0~0~0~0~0.
Definition funct3_SLL  := WO~0~0~1.
Definition funct7_SLL  := WO~0~0~0~0~0~0~0.
Definition funct3_SLT  := WO~0~1~0.
Definition funct7_SLT  := WO~0~0~0~0~0~0~0.
Definition funct3_SLTU := WO~0~1~1.
Definition funct7_SLTU := WO~0~0~0~0~0~0~0.
Definition funct3_XOR  := WO~1~0~0.
Definition funct7_XOR  := WO~0~0~0~0~0~0~0.
Definition funct3_SRL  := WO~1~0~1.
Definition funct7_SRL  := WO~0~0~0~0~0~0~0.
Definition funct3_SRA  := WO~1~0~1.
Definition funct7_SRA  := WO~0~1~0~0~0~0~0.
Definition funct3_OR   := WO~1~1~0.
Definition funct7_OR   := WO~0~0~0~0~0~0~0.
Definition funct3_AND  := WO~1~1~1.
Definition funct7_AND  := WO~0~0~0~0~0~0~0.
Definition funct3_MUL    :=WO~0~0~0.
Definition funct7_MUL    :=WO~0~0~0~0~0~0~1.
Definition funct3_MULH   :=WO~0~0~1.
Definition funct7_MULH   :=WO~0~0~0~0~0~0~1.
Definition funct3_MULHSU :=WO~0~1~0.
Definition funct7_MULHSU :=WO~0~0~0~0~0~0~1.
Definition funct3_MULHU  :=WO~0~1~1.
Definition funct7_MULHU  :=WO~0~0~0~0~0~0~1.
Definition funct3_DIV    :=WO~1~0~0.
Definition funct7_DIV    :=WO~0~0~0~0~0~0~1.
Definition funct3_DIVU   :=WO~1~0~1.
Definition funct7_DIVU   :=WO~0~0~0~0~0~0~1.
Definition funct3_REM    :=WO~1~1~0.
Definition funct7_REM    :=WO~0~0~0~0~0~0~1.
Definition funct3_REMU   :=WO~1~1~1.
Definition funct7_REMU   :=WO~0~0~0~0~0~0~1.
Definition funct3_BEQ  := WO~0~0~0.
Definition funct3_BNE  := WO~0~0~1.
Definition funct3_BLT  := WO~1~0~0.
Definition funct3_BGE  := WO~1~0~1.
Definition funct3_BLTU := WO~1~1~0.
Definition funct3_BGEU := WO~1~1~1.
Definition funct3_PRIV   := WO~0~0~0.
Definition funct12_ECALL  := WO~0~0~0~0~0~0~0~0~0~0~0~0.
Definition funct12_EBREAK := WO~0~0~0~0~0~0~0~0~0~0~0~1.
Definition funct12_URET   := WO~0~0~0~0~0~0~0~0~0~0~1~0.
Definition funct12_SRET   := WO~0~0~0~1~0~0~0~0~0~0~1~0.
Definition funct12_MRET   := WO~0~0~1~1~0~0~0~0~0~0~1~0.
Definition funct12_WFI    := WO~0~0~0~1~0~0~0~0~0~1~0~1.
Definition funct7_SFENCE_VM := WO~0~0~0~1~0~0~1.
Definition funct3_CSRRW  := WO~0~0~1.
Definition funct3_CSRRS  := WO~0~1~0.
Definition funct3_CSRRC  := WO~0~1~1.
Definition funct3_CSRRWI := WO~1~0~1.
Definition funct3_CSRRSI := WO~1~1~0.
Definition funct3_CSRRCI := WO~1~1~1.

Section Decode.

Context {B: RiscvBitWidths}.

Definition Register := word 32.
Definition MachineInt := word wXLEN.

Inductive Instruction : Set :=
  | InvalidInstruction : Instruction

  |  Lb(rd: Register)(rs1: Register)(oimm12: MachineInt): Instruction
  |  Lh(rd: Register)(rs1: Register)(oimm12: MachineInt): Instruction
  |  Lw(rd: Register)(rs1: Register)(oimm12: MachineInt): Instruction
  |  Ld(rd: Register)(rs1: Register)(oimm12: MachineInt): Instruction
  |  Lbu(rd: Register)(rs1: Register)(oimm12: MachineInt): Instruction
  |  Lhu(rd: Register)(rs1: Register)(oimm12: MachineInt): Instruction
  |  Lwu(rd: Register)(rs1: Register)(oimm12: MachineInt): Instruction

  (* | Fence (pred : MachineInt)(succ : MachineInt): Instruction *)
  | Fence_i:Instruction
  
  | Addi (rd: Register)(rs1: Register)(imm12: MachineInt) : Instruction
  | Slli (rd: Register)(rs1: Register)(shamt6: MachineInt) : Instruction
  | Slti (rd: Register)(rs1: Register)(imm12: MachineInt) : Instruction
  | Sltiu (rd: Register)(rs1: Register)(imm12: MachineInt) : Instruction
  | Xori (rd: Register)(rs1: Register)(imm12: MachineInt) : Instruction
  | Ori (rd: Register)(rs1: Register)(imm12: MachineInt) : Instruction
  | Andi (rd: Register)(rs1: Register)(imm12: MachineInt) : Instruction
  | Srli (rd: Register)(rs1: Register)(shamt6: MachineInt) : Instruction
  | Srai (rd: Register)(rs1: Register)(shamt6: MachineInt) : Instruction

  | Auipc (rd : Register)(oimm20: MachineInt): Instruction

  | Addiw (rd: Register)(rs1: Register)(imm12: MachineInt) :  Instruction
  | Slliw (rd: Register)(rs1: Register)(shamt5: MachineInt) :  Instruction
  | Srliw (rd: Register)(rs1: Register)(shamt5: MachineInt) :  Instruction
  | Sraiw (rd: Register)(rs1: Register)(shamt5: MachineInt) :  Instruction
  | Sb (rs1: Register)(rs2: Register)(simm12: MachineInt) :  Instruction
  | Sh (rs1: Register)(rs2: Register)(simm12: MachineInt) :  Instruction
  | Sw (rs1: Register)(rs2: Register)(simm12: MachineInt) :  Instruction
  | Sd (rs1: Register)(rs2: Register)(simm12: MachineInt) :  Instruction
  | Add (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | Sub (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | Sll (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | Slt (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | Sltu (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | Xor (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | Srl (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | Sra (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | Or (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | And (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | Mul (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | Mulh (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | Mulhsu (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | Mulhu (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | Div (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | Divu (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | Rem (rd: Register)(rs1: Register)(rs2: Register) :  Instruction
  | Remu (rd: Register)(rs1: Register)(rs2: Register) :  Instruction

  | Lui(rd: Register)(imm20: MachineInt): Instruction
  | Beq(rs1: Register)(rs2: Register)(sbimm12: MachineInt): Instruction
  | Bne(rs1: Register)(rs2: Register)(sbimm12: MachineInt): Instruction
  | Blt(rs1: Register)(rs2: Register)(sbimm12: MachineInt): Instruction
  | Bge(rs1: Register)(rs2: Register)(sbimm12: MachineInt): Instruction
  | Bltu(rs1: Register)(rs2: Register)(sbimm12: MachineInt): Instruction
  | Bgeu(rs1: Register)(rs2: Register)(sbimm12: MachineInt): Instruction
  | Jalr(rd: Register)(rs1: Register)(oimm12: MachineInt): Instruction
  | Jal(rd: Register)(jimm20: MachineInt) : Instruction

  | Ecall : Instruction
  | Ebreak : Instruction
  | Uret : Instruction
  | Sret : Instruction
  | Mret : Instruction
  | Wfi : Instruction
  | Sfence_vm (rs1: Register)(rs2: Register): Instruction

  | Csrrw(rd: Register)(rs1: Register)(csr12: MachineInt): Instruction
  | Csrrs(rd: Register)(rs1: Register)(csr12: MachineInt): Instruction
  | Csrrc(rd: Register)(rs1: Register)(csr12: MachineInt): Instruction
  | Csrrwi(rd: Register)(zimm: MachineInt)(csr12: MachineInt): Instruction
  | Csrrsi(rd: Register)(zimm: MachineInt)(csr12: MachineInt): Instruction
  | Csrrci(rd: Register)(zimm: MachineInt)(csr12: MachineInt): Instruction
.


Arguments sumbool_not {_} {_} (_).

Section comparisons.

  Context {sz: nat}.
  Variable a b: word sz.

  (* a >= b <-> b <= a <-> ~ b > a <-> ~ a < b *)
  Definition wge_dec := sumbool_not (wlt_dec a b).

  (* a > b <-> b < a *)
  Definition wgt_dec := wlt_dec b a.

  (* a <= b <-> ~ b < a *)
  Definition wle_dec := sumbool_not (wlt_dec b a).

  (* a >= b <-> b <= a <-> ~ b > a <-> ~ a < b *)
  Definition wsge_dec := sumbool_not (wslt_dec a b).

  (* a > b <-> b < a *)
  Definition wsgt_dec := wslt_dec b a.

  (* a <= b <-> ~ b < a *)
  Definition wsle_dec := sumbool_not (wslt_dec b a).

  Definition wneq_dec := sumbool_not (weq a b).

End comparisons.

Definition split_upper(szU szL : nat): word (szL + szU) -> word szU := split2 szL szU.

Definition split_lower(szU szL : nat): word (szL + szU) -> word szL := split1 szL szU.

Definition split_middle(szU szM szL: nat)(w: word (szL + szM + szU)): word szM :=
  split_upper szM szL (split_lower szU (szL + szM) w).

(* keeps word size *)
Definition bitSlice'{sz: nat}(inst: word sz)(n m: nat){H: n <= m <= sz}: word sz.
  refine (nat_cast _ _ (zext (split_middle (sz - m) (m - n) n (nat_cast _ _ inst)) (sz - (m - n))));
  abstract omega.
Defined.

(* we redefine a wlshift which does not match on (possibly opaque) equality proofs,
   so that we can simpl/cbv/etc it *)
Definition wlshift {sz : nat} (w : word sz) (n : nat) : word sz.
  refine (split1 sz n (nat_cast _ _ (combine (wzero n) w))). apply plus_comm.
Defined.

(* extends word size to wXLEN *)
Definition bitSlice(inst: word 32)(n m: nat){H: n <= m <= 32}: word wXLEN.
  set (bits := @bitSlice' _ inst n m H).
  refine (nat_cast _ _ (zext bits (wXLEN - 32))). abstract bitwidth_omega.
Defined.

(* this is actually "zero-extend and then shift left" *)
Definition shift{n: nat}{sz: nat}(w: word n)(m : nat){H: (n <= sz)%nat}: word sz.
  refine (wlshift (nat_cast _ _ (zext w (sz - n))) m). abstract omega.
Defined.

(* calculating (pow2 32) on nat will result in S (S (S .... 2^32 times, that's too much *)
Definition setBit(sz: nat)(b: nat): word sz := NToWord sz (Npow2 b).

Definition testBit{sz: nat}(w: word sz)(l: nat): bool :=
  weqb (wzero sz) (wand w (setBit sz l)).

(* bad because (pow2 l) will compute a huge nat
Definition signExtend{sz: nat}(l: nat)(n: word sz): word sz :=
  if testBit n (l-1) then (n ^- $ (pow2 l)) else n.
*)

(* Note: also works if sz = l: In that case, setBit will overflow and equal 0,
   so the subtraction doesn't do anything, but that's fine because no bits need
   to be change in that case. *)
Definition signExtend{sz: nat}(l: nat)(n: word sz): word sz :=
  if testBit n (l-1) then (n ^- (setBit sz l)) else n.

Notation "a <|> b" := (wor a b) (at level 50, left associativity).

Definition decode (inst : word 32) : Instruction. simple refine (
  let opcode :=  split_lower 25 7 (bitSlice' inst 0 7) in
  let funct3 :=  split_lower 29 3 (bitSlice' inst 12 15) in
  let funct7 :=  split_lower 25 7 (bitSlice' inst 25 32) in
  let funct10 := split_lower 22 10 ((shift (bitSlice' inst 25 32) 3) <|> (bitSlice' inst 12 15)) in
  let funct12 :=  split_lower 20 12 (bitSlice' inst 20 32) in
  let rd := bitSlice' inst 7 12 in
  let rs1 := bitSlice' inst 15 20 in
  let rs2 := bitSlice' inst 20 25 in
  let rs3 := bitSlice' inst 27 32 in
  let succ := bitSlice inst 20 24 in
  let pred := bitSlice inst 24 28 in
  let msb4 := bitSlice inst 28 32 in
  let imm20 := signExtend 32 (shift (bitSlice inst 12 32) 12) in
  let oimm20 := signExtend 32 (shift (bitSlice inst 12 32) 12) in
  let jimm20 := signExtend 21 (shift (bitSlice inst 31 32) 20  <|>
                                shift (bitSlice inst 21 31) 1  <|>
                                shift (bitSlice inst 20 21) 11 <|>
                                shift (bitSlice inst 12 20) 12) in
  let imm12 := signExtend 12 (bitSlice inst 20 32) in
  let oimm12 := signExtend 12 (bitSlice inst 20 32) in
  let csr12 := bitSlice inst 20 32 in
  let simm12 := signExtend 12 (shift (bitSlice inst 25 32) 5 <|> bitSlice inst 7 12) in
  let sbimm12 := signExtend 13 (shift (bitSlice inst 31 32) 12 <|>
                                shift (bitSlice inst 25 31) 5 <|>
                                shift (bitSlice inst 8 12) 1  <|>
                                shift (bitSlice inst 7 8) 11) in
  let shamt5 := bitSlice inst 20 25 in
  let shamt6 := bitSlice inst 20 26 in
  let zimm := bitSlice inst 15 20 in
           if dec(opcode = opcode_LOAD /\ funct3 = funct3_LB) then  Lb  rd rs1 oimm12
      else if dec(opcode = opcode_LOAD /\ funct3 = funct3_LH) then  Lh  rd rs1 oimm12
      else if dec(opcode = opcode_LOAD /\ funct3 = funct3_LW) then  Lw  rd rs1 oimm12
      else if dec(opcode = opcode_LOAD /\ funct3 = funct3_LBU) then  Lbu rd rs1 oimm12
      else if dec(opcode = opcode_LOAD /\ funct3 = funct3_LHU) then  Lhu rd rs1 oimm12
      (* else if dec(opcode = opcode_MISC_MEM /\ rd = $0 /\ funct3 = funct3_FENCE /\ rs1 = $0 /\ msb4 inst = 0) then  Fence pred succ *)
      else if dec(opcode = opcode_MISC_MEM /\ rd = $0 /\ funct3 = funct3_FENCE_I /\ rs1 = $0 /\ imm12 = $0) then  Fence_i
      else if dec(opcode = opcode_OP_IMM /\ funct3 = funct3_ADDI) then  Addi  rd rs1 imm12
      else if dec(opcode = opcode_OP_IMM /\ funct3 = funct3_SLLI /\ funct7 = funct7_SLLI)  then  Slli  rd rs1 shamt5
      else if dec(opcode = opcode_OP_IMM /\ funct3 = funct3_SLTI) then  Slti  rd rs1 imm12
      else if dec(opcode = opcode_OP_IMM /\ funct3 = funct3_SLTIU) then  Sltiu rd rs1 imm12
      else if dec(opcode = opcode_OP_IMM /\ funct3 = funct3_XORI) then  Xori  rd rs1 imm12
      else if dec(opcode = opcode_OP_IMM /\ funct3 = funct3_ORI) then  Ori   rd rs1 imm12
      else if dec(opcode = opcode_OP_IMM /\ funct3 = funct3_ANDI) then  Andi  rd rs1 imm12
      else if dec(opcode = opcode_OP_IMM /\ funct3 = funct3_SRLI /\ funct7 = funct7_SRLI)  then  Srli  rd rs1 shamt5
      else if dec(opcode = opcode_OP_IMM /\ funct3 = funct3_SRAI /\ funct7 = funct7_SRAI)  then  Srai  rd rs1 shamt5
      else if dec(opcode = opcode_AUIPC) then  Auipc rd oimm20
      else if dec(opcode = opcode_STORE /\ funct3 = funct3_SB) then  Sb rs1 rs2 simm12
      else if dec(opcode = opcode_STORE /\ funct3 = funct3_SH) then  Sh rs1 rs2 simm12
      else if dec(opcode = opcode_STORE /\ funct3 = funct3_SW) then  Sw rs1 rs2 simm12
      else if dec(opcode = opcode_OP /\ funct3 = funct3_ADD /\ funct7 = funct7_ADD) then  Add  rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_SUB /\ funct7 = funct7_SUB) then  Sub  rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_SLL /\ funct7 = funct7_SLL) then  Sll  rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_SLT /\ funct7 = funct7_SLT) then  Slt  rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_SLTU /\ funct7 = funct7_SLTU) then  Sltu rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_XOR /\ funct7 = funct7_XOR) then  Xor  rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_SRL /\ funct7 = funct7_SRL) then  Srl  rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_SRA /\ funct7 = funct7_SRA) then  Sra  rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_OR /\ funct7 = funct7_OR) then  Or   rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_AND /\ funct7 = funct7_AND) then  And  rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_MUL /\ funct7 = funct7_MUL) then  Mul    rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_MULH /\ funct7 = funct7_MULH) then  Mulh   rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_MULHSU /\ funct7 = funct7_MULHSU) then  Mulhsu rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_MULHU /\ funct7 = funct7_MULHU) then  Mulhu  rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_DIV /\ funct7 = funct7_DIV) then  Div    rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_DIVU /\ funct7 = funct7_DIVU) then  Divu   rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_REM /\ funct7 = funct7_REM) then  Rem    rd rs1 rs2
      else if dec(opcode = opcode_OP /\ funct3 = funct3_REMU /\ funct7 = funct7_REMU) then  Remu   rd rs1 rs2
      else if dec(opcode = opcode_LUI) then  Lui rd imm20
      else if dec(opcode = opcode_BRANCH /\ funct3 = funct3_BEQ) then  Beq  rs1 rs2 sbimm12
      else if dec(opcode = opcode_BRANCH /\ funct3 = funct3_BNE) then  Bne  rs1 rs2 sbimm12
      else if dec(opcode = opcode_BRANCH /\ funct3 = funct3_BLT) then  Blt  rs1 rs2 sbimm12
      else if dec(opcode = opcode_BRANCH /\ funct3 = funct3_BGE) then  Bge  rs1 rs2 sbimm12
      else if dec(opcode = opcode_BRANCH /\ funct3 = funct3_BLTU) then  Bltu rs1 rs2 sbimm12
      else if dec(opcode = opcode_BRANCH /\ funct3 = funct3_BGEU) then  Bgeu rs1 rs2 sbimm12
      else if dec(opcode = opcode_JALR) then  Jalr rd rs1 oimm12
      else if dec(opcode = opcode_JAL) then  Jal rd jimm20
      else if dec(opcode = opcode_SYSTEM /\ rd = $0 /\ funct3 = funct3_PRIV /\ rs1 = $0 /\ funct12 = funct12_ECALL) then  Ecall
      else if dec(opcode = opcode_SYSTEM /\ rd = $0 /\ funct3 = funct3_PRIV /\ rs1 = $0 /\ funct12 = funct12_EBREAK) then  Ebreak
      else if dec(opcode = opcode_SYSTEM /\ rd = $0 /\ funct3 = funct3_PRIV /\ rs1 = $0 /\ funct12 = funct12_URET) then  Uret
      else if dec(opcode = opcode_SYSTEM /\ rd = $0 /\ funct3 = funct3_PRIV /\ rs1 = $0 /\ funct12 = funct12_SRET) then  Sret
      else if dec(opcode = opcode_SYSTEM /\ rd = $0 /\ funct3 = funct3_PRIV /\ rs1 = $0 /\ funct12 = funct12_MRET) then  Mret
      else if dec(opcode = opcode_SYSTEM /\ rd = $0 /\ funct3 = funct3_PRIV /\ rs1 = $0 /\ funct12 = funct12_WFI) then  Wfi
      else if dec(opcode = opcode_SYSTEM /\ rd = $0 /\ funct3 = funct3_PRIV /\ funct7 = funct7_SFENCE_VM) then  Sfence_vm rs1 rs2
      else if dec(opcode = opcode_SYSTEM /\ funct3 = funct3_CSRRW) then  Csrrw   rd rs1 csr12
      else if dec(opcode = opcode_SYSTEM /\ funct3 = funct3_CSRRS) then  Csrrw   rd rs1 csr12
      else if dec(opcode = opcode_SYSTEM /\ funct3 = funct3_CSRRC) then  Csrrw   rd rs1 csr12
      else if dec(opcode = opcode_SYSTEM /\ funct3 = funct3_CSRRWI) then  Csrrwi  rd zimm csr12
      else if dec(opcode = opcode_SYSTEM /\ funct3 = funct3_CSRRSI) then  Csrrwi  rd zimm csr12
      else if dec(opcode = opcode_SYSTEM /\ funct3 = funct3_CSRRCI) then  Csrrwi  rd zimm csr12
      else InvalidInstruction);
  (clear; abstract omega).
Defined.

End Decode.


Definition test_instruction: word 32 :=
  combine opcode_LUI (combine (natToWord 5 9) (natToWord 20 (35 + 128 + 2048))).

Require Import riscv.RiscvBitWidths32.

Definition test_result: Instruction := decode test_instruction.

Goal test_result = Lui (zext (natToWord 5 9) 27) (extz (natToWord 20 (35 + 128 + 2048)) 12).
  cbv.
  reflexivity.
Qed.
