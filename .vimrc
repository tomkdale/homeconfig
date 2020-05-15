""""""""""""""""""""""""""""""""""""""""
" Tom's vimrc
"
""""""""""""""""""""""""""""""""""""""


" VIMPLUG
" If vimplug not installed then install it
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Aligns text is special ways for extended formating rules
" https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Github dashboard, look through github events in vim
" https://github.com/junegunn/vim-github-dashboard
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" autofilling snippets in vim
" https://github.com/SirVer/ultisnips
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


" Nerdtree and nerdtree git
Plug 'preservim/nerdtree' | Plug 'scrooloose/nerdtree' 

" Sensible vimrc things that 'should be in any vimrc'
" https://github.com/tpope/vim-sensible
Plug 'tpope/vim-sensible'

" Initialize plugin system
call plug#end()


" https://fedoramagazine.org/add-power-terminal-powerline/
python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup
set laststatus=2 " Always display the statusline in all windows
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set t_Co=256

" Save with sudo
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
"personal fun things
set number relativenumber

set mouse=a
set ic ai ts=2 
syntax on
if has("autocmd")
	  filetype indent plugin on
  endif
"split screen setting
set splitbelow
set splitright
set modifiable
"set leader
let mapleader = ","
let maplocalleader = '\\'
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
"abbreviations to fix typos
iabbrev waht what
iabbrev stache stash
iabbrev comit commit
iabbrev whaoami whoami
iabbrev whaomi whoami
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>w :set wrap!
nnoremap <leader># i#########################################<esc>
inoremap <leader># #########################################
nnoremap <space> i<space>
noremap <leader>, i<enter><esc>

