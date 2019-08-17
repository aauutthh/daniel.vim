if exists('g:daniel_vim_pluged')
  finish
endif
let g:daniel_vim_pluged=1

""
" 小写shell 进入shell
" 大写Shell 执行选中区域(或当前行)的shell命令
" ex:
" :'<,'>BashFilter cat|grep -Po "Filt"
command! -range -nargs=1 ShFilter :<line1>,<line2>w !sh -c <args>
command! -range -nargs=1 BashFilter :<line1>,<line2>w !bash -c <args>

command! -range -nargs=0 ShRun :<line1>,<line2>w !sh
command! -range -nargs=0 BashRun :<line1>,<line2>w !sh

""
" 小写source 执行文件
" 大写Source 执行选中区域(或当前行)的命令
command! -range Source :<line1>,<line2>y x | :@x

