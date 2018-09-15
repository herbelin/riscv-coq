from LanguagePrinter import LanguagePrinter

class PythonPrinter(LanguagePrinter):
    def __init__(self, outfile):
        super(PythonPrinter, self).__init__(outfile)
        self.comment('This Python file was autogenerated from Coq')
        self.writeln('from enum import Enum')
        self.writeln('import ZBitOps')
        self.writeln('from Utility import *')
        self.end_decl()

    def comment(self, s):
        self.writeln('# ' + s)

    def end_decl(self):
        self.writeln('')

    def type_alias(self, name, rhsName):
        pass # there are no types aliases in Python

    def enum(self, name, valueNames):
        self.writeln('class {}(Enum):'.format(name))
        for i, n in enumerate(valueNames, 1):
            self.writeln('    ' + n + ' = ' + str(i))
        self.end_decl()

    def variant(self, name, branches):
        '''
        name: str
        branches: list of (branchName, typesList) tuples
        '''
        self.writeln('class {}(object): pass'.format(name))
        self.end_decl()

        for branchName, argTypes in branches:
            self.writeln('class {}({}):'.format(branchName, name))
            self.increaseIndent()
            constructorArgs = ''.join([', f' + str(i) for i in range(len(argTypes))])
            self.writeln('def __init__(self{}):'.format(constructorArgs))
            self.increaseIndent()
            for i in range(len(argTypes)):
                self.writeln('self.f{} = f{}'.format(i, i))
            if len(argTypes) == 0:
                self.writeln('pass')
            self.decreaseIndent()
            self.decreaseIndent()
            self.end_decl()

    def if_stmt(self, cond, ifyes, ifno):
        self.startln()
        self.write('if ')
        cond()
        self.write(':\n')
        self.increaseIndent()
        self.startln()
        ifyes()
        self.write('\n')
        self.decreaseIndent()
        self.startln()
        self.write("else:\n")
        self.increaseIndent()
        self.startln()
        ifno()
        self.write("\n")
        self.decreaseIndent()

    def if_expr(self, cond, ifyes, ifno):
        self.write('(')
        ifyes()
        self.write("\n")
        self.increaseIndent()
        self.startln()
        self.write(" if ")
        cond()
        self.write("\n")
        self.startln()
        self.write(" else ")
        ifno()
        self.write(')')
        self.decreaseIndent()
    def begin_list(self):
        self.write('[')

    def end_list(self):
        self.write(']')

    def list_length(self, first_arg):
        self.write("len(")
        first_arg()
        self.write(")")

    def list_nth_default(self, index, l, default):
        self.write("list_nth_default(")
        index()
        self.write(', ')
        l()
        self.write(', ')
        default()
        self.write(')')

    def concat(self, first_arg, second_arg):
        first_arg()
        self.write(' + ')
        second_arg()

    def equality(self, first_arg, second_arg):
        first_arg()
        self.write(' == ')
        second_arg()

    def gt(self, first_arg, second_arg):
        first_arg()
        self.write(' > ')
        second_arg()

    def logical_or(self, first_arg, second_arg):
        first_arg()
        self.write(' | ')
        second_arg()

    def shift_left(self, first_arg, second_arg):
        first_arg()
        self.write(' << ')
        second_arg()

    def boolean_and(self, first_arg, second_arg):
        first_arg()
        self.write(' and ')
        second_arg()

    def boolean_or(self, first_arg, second_arg):
        first_arg()
        self.write(' or ')
        second_arg()

    def empty_list(self):
        self.begin_list()
        self.end_list()

    def begin_local_var_decl(self, name, typ):
        self.startln()
        self.write(name + ' = ')

    def end_local_var_decl(self):
       # self.write('\n')
        self.end_decl()

    def begin_constant_decl(self, name, typ):
        self.write(name + ' = ')

    def end_constant_decl(self):
        self.write('\n')
        self.end_decl()

    def begin_function_call(self,func):
        func()
        self.write('(')

    def end_function_arg(self):
        self.write(', ')

    def end_function_call(self):
        self.write(')')


    def bit_literal(self, s):
        self.write('0b' + s)

    def true_literal(self):
        self.write('True')

    def false_literal(self):
        self.write('False')

    def var(self, varName):
        self.write(varName)

    def begin_fun_decl(self, name, argnamesWithTypes, returnType):
        self.writeln('def {}({}):'.format(name,
                ', '.join([argname for argname, tp in argnamesWithTypes])))
        self.increaseIndent()

    def end_fun_decl(self):
        self.decreaseIndent()
        self.end_decl()

    def begin_match(self, discriminee):
        pass # nothing to be done

    def end_match(self):
        pass # nothing to be done

    def begin_match_case(self, discriminee, constructorName, argNames):
        self.writeln('if isinstance({}, {}):'.format(discriminee, constructorName))
        self.increaseIndent()
        self.startln()

    def end_match_case(self):
        self.decreaseIndent()
        self.write('\n')

    def begin_match_default_case(self):
        self.startln()

    def end_match_default_case(self):
        self.write('\n')

    def begin_switch(self, discriminee):
        pass # nothing to be done

    def end_switch(self):
        pass # nothing to be done

    def begin_switch_case(self, discriminee, constructorName, enumName):
        self.writeln('if {} == {}.{}:'.format(discriminee, enumName, constructorName))
        self.increaseIndent()
        self.startln()

    def end_switch_case(self):
        self.decreaseIndent()
        self.write('\n')

    def begin_switch_default_case(self):
        self.startln()

    def end_switch_default_case(self):
        self.write('\n')

    def begin_return_expr(self):
        self.write('return ')

    def end_return_expr(self):
        pass # nothing to be done

    def nop(self):
        self.writeln('pass')
