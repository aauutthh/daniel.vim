" (C) Copyright 2019 all rights reserved
" File              : daniel.vim
" Author            : Daniel Li <authendic@163.com>
" Date              : 2019-07-15
" Last Modified Date: 2019-07-15
" Last Modified By  : Daniel Li <authendic@163.com>

" vim:set fdm=marker:

""
" @section Introduction,intro
" 该插件是daniel本人使用，不考虑其他任何人使用习惯
" 为了该插件一处编写，到处使用:
" 1. 尽量不修改mapping
" 2. 只使用vim-plug作为插件管理，并有限提供该管理器的兼容支持
" 

if exists('g:daniel_vim_loaded')
  finish
endif
let g:daniel_vim_loaded = 1

""
" @section 配置方法,config
"
" 安装本插件
"
" git clone https://github.com/aauutthh/daniel.vim -C ~/.vim/pack
"
" vim +"PlugInstall"
"

""
" 自动安装vim-plug插件管理器
function! daniel#PlugManagerInstall() 
"{{{
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endfunction "}}}

""
" daniel使用的PlugIns, 该函数需要在 |plug#begin| |plug#end| 之间使用，可参考 |daniel#InstallPlugIns|
function! daniel#PlugIns() 
"{{{
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
"Plug 'aauutthh/deb_config' , {'rtp': 'daniel.vim'}
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'burnettk/vim-angular'
Plug 'pangloss/vim-javascript'
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
Plug 'davidhalter/jedi-vim'
Plug 'vim-scripts/taglist.vim'
Plug 'godlygeek/tabular' " 对齐工具 Tab /=
"Plug 'vim-scripts/DoxygenToolkit.vim'
Plug 'alpertuna/vim-header'
endfunction "}}}

""
" 自动安装daniel使用的系列插件
" 几个要注意的问题:
" 1. 一骨脑安装，网络环境不好时会很慢，可以按需调整 |daniel#PlugIns| 中的插件
" 2. |plug#begin| |plug#end| 在整个vim的生命周期中只可运行一次，因其影响全局设置才使得其管理的插件生效
" 3. 该函数调用完 |plug#begin| |plug#end| 会将这两个重定义，以防被多次调用
" 4. 该函数会被自动调用，如果发现|plug#begin| |plug#end|被运行过，则给出修改建议
function! daniel#InstallPlugIns() 
"{{{
if exists("g:plugs") && len(g:plugs) > 0 
  call daniel#recallerr_hint()
  return
endif
  call plug#begin('~/.vim/plugged')
  call daniel#PlugIns() 
  call plug#end()

" 重定义plug#函数，以免被二次调用
" {{{
  function! plug#begin(...)
    echohl WarningMsg|echom "recall plug#begin" | echohl None
  endfunction
  function! plug#end(...)
  call daniel#recallerr_hint()
  endfunction
  function! plug#(...)
    echohl WarningMsg|echom "redo command Plug ". a:000[0] | echohl None
  endfunction
" end redefine for cover
" }}}

endfunction "}}}

function! daniel#recallerr_hint() 
"{{{
  echohl WarningMsg
  echom "modify `plug` add daniel#PlugIns like below:"
  echom "```vim"
  echom "call plug#begin()"
  echom "call daniel#PlugIns()"
  echom "call plug#end()"
  echom "call daniel#VimConfig(0) \" without auto plugins"
  echom "```"
  echom "and restart"
  echom "daniel#VimConfig(1) will call daniel#PlugIns() inner"
  echohl None
  return
endfunction "}}}

""
" 该函数是主驱函数，驱动以下事务:
" 1. 自动安装vim-plug , |daniel#PlugManagerInstall|
" 1. 自动配置公共设置
" 1. 不同插件的配置
"
" 参数含义 doInstall 是否由daniel插件直接安装daniel所需插件
" 1: 是的。 这样做的话在~/.vimrc中不能再调用 |plug#begin| |plug#end|
" 0: 不安装。 可以在~/.vimrc中调用 |plug#begin| |plug#end|, 并选择性在其中调用 |daniel#PlugIns|
function! daniel#VimConfig(doInstall,...) 
"{{{
  call daniel#PlugManagerInstall()
  call daniel#CommondConfig()
  
  " TagList config
  call daniel#TagListConfig() 
  
  " ctags
  set tc=ignore " tagcase ignore case
  set tags=./tags,tags "tags file searching list
  
  call daniel#ForPythonConfig() 
  
  " call daniel#DoxygenConfig() 
  call daniel#VimHeaderConfig() 
  
  " 用户设置完成后，才加载插件，以使得用户设置生效
  if a:doInstall
    call daniel#InstallPlugIns()
  endif

endfunction "}}}

let s:Paths = {}

""
" 通用配置， 插件无关
function! daniel#CommondConfig() 
"{{{
source $VIMRUNTIME/defaults.vim
source $VIMRUNTIME/vimrc_example.vim

set nocompatible
set fileformat=unix
set nu  " number
set go=e
"colo evening " 部分终端会变成灰色  
set noautoindent
set paste
set noai
set tabstop=2
set expandtab
set shiftwidth=4
set shiftround

if has('unix') 
  let s:Paths["tmpdir"] = "/tmp/vim_".$USER."/"
  if !isdirectory(s:Paths["tmpdir"])
    call mkdir(s:Paths["tmpdir"],"p","0750")
  endif
end
let &g:undodir=s:Paths["tmpdir"] 
let &g:backupdir=s:Paths["tmpdir"]. "," .&g:backupdir
let &g:directory=s:Paths["tmpdir"]. "," .&g:directory

set nobackup
set autochdir
set ignorecase smartcase
set nowrapscan
"set linebreak

" 总显示状态栏
set laststatus=2

"set encoding=utf-8
"set langmenu=zh_CN.UTF-8
"language message zh_CN.UTF-8
"set termencoding=gb2312
"let &termencoding=&encoding
" 自动识别文件编码
set fileencodings=utf-8,ucs-bom,cp936,GBK
"set fileencodings=cp936,GBK,utf-8
"set encoding=GBK
"set termencoding=gbk

filetype plugin indent on
filetype indent on

set completeopt=menu

"" for Xclipboard
" vnoremap <silent> ,y :silent! w ! xsel -i -b<CR>
vnoremap <silent> ,y :w ! xsel -i -b<CR>

" 代码折叠 zc zC zo zO zi
"set foldmethod=indent

endfunction "}}}

" Tag list config (ctags)
function! daniel#TagListConfig() 
"{{{
" 设定ctags程序位置
let g:Tlist_Ctags_Cmd = "/usr/bin/ctags"

" 不同时显示多个文件的tag，只显示当前文件的
let g:Tlist_Show_One_File = 1

" 如果taglist窗口是最后一个窗口，则退出vim
let g:Tlist_Exit_OnlyWindow = 1 

" 在taglist窗口显示位置 0:左侧窗口(默认) 1:右侧
" let g:Tlist_Use_Right_Window = 1 

" Tag List 查找tag的位置默认是当前路径下的tags
" set tags+=/usr/include/python2.7/tags

autocmd FileType python,c,cpp,go let g:Tlist_Auto_Open = 1
autocmd VimEnter *.cpp,*.h,*.hpp,*.c,*.cc,*.mq4,*.s,*.go,*.py,*.vim :Tlist
endfunction "}}}


function! daniel#ForPythonConfig() 
"{{{
autocmd FileType python setlocal omnifunc-=preview
endfunction "}}}

function! daniel#ForCLikeConfig() 
"{{{
endfunction "}}}

function! daniel#DoxygenConfig() 
"{{{
"let g:DoxygenToolkit_briefTag_pre="@Synopsis  "
"let g:DoxygenToolkit_paramTag_pre="@Param "
"let g:DoxygenToolkit_returnTag="@Returns   "
let s:blockbound="----------------------------------------------------------------------------"
let g:DoxygenToolkit_blockHeader=s:blockbound
let g:DoxygenToolkit_blockFooter=s:blockbound
let g:DoxygenToolkit_authorName="Daniel Li"
let g:DoxygenToolkit_licenseTag="(C) Copyright ". strftime("%Y")
endfunction "}}}

function! daniel#VimHeaderConfig() 
"{{{
let g:header_auto_add_header = 0
let g:header_field_author = 'Daniel Li'
let g:header_field_author_email = 'authendic@163.com'
let g:header_field_copyright = '(C) Copyright '.strftime("%Y")." all rights reserved"
let g:header_field_timestamp_format = '%Y-%m-%d'
" map <F4> :AddHeader<CR>
endfunction "}}}
