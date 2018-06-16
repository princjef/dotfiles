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
Plug 'tyru/markdown-codehl-onthefly.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'itmammoth/doorboy.vim'
Plug 'valloric/MatchTagAlways', { 'on_ft': 'html' }
Plug 'tomtom/tcomment_vim'				" Comment with gc
Plug 'mattn/emmet-vim'
Plug 'sbdchd/neoformat'					" Autoformat with :Neoformat
Plug 'ternjs/tern_for_vim', { 'build': 'npm install' }
Plug 'carlitux/deoplete-ternjs', { 'on_ft': 'javascript' }
Plug 'maksimr/vim-jsbeautify'
Plug 'tmux-plugins/vim-tmux'
Plug 'christoomey/vim-tmux-navigator'

" git
Plug 'tpope/vim-fugitive'
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
Plug 'vim-airline/vim-airline-themes'	" Themes for vim-airline

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

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " Fuzzy finder

call plug#end()

" colors
set termguicolors
colorscheme molokai
let &colorcolumn=join(range(80,999),",")

" settings
set number relativenumber
set clipboard+=unnamedplus
syntax enable
set tabstop=4 shiftwidth=4 expandtab	" add exapndtab to replace tab with spaces
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1		" Allow cursor shape to change

set noshowmode							" Hide default text indicating mode and status (so that airline can show it)
filetype on
set laststatus=2						" Always show a status line uder the window
set wrap linebreak nolist				" Wraps on a reasonable character (think word boundary)
let mapleader=","

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

" Remap quit
nnoremap q :Sayonara<cr>

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
noremap ƒ :Neoformat<cr>

set splitbelow " make horizontal splits show up below
set splitright " make vertical splits show up to the right

" Deoplete
let g:deoplete#enable_at_startup=1
let g:echodoc_enable_at_startup=1
set completeopt+=noinsert " fix selection of the option
autocmd CompleteDone * pclose
" Use tab to select the option we want
inoremap <silent><expr><tab> pumvisible() ? "\<return>" : "\<tab>"

call deoplete#custom#source('buffer', 'mark', 'buffer')
call deoplete#custom#source('ternjs', 'mark', '')
call deoplete#custom#source('typescript', 'mark', '')
call deoplete#custom#source('omni', 'mark', 'omni')
call deoplete#custom#source('file', 'mark', 'file')

function! Preview_func()
	if &pvw
		setlocal nonumber norelativenumber
	endif
endfunction
autocmd WinEnter * call Preview_func()
call deoplete#custom#source('_', 'matchers', ['matcher_fuzzy'])

" Denite configuration (unified finder for neovim)
autocmd FileType unite call s:uniteinit()
function! s:uniteinit()
	set nonumber
	set norelativenumber
endfunction

" File finder with Ctrl-P
noremap <silent> <c-p> :Denite file_rec<cr>
noremap <silent> <c-h> :Denite buffer<cr>

" Git menu for Denite
let s:menus = {}
let s:menus.git = {
	\ 'description' : 'Fugitive interface',
	\}
let s:menus.git.command_candidates = [
	\[' git status', 'Gstatus'],
	\[' git blame', 'Gblame'],
	\[' git diff', 'Gvdiff'],
	\[' git commit', 'Gcommit'],
	\[' git stage/add', 'Gwrite'],
	\[' git checkout', 'Gread'],
	\[' git rm', 'Gremove'],
	\[' git cd', 'Gcd'],
	\[' git push', 'exe "Git! push " input("remote/branch: ")'],
	\[' git pull', 'exe "Git! pull " input("remote/branch: ")'],
	\[' git pull rebase', 'exe "Git! pull --rebase " input("branch: ")'],
	\[' git checkout branch', 'exe "Git! checkout " input("branch: ")'],
	\[' git fetch', 'Gfetch'],
	\[' git merge', 'Gmerge'],
	\[' git browse', 'Gbrowse'],
	\[' git head', 'Gedit HEAD^'],
	\[' git parent', 'edit %:h'],
	\[' git log commit buffers', 'Glog --'],
	\[' git log current file', 'Glog -- %'],
	\[' git log last n commits', 'exe "Glog -" input("num: ")'],
	\[' git log first n commits', 'exe "Glog --reverse -" input("num: ")'],
	\[' git log until date', 'exe "Glog --until=" input("day: ")'],
	\[' git log grep commits',  'exe "Glog --grep= " input("string: ")'],
	\[' git log pickaxe',  'exe "Glog -S" input("string: ")'],
	\[' git index', 'exe "Gedit " input("branchname\:filename: ")'],
	\[' git mv', 'exe "Gmove " input("destination: ")'],
	\[' git grep',  'exe "Ggrep " input("string: ")'],
	\[' git prompt', 'exe "Git! " input("command: ")'],
	\] " Append ' --' after log to get commit info commit buffers

call denite#custom#var('menu', 'menus', s:menus)
call denite#custom#source('file_rec', 'matchers', ['matcher_fuzzy', 'matcher_ignore_globs'])
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
            \ [ '*~', '*.o', '*.exe', '*.bak',
            \ '.DS_Store', '*.pyc', '*.sw[po]', '*.class',
            \ '.hg/', '.git/', '.bzr/', '.svn/',
            \ 'node_modules/', 'bower_components/', 'tmp/', 'log/', 'vendor/ruby',
            \ '.idea/', 'dist/',
            \ 'tags', 'tags-*'])

" vim-airline configuration
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#show_buffers=1
let g:airline#extensions#tabline#fnamemod=':t'
let g:airline_skip_empty_sections=1
set hidden " allow buffers to be hidden without closing
let g:airline_powerline_fonts=1
let g:airline_theme='molokai'

tmap <leader>1  <C-\><C-n><Plug>AirlineSelectTab1
tmap <leader>2  <C-\><C-n><Plug>AirlineSelectTab2
tmap <leader>3  <C-\><C-n><Plug>AirlineSelectTab3
tmap <leader>4  <C-\><C-n><Plug>AirlineSelectTab4
tmap <leader>5  <C-\><C-n><Plug>AirlineSelectTab5
tmap <leader>6  <C-\><C-n><Plug>AirlineSelectTab6
tmap <leader>7  <C-\><C-n><Plug>AirlineSelectTab7
tmap <leader>8  <C-\><C-n><Plug>AirlineSelectTab8
tmap <leader>9  <C-\><C-n><Plug>AirlineSelectTab9
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

let g:airline#extensions#tabline#buffer_idx_format = {
	\ '0': '0 ',
	\ '1': '1 ',
	\ '2': '2 ',
	\ '3': '3 ',
	\ '4': '4 ',
	\ '5': '5 ',
	\ '6': '6 ',
	\ '7': '7 ',
	\ '8': '8 ',
	\ '9': '9 ',
	\ '10': '10 '
	\}

" Navigate between vim buffers and tmux panels
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-j> :TmuxNavigateDown<cr>
nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
nnoremap <silent> <C-l> :TmuxNavigateRight<cr>
nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-;> :TmuxNavigatePrevious<cr>
tmap <C-j> <C-\><C-n>:TmuxNavigateDown<cr>
tmap <C-k> <C-\><C-n>:TmuxNavigateUp<cr>
tmap <C-l> <C-\><C-n>:TmuxNavigateRight<cr>
tmap <C-h> <C-\><C-n>:TmuxNavigateLeft<CR>
tmap <C-;> <C-\><C-n>:TmuxNavigatePrevious<cr>
