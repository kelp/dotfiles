" kelp's Neovim Config
" https://github.com/kelp/nvim

" Startup {{{
"
" Things that have to go first. Other fold titles are alphabetized.
"
if has('vim_starting')
  set nocompatible
endif

" vim-plug won't bootstrap without setting this
if $SHELL =~ 'bin/fish'
    set shell=/bin/sh
endif

" }}}

" Appearance {{{
"
" Editor Appearance Settings
"
set number      " enable line numbers
set showcmd     " show the last command entered
set cursorline  " put a line where the cursor is
"set list        " show invisible characters
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨,space:␣
set showbreak=↪\ 
" TODO figure out how to change the color of extra characters
" like trail:

" This requires a terminal configured with Nerd Font
let g:airline_powerline_fonts = 1
let g:airline_theme='onedark'
let g:airline#extensions#tabline#enabled = 1 " Enable tab line at top
let g:airline#extensions#clock#auto = 0
function! AirlineInit()
  let g:airline_section_z = airline#section#create(['clock', g:airline_symbols.space, g:airline_section_z])
endfunction
autocmd User AirlineAfterInit call AirlineInit()
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1

set laststatus=2

let g:indentLine_char = '⎸'

" Disable setting a background color without this we get kind of a grey 
" washed out look
if (has("autocmd") && !has("gui_running"))
  augroup colorset
    autocmd!
    let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
    autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) 
    " `bg` will not be styled since there is no `bg` setting
  augroup END
endif 

" Enable 24 bit colors if we can
if (has("termguicolors"))
  set termguicolors
endif

set background=dark
let g:onedark_terminal_italics=1

if has('nvim')
    highlight! TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15
endif

" vim-startify configs
let g:startify_bookmarks = [ { 'c':
  \ '$HOME/.homesick/repos/nvim/home/.config/nvim/init.vim'},
  \ { 'ze': '$HOME/.homesick/repos/dotfiles/home/.zshenv'},
  \ { 'zr': '$HOME/.homesick/repos/dotfiles/home/.zshrc'}]

let g:startify_commands = [
  \ {'h': 'help reference'},
  \ {'hq': 'help quickref'},
  \ ]
let g:startify_fortune_use_unicode = 1  " Of course use utf-8!
let g:startify_change_to_dir = 1        " Change to dir of file
let g:startify_change_to_vcs_root = 1   " Change to vcs dir of file

" }}}

" Autocmd Rules {{{
"
if !exists('*s:setupWrapping')
  function s:setupWrapping()
    set wrap
    set wm=2
    set textwidth=79
  endfunction
endif

" Fix issues with syntax highliting in large files
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" wrap long lines in vimrc
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END

set autoread " Reread a file if it's changed outside of vim

" }}}

" File Management {{{
"
" NERDTree configs
map <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" NERDtree is really slow without these
" let NERDTreeHighlightCursorline = 0
let g:NERDTreeSyntaxEnabledExtensions = ['c', 'css', 'c++', 'go', 'h', 'js', 'md', 'py', 'rb']
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 50
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite

nnoremap <C-p> :<C-u>FZF<CR>

" }}}

" Git and Related Plugins {{{
" Limit what VCS Signify looks for
let g:signify_vcs_list = [ 'git' ]
" Update signs in real time
let g:signify_realtime=1
"
" }}}

" Language Specific {{{
"
" Programming language configs
"
let g:ale_linters = {}
let g:ale_fixers = {}

" Fish Shell
autocmd FileType fish compiler fish 
autocmd FileType fish setlocal textwidth=79 foldmethod=expr

" Go Lang
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
    \ softtabstop=4
let g:ale_linters.go = { 'go': ['gofmt'] }

" Markdown
" vim-polyglot installs vim-markdown
let g:vim_markdown_conceal = 0  " Disable concealing

" Python
augroup vimrc-python
  autocmd!
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=79
      \ formatoptions+=croq softtabstop=4
      \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END
let g:ale_fixers.python = ['autopep8']
let g:ale_linters.python =  ['flake8']
" enable python virtualenv support in airline
let g:airline#extensions#virtualenv#enabled = 1
" show doc strings in python
let g:deoplete#sources#jedi#show_docstring = 1

" JavaScript 
" use `eslint` for JavaScript and Vue
let g:ale_linters.javascript = ['prettier']
let g:ale_fixers.javascript = ['prettier', 'eslint']
let g:ale_linter_alias = { 'vue': ['vue', 'javascript'], }
let g:ale_linters.vue = ['prettier', 'vls']

" Terraform
let g:terraform_align = 1           " Use vim-terraform indents
let g:terraform_fold_sections = 1   " Auto fold terraform

" Zsh
let g:ale_linters.zsh = ['shell']

" }}}

" Misc {{{
"
" Prevent running nvim inside of nvim terminal
if has('nvim') && executable('nvr')
    let $VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
endif

" make esc work in nvim terminal mode
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-v><Esc> <Esc>
endif

" Searching
set hlsearch        " highlight all text matching current search pattern
" Turn off search matches with space
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
set incsearch       " show search matches as you type
set ignorecase      " ignore case on search
set smartcase       " case sensitive matches when search includes uppercase
set showmatch       " highlight matching [{()}]
set splitbelow      " open new splits on the bottom
set splitright      " open new splits on the right
if has('nvim')
    set inccommand=nosplit  " show search and replace in real time
endif
" Need to figure out what mouse mode I prefer
"set mouse=a         " enable mouse scrolling
set clipboard=unnamed   " vim clipboard copies to system clipboard

" Config for UtiSnips
" TODO consider better configs here, learn more about using this
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" let g:comfortable_motion_scroll_down_key = "j"
" let g:comfortable_motion_scroll_up_key = "k"

" }}}

" Plugin Management {{{
"
" Plugins are installed here with vim-plug
"
" Test if vim-plug is installed
let vimplug_exists=expand('~/.local/share/nvim/site/autoload/plug.vim')

" Install vim-plug if it's not already installed
if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs 
  \https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

" Upgrade all Plugins, including Plug
command! PU PlugUpdate | PlugUpgrade

" Load Plug
" Required:
call plug#begin()

Plug 'Shougo/deoplete.nvim'                         " Code completion plugin
  Plug 'zchee/deoplete-jedi', { 'for': 'python' }   " Jedi support for deoplete
  Plug 'zchee/deoplete-go', { 'for': 'go' }         " Support for go
  "Plug 'mdempsky/gocode', { 'for': 'go' }          " Required by deoplete-go

" This genrates shell prompt configs simialr to airline
" Usage: :PromptlineSnapshot ~/promptline.sh
Plug 'edkolev/promptline.vim', { 'on': 'PromptlineSnapshot'}
" Put a nice colored powerline like bar at the bottom
Plug 'vim-airline/vim-airline'              " Powerline like bar
  Plug 'vim-airline/vim-airline-themes'     " Themes
  Plug 'enricobacis/vim-airline-clock'      " A clock for airline
  Plug 'ryanoasis/vim-devicons'             " utf-8 icons for vim-airline
  Plug 'mhinz/vim-signify'                  " Show vcs changes per line

Plug 'fatih/vim-go', { 'for': 'go' } " Go lang support
Plug 'mhinz/vim-startify'       " Creates a nice default start screen
Plug 'joshdick/onedark.vim'     " The onedark color theme
Plug 'yggdroot/indentline'      " Add a nice indent vertical indicator
Plug 'tpope/vim-fugitive'       " A bunch of commands for git
Plug 'tpope/vim-scriptease'     " Some tools for writing vim plugins
Plug 'w0rp/ale'                 " A linter, fixer and completion plugin
  Plug 'posva/vim-vue'          " Vue.js Syntax
Plug 'sheerun/vim-polyglot'     " Syntax and indentation for many languages
Plug 'thaerkh/vim-workspace'    " Session management
Plug 'scrooloose/nerdcommenter' " Smart handling of commenting
Plug 'godlygeek/tabular'        " :Tab helps to line up text
Plug 'hashivim/vim-terraform'   " Terraform support for vim
Plug 'dag/vim-fish'             " Fish shell support
Plug 'SirVer/ultisnips'
  Plug 'honza/vim-snippets'

" fzf fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Sets editorconfig project / langauge specific settings if they exist
Plug 'editorconfig/editorconfig-vim'
" Plug 'yuttie/comfortable-motion.vim'
" pip requirements file support
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}

" A nice file manager
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight', { 'on':  'NERDTreeToggle' }
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on':  'NERDTreeToggle' }

" Finish 
" Required:
call plug#end()

" }}}

" Syntax, Linting and Code Completion {{{

" Enable deoplete code completion at startup
let g:deoplete#enable_at_startup = 1

let g:ale_enabled = 1 " enablee/disable ale
" Enable/Disable Ale completion - disabled currently
let g:ale_completion_enabled = 0
let g:ale_fix_on_save = 1
let g:ale_set_baloons = 1
let g:airline#extensions#ale#enabled = 1   " Integrate airline with ale
let airline#extensions#ale#show_line_numbers = 1
" Show 5 lines of errors (default: 10)
let g:ale_list_window_size = 5
let g:ale_open_list = 1             " open the error list while errors exist
let g:ale_keep_list_window_open = 1 " keep the list window open
" Prevents having to exit twice with list window always open
augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END
let g:ale_sign_column_always = 1    " keep the sign column open
let g:ale_warn_about_trailing_whitespace = 1
let g:ale_warn_about_trailing_blank_lines = 1
let g:ale_cursor_detail = 0
let g:ale_sign_style_error='✗'
let g:ale_sign_style_warning='⚠'
let g:ale_sign_error='✗'
let g:ale_sign_warning='⚠'

" ALE key mappings in the style of unimpaired-next Plugin
nmap <silent> [W <Plug>(ale_first)
nmap <silent> [w <Plug>(ale_previous)
nmap <silent> ]w <Plug>(ale_next)
nmap <silent> ]W <Plug>(ale_last)

syntax on       " enable syntax highlighting
" }}}

" Text Formatting {{{
"
set encoding=utf-8
" Add some key mappings to manage code omments 
let g:NERDSpaceDelims = 1


set tabstop=4               " Show a tab as 4 spaces
set softtabstop=4           " Number of spaces a tab means when editing
set shiftwidth=4            " Tab key inserts 4 spaces
set expandtab               " Tab key inputs spaces
filetype plugin indent on   " Load filetype-specific indent files
set wildmenu                " Visual autocomplete for the command menu
set lazyredraw              " Redraw only when we need to.
set foldenable              " Enable folding
set foldlevelstart=10       " Open most folds by default
set foldnestmax=10          " 10 nested fold max
set foldmethod=indent       " Fold based on indent level
set colorcolumn=80          " mark column 80
set modelines=1             " Read a modeline on the last line of the file

" }}}

" Themes {{{
"
" configure colorscheme onedark
" Color scheme has to be loaded after plugin initilization
if !exists('g:not_finish_vimplug')
	colorscheme onedark
endif

" }}}

" vim:foldmethod=marker:foldlevel=0
