
import ply.lex as lex
from colorama import Fore, Back, Style
import spss
import sys

# List of token names.   This is always required
tokens = [
   'NUMBER',
   'PLUS',
   'MINUS',
   'TIMES',
   'DIVIDE',
   'LPAREN',
   'RPAREN',
   'STRING',
   'EQ',
   'LINE_TERMINATOR',
   'ID'
]

reserved = {
   'if' : 'IF',
   'then' : 'THEN',
   'else' : 'ELSE',
   'while' : 'WHILE',
   'GET': 'GET',
   'SHOW' : 'SHOW'
}

tokens = tokens + list(reserved.values())

# Regular expression rules for simple tokens
t_PLUS    = r'\+'
t_MINUS   = r'-'
t_TIMES   = r'\*'
t_DIVIDE  = r'/'
t_LPAREN  = r'\('
t_RPAREN  = r'\)'
t_STRING = r'\'(.*?)\''
t_EQ = r'\='
t_LINE_TERMINATOR = r'\.'


# A regular expression rule with some action code
def t_NUMBER(t):
    r'\d+'
    t.value = int(t.value)    
    return t

# Define a rule so we can track line numbers
def t_newline(t):
    r'\n+'
    t.lexer.lineno += len(t.value)

# A string containing ignored characters (spaces and tabs)
t_ignore  = ' \t'

def t_ID(t):
    r'[a-zA-Z_][a-zA-Z_0-9]*'
    t.type = reserved.get(t.value.upper(),'ID')    # Check for reserved words
    return t

# Error handling rule
def t_error(t):
    print("Illegal character '%s'" % t.value[0])
    t.lexer.skip(1)

# Build the lexer
lexer = lex.lex()

def lex_line(line):
    # Give the lexer some input
    lexer.input(line)
    print(lexer.token)
    for tok in lexer:
         print('token:', tok.type, tok.value, tok.lineno, tok.lexpos)
         if tok.type == 'LINE_TERMINATOR':
             return True
    return False

def run_command(command):
    try:
        result = spss.Submit(command)
    except spss.SpssError as err:
        print(err)
        errorLevel=str(spss.GetLastErrorLevel()) 
        errorMsg=spss.GetLastErrorMessage()
        print("Error level " + errorLevel + ": " + errorMsg) 
        print("3 Command does not run, subsequent commands are processed.")
    except Exception as err:
        print(f"Unexpected {err=}, {type(err)=}")
        raise

def intercept_input(event, *args):
    # the hook is called on all events
    # only react if it is an interesting one
    if event == "builtins.input":
        # the only input argument is the prompt message
        prompt, = args
        print("Querying for input as", repr(prompt))



def main():
    print(Fore.RED + "SPSS Statistics Terminal" + Style.RESET_ALL)
    sys.addaudithook(intercept_input)
    inputlist = []
    nextline = False
    while True:
        try:
            if nextline:
                line = input(Fore.RED + '..\t' + Style.RESET_ALL)
            else:
                line = input(Fore.RED + '>> ' + Style.RESET_ALL)
        except EOFError:
            break
        #mylex(line)
        if lex_line(line):
             nextline = False
        else:
             nextline = True
        inputlist.append(line)
        if not(nextline):
           # print('tokens: ', inputlist)
            command = ' '.join(inputlist)
            #print(command)
            inputlist = []
            if command == 'q.':
                break
            print('SUBMIT COMMAND:', Fore.RED + command + Style.RESET_ALL)
            run_command(command)
            command = ''
    
    print(Fore.RED +  'SPSS terminal Finished.' + Style.RESET_ALL)

if __name__ == "__main__":
    main()