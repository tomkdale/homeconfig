"Surround.vim 
"https://vimawesome.com/plugin/surround-vim""""""""""""""""""""""""""""""""""""""
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

" Check syntax in Vim 
" https://vimawesome.com/plugin/ale
Plug 'w0rp/ale'

" Vim-tmux navigator
"https://github.com/christoomey/vim-tmux-navigator
Plug 'christoomey/vim-tmux-navigator'	

" Github dashboard, look through github events in vim
" https://github.com/junegunn/vim-github-dashboard
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

"" autofilling snippets in vim
"" https://github.com/SirVer/ultisnips
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
"" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
"" If you want :UltiSnipsEdit to split your window.
"let g:UltiSnipsEditSplit="vertical"

" Indent Guide
Plug 'thaerkh/vim-indentguides'


" Nerdtree and nerdtree git
Plug 'preservim/nerdtree' | Plug 'scrooloose/nerdtree' 

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let NERDTreeShowHidden=1


" Sensible vimrc things that 'should be in any vimrc'
" https://github.com/tpope/vim-sensible
Plug 'tpope/vim-sensible'

"Surround.vim 
"https://vimawesome.com/plugin/surround-vim
Plug 'tpope/vim-surround'

" Vim-powerline
Plug 'powerline/powerline'

" Vimwiki
Plug 'vimwiki/vimwiki'

    let wiki_1 = {}
    let wiki_1.path = '~/Dropbox/Apps/Notes/'
    let wiki_1.html_template = '~/Dropbox/Apps/Notes/template.tpl'
    let g:vimwiki_list = [wiki_1]
    let g:vimwiki_ext = '.md' " set extension to .md
    let g:vimwiki_global_ext = 0 " make sure vimwiki doesn't own all .md files
" needed for vimwiki
set nocompatible
filetype plugin on
syntax on

" Initialize plugin system
call plug#end()
"End plugin code
""""""""""""""""""""""""""""""""""""""""""""""""""""

" Save with sudo
command! W w !sudo tee % > /dev/null


set number
set smartcase
set mouse=a

"tabs
filetype plugin indent on
" On pressing tab, insert 2 spaces
set expandtab
" show existing tab with 2 spaces width
set tabstop=2
set softtabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=2
set ic ai ts=2 

"split screen setting
set splitbelow
set splitright
set modifiable
"set leader
let mapleader = ","
let maplocalleader = '\\'
nnoremap <leader>sv :source ~/.vimrc<cr>
nnoremap <K> <C-Y>
nnoremap <leader>ev :vsplit ~/.vimrc<cr>
noremap <leader>n :set number!<cr>

"abbreviations to fix typos
"seperate abbreviation file to vim bash and zsh
iabbrev waht what
iabbrev stache stash
iabbrev comit commit
iabbrev whaoami whoami
iabbrev whaomi whoami
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>W :set wrap!
nnoremap <leader># i#########################################<esc>
inoremap <leader># #########################################
nnoremap <leader>#m i################################<esc>o# Monday <esc>o#######################################
nnoremap <leader>#t i################################<esc>o# Tuesday <esc>o#######################################
nnoremap <leader>#w i################################<esc>o# Wednesday <esc>o######################################
nnoremap <leader>#th i################################<esc>o# Thursday <esc>o#######################################
nnoremap <leader>#f i################################<esc>o# Friday <esc>o#######################################
inoremap <leader>#m ################################<esc>o# Monday <esc>o#######################################
inoremap <leader>#t ################################<esc>o# Tuesday <esc>o#######################################
inoremap <leader>#w ################################<esc>o# Wednesday <esc>o######################################
inoremap <leader>#th ################################<esc>o# Thursday <esc>o#######################################
inoremap <leader>#f ################################<esc>o# Friday <esc>o#######################################

nnoremap <space> i<space>
noremap <leader>, i<enter><esc>

