if exists('g:daniel_vim_pluged')
  finish
endif
let g:daniel_vim_pluged=1

"if empty(glob('~/.vim/autoload/daniel.vim'))
"    silent !curl -fLo ~/.vim/autoload/daniel.vim --create-dirs
"                \ https://raw.githubusercontent.com/aauutthh/deb_config/master/daniel.vim/autoload/daniel.vim
"    source ~/.vim/autoload/daniel.vim
"    call daniel#PlugManagerInstall()
"endif
"

""
" 这个调用需要写到~/.vimrc中
" call daniel#VimConfig(1)
