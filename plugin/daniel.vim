if exists('g:daniel_vim_pluged')
  finish
endif
let g:daniel_vim_pluged=1

""
" 小写shell 进入shell
" 大写Shell 执行选中区域(或当前行)的shell命令
command! -range -nargs=1 Shell :<line1>,<line2>w !sh -c <args>
command! -range -nargs=1 Bash :<line1>,<line2>w !bash -c <args>

""
" 小写source 执行文件
" 大写Source 执行选中区域(或当前行)的命令
command! -range Source :<line1>,<line2>y x | :@x
