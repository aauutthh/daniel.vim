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

" script path
let s:spath = resolve(expand("<sfile>:p:h"))

function daniel#Path() 
"{{{
  return s:spath
endfunction "}}}

""
" @section 配置方法,config
"
" 安装本插件
"
" 在~/.vimrc开头中加入以下内容:
"
" set rtp+=~/.vim/daniel
"
" if empty(glob('~/.vim/daniel'))
"
"     silent !git clone https://github.com/aauutthh/daniel.vim ~/.vim/daniel
"
"     if v:shell_error==0
"
"         call daniel#PlugManagerInstall()
"
"     endif
"
"     finish
"
" endif
"
" call daniel#VimConfig(1)
"
" 保存关闭后执行:
"
" vim +"PlugInstall"
"
" 有时可能这一句:
"
"   call daniel#VimConfig(1)
"
" 要替换成下面:
"
"   call plug#begin()
"
"   call daniel#PlugIns()
"
"   call plug#end()
"
"   call daniel#VimConfig(0)
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
  Plug 'vim-airline/vim-airline-themes'
  Plug 'junegunn/seoul256.vim'
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/limelight.vim'
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'burnettk/vim-angular'
  Plug 'pangloss/vim-javascript'
  " ternjs for javascript
  Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }
  Plug 'davidhalter/jedi-vim'
  " jedi 默认会绑定\r, 这里改为空就不会绑定
  let g:jedi#rename_command = ""
  Plug 'vim-scripts/taglist.vim'
  Plug 'majutsushi/tagbar'
  Plug 'godlygeek/tabular' , { 'on': 'Tabularize' } " 对齐工具 Tab /=
  "Plug 'vim-scripts/DoxygenToolkit.vim'
  Plug 'alpertuna/vim-header'
  Plug 'lvht/phpcd.vim', { 'for': 'php', 'do': 'composer install' }

  " 自动生成tag文件, 自动查找项目顶层目录
  Plug 'ludovicchabant/vim-gutentags'

  " :NERDTreeToggle 打开文件浏览器
  Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

  " 该模块还有后续安装步骤，见 daniel#ForYCMConfig
  Plug 'ycm-core/YouCompleteMe' , { 'do' : 'git submodule update --init --recursive' }

  " ctrl-w_o 放大一个窗口，两次输入回复窗口。 原生的only window无法恢复窗口
  Plug 'vim-scripts/ZoomWin'

  " 为了支持flask而安装python-mode
  " python-mode 可以实现检查pep8
  Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
  " 插件会绑定快捷键\r , 作为执行脚本用, 与我想绑定的执行shell冲突
  " pymode_run置为0就会不绑定相关
  let g:pymode_run = 0
  let g:pymode_run_bind='<leader>exe' 

  ""
  " 增加额外的配色方案
  " 通过colorscheme <name>来设置
  Plug 'flazz/vim-colorschemes'

  Plug 'morhetz/gruvbox'

  ""
  " 该插件只是完成了后台运行，linux下不能显示quickfix窗口
  " 思想上可以借鉴
  " Plug '~/gits/src/github.com/skywind3000/asyncrun.vim'

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
  call s:recallerr_hint()
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
  call s:recallerr_hint()
  endfunction
  function! plug#(...)
    echohl WarningMsg|echom "redo command Plug ". a:000[0] | echohl None
  endfunction
" end redefine for cover
" }}}

endfunction "}}}

function! s:recallerr_hint()
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
  
  call daniel#ForAirlineConfig () 
  " Tag config
  call daniel#TagConfig() 
  
  call daniel#ForGolangConfig() 
  call daniel#ForClangConfig() 
  call daniel#ForYCMConfig () 
  call daniel#ForTernJsConfig() 
  call daniel#ForPhpConfig()
  call daniel#ForPythonConfig() 

  autocmd FileType * call daniel#FileTypeChange()

  com! MarkdownPrintCode call daniel#MarkdownPrintCode()
  
  " call daniel#DoxygenConfig() 
  call daniel#VimHeaderConfig() 
  
  " 用户设置完成后，才加载插件，以使得用户设置生效
  if a:doInstall
    call daniel#InstallPlugIns()
  endif

  exec "set rtp+=".fnamemodify(s:spath,":h")."/after"

  " themes选择必须在插件适配后才可以
  " 颜色模式会根据终端类型而不同为
  " linux下需将终端设为linux , mac下使用iterm2会自动设置终端为xterm,注意.bashrc不会复盖这个设置即可
  "colo evening " 部分终端会变成灰色  
  "let g:gruvbox_termcolors=16
  "colo gruvbox
  colo seoul256
  call daniel#UtilCommands()

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
  set noautoindent
  "设置set paste , 否则复制时会触发过多的输入事件，导致很慢
  set paste
  set ai
  set tabstop=2
  set expandtab
  set shiftwidth=4
  set shiftround

  " ctrl-w_} 打开预览窗口， 窗口大小
  " :pc "preview close
  set previewheight=4
  
  "guioptions
  "set go=e
  
  if has('unix') 
    let s:Paths["tmpdir"] = "/tmp/vim_".$USER."/"
    if !isdirectory(s:Paths["tmpdir"])
      call mkdir(s:Paths["tmpdir"],"p","0750")
    endif
  end
  let &g:undodir=s:Paths["tmpdir"] 
  let &g:backupdir=s:Paths["tmpdir"]. "," .&g:backupdir
  " directory 用于swapfile , 当结尾是'//'时，使用绝对路径，避免swapfile collisions冲突
  " 用:sw 查看当前的swapfile
  let &g:directory=s:Paths["tmpdir"]. "/," .&g:directory
  
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

  ""
  " 在tty下可以使用鼠标
  " 左键定位 右键定位并进入v mode可视化模式
  set ttymouse=xterm
  
  ""
  " 在normal mode/insert mode下不开启vim鼠标响应，鼠标响应xterm的事件,可以选取文字和右键复制
  " 在visual mode下开启vim鼠标响应，鼠标不响应xterm的事件, 不可以选取文字，但可以定位光标
  " 网上那些教mouse=a的混蛋，a表示所有模式都开启vim鼠标响应，鼠标将不能再选取文字右键复制了
  set mouse=v
  
  "" for Xclipboard
  " vnoremap <silent> ,y :silent! w ! xsel -i -b<CR>
  vnoremap <silent> ,y :w ! xsel -i -b<CR>
  
  " 代码折叠 zc zC zo zO zi
  "set foldmethod=indent

endfunction "}}}

" Tag list config (ctags)
" Tag Config
function! daniel#TagConfig() 
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
  " 增加向上查找tags, ';'表示向上查找, tags变量是","分隔的

  " ctags
  set tc=ignore " tagcase ignore case
  set tags=./tags;,./.tags; "tags file searching list
  " let g:tagbar_type_cpp = {
  "     \ 'ctagstype' : 'cpp',
  "     \ 'deffile' : expand('%:p:h') . 'cpp.cnf'
  " \ }
  
  "{{{ gutentags 自动生成tags 文件
  " 设置顶层目录标志文件, 自动查找项目顶层
  let g:gutentags_project_root = ['.gutctags','.root','.top']
  "let g:gutentags_dont_load=1 
  let g:gutentags_enabled = 1 

  " gutctags文件内容与ctags文件一样 man ctags, gutentags插件会把这个文件中的内容传递给ctags作为参数
  " 参考格式:
  " --exclude=*back
  " --exclude=^\.*
  " --exclude=*bin*

  " 设置cache目录有助于集中管理tags, 但是tag搜索需要更多配置，gutentags没有提供项目tags名称的接口
  "let g:gutentags_cache_dir="~/ctags"

  " 为使文件不污染svn目录，使用'.'前缀
  let g:gutentags_ctags_tagfile = '.tags'
  "}}}

  "{{{
  " tagbar
  let g:tagbar_type_go = {
      \ 'ctagstype' : 'go',
      \ 'kinds'     : [
          \ 'p:package',
          \ 'i:imports:1',
          \ 'c:constants',
          \ 'v:variables',
          \ 't:types',
          \ 'n:interfaces',
          \ 'w:fields',
          \ 'e:embedded',
          \ 'm:methods',
          \ 'r:constructor',
          \ 'f:func'
      \ ],
      \ 'sro' : '.',
      \ 'kind2scope' : {
          \ 't' : 'ctype',
          \ 'n' : 'ntype'
      \ },
      \ 'scope2kind' : {
          \ 'ctype' : 't',
          \ 'ntype' : 'n'
      \ },
      \ 'ctagsbin'  : 'gotags',
      \ 'ctagsargs' : '-sort -silent'
  \ }
  let g:tagbar_left = 1
  let g:tagbar_width = winwidth(0) / 4
  if g:tagbar_width  < 20
    let g:tagbar_width  = 20
  endif

  "}}}

  "autocmd FileType python,c,cpp,go let g:Tlist_Auto_Open = 1
  autocmd FileType python,c,cpp,go :Tagbar
  autocmd FileType go let g:Tlist_Ctags_Cmd="gotags" | let g:gutentags_dont_load=1 | let g:gutentags_enabled = 0 
  autocmd VimEnter *.cpp,*.h,*.hpp,*.c,*.cc,*.mq4,*.s,*.py let g:gutentags_enabled = 1 | :Tagbar
  autocmd VimEnter *.vim*,*.go :Tagbar
endfunction "}}}

let g:project_top= ""
function! s:Project_vimrc()
"{{{
  let l:prjtop = s:GetProjectTop()
  let g:project_top = l:prjtop
  " let l:topvimrc=findfile(".vimrc",".;")
  let l:topvimrc=l:prjtop."/.vimrc"
  if !filereadable(l:topvimrc)
    return
  endif
  " 需避免运行其他用户的vimrc文件
  if l:topvimrc != "" 
      let l:homevimrc= fnamemodify("~/.vimrc", ":p")
      if l:topvimrc != l:homevimrc
          echom "find proj vim: ".l:topvimrc
          exec "source ".l:topvimrc
      endif
  endif

endfunction "}}}

""
" 查找项目顶层目录
" 兼容使用 g:gutentags_project_root = ['...']
function! s:GetProjectTop()
"{{{
if exists("*gutentags#get_project_root")
    return gutentags#get_project_root(expand('%:p:h', 1))
endif
try
    return gutentags#get_project_root(expand('%:p:h', 1))
catch "/.*/
    "echom "error:".v:exception
    return expand('%:p:h', 1)
endtry
endfunction "}}}

function! s:GOPATH_Add_project_dir()
"{{{
  " 从当前路径向上查找.gotop文件,作为根路径
  let l:top=findfile(".gotop",".;")
  if l:top==""
      " 从当前路径向上查找src目录 , src与.gotop同级
      let l:top=finddir("src",".;")
  endif
  if l:top==""
      return 
  endif
  
  " 取目录
  let l:top = fnamemodify(l:top, ":h")
  let l:paths=split($GOPATH,":")
  if index(l:paths, l:top) >0 
      return 
  endif

  exec "GoPath ".l:top . ":" . $GOPATH
  "let $GOPATH = l:top . ":" . $GOPATH

endfunction "}}}

function! daniel#ForClangConfig() 
"{{{
  "autocmd VimEnter *.cpp,*.h,*.hpp,*.c,*.cc,*.mq4,*.s :set tags+=./tags;
  autocmd VimEnter *.cpp,*.h,*.hpp,*.c,*.cc,*.mq4,*.s :call s:Project_vimrc()
endfunction "}}}

function! daniel#ForGolangConfig() 
"{{{
  " 用vimenter时机比gopls慢，导致设置GOPATH前gopls就启动了
  "autocmd VimEnter *.go :call s:GOPATH_Add_project_dir()
  autocmd FileType go :call s:GOPATH_Add_project_dir()
endfunction "}}}

function! s:PythonAutoSettingPost() 
"{{{
  setlocal omnifunc-=preview 
  let s:pythonpath = fnamemodify(s:spath,":h") . "/modules/python3/site-packages"
  "exec ":badd ".s:pythonpath . "/_.py" 
  py3 << EOF
# hook for ycm 
import os
jedi_vim.jedi.settings.cache_directory = os.getenv('HOME') + '/.cache/jedi'
jedi_vim.jedi.settings.use_filesystem_cache = True
jedi_vim.jedi.settings.fast_parser = True
#jedi_vim.jedi.settings.auto_import_modules += ['requests']

pythonpath=vim.bindeval("s:pythonpath")
from ycm.client.base_request import BuildRequestData
#if "myBuildRequestData" not in dir():
if False:
    def myBuildRequestData(*args , **kwargs):
        r = BuildRequestData()
        add_code_line = [
          "import sys",
          "sys.path.insert(0,'%s')" % pythonpath.decode("utf8"),
          "\n",
        ]
        rfilepath = r['filepath']
        if rfilepath in r['file_data']:
            r['line_num'] += len(add_code_line)
            add_code = "\n".join(add_code_line)
            r['file_data'][rfilepath]['contents'] = add_code + r['file_data'][rfilepath]['contents']
        return r
    
    youcompleteme.BuildRequestData = myBuildRequestData
EOF

if 0
  py3 << EOF
# hook for jedi
@jedi_vim.catch_and_print_exceptions
def get_script(source=None, column=None):
    jedi_vim.jedi.settings.additional_dynamic_modules = [
        b.name for b in vim.buffers if (
            b.name is not None and
            b.name.endswith('.py') and
            b.options['buflisted'])]
    if source is None:
        source = '\n'.join(vim.current.buffer)
    source = "import sys\nsys.path.insert(0,'%s')\n" % pythonpath + source
    row = vim.current.window.cursor[0]
    if column is None:
        column = vim.current.window.cursor[1]
    buf_path = vim.current.buffer.name

    return jedi_vim.jedi.Script(
        source, row, column, buf_path,
        encoding=jedi_vim.vim_eval('&encoding') or 'latin1',
        environment=jedi_vim.get_environment(),
    )
#jedi_vim.get_script = get_script
EOF
endif
endfunction "}}}

function! daniel#ForPythonConfigPost() 
"{{{
  call s:PythonAutoSettingPost()
endfunction "}}}

function! daniel#ForPythonConfig() 
"{{{
" let g:jedi#completions_command = "<c-o>"
"      let pluginpath = fnamemodify(s:spath , ':h:h')
"       let g:ycm_language_server = [ {
" \         'name': 'python',
" \         'cmdline': [ '/usr/bin/python3',
" \         pluginpath.'/plugged/jedi-vim/pythonx/jedi/jedi/evaluate/compiled/subprocess/__main__.py',
" \         pluginpath.'/plugged/jedi-vim/pythonx/parso',
" \         '3.5.3'],
" \         'filetypes': [ 'python' ]
" \         }
" \         ]

endfunction "}}}

function! daniel#ForPhpConfig() 
"{{{
  set ai
endfunction "}}}

function! daniel#ForCLikeConfig() 
"{{{
endfunction "}}}

""
" 参考这里配置
" http://ternjs.net/doc/manual.html#configuration
" 1. 语义树
" ~/.vim/plugged/tern_for_vim/node_modules/tern/defs/chai.json
" 在defs目录中的这些文件，定义一些语法元素，用于一些builtin
" type或没有原码但需要提示的场景
"
" 2. Project configuration 项目配置
" 在项目顶层放置一个`.tern-project`这样的json文件
" :help tern  
function! daniel#ForTernJsConfig() 
"{{{
	  let s:tern_project_code='{
\      "libs": [
\        "browser",
\        "jquery"
\      ],
\      "loadEagerly": [
\        "importantfile.js"
\      ],
\      "plugins": {
\        "requirejs": {
\          "baseURL": "./",
\          "paths": {}
\        }
\      }
\    }'

  command TernProjectFileCreate call writefile([json_encode(json_decode(s:tern_project_code))],".tern-project") |
              \  echom "save .tern-project to ".getcwd()

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

""
" for vim-header
function! daniel#VimHeaderConfig() 
"{{{
  let g:header_auto_add_header = 0
  let g:header_field_author = 'Daniel Li'
  let g:header_field_author_email = 'authendic@163.com'
  let g:header_field_copyright = '(C) Copyright '.strftime("%Y")." all rights reserved"
  let g:header_field_timestamp_format = '%Y-%m-%d'
  " map <F4> :AddHeader<CR>
endfunction "}}}

""
" ycm需要go支持， 并且会访问 https://golang.org/x/tools 这个被墙的网站
" 需要在$GOPATH/src/github.com/golang 下git clone https://github.com/golang/..
" 然后 :
"  cd ~/.vim/plugged/YouCompleteMe/third_party/ycmd/third_party/go/src/golang.org
"  ln -sf $GOPATH/src/github.com/golang x 
"
"重新在  ~/.vim/plugged/YouCompleteMe
"  git submodule update --init --recursive
"  如果`third_party`目录下有哪个目录出问题，就删掉重新执行submodule
"
"一切就绪后:
"  python3 install.py --clang-completer
"  
"其他语言支持见官网
"
"项目下最好有个 compile_commands.json 文件，指示每个文件的编译方式
"只要命令能编译通过，ycm就能通过libclang.so的调用检查语法及补全
"对于没有外部依赖的文件，可以不用这个json文件
"生成 compile_commands.json的工具 `apt-get install bear`
"//TODO: 目前为止, 没有使用compile_commands.json 成功配置过ycm
"
"如果要扩展/修改，只需要修改g:ycm_global_ycm_extra_conf所指示python脚本
"ycm使用的是clang的库，所以需要安装`sudo apt install libc++-dev`
" 
function! daniel#ForYCMConfig () 
"{{{
" https://www.jianshu.com/p/d908ce81017a?nomobile=yes
  let g:ycm_server_python_interpreter='python3'
  " 找到.extra_conf不用提示
  let g:ycm_confirm_extra_conf=0
  " 补全窗口中选择会同时输出preview窗口查看docstring/helpmessage
  let g:ycm_add_preview_to_completeopt=1
  " 补全窗口关闭同时关闭preview窗口
  let g:ycm_autoclose_preview_window_after_completion=1

  let g:ycm_always_populate_location_list =1

  " https://github.com/ycm-core/YouCompleteMe/issues/2870
  let g:ycm_python_binary_path='python3'


  ""
  " ycm会在打开的文件所在目录及向上查找 .ycm_extra_conf.py
  " 如果查找不到，则会使用全局
  " 其中最重要的接口是: FlagsForFile( filename, **kwargs )
  " 每打开一次文件，ycm就会调用这个接口一次，以决定该文件使用的clang编译flags
  "let g:ycm_global_ycm_extra_conf='~/.vim/plugged/YouCompleteMe/third_party/ycmd/examples/.ycm_extra_conf.py'
  autocmd FileType c,cpp let g:ycm_global_ycm_extra_conf='~/.vim/.ycm_extra_conf.py'


  " ycm 切换下一个error
  nmap ,n :lnext<CR>

endfunction "}}}

""
" Airline 需要安装powerline 字体
" sudo apt-get install fonts-powerline
" 终端需配置使用powerline字体
function! daniel#ForAirlineConfig () 
"{{{
  " 这个很重要
  set t_Co=256

  let g:airline_powerline_fonts = 1

  "AirlineTheme term
  "修改了vim-airline-themes/autoload/airline/themes/solarized.vim中`s:N3`变量，字体效果改为'bold'
  let g:airline_theme='solarized'

  " 打开tabline
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#buffer_nr_show = 1

  ""
  "gui vim 程序 需要设置字体
  "set guifont=Cousine\ for\ Powerline:h15
  let g:Powerline_symbols = 'fancy'

endfunction "}}}
  
function! daniel#FileTypeChange()
"{{{
"echom "ft change to ".&ft
  if (&ft == "vim")
    set fdm=marker
  elseif(&ft == "python")
    set fdm=indent
  endif
endfunction "}}}

function! daniel#UtilCommands()
"{{{
  ""
  " 查找笔记，并在预留窗口打开(ctrl-q) q for quickfix
  if exists('$NOTEDIR') && isdirectory($NOTEDIR)
    "com! -nargs=0 ViewNote call fzf#run({"source":"find ".$NOTEDIR.' -type f -name "*.md"',"down":20})
    "com! -bang -nargs=0 ViewNote call fzf#run(fzf#wrap("ViewNote",{"source":"find . -type f -name '*.md'","dir":$NOTEDIR,"down":20},<bang>)) | normal <c-w>P
    com! -bang -nargs=0 ViewNote :FZF $NOTEDIR
    " let g:fzf_action = {
    " \ 'ctrl-q': 'ped',
    " \}
  endif

    function! s:build_quickfix_list(lines)
      call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
      copen
      "cc
    endfunction

    function! s:save_to_reg(lines)
      call setreg('"',join(a:lines,"\n"))
      call append(line('.'),a:lines)
    endfunction

    let g:fzf_action = {
      \ 'ctrl-r': function('s:build_quickfix_list'),
      \ 'ctrl-q': 'ped',
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-y': function('s:save_to_reg'),
      \ 'ctrl-v': 'vsplit' }

"}}}
endfunction

function! daniel#MarkdownPrintCode()
"{{{
  let oldpos = getcurpos()

  call cursor(oldpos[1]-1,0)
  let posA = searchpos('^\s*```','nW')  " 不移动cursor 不wrapscan
  call cursor(oldpos[1],oldpos[2])
  if ( posA == [0,0])
    return
  endif

  let line=getline(posA[0])
  let space = matchstrpos(line,'```')
  let pattern2='^'.line[:space[2]-1].'\_s*$'
  call cursor(posA[0]+1,posA[1])
  let posB = searchpos(pattern2,'nW')  " 不移动cursor 不wrapscan
  call cursor(oldpos[1],oldpos[2])
  if ( posB == [0,0])
    return
  endif

  exec ":".posA[0].",".posB[0]."w !cut -c ".(space[1]+1)."-"

"}}}
endfunction

function! s:Previewwindow_open(name) 
"{{{
    pclose
    exe "botright 4new " . a:name
    setlocal buftype=nofile bufhidden=delete noswapfile nowrap previewwindow
    redraw
endfunction 
"}}}

function! s:Previewwindow_run(cmd) 
"{{{
    try
    let l:cmd = substitute(a:cmd, '%\(:[phtre]\)*' ,'\=expand(submatch(0))',"g")
    let l:cmd = substitute(l:cmd, '<\w\+>\(:[phtre]\)*' ,'\=expand(submatch(0))',"g")
    let l:msg=systemlist(l:cmd)
    if len(msg)
        call s:Previewwindow_open("__run__")
        call append(line('$'), l:msg)
        normal dd
        call cursor(line('$'),1)
        wincmd p
     else
         echo "No output."
     endif
     catch
        echohl Error | echo "Run-time error." | echohl none
     endtry
endfunction 
"}}}

command! -nargs=+ -complete=shellcmd PreviewRun :call <SID>Previewwindow_run(<q-args>)

if len(mapcheck('<Leader>r','n'))==0
  nmap <Leader>r :PreviewRun 
endif
