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
Plug 'ternjs/tern_for_vim', { 'build': 'npm install' }
Plug 'carlitux/deoplete-ternjs', { 'on_ft': 'javascript' }

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
Plug 'Shougo/deol.nvim'								" Neovim shell?
Plug 'Shougo/denite.nvim'							" United search interface with :Denite?
Plug 'Shougo/neomru.vim'							" MRU for unite/denite
Plug 'Shougo/context_filetype.vim'					" Context filetype library for Vim script
Plug 'Shougo/neco-vim', {'on_ft': 'vim'}			" Deoplete for vim files
Plug 'Shougo/neoinclude.vim'						" Includes for deoplete?
Plug 'zchee/deoplete-jedi', {'on_ft': 'python'}		" Deoplete for python (uses the jedi tool for python)
Plug 'zchee/deoplete-zsh'							" Deoplete for zsh
Plug 'Valodim/vim-zsh-completion'					" More zsh completion
Plug 'mhartington/nvim-typescript'					" Typescript deoplete integration
Plug 'Shougo/neosnippet.vim'						" Snippet support (integrates with deoplete)
Plug 'Shougo/neosnippet-snippets'					" Collection of snippets for certain languages integrated with above
Plug 'honza/vim-snippets'							" More snippets for various languages
Plug 'Shougo/echodoc.vim'							" Shows documentation for function signatures while typing

Plug 'mhinz/vim-sayonara'				" Makes closing a tab act like normal programs
Plug 'terryma/vim-multiple-cursors'		" Like SublimeText multiple cursors
Plug 'tyru/open-browser.vim'			" Open link in a web browser from vim
Plug 'junegunn/vim-easy-align'			" Align around certain characters (like these comments)
Plug 'MartinLafreniere/vim-PairTools'	" Does things like autoclosing and autoa tabbing

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

" Default behavior when opening a new terminal?
" (honestly not sure what this does)
tmap <esc> <c-\><c-n><esc><cr>

" Remap comments
vnoremap <c-/> :TComment<cr>

" No need to use shift when doing : commands
nnoremap ; :

" Mappings for 'terryma/vim-multiple-cursors'
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Javascript/Typescript

" heavenshell/vim-jsdoc
let g:jsdoc_allow_input_prompt = 1
let g:jsdoc_input_description = 1

" elzr/vim-json
let g:vim_json_syntax_conceal = 0	" turn off quote concealing

" ternjs/tern_for_vim
let g:tern#command = ['tern']
let g:tern#arguments = ['--persistent']
let g:nvim_typescript#max_completion_detail = 100
map <silent> <leader>D :TSDoc<cr>

" Git
vnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gb :Gblame<cr>

" NERDTree
let NERDTreeShowHidden=1
let NERDTreeHijackNetrw=0
let g:WebDevIconsUnicodeDecorateFolderNodes=1
let g:NERDTreeWinSize=45
let g:NERDTreeAutoDeleteBuffer=1
let NERDTreeMinimalUI=1
let NERDTreeCascadeSingleChildDir=0
nnoremap <c-\> :NERDTreeToggle<cr>

" autocmd VimEnter * NERDTreeToggle

" Code formatting
noremap <C-f> :Neoformat<cr>

" Deoplete
let g:deoplete#enable_at_startup=1
let g:echodoc_enable_at_startup=1
set splitbelow " makes the suggestions window show up below?
set completeopt+=noselect
autocmd CompleteDone * pclose

call deoplete#custom#set('buffer', 'mark', 'buffer')
call deoplete#custom#set('ternjs', 'mark', '')
call deoplete#custom#set('typescript', 'mark', '')
call deoplete#custom#set('omni', 'mark', 'omni')
call deoplete#custom#set('file', 'mark', 'file')

function! Preview_func()
	if &pvw
		setlocal nonumber norelativenumber
	endif
endfunction
autocmd WinEnter * call Preview_func()
call deoplete#custom#set('_', 'matchers', ['matcher_fuzzy'])
