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
" choosing to use ale over syntastic
Plug 'w0rp/ale'

set nocompatible
call plug#begin()
Plug 'sheerun/vim-polyglot'
call plug#end()

" Vim-tmux navigator
"https://github.com/christoomey/vim-tmux-navigator
Plug 'christoomey/vim-tmux-navigator'	

" vim-prettier
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'branch': 'release/0.x'
  \ }


" Github dashboard, look through github events in vim
" https://github.com/junegunn/vim-github-dashboard
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" youcompleteme
Plug 'ycm-core/YouCompleteMe'
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

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
let g:indentguides_ignorelist = ['text','markdown']
          

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
"Plug 'tpope/vim-surround'

" Vimwiki
Plug 'vimwiki/vimwiki'

    let wiki_1 = {}
    let wiki_2 = {}
    let wiki_1.path = '~/productivity/Notes/'
    let wiki_1.html_template = '~/productivity/Notes/template.tpl'
    let wiki_2.path = '~/productivity/blog/'
    let wiki_2.html_template = '~/productivity/blog/template.tpl'
    let g:vimwiki_list = [wiki_1, wiki_2]
    let g:vimwiki_ext = '.md' " set extension to .md
    let g:vimwiki_global_ext = 0 " make sure vimwiki doesn't own all .md files
    let g:vimwiki_autowriteall = 1
" needed for vimwiki
set nocompatible
filetype plugin on
syntax on

"""""""""""""""""""""""""""""""""""""
" Language specific  Plugins
""" golang plugins
" vim-go 
" https://github.com/fatih/vim-go
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
""" python plugins
"https://realpython.com/vim-and-python-a-match-made-in-heaven/#vim-extensions
Plug 'tmhedberg/SimpylFold'

" Initialize plugin system
call plug#end()
"End plugin code
""""""""""""""""""""""""""""""""""""""""""""""""""""

set number
set smartcase
set mouse=a

" Enable folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

"tabs
filetype plugin indent on
" On pressing tab, insert 4 spaces
set expandtab
" show existing tab with 4 spaces width
set tabstop=4
set softtabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
set ic ai ts=4 

"split screen setting
set splitbelow
set splitright
set modifiable

"set leader
let mapleader = ","
let maplocalleader = '\\'

nnoremap <leader>sv :source ~/.vimrc<cr>
nnoremap <leader>ev :tabe ~/.vimrc<cr>
" Lookup vim help on selected word
nnoremap <K> <C-Y>
        
" Copy-freindly
 noremap <leader>n :set number! <bar> :IndentGuidesToggle<cr>

" Language filetype specific changes are set in ~/.vim/ftplugin/*.vim
" https://vim.fandom.com/wiki/Keep_your_vimrc_file_clean
filetype plugin on
filetype plugin indent on


" theme
"
syntax enable
colorscheme monokai
"""""""""""""""""""""""""""""""""""""""""
" Code navigation
" pane/window navigation
nnoremap <leader>% :vnew <cr>
nnoremap <leader>' :new <cr>
nnoremap <leader>t :tab split<cr>
nnoremap <leader>q :close<cr>


"""""""""""""""""""""""""""""""""""""""""
" Simple typing fixes and shortcuts
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
nnoremap <leader>" i"""""""""""""""""""""""""""""""""""""""""<esc>
inoremap <leader>" """""""""""""""""""""""""""""""""""""""""
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

