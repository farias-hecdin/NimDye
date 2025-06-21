" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if v:version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

" Lista de variables de resaltado (nombres abreviados).
let s:hl_v = ['nim_hl_nums', 'nim_hl_builtins', 'nim_hl_excs', 'nim_hl_sp_errs', 'nim_hl_spec_vars']

" Si 'nim_highlight_all' existe, se activan todas las opciones.
" De lo contrario, solo se inicializan las que no estén definidas por el usuario.
let s:hl_all = exists('g:nim_highlight_all')
for s:v_name in s:hl_v
  if s:hl_all || !exists('g:' . s:v_name)
    execute 'let g:' . s:v_name . ' = 1'
  endif
endfor
unlet s:hl_all s:v_name s:hl_v

" Regiones y coincidencias generales
syn match nimBuiltin "\<[A-Z]\w*"
syn region nimBrackets contained extend keepend matchgroup=Bold start=+\(\\\)\@<!\[+ end=+]\|$+ skip=+\\\s*$\|\(\\\)\@<!\\]+ contains=@tclCommandCluster

let s:kws = ['and', 'asm', 'atomic', 'div', 'bind', 'block', 'break', 'concept', 'const', 'continue', 'converter', 'defer', 'discard', 'discardable', 'distinct', 'do', 'end', 'enum', 'except', 'export', 'finally', 'for', 'from', 'func', 'import', 'interface', 'iterator', 'let', 'macro', 'method', 'mixin', 'not', 'notin', 'or', 'object', 'out', 'proc', 'raise', 'ref', 'template', 'try', 'tuple', 'type', 'using', 'var', 'vtptr', 'vtref', 'when', 'while', 'with', 'without', 'yield']
let s:b_kws = ['define', 'pragma', 'threadvar', 'compiletime', 'passC', 'passL', 'link', 'importc', 'importcpp', 'importjs', 'cdecl', 'inline', 'async', 'await', 'typeof', 'align', 'pure', 'comptime', 'namespace', 'stub', 'readonly', 'noreturn']
execute 'syn keyword nimKeyword ' . join(s:kws + s:b_kws)
unlet s:kws s:b_kws

let s:excs = ['static', 'include', 'addr', 'ptr', 'cast', 'equalmem', 'equalMem', 'alloc', 'alloc0', 'realloc', 'dealloc', 'zeromem', 'zeroMem', 'copymem', 'copyMem', 'movemem', 'moveMem', 'bycopy', 'calloc', 'malloc', 'free', 'resize', 'memset', 'memcpy', 'memmove']
execute 'syn keyword nimException ' . join(s:excs)
unlet s:excs

let s:conds = ['if', 'elif', 'else', 'case', 'of']
execute 'syn keyword nimConditional ' . join(s:conds)
unlet s:conds

" Funciones, clases, operadores y delimitadores
syn match   nimFunction      "[a-zA-Z_][a-zA-Z0-9_]*\|`.*`" contained
syn match   nimClass         "[a-zA-Z_][a-zA-Z0-9_]*\|`.*`" contained
syn match   nimOperator      +[.][.]+
syn match   nimOperator      "\\>="
syn match   nimOperator      "[-=+/<>@$~&%|!?^\\]\?="
syn match   nimOperator      "[-+/<>@$~&%|!?^\\]"
syn match   nimOperator      "[∙∘×★⊗⊘⊙⊛ ⊠⊡∩∧⊓]"
syn match   nimOperator      "[±⊕⊖⊞⊟∪∨⊔]"
syn match   nimDelimiters    '[{}\[\]()]'
syn match   nimPreCondit     '{\.[a-zA-Z0-9]\+\|\.}'

" Comentarios y TODOs
syn match   nimComment       "#.*$" contains=nimTodo,@Spell
syn region  nimComment       start="#\[" end="\]#" contains=nimTodo,@Spell
syn keyword nimTodo          TODO FIXME XXX contained

" Booleanos, Cadenas y Escapes
syn keyword nimBoolean       true false
syn region  nimString        start=+'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=nimEscape,nimEscapeError,@Spell
syn region  nimString        start=+"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=nimEscape,nimEscapeError,@Spell
syn region  nimString        start=+"""+ end=+"""+ keepend contains=nimEscape,nimEscapeError,@Spell
syn region  nimRawString     matchgroup=Normal start=+[rR]"+ end=+"+ skip=+\\\\\|\\"+ contains=@Spell
syn match   nimEscape        +\\[abfnrtv'"\\]+ contained
syn match   nimEscape        "\\\o\{1,3}" contained
syn match   nimEscape        "\\x\x\{2}" contained
syn match   nimEscape        "\(\\u\x\{4}\|\\U\x\{8}\)" contained
syn match   nimEscape        "\\$"
syn match   nimEscapeError   "\\x\x\=\X" display contained

" Resaltado Condicional
if g:nim_hl_nums == 1
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

if g:nim_hl_builtins == 1
  let s:b_funcs = ['BiggestFloat', 'BiggestInt', 'Byte', 'ByteAddress', 'CloseFile', 'CompileDate', 'CompileTime', 'Conversion', 'EndOfFile', 'Endianness', 'File', 'FileHandle', 'FileMode', 'FlushFile', 'GC_Strategy', 'GC_disable', 'GC_disableMarkAndSweep', 'GC_enable', 'GC_enableMarkAndSweep', 'GC_fullCollect', 'GC_getStatistics', 'GC_ref', 'GC_setStrategy', 'GC_unref', 'Natural', 'OpenFile', 'Positive', 'QuitFailure', 'QuitSuccess', 'ReadBytes', 'ReadChars', 'RootObj', 'abs', 'it', 'add', 'parseInt', 'addQuitProc', 'addquitproc', 'any', 'array', 'assert', 'auto', 'bool', 'byte', 'card', 'cchar', 'cdouble', 'cfloat', 'char', 'chr', 'cint', 'clong', 'clongdouble', 'clonglong', 'copy', 'countdown', 'countup', 'cpuEndian', 'cpuendian', 'cschar', 'cshort', 'csize', 'csize_t', 'cstring', 'cstringArray', 'cuchar', 'cuint', 'culong', 'culonglong', 'cushort', 'dbgLineHook', 'dbglinehook', 'dec', 'defined', 'echo', 'excl', 'expr', 'fileHandle', 'filehandle', 'find', 'float', 'float32', 'float64', 'getCurrentExceptionMsg', 'getFilePos', 'getFileSize', 'getFreeMem', 'getOccupiedMem', 'getRefcount', 'getTotalMem', 'getcurrentexception', 'getfilepos', 'getfilesize', 'getfreemem', 'getoccupiedmem', 'getrefcount', 'gettotalmem', 'high', 'hostCPU', 'hostOS', 'hostcpu', 'hostos', 'inc', 'incl', 'inf', 'int', 'int16', 'int32', 'int64', 'int8', 'isNil', 'isnil', 'items', 'len', 'pairs', 'lines', 'low', 'mapIt', 'max', 'min', 'nan', 'neginf', 'new', 'newSeq', 'newSeqOfCap', 'newSeqWith', 'newString', 'newStringOfCap', 'newseq', 'newstring', 'nimMajor', 'nimMinor', 'nimPatch', 'nimVersion', 'nimmajor', 'nimminor', 'nimpatch', 'nimversion', 'openArray', 'openarray', 'ord', 'pointer', 'pop', 'pred', 'push', 'quit', 'range', 'readBuffer', 'readChar', 'readFile', 'readLine', 'readbuffer', 'readfile', 'readline', 'repeat', 'repr', 'seq', 'seqToPtr', 'seqtoptr', 'set', 'setFilePos', 'setLen', 'setfilepos', 'setlen', 'sizeof', 'stderr', 'stdin', 'stdout', 'stmt', 'string', 'succ', 'swap', 'toBiggestFloat', 'toBiggestInt', 'toFloat', 'toInt', 'toU16', 'toU32', 'toU8', 'tobiggestfloat', 'tobiggestint', 'tofloat', 'toint', 'tou16', 'tou32', 'tou8', 'typed', 'typedesc', 'uint', 'uint16', 'uint32', 'uint64', 'uint8', 'untyped', 'varArgs', 'varargs', 'void', 'write', 'writeBuffer', 'writeBytes', 'writeChars', 'writeLine', 'writeLn', 'writebuffer', 'writebytes', 'writechars', 'writeline', 'writeln', 'ze', 'ze64']
  let s:c_types = ['nil', 'i8', 'i16', 'i32', 'i64', 'u8', 'u16', 'u32', 'u64', 'f32', 'f64', 'uP', 'Sz', 'str', 'cstr']
  execute 'syn keyword nimBuiltin ' . join(s:c_types + s:b_funcs)
  unlet s:b_funcs s:c_types

  let s:ns_vars = ['author', 'backend', 'bin', 'binDir', 'description', 'installDirs', 'installExt', 'installFiles', 'license', 'packageName', 'requiresData', 'skipDirs', 'skipExt', 'skipFiles', 'srcDir', 'buildCPU', 'version', 'buildOS']
  for s:kw in s:ns_vars
    execute 'syn match nimNimscriptVar ' . '"^' . s:kw . '\>"'
  endfor
  unlet s:ns_vars s:kw

  let s:ns_funcs = ['withDir', 'taskRequires', 'task', 'cp', 'cmpic', 'cpDir', 'cpDir', 'cppDefine', 'delEnv', 'dirExists', 'exec', 'exists', 'existsEnv', 'fileExists', 'findExe', 'getCurrentDir', 'getEnv', 'hint', 'listDirs', 'listFiles', 'mkDir', 'mvDir', 'mvFile', 'nimcacheDir', 'paramCount', 'paramStr', 'patchFile', 'projectDir', 'projectName', 'projectPath', 'putEnv', 'readAllFromStdin', 'readLineFromStdin', 'requires', 'rmDir', 'rmFile', 'selfExe', 'selfExec', 'setCommand', 'switch', 'thisDir', 'toDll', 'toExe', 'warning', 'echo']
  execute 'syn keyword nimFunction ' . join(s:ns_funcs)
  unlet s:ns_funcs

  " Coincidencias especiales para builtins y funciones
  syn match nimBuiltin "\<contains\>"
  syn match nimBuiltin "\zs\s\<\L[a-zA-Z0-9_]\+"
  syn match nimConstructor "\s*[A-Z][a-zA-Z0-9_]\+\ze("
  syn match nimFunction "\%(\.\zs\w\+\|\<\l\w*\)\ze\**\%(\[[^\]]*\]\)\?("
  syn match nimKeyword "\<compile:"
  syn match nimKeyword "\<emit:"
  syn match nimKeyword "\<header:"
  syn match nimKeyword "\<size:"
  syn match nimKeyword "\zs\sin\s"
endif

if g:nim_hl_excs == 1
  let s:defs = ['Defect', 'ArithmeticDefect', 'DivByZeroDefect', 'OverflowDefect', 'AccessViolationDefect', 'DeadThreadDefect', 'OutOfMemDefect', 'IndexDefect', 'FieldDefect', 'RangeDefect', 'StackOverflowDefect', 'ReraiseDefect', 'AssertionDefect', 'ObjectAssignmentDefect', 'ObjectConversionDefect', 'FloatingPointDefect', 'FloatInvalidOpDefect', 'FloatDivByZeroDefect', 'FloatOverflowDefect', 'FloatUnderflowDefect', 'FloatInexactDefect', 'NilAccessDefect']
  let s:errs = ['LibraryError', 'ResourceExhaustedError', 'Exception', 'CatchableError', 'IOError', 'EOFError', 'OSError', 'KeyError', 'ValueError']
  execute 'syn keyword nimBuiltin ' . join(s:defs + s:errs)
  unlet s:defs s:errs

  syn match nimException '\<[A-Z]\w*Error\>'
  syn match nimException '\<[A-Z]\w*Defect\>'
endif

if g:nim_hl_sp_errs == 1
  syn match nimSpaceError display excludenl "\S\s\+$"ms=s+1
  syn match nimSpaceError display "\t"
endif

if g:nim_hl_spec_vars
  syn keyword nimSpecialVarAndReturn result return
endif

" Sincronización y Enlaces de Resaltado
syn sync match nimSync grouphere NONE "):$"
syn sync minlines=2
syn sync maxlines=200

if v:version >= 508 || !exists('did_nim_syn_init')
  if v:version <= 508
    let did_nim_syn_init = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  let s:hl_links = [
        \ ['nimBoolean', 'Boolean'], ['nimBrackets', 'Operator'],
        \ ['nimCharacter', 'Character'], ['nimComment', 'Comment'],
        \ ['nimConditional', 'Conditional'], ['nimConstructor', '@constructor'],
        \ ['nimDecorator', 'Define'], ['nimDelimiters', '@variable'], ['nimEscape', 'Special'],
        \ ['nimFloat', 'Float'], ['nimFunction', 'Function'],
        \ ['nimInclude', 'Include'], ['nimKeyword', 'Keyword'],
        \ ['nimMacro', 'Macro'], ['nimNimscriptFunc', 'Keyword'],
        \ ['nimNimscriptVar', 'Statement'], ['nimOperator', 'Repeat'],
        \ ['nimPragma', 'PreProc'], ['nimPreCondit', '@variable.member'],
        \ ['nimRawString', 'String'], ['nimRepeat', 'Repeat'],
        \ ['nimSpecialVarAndReturn', '@keyword.return'], ['nimStatement', 'Statement'],
        \ ['nimString', 'String'], ['nimStructure', 'Structure'],
        \ ['nimTodo', 'Todo'], ['nimType', 'Function'],
        \ ]

  for [s:group, s:link] in s:hl_links
    execute 'HiLink ' . s:group . ' ' . s:link
  endfor
  unlet s:hl_links s:group s:link

  if g:nim_hl_nums == 1
    HiLink nimNumber Number
  endif
  if g:nim_hl_builtins == 1
    HiLink nimBuiltin Number
  endif
  if g:nim_hl_excs == 1
    HiLink nimException Exception
  endif
  if g:nim_hl_sp_errs == 1
    HiLink nimSpaceError Error
  endif

  delcommand HiLink
endif

let b:current_syntax = 'nim'
