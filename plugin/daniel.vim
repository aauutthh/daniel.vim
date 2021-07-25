:scriptencoding utf-8
if exists('g:daniel_vim_pluged')
  finish
endif
let g:daniel_vim_pluged=1

""
" 小写shell 进入shell
" 大写ShRun 执行选中区域(或当前行)的shell命令
" ex:
" :'<,'>BashFilter cat|grep -Po "Filt"
command! -range -nargs=1 ShFilter :<line1>,<line2>w !sh -c <args>
command! -range -nargs=1 BashFilter :<line1>,<line2>w !bash -c <args>

command! -range -nargs=0 ShRun :<line1>,<line2>w !sh
command! -range -nargs=0 BashRun :<line1>,<line2>w !bash

""
" 小写source 执行文件
" 大写Source 执行选中区域(或当前行)的命令
command! -range Source :<line1>,<line2>y x | :@x


"nmap ,date :. !date +"\# \%Y-\%m-\%d \%H:\%M:\%S"<CR>
nmap ,date :call setline(line('.'), getline('.') ." ". strftime("%Y-%m-%d %H:%M:%S"))<CR>

" 语法检查时忽略的错误
let g:syntastic_quiet_messages = {
    \ 'regex':   ['MD013', 'MD033'],
    \ 'file:p':  ['\m^/usr/include/', '\m\c\.h$'] }


" markdown 文件保存时去除末尾空格
augroup markdown_trim_space
  autocmd!
  " :ks 当前位置记号为s, 方便跳回
  autocmd BufWritePre *.md ks|%s/\s\+$//ge
      \|%s/\t/    /ge|'s
augroup END

" auto use templates
" 新建文件时自动使用模板
augroup Templates
  autocmd!
  " 模板替换算法: [template.vim](https://www.vim.org/scripts/script.php?script_id=2834)
  autocmd BufNewFile *.*  let b:tpl = daniel#TemplatesPath(). '/skeleton.'.expand('%:e')
    \| if filereadable(b:tpl) 
    \| exec "0r ".b:tpl 
    \| silent %s/<%=\(.\{-}\)%>/\=eval(submatch(1))/ge 
    \| endif
augroup end

" help vim
" 设置modeline支持
set modeline

function s:NeedGitSave()
    "call system('git ls-files '.expand('%:p').' > /dev/null 2>&1')
    call system('git ls-files --error-unmatch -- '.expand('%:p').' > /tmp/11 2>&1')
    if v:shell_error
        return v:false
    endif
    let s:diffnumstat = system('git diff --numstat '.expand('%:p'))
    let s:addlinenum = str2nr(split(s:diffnumstat.'0', '\s\+')[0])
    " 差异数达到10行才自动提交，避免频繁提交
    if s:addlinenum < 10
      return v:false
    endif
    return v:true
endfunction

function s:AutoGitSave()
    if ! s:NeedGitSave()
      return
    endif
    let s:message = 'vim-AutoComit ' . expand('%:.')
    call system('git add ' . expand('%:p'))
    call system('git commit -m ' . shellescape(s:message, 1))
    silent echom s:message
endfunction

" 保存时自动在git提交文件
augroup GitSaveGrp
  autocmd!
  autocmd BufWritePost *.vim,*.md call s:AutoGitSave()
augroup end

" Tabularize 
" Tabularize  for markdown table 
" :'<,'>Tabularize M<Tab>
AddTabularPattern MdTable /|/l0

