" plugins
call plug#begin('~/.config/nvim/packages')

" syntax
Plug 'othree/html5.vim'
Plug 'othree/yajs.vim'
Plug 'othree/jspc.vim'
Plug 'othree/jsdoc-syntax.vim'
Plug 'heavenshell/vim-jsdoc'
Plug 'moll/vim-node'
Plug 'elzr/vim-json', { 'on_ft': 'json' }
Plug 'hail2u/vim-css3-syntax', { 'on_ft': ['css', 'scss'] }
Plug 'ap/vim-css-color'
Plug 'tpope/vim-markdown', { 'on_ft': 'markdown' }
Plug 'nelstrom/vim-markdown-folding'
Plug 'tyru/markdown-codehl-onthefly.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'itmammoth/doorboy.vim'
Plug 'valloric/MatchTagAlways', { 'on_ft': 'html' }
Plug 'tomtom/tcomment_vim'				" Comment with gc
Plug 'mattn/emmet-vim'
Plug 'sbdchd/neoformat'					" Autoformat with :Neoformat

" git
Plug 'lambdalisue/vim-gita'
Plug 'lambdalisue/gina.vim'
Plug 'jreybert/vimagit'
Plug 'airblade/vim-gitgutter'

" file tree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'				" Git diffing for file tree
Plug 'ryanoasis/vim-devicons'					" Icons for file tree
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'	" Coloring for file tree icons

" generic config
Plug 'editorconfig/editorconfig-vim'	" Generic editor config
Plug 'tpope/vim-repeat'					" Gives other plugins repeat capabilities
Plug 'tpope/vim-surround'				" Manage delimiters (cs to replace)
Plug 'vim-airline/vim-airline'			" Bottom status/tabline (colors on insert line and such)

" deoplete (asynchronous autocomplete) and friends
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/deol.nvim'					" Neovim shell?
Plug 'Shougo/denite.nvim'				" United search interface with :Denite?
Plug 'Shougo/neomru.vim'				" MRU for unite/denite
Plug 'Shougo/context_filetype.vim'		" Context filetype library for Vim script
Plug 'Shougo/neco-vim'
Plug 'Shougo/neoinclude.vim'			" Includes for deoplete?
Plug 'mhartington/nvim-typescript'		" Typescript deoplete integration

call plug#end()

" colors
set termguicolors
colorscheme molokai

" settings
set number relativenumber
set clipboard+=unnamedplus
syntax enable
set tabstop=4 shiftwidth=4				" add exapndtab to replace tab with spaces
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1		" Allow cursor shape to change

set noshowmode							" Hide default text indicating mode and status (so that airline can show it)
filetype on
set laststatus=2						" Always show a status line uder the window
set wrap linebreak nolist				" Wraps on a reasonable character (think word boundary)

" undo
set undofile
set undodir="$HOME/.VIM_UNDO_FILES"

" remember cursor between vim sessions
autocmd BufReadPost *
				\ if line("'\"") > 0 && line ("'\"") <= line("$") |
				\   exe "normal! g'\"" |
				\ endif

" center buffer around curosr when opening files
autocmd BufRead * normal zz				
set updatetime=1000						" Amount of inactive time (ms) to wait between saves
set complete=.,w,b,u,t,k
autocmd InsertEnter * let save_cwd = getcwd() | set autochdir
autocmd InsertLeave * set noautochdir | execute 'cd' fnameescape(save_cwd)
set inccommand=nosplit					" Show what substitute will do while typing it
set shortmess=atI						" Status text formatting options

" Remap comments
vnoremap <C-/> :TComment<cr>
