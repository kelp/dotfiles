" kelp's Neovim Config
"
" https://github.com/kelp/dotfiles/blob/master/.config/nvim/init.vim
"
" This probably only works with Neovim.
"
" Startup {{{
"
" Everything that must go first to bootstrap a new nvim install
"

" vim-plug only works with /bin/sh
if $SHELL =~ 'bin/fish'
  set shell=/bin/sh
endif

" Install npm modules if we already have npm
if !executable('eslint') || !executable('prettier')
  if executable('npm')
    echo "Installing eslint and prettier"
    silent !npm install -g eslint prettier eslint-config-prettier
    \ eslint-plugin-prettier &
  else
    echo "Install npm to complete setup"
  endif
endif

" }}}
"
" Appearance {{{
"
set number      " show line numbers
set cursorline  " highlight the line with the cursor
" invisible characters to use when 'set list' is enabled manually
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:⟩,precedes:⟨,space:␣
set showbreak=↪\

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1 " enable tab line at top
let g:airline#extensions#tabline#buffer_idx_mode = 1
" key mapping to switch tabs
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab
" warn on mixed indent
let g:airline#extensions#whitespace#mixed_indent_algo = 2
let g:airline#extensions#whitespace#checks = [ 'indent', 'trailing', 'long',
      \ 'mixed-indent-file', 'conflicts' ]

" Enable coc extension
let g:airline#extensions#coc#enabled = 1

set laststatus=2

let g:indentLine_char = ''

" Enable 24 bit colors if we can
if (has("termguicolors"))
  set termguicolors
else
  set t_Co=8
endif

" Theme configs
"set background=dark
let g:nord_italic = 1
let g:nord_uniform_diff_background = 0
let g:nord_italic_comments = 1
let g:nord_underline = 0
let g:nord_cursor_line_number_background = 0

" vim-startify configs
let g:startify_bookmarks = [
  \ { 'c':  '$HOME/.config/nvim/init.vim'},
  \ { 'fc': '$HOME/.config/fish/config.fish'},
  \ ]

let g:startify_commands = [
  \ {'h': 'help reference'},
  \ {'hq': 'help quickref'},
  \ ]
let g:startify_fortune_use_unicode = 1  " Use utf-8
let g:startify_change_to_dir = 1        " Change to dir of file
let g:startify_change_to_vcs_root = 1   " Change to vcs dir of file

augroup startify-init
  " Enable cursorline in startify
  autocmd User Startified setlocal cursorline
augroup END

" vim-better-whitespace config
let g:better_whitespace_ctermcolor='grey'
let g:better_whitespace_guicolor='grey'
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=0
let g:show_spaces_that_precede_tabs=1

" }}}
"
" Git and Related Plugins {{{
"
let g:signify_vcs_list = [ 'git', 'cvs' ]

let g:signify_realtime=1 	" Update signs in real time

" }}}
"
" Language Specific {{{
"

" Fish Shell
augroup initvim-fish-setup
  autocmd FileType fish compiler fish
  autocmd FileType fish setlocal textwidth=79 foldmethod=expr expandtab
        \ tabstop=4 softtabstop=4 shiftwidth=4
augroup END

" Go
augroup initvim-go-setup
  autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
        \ softtabstop=4
  " Disable vim-go's autocompletion. Use coc's instead.
  let g:go_code_completion_enabled = 0
  let g:go_metalinter_autosave = 1
  let g:go_highlight_array_whitespace_error = 1
  let g:go_highlight_space_tab_error = 1
  let g:go_highlight_chan_whitespace_error = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_function_parameters = 1
  let g:go_highlight_function_calls = 1
augroup END

" coc needs gopls for Go completion
if !executable('gopls')
  echo "Installing gopls..."
  silent !go get golang.org/x/tools/gopls
endif
" disable vim-go :GoDef short cut (gd)
" this is handled by coc
let g:go_def_mapping_enabled = 0

" Markdown
" vim-polyglot installs vim-markdown
let g:vim_markdown_conceal = 0  " Disable concealing

" OpenBSD style(9)
augroup initvim-openbsd
  au BufRead,BufNewFile *.[ch],*.cpp
    \  if getline(1) =~ 'OpenBSD:'
    \|   setl ft=c.openbsd
    \|	 call OpenBSD_Style()
    \| endif
augroup END

" Python
augroup initvim-python
  autocmd!
  autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8
        \ colorcolumn=79 formatoptions+=croq softtabstop=4
        \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
augroup END
" enable python virtualenv support in airline
let g:airline#extensions#virtualenv#enabled = 1

" Terraform
let g:terraform_align = 1           " Use vim-terraform indents
let g:terraform_fold_sections = 1   " Auto fold terraform

" Vim
augroup initvim-vim
autocmd BufNewFile,BufRead *.vim setlocal expandtab shiftwidth=2
      \ softtabstop=2 tabstop=2
augroup END

" }}}
"
" Misc {{{
"

" Vimwiki
let g:vimwiki_list = [{'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_global_ext = 0

" Searching
set hlsearch            " highlight all text matching current search pattern
" Turn off search matches with space
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
set incsearch           " show search matches as you type
set ignorecase          " ignore case on search
set smartcase           " case sensitive when search includes uppercase
set showmatch           " highlight matching [{()}]
set splitbelow          " open new splits on the bottom
set splitright          " open new splits on the right"
set inccommand=nosplit  " show search and replace in real time
set clipboard=unnamed   " vim clipboard copies to system clipboard
set autoread		        " reread a file if it's changed outside of vim

" vim-workspace settings
nnoremap <leader>s :ToggleWorkspace<CR>
let g:workspace_session_directory = $HOME . '/.local/share/nvim/sessions/'

" Remember cursor position
augroup initvim-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
        \ exe "normal! g`\"" | endif
augroup END

" }}}
"
" Plug Install {{{
"
" Plugins are installed with vim-plug
"

" Utility to run PlugInstall and guard against loading color schemes
" before we're ready.
if !exists('*SetupPlug')
  function SetupPlug()
    let g:not_finish_vimplug = "yes"
    PlugInstall --sync
    unlet g:not_finish_vimplug
    "set verbose=15
    source $MYVIMRC | q
    "set verbose=0
  endfunction
endif

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
  \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  autocmd VimEnter * call SetupPlug()
endif

" Install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   call SetupPlug()
  \| endif

" Shortcut to upgrade all plugins, including Plug
command! PU PlugUpdate | PlugUpgrade

" Load Plug
" Required:
call plug#begin()

" }}}
"
" {{{ Plugins
"

" Install plugins

Plug 'arcticicestudio/nord-vim'  " The nord theme
Plug 'dag/vim-fish'             " Fish shell support
Plug 'editorconfig/editorconfig-vim'                " Support editorconfig
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }  " Go support
Plug 'hashivim/vim-terraform'   " Terraform support for vim
Plug 'junegunn/vim-plug'        " For :help plug
Plug 'mhinz/vim-startify'       " Creates a nice default start screen
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Conquer of Completion
Plug 'ninjin/vim-openbsd'       " OpenBSD style(8)
Plug 'ntpeters/vim-better-whitespace'   " Highlight extra whitespace
Plug 'sheerun/vim-polyglot'     " Syntax and indentation for many languages
Plug 'thaerkh/vim-workspace'    " Automated workspace management
Plug 'tpope/vim-fugitive'       " Git commands for vim
Plug 'vim-airline/vim-airline'              " Powerline like bar
  Plug 'mhinz/vim-signify'                  " Show vcs changes per line
  Plug 'ryanoasis/vim-devicons'             " utf-8 icons for vim-airline
  Plug 'vim-airline/vim-airline-themes'     " Themes
Plug 'yggdroot/indentline'      " Add a nice indent vertical indicator
Plug 'vimwiki/vimwiki'          " A personal vimwiki

" Finish
" Required:
call plug#end()

" }}}
"
" Syntax, Linting and Code Completion {{{
"
" coc settings
"
" if hidden is not set, TextEdit might fail.
set hidden
" Better display for messages
set cmdheight=2
" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
"
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other
" plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
" Cycle through completions with tab
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" Cycle back with shift tab
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" Confirm confirm completion with return
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Confirm first completion on enter
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use U to show documentation in preview window
nnoremap <silent> U :call <SID>show_documentation()<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" https://github.com/neoclide/coc-prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile
"
" End coc settings

" }}}
"
" Text Formatting {{{
"

set encoding=utf-8

set wildmenu                " visual autocomplete for the command menu
set lazyredraw              " redraw only when we need to.
set foldenable              " enable folding
set foldlevelstart=10       " open most folds by default
set foldnestmax=10          " 10 nested fold max
set foldmethod=indent       " fold based on indent level
set colorcolumn=80          " mark column 80
set modelines=1             " read a modeline on the last line of the file
"set autoindent              " autoindent

" }}}
"
" Themes {{{
"

" configure colorscheme nord
" Color scheme has to be loaded after plugin initilization
silent! colorscheme nord
silent! AirlineTheme nord

" }}}
"
" vim:foldmethod=marker:foldlevel=0
