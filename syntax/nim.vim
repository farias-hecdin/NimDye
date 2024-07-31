" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if v:version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

" List of highlight variables
let highlight_vars = [
      \ 'nim_highlight_numbers', 'nim_highlight_builtins', 'nim_highlight_exceptions',
      \ 'nim_highlight_space_errors', 'nim_highlight_special_vars'
      \ ]

" Initialize highlight variables if they do not exist
for var in highlight_vars
  if !exists(var)
    execute 'let ' . var . ' = 1'
  endif
endfor

" Set all highlight variables to 1 if nim_highlight_all exists
if exists('nim_highlight_all')
  for var in highlight_vars
    execute 'let ' . var . ' = 1'
  endfor
endif

" Define regions and matches
syn region nimBrackets contained extend keepend matchgroup=Bold start=+\(\\\)\@<!\[+ end=+]\|$+ skip=+\\\s*$\|\(\\\)\@<!\\]+ contains=@tclCommandCluster
syn match nimType "\<[A-Z]\w*"

" Define keywords
let nimKeywords = [
      \ 'asm', 'atomic', 'block',
      \ 'enum', 'concept', 'tuple', 'distinct',
      \ 'defer', 'do', 'discard', 'discardable',
      \ 'end', 'out', 'interface',
      \ 'from', 'import', 'export',
      \ 'bind', 'mixin', 'using',
      \ 'ref', 'object',
      \ 'proc', 'func', 'method', 'macro', 'template', 'iterator', 'converter',
      \ 'raise', 'try', 'finally', 'except',
      \ 'vtref', 'vtptr',
      \ 'yield',
      \ 'when', 'with', 'without', 'for', 'while',
      \ 'let', 'const'
      \]

for keyword in nimKeywords
  execute 'syn keyword nimKeyword ' . keyword
endfor

" Define built-in keywords
let nimBuiltins = ['nil', 'result']
for builtin in nimBuiltins
  execute 'syn keyword nimBuiltin ' . builtin
endfor

" Define operator keywords
let nimOperators = ['var', 'type', 'break', 'continue', 'return']
for operator in nimOperators
  execute 'syn keyword nimOperator ' . operator
endfor

" Define exception keywords
let nimExceptions = [
      \ 'static', 'include', 'addr', 'ptr', 'cast', 'equalmem', 'equalMem',
      \ 'alloc', 'alloc0', 'realloc', 'dealloc', 'zeromem', 'zeroMem',
      \ 'copymem', 'copyMem', 'movemem', 'moveMem', 'bycopy'
      \]
for exception in nimExceptions
  execute 'syn keyword nimException ' . exception
endfor

" Define functions and classes
syn match   nimFunction      "[a-zA-Z_][a-zA-Z0-9_]*\|`.*`" contained
syn match   nimClass         "[a-zA-Z_][a-zA-Z0-9_]*\|`.*`" contained

" Define conditionals and operators
let nimConditionals = ['if', 'elif', 'else', 'case', 'of']
for conditional in nimConditionals
  execute 'syn keyword nimConditional ' . conditional
endfor

syn match nimOperator +[.][.]+
syn match nimOperator +[-=+/<>@$~&%|!?^\\]*[=]+
syn match nimOperator "[-+/<>@$~&%|!?^\\]*"
syn match nimOperator "[∙∘×★⊗⊘⊙⊛⊠⊡∩∧⊓]" " same priority as * (multiplication)
syn match nimOperator "[±⊕⊖⊞⊟∪∨⊔]" " same priority as + (addition)

" Define comments and TODOs
syn match   nimComment       "#.*$" contains=nimTodo,@Spell
syn region  nimComment       start="#\[" end="\]#" contains=nimTodo,@Spell
syn keyword nimTodo          TODO FIXME XXX contained

" Define booleans and constants
syn keyword nimBoolean       true false
syn match   nimConstant      '[{}\[\]()]'
syn match   nimPreCondit     '{\.\|\.}'

" Define strings and raw strings
syn region nimString    start=+'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=nimEscape,nimEscapeError,@Spell
syn region nimString    start=+"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=nimEscape,nimEscapeError,@Spell
syn region nimString    start=+"""+ end=+"""+ keepend contains=nimEscape,nimEscapeError,@Spell
syn region nimRawString matchgroup=Normal start=+[rR]"+ end=+"+ skip=+\\\\\|\\"+ contains=@Spell

" Define escapes
syn match nimEscape +\\[abfnrtv'"\\]+ contained
syn match nimEscape "\\\o\{1,3}" contained
syn match nimEscape "\\x\x\{2}" contained
syn match nimEscape "\(\\u\x\{4}\|\\U\x\{8}\)" contained
syn match nimEscape "\\$"

" Define escape errors
syn match nimEscapeError "\\x\x\=\X" display contained

" Others
" syn match   nimRepeat  '\.\k\+'
" syn match   nimRepeat  '\(?:[a-zA-Z]*\.\)\k\+'
" syn match   nimEscape  '[a-zA-Z]\w*\s\?('
" syn region  nimEscape  start=+\k\+(+ skip=+[\w]*+ end=+)+ contains=nimBuiltin,nimKeyword,nimString,nimRawString,nimBoolean,nimOperator
" syn match   nimEscape  '\w*[\(](\s+\n?\w*\s?)[\)]\n?' " TODO

if nim_highlight_numbers == 1
  " numbers (including longs and complex)
  let s:dec_num = '\d%(_?\d)*'
  let s:int_suf = '%(''%(%(i|I|u|U)%(8|16|32|64)|u|U))'
  let s:float_suf = '%(''%(%(f|F)%(32|64|128)?|d|D))'
  let s:exp = '%([eE][+-]?'.s:dec_num.')'
  exe 'syn match nimNumber /\v<0[bB][01]%(_?[01])*%('.s:int_suf.'|'.s:float_suf.')?>/'
  exe 'syn match nimNumber /\v<0[ocC]\o%(_?\o)*%('.s:int_suf.'|'.s:float_suf.')?>/'
  exe 'syn match nimNumber /\v<0[xX]\x%(_?\x)*%('.s:int_suf.'|'.s:float_suf.')?>/'
  exe 'syn match nimNumber /\v<'.s:dec_num.'%('.s:int_suf.'|'.s:exp.'?'.s:float_suf.'?)>/'
  exe 'syn match nimNumber /\v<'.s:dec_num.'\.'.s:dec_num.s:exp.'?'.s:float_suf.'?>/'
  unlet s:dec_num s:int_suf s:float_suf s:exp
endif

if nim_highlight_builtins == 1
  " Builtin functions, types and objects, not really part of the syntax
  let builtin_functions = [
        \ 'mapIt', 'repeat', 'int', 'int8', 'int16', 'int32', 'int64',
        \ 'uint', 'uint8', 'uint16', 'uint32', 'uint64', 'float', 'float32', 'float64',
        \ 'bool', 'void', 'chr', 'char', 'string', 'cstring', 'pointer', 'range',
        \ 'array', 'openarray', 'openArray', 'seq', 'varargs', 'varArgs', 'set',
        \ 'Byte', 'Natural', 'Positive', 'Conversion', 'BiggestInt', 'BiggestFloat',
        \ 'cchar', 'cschar', 'cshort', 'cint', 'csize', 'cuchar', 'cushort',
        \ 'clong', 'clonglong', 'cfloat', 'cdouble', 'clongdouble', 'cuint',
        \ 'culong', 'culonglong', 'CompileDate', 'CompileTime', 'nimversion',
        \ 'nimVersion', 'nimmajor', 'nimMajor', 'nimminor', 'nimMinor', 'nimpatch',
        \ 'nimPatch', 'cpuendian', 'cpuEndian', 'hostos', 'hostOS', 'hostcpu',
        \ 'hostCPU', 'inf', 'neginf', 'nan', 'QuitSuccess', 'QuitFailure',
        \ 'dbglinehook', 'dbgLineHook', 'stdin', 'stdout', 'stderr', 'defined',
        \ 'new', 'high', 'low', 'sizeof', 'succ', 'pred', 'inc', 'dec', 'newseq',
        \ 'newSeq', 'len', 'incl', 'excl', 'card', 'ord', 'chr', 'ze', 'ze64',
        \ 'tou8', 'toU8', 'tou16', 'toU16', 'tou32', 'toU32', 'abs', 'min', 'max',
        \ 'add', 'repr', 'tofloat', 'toFloat', 'tobiggestfloat', 'toBiggestFloat',
        \ 'toint', 'toInt', 'tobiggestint', 'toBiggestInt', 'addquitproc',
        \ 'addQuitProc', 'copy', 'setlen', 'setLen', 'newstring', 'newString',
        \ 'assert', 'typedesc', 'typed', 'untyped', 'stmt', 'expr', 'echo',
        \ 'swap', 'getrefcount', 'getRefcount', 'getcurrentexception',
        \ 'getCurrentExceptionMsg', 'getoccupiedmem', 'getOccupiedMem',
        \ 'getfreemem', 'getFreeMem', 'gettotalmem', 'getTotalMem', 'isnil',
        \ 'isNil', 'seqtoptr', 'seqToPtr', 'find', 'push', 'pop', 'GC_disable',
        \ 'GC_enable', 'GC_fullCollect', 'GC_setStrategy', 'GC_enableMarkAndSweep',
        \ 'GC_Strategy', 'GC_disableMarkAndSweep', 'GC_getStatistics', 'GC_ref',
        \ 'GC_unref', 'quit', 'OpenFile', 'CloseFile', 'EndOfFile', 'readChar',
        \ 'FlushFile', 'readfile', 'readFile', 'readline', 'readLine', 'write',
        \ 'writeln', 'writeLn', 'writeline', 'writeLine', 'getfilesize',
        \ 'getFileSize', 'ReadBytes', 'ReadChars', 'readbuffer', 'readBuffer',
        \ 'writebytes', 'writeBytes', 'writechars', 'writeChars', 'writebuffer',
        \ 'writeBuffer', 'setfilepos', 'setFilePos', 'getfilepos', 'getFilePos',
        \ 'filehandle', 'fileHandle', 'countdown', 'countup', 'items', 'lines',
        \ 'FileMode', 'File', 'RootObj', 'FileHandle', 'ByteAddress', 'Endianness',
        \ 'byte', 'any', 'auto', 'csize_t', 'cstringArray', 'newSeqWith',
        \ 'newSeqOfCap', 'newStringOfCap'
        \ ]

  for keyword in builtin_functions
    execute 'syn keyword nimBuiltin ' . keyword
  endfor

  let builtin_keywords = [
        \ 'define', 'pragma', 'threadvar', 'compiletime', 'passC', 'passL',
        \ 'link', 'importc', 'importcpp', 'importjs', 'cdecl', 'inline',
        \ 'async', 'await', 'typeof', 'align', 'pure'
        \ ]

  for keyword in builtin_keywords
    execute 'syn keyword nimKeyword ' . keyword
  endfor

  let nimscript_vars = [
        \ 'author', 'backend', 'bin', 'binDir', 'description', 'installDirs',
        \ 'installExt', 'installFiles', 'license', 'packageName', 'requiresData',
        \ 'skipDirs', 'skipExt', 'skipFiles', 'srcDir', 'buildCPU',
        \ 'buildOS'
        \ ]

  for keyword in nimscript_vars
    execute 'syn keyword nimNimscriptVar ' . keyword
  endfor

  let nimscript_funcs = [
        \ 'withDir', 'taskRequires', 'task', 'cp', 'cmpic', 'cpDir', 'cpDir',
        \ 'cppDefine', 'delEnv', 'dirExists', 'exec', 'exists', 'existsEnv',
        \ 'fileExists', 'findExe', 'getCurrentDir', 'getEnv', 'hint', 'listDirs',
        \ 'listFiles', 'mkDir', 'mvDir', 'mvFile', 'nimcacheDir', 'paramCount',
        \ 'paramStr', 'patchFile', 'projectDir', 'projectName', 'projectPath',
        \ 'putEnv', 'readAllFromStdin', 'readLineFromStdin', 'requires', 'rmDir',
        \ 'rmFile', 'selfExe', 'selfExec', 'setCommand', 'switch', 'thisDir',
        \ 'toDll', 'toExe', 'warning'
        \ ]

  for keyword in nimscript_funcs
    execute 'syn keyword nimNimscriptFunc ' . keyword
  endfor

  let custom_types = [
        \ 'i8', 'i16', 'i32', 'i64', 'u8', 'u16', 'u32', 'u64', 'f32', 'f64',
        \ 'uP', 'Sz', 'str', 'cstr'
        \ ]

  for keyword in custom_types
    execute 'syn keyword nimBuiltin ' . keyword
  endfor

  let minc_specials = [
        \ 'comptime', 'namespace', 'stub', 'readonly', 'noreturn'
        \ ]

  for keyword in minc_specials
    execute 'syn keyword nimKeyword ' . keyword
  endfor

  let exceptions = [
        \ 'calloc', 'malloc', 'free', 'resize', 'memset', 'memcpy', 'memmove'
        \ ]

  for keyword in exceptions
    execute 'syn keyword nimException ' . keyword
  endfor

  " Special matches
  syn match nimFunction "\.\<[a-zA-Z0-9_]\+\ze("
  syn match nimFunction "\<\l[a-zA-Z0-9_]\+\ze("
  syn match nimConstructor "\<\L[a-zA-Z0-9_]\+\ze("

  syn match nimBuiltin "\<contains\>"
  syn match nimKeyword "\<compile:"
  syn match nimKeyword "\<header:"
  syn match nimKeyword "\<size:"
  syn match nimKeyword "\<emit:"
endif

if nim_highlight_exceptions == 1
  " Builtin Defects
  let defects = [
        \ 'Defect', 'ArithmeticDefect', 'DivByZeroDefect', 'OverflowDefect',
        \ 'AccessViolationDefect', 'DeadThreadDefect', 'OutOfMemDefect',
        \ 'IndexDefect', 'FieldDefect', 'RangeDefect', 'StackOverflowDefect',
        \ 'ReraiseDefect', 'AssertionDefect', 'ObjectAssignmentDefect',
        \ 'ObjectConversionDefect', 'FloatingPointDefect', 'FloatInvalidOpDefect',
        \ 'FloatDivByZeroDefect', 'FloatOverflowDefect', 'FloatUnderflowDefect',
        \ 'FloatInexactDefect', 'NilAccessDefect'
        \ ]

  " Builtin Errors
  let errors = [
        \ 'LibraryError', 'ResourceExhaustedError', 'Exception', 'CatchableError',
        \ 'IOError', 'EOFError', 'OSError', 'KeyError', 'ValueError'
        \ ]

  " Apply syntax highlighting for defects and errors
  for defect in defects
    execute 'syn keyword nimBuiltin ' . defect
  endfor
  for error in errors
    execute 'syn keyword nimBuiltin ' . error
  endfor

  " Any User error possible
  syn match nimException '\<[A-Z]\w*Error\>'
  syn match nimException '\<[A-Z]\w*Defect\>'
endif

" Highlight space errors if enabled
if nim_highlight_space_errors == 1
  " Trailing whitespace
  syn match nimSpaceError display excludenl "\S\s\+$"ms=s+1
  " Any tabs are illegal in Nim
  syn match nimSpaceError display "\t"
endif

" Highlight special variables if enabled
if nim_highlight_special_vars
  syn keyword nimSpecialVar result
endif

" Sync settings
syn sync match nimSync grouphere NONE "):$"
syn sync minlines=2
syn sync maxlines=200

if v:version >= 508 || !exists('did_nim_syn_inits')
  if v:version <= 508
    let did_nim_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " Default highlighting methods
  let highlight_links = [
        \ ['nimBrackets', 'Operator'],
        \ ['nimKeyword', 'Keyword'],
        \ ['nimConstructor', '@constructor'],
        \ ['nimFunction', 'Function'],
        \ ['nimConditional', 'Conditional'],
        \ ['nimRepeat', 'Repeat'],
        \ ['nimString', 'String'],
        \ ['nimRawString', 'String'],
        \ ['nimBoolean', 'Boolean'],
        \ ['nimEscape', 'Special'],
        \ ['nimOperator', 'Repeat'],
        \ ['nimPreCondit', 'PreCondit'],
        \ ['nimComment', 'Comment'],
        \ ['nimTodo', 'Todo'],
        \ ['nimDecorator', 'Define'],
        \ ['nimSpecialVar', 'Identifier'],
        \ ['nimStatement', 'Statement'],
        \ ['nimConstant', 'Constant'],
        \ ['nimInclude', 'Include'],
        \ ['nimStructure', 'Structure'],
        \ ['nimMacro', 'Macro'],
        \ ['nimCharacter', 'Character'],
        \ ['nimFloat', 'Float'],
        \ ['nimPragma', 'PreProc'],
        \ ['nimType', 'Identifier'],
        \ ['nimNimscriptVar', 'Statement'],
        \ ['nimNimscriptFunc', 'Keyword']
        \ ]

  for [group, link] in highlight_links
    execute 'HiLink ' . group . ' ' . link
  endfor

  " Conditional highlighting
  if nim_highlight_numbers == 1
    HiLink nimNumber Number
  endif
  if nim_highlight_builtins == 1
    HiLink nimBuiltin Number
  endif
  if nim_highlight_exceptions == 1
    HiLink nimException Exception
  endif
  if nim_highlight_space_errors == 1
    HiLink nimSpaceError Error
  endif

  delcommand HiLink
endif

let b:current_syntax = 'nim'
