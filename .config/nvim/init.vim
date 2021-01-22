""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Maintainer:   Daniel Hamilton
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Requirements:
"
"   LocalDebianPackages:
"
"   - Neovim 0.4.4
"   - bat ('musl' deb package from: https://github.com/sharkdp/bat/releases)
"
"   DebianPackages:
"
"   Base:
"   - build-essential
"   - curl
"   - git
"   - nodejs (see https://nodejs.org/en/download/package-manager for repo)
"
"   C:
"   - clang-format
"   - exuberant-ctags
"
"   Golang:
"   - golang-go (from buster-backports)
"
"   PythonProvider:
"   - python3-minimal
"   - python3-pip
"   - python3-setuptools
"   - python3-wheel
"
" AdditionalSetup:
"
"   OptionalPython3Provider:
"   python3 -m pip install --user --upgrade pynvim
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" --------------------------------------------------------------------------
" Vim-Plug: Install the Plugin Manager
" --------------------------------------------------------------------------
"
" Manage all plugins with vim-plug
"       - https://github.com/junegunn/vim-plug
"       - A minimalist Vim plugin manager
"
if empty(glob("$HOME/.local/share/nvim/site/autoload/"))
  silent !curl -fLo
      \ $HOME/.local/share/nvim/site/autoload/plug.vim
      \ --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
  \| endif

" --------------------------------------------------------------------------
" Vim-Plug: Auto install plugins and apply settings
" --------------------------------------------------------------------------
call plug#begin(stdpath('data') . '/plugged')

" neos-irblack
"       - https://github.com/DanHam/neos-irblack.git
"       - A custom version of the Vim IR Black colour scheme
"       - The main theme must be loaded first so that all other plugins
"         that set some form of highlighting can take effect
"
Plug 'DanHam/neos-irblack'

" Coc vim
"       - https://github.com/neoclide/coc.nvim
"       - Intellisense engine for Vim8 & Neovim
"       - Full language server protocol support as VSCode
"
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" vim-jsonc
"       - https://github.com/kevinoid/vim-jsonc
"       - Vim syntax highlighting plugin for JSON with C-style line (//)
"         and block (/* */) comments.
"       - Supports syntax highlighting for Coc configuration files (jsonc)
"
Plug 'kevinoid/vim-jsonc'

" nerdcommenter
"       - https://github.com/scrooloose/nerdcommenter.git
"       - Vim plugin for intensely orgasmic commenting
"
Plug 'preservim/nerdcommenter'

" nerdtree
"       - https://github.com/scrooloose/nerdtree.git
"       - The NERDTree is a file system explorer for the Vim editor
"
Plug 'preservim/nerdtree'

" tagbar
"       - https://github.com/perservim/tagbar.git
"       - Tagbar is a Vim plugin that provides an easy way to browse the
"         tags of the current file and get an overview of its structure.
"       - Requires exuberant-ctags >=5.5
Plug 'preservim/tagbar'

" vim-better-whitespace:
"       - https://github.com/ntpeters/vim-better-whitespace.git
"       - This plugin causes all trailing whitespace characters (spaces and
"         tabs) to be highlighted. Whitespace for the current line will not
"         be highlighted while in insert mode.
"       - A helper function :StripWhitespace is also provided to make
"         whitespace cleaning painless.
"
Plug 'ntpeters/vim-better-whitespace'

" vim-endwise
"       - https://github.com/tpope/vim-endwise.git
"       - A plugin that helps to end certain structures automatically
"
Plug 'tpope/vim-endwise'

" vim-indent-guides
"       - https://github.com/nathanaelkane/vim-indent-guides.git
"       - Visually display indent levels in Vim
"
Plug 'nathanaelkane/vim-indent-guides'

" delimitMate
"       - https://github.com/Raimondi/delimitMate.git
"       - delimitMate provides automatic closing of quotes, parenthesis,
"         brackets, and so on.
"
Plug 'Raimondi/delimitMate'

" vim-go
"       - https://github.com/fatih/vim-go.git
"       - Provides Go (golang) support for vim
"       - Run :GoInstallBinaries to install the required Go Tools
"       - Install deoplete for auto completion
"
if executable('go')
    Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries', 'for': 'go'}
endif

" UltiSnips
"       - https://github.com/SirVer/ultisnips.git
"       - The ultimate snippet tool for Vim
"
Plug 'SirVer/ultisnips'

" vim-snippets
"       - https://github.com/honza/vim-snippets
"       - Snippet collection for use with UltiSnips
"
Plug 'honza/vim-snippets'

" vim-terraform
"       - https://github.com/hashivim/vim-terraform.git
"       - Adds a :Terraform command that runs terraform, with tab
"         completion of subcommands
"       - Sets up *.tf, *.tfvars, and *.tfstate files to be highlighted as
"         HCL, HCL, and JSON respectively
"       - Adds a :TerraformFmt command that runs terraform fmt against the
"         current buffer
"
Plug 'hashivim/vim-terraform'

" vim-clang-format
"       - https://github.com/rhysd/vim-clang-format
"       - Formats your code with specific coding style using clang-format
"       - Requires the 'clang-format' package to be installed
"
if executable('clang-format')
    Plug 'rhysd/vim-clang-format'
endif

" vim-lsp-cxx-highlight
"       - https://github.com/jackguo380/vim-lsp-cxx-highlight
"       - Provides C/C++/Cuda/ObjC semantic highlighting using the language
"         server protocol
"       - To enable with Coc and Clangd, in CocConfig set:
"         "clangd.semanticHighlighting": true
"
Plug 'jackguo380/vim-lsp-cxx-highlight'

" fzf.vim
"       - https://github.com/junegunn/fzf.vim
"       - fzf.vim integrates fzf (a general purpose command-line fuzzy
"         finder) with vim
"
Plug 'junegunn/fzf', {
    \ 'dir': '~/.fzf',
    \'do': './install --completion --key-bindings --update-rc --no-zsh --no-fish'
    \ }
Plug 'junegunn/fzf.vim'

" vim-visual-multi
"       - https://github.com/mg979/vim-visual-multi
"       - Provides multi-line editing
"
Plug 'mg979/vim-visual-multi', {'branch': 'master'}

" --------------------------------------------------------------------------
" vim-plug: end auto plugin management
" --------------------------------------------------------------------------
call plug#end()

" --------------------------------------------------------------------------
" Plugin Settings and configuration
" --------------------------------------------------------------------------

" neos-irblack
colorscheme neos_irblack

" Coc
let g:coc_global_extensions =
    \ [
    \ 'coc-clangd',
    \ 'coc-go',
    \ 'coc-json',
    \ 'coc-markdownlint',
    \ 'coc-pyright',
    \ 'coc-sh',
    \ 'coc-yaml',
    \ ]

" nerdcommenter
"
" Set to insert spaces after left comment delimiter and before right comment
" delimiter e.g. /* With Spaces */ as opposed to /*Without Spaces*/ and
" conversely set to remove extra spaces when we uncomment a line... but not
" when editing a python file where this behaviour seems to be automatic!!
if has("autocmd")
    autocmd Filetype *
    \   if &ft != "python" |
    \       let g:NERDSpaceDelims = 1 |
    \       let g:NERDRemoveExtraSpaces = 1 |
    \   endif
endif

" vim-better-whitespace
"
" Set to auto strip trailing whitespace on file save
autocmd BufWritePre * StripWhitespace

" vim-indent-guides
"
" Don't allow plugin to override the default colours
let g:indent_guides_auto_colors = 0

" vim-go
"
" Use gopls for :GoDef and :GoInfo
let g:go_def_mode = "gopls"
let g:go_info_mode = "gopls"
" Auto display function signatures, types etc
let g:go_auto_type_info = 1
let g:go_doc_popup_window = 1
" Run GoFmt on save
let g:go_fmt_command = "gofmt"
" Additional Go syntax highlighting
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_chan_whitespace_error = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_functions = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 1
let g:go_highlight_space_tab_error = 1
let g:go_highlight_string_spellcheck = 1
let g:go_highlight_structs = 1
let g:go_highlight_trailing_whitespace_error = 1
let g:go_highlight_types = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_variable_declarations = 1

" UltiSnips
"
" Set the Ultisnip edit window to open either vertically or horizontally
" depending on context
let g:UltiSnipsEditSplit = "context"
" Use snippets defined by third party plugins (~/.vim/UltiSnips) and user
" defined snippets (~/.vim/local-snippets)
let g:UltiSnipsSnippetDirectories = ["UltiSnips", "local-snippets"]
" Key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<C-space>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" vim-terraform
"
" Run terraform fmt automatically when saving a *.tf or *.tfvars file
let g:terraform_fmt_on_save = 1

" vim-clang-format
"
let g:clang_format#code_style = "llvm"
let g:clang_format#style_options = { "BreakBeforeBraces": "Linux" }

" vim-visual-multi
"
" Suppress warning from VM about delimitMate overriding <BS>
let g:VM_show_warnings = 0
" Set leader to something more friendly
let g:VM_leader = '\'
" Set the highlighting theme
let g:VM_theme = 'spacegray'

" --------------------------------------------------------------------------
" Basic Editor settings
" --------------------------------------------------------------------------

filetype on         " Automatic file type detection

set autoindent      " Automatically indent code to match the last line
set smartindent     " Same as above but do it smart
set showcmd         " Display incomplete commands
set showmatch       " Show matching brackets.
set tabstop=4       " Number of spaces diplayed for a tab
set softtabstop=4   " How many columns are used for tab in insert mode
set shiftwidth=4    " Spaces for autoindents
set expandtab       " Turn tabs into spaces
set number          " Always show line numbers
set nowrap          " Deactivate wrapping
set textwidth=75    " Text auto breaks after 75 characters
set modeline        " Enable modeline
set encoding=utf-8  " Set default encoding
set hlsearch        " Highlight all matches found when searching
set mouse=a         " Enable mouse support for all modes

set wildmenu        " Show zsh like menu for tab autocompletes
set ruler           " Show the cursor position all the time
set laststatus=2    " Use 2 lines for the status bar
set showmode        " Show the mode in the status bar (insert/replace...)
set clipboard=unnamed " y and p copy/paste interaction with OS X clipboard

set notitle         " Do not show filename in terminal titlebar
set backspace=indent,eol,start " Backspacing over everything in insert mode
set whichwrap+=>,l  " At the end of a line move to beginning of the next
                    " when moving the cursor
set whichwrap+=<,h  " At the start of a line move to end of the previous
                    " when moving the cursor
set scrolloff=5     " Keep at least 5 lines above/below the cursor
set sidescroll=1    " Smoother control of horizontal scrolling

set autoread        " Watch for file changes by other programs
set autowrite       " Write current buffer when running :make
set smarttab        " Make <tab> and <backspace> smarter
set noignorecase    " Don't ignore case in searches
set autoindent      " Turn on autoindent
set smartindent     " Turn on smartindent
set lazyredraw      " Don't redraw the screen while executing marcos etc

set maxmempattern=2000 " set max memory in kb to use for pattern matching
set undolevels=1000 " set max number of changes that can be undone
set updatecount=50  " set chars before vim writes recovery swapfile to disk
set history=1000    " Number of commands to remember
set hidden          " Opening a new file when the current buffer has unsaved
                    " changes causes the current file to be hidden instead
                    " of closed
set confirm         " Get a dialog when :q, :w, :wq etc fails
set incsearch       " Do incremental searching
set undofile        " Keep an undo file (undo changes after closing)
set backup          " Keep backup files

" --------------------------------------------------------------------------
" Settings for better performance with plugins such as Coc
" --------------------------------------------------------------------------

set cmdheight=2       " More space for messages below the status bar
set updatetime=300    " Shorter updatetime gives a better user experience
set shortmess+=c      " Don't pass messages to |ins-completion-menu|
set signcolumn=yes:1  " Always show the signcolumn

set completeopt+=preview " Completion menu to display additional

" --------------------------------------------------------------------------
" Undo, Swap and Backup settings
" --------------------------------------------------------------------------

" Enable persistent undo, and put undo files in their own directory to
" prevent pollution of project directories
if exists("+undofile")
    " Create the directory if it doesn't exists
    if isdirectory($HOME . '/.local/share/nvim/undo') == 0
        :silent !mkdir -p ~/.local/share/nvim/undo > /dev/null 2>&1
    endif
    " Remove current directory and home directory, then add .vim/undo as
    " main dir and current dir as backup dir
    set undodir-=.
    set undodir-=~/
    set undodir+=.
    set undodir^=~/.local/share/nvim/undo//
    set undofile
endif

" Set a common location for storing backup files
if exists("+backup")
    " Create the directory if it doesn't exists
    if isdirectory($HOME . '/.local/share/nvim/backup') == 0
        :silent !mkdir -p ~/.local/share/nvim/backup > /dev/null 2>&1
    endif
    " Remove current directory and home directory, then add .vim/backup as
    " main dir and current dir as backup dir
    set backupdir-=.
    set backupdir-=~/
    set backupdir+=.
    set backupdir^=~/.local/share/nvim/backup//
    set backup
endif

" Configure the location for storing temporary swap files creating if
" required
if isdirectory($HOME . '/.local/share/nvim/swap') == 0
    :silent !mkdir -p ~/.local/share/nvim/swap > /dev/null 2>&1
endif
" Set the dir, falling back to /var/tmp in case the above failed
set dir=~/.local/share/nvim/swap,/var/tmp

" --------------------------------------------------------------------------
" Folding
" --------------------------------------------------------------------------

if has('folding') |
    setlocal foldmethod=syntax     " Use syntax for folding
    setlocal foldlevel=99          " Auto folding occurs for folds above num
    setlocal foldnestmax=10        " Allow this many folds within folds
    setlocal foldcolumn=2          " Display a column for folding
    setlocal foldignore=none       " Don't ignore # when folding
endif

" --------------------------------------------------------------------------
" User commands
" --------------------------------------------------------------------------

" My fingers cant seem to lift off the shift key after typing a :
command! Q      q
command! W      w
command! Wq     wq
command! WQ     wq

" Rebind <Leader> key
let mapleader = ","

" Faster Scrolling
nmap <C-k> 5k
nmap <C-j> 5j
nmap <C-h> 5h
nmap <C-l> 5l

" Complete with tab
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Map sort function to key
vnoremap <Leader>s :sort<cr>

" Quick toggle of folds
nnoremap <space> za
vnoremap <space> za
" Quick unfold of nested folds
nnoremap <Leader><space> zA
vnoremap <Leader><space> zA

" Easier moving of highlighted code blocks in visual mode - This prevents
" loss of visual highlight on change of indent
vnoremap < <gv
vnoremap > >gv

" Paste mode toggle. Helps avoid unexpected effects when pasting into vim
nnoremap <C-p> :set invpaste<cr>

" Show line numbers toggle
nnoremap <Leader>l :set invnumber<cr>

" Clear highlight search items
nnoremap <silent> <Esc><Esc> :nohls<cr>

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 74 characters.
  autocmd FileType text setlocal textwidth=74

  " Set to automatically reload init.vim when changes are made to it
  autocmd! BufWritePost $MYVIMRC source %

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif

" Output the name of the highlight group under the cursor
nmap <leader>g :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" --------------------------------------------------------------------------
" User Commands - Plugin specific
" --------------------------------------------------------------------------

" Coc
"
" Auto show documentation for symbol under cursor in pop up
nnoremap <silent> <leader>h :call CocActionAsync('doHover')<cr>
" Remap <C-c> and <C-d> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-c>
    \ coc#float#has_scroll() ? coc#float#scroll(1,1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-d>
    \ coc#float#has_scroll() ? coc#float#scroll(0,1) : "\<C-b>"
inoremap <silent><nowait><expr> <C-c>
    \ coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1,1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-d>
    \ coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0,1)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-c>
    \ coc#float#has_scroll() ? coc#float#scroll(1,1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-d>
    \ coc#float#has_scroll() ? coc#float#scroll(0,1) : "\<C-b>"

" nerdtree
"
" Toggle nerdtree
nnoremap <silent> <leader>n :NERDTreeToggle<cr>

" tagbar
"
" Toggle tagbar
nnoremap <silent> <leader>t :TagbarToggle<cr>

" vim-clang-format
"
" Trigger auto formatting
if executable('clang-format')
    autocmd FileType c,cpp,objc
        \ nnoremap <silent><buffer><Leader>f :<C-u>ClangFormat<cr>
    autocmd FileType c,cpp,objc
        \ vnoremap <silent><buffer><Leader>f :ClangFormat<cr>
    " Auto-enable auto-formatting
    autocmd Filetype c ClangFormatAutoEnable
    " Auto format on write
    autocmd BufWritePre *.h,*.cc,*.c,*.cpp :ClangFormat
endif

" --------------------------------------------------------------------------
" Language settings
" --------------------------------------------------------------------------

" Set up auto completion with omnifunc. This will set up completion only if
" a specific plugin does not exist for a filetype.
" Note that the jedi plugin will set omnifunc to jedi#completions for us if
" it handles the filetype
if has("autocmd") && exists("+omnifunc")
    autocmd Filetype *
    \	if &omnifunc == "" |
    \		setlocal omnifunc=syntaxcomplete#Complete |
    \	endif
endif

" --------------------------------------------------------------------------
" Local overrides of main Vim Theme and custom theme settings
" --------------------------------------------------------------------------

" vim-better-whitespace
" Set to highlight whitespace in green rather than the default red
hi ExtraWhitespace ctermbg=green

" vim-indent-guides
" Set the colors for the indent markers
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=232
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=234

" Create a (faint grey) ruler at max line width
if exists('+colorcolumn') |
    if has("autocmd") |
        autocmd Filetype *
        \   if &ft == "go" |
        \       set colorcolumn=120 |
        \   else |
        \       set colorcolumn=80 |
        \   endif
        hi colorcolumn ctermfg=none ctermbg=235
    endif
endif

" Set colours for folding
if has('folding')
    " Set colour for the fold text
    hi folded ctermfg=240 ctermbg=none
    " Set colour for the fold column
    hi foldcolumn ctermfg=24 ctermbg=none
endif

" Highlight current line
set cursorline
" Adjust colours for the line itself and line number highlighting
hi CursorLine cterm=none ctermbg=none
hi CursorLineNr ctermfg=226 ctermbg=none

" Set a custom highlight group for use with the statusline
hi User1 ctermbg=235 ctermfg=208
hi User2 ctermbg=235 ctermfg=27
hi User3 ctermbg=235 ctermfg=160

" Now create the status line
set statusline=                                 " Clear default statusline
set statusline+=%1*%t\                          " Tail of the filename
set statusline+=%2*[%3.3n]                      " Buffer number
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, " File encoding
set statusline+=%{&ff}]                         " File format
set statusline+=%h                              " Help file flag
set statusline+=%3*%m                           " Modified flag
set statusline+=%r                              " Read only flag
set statusline+=%2*%y                           " Filetype
set statusline+=%=                              " Left/right separator
set statusline+=%c,                             " Cursor column
set statusline+=%l/%L                           " Cursor line/total lines
set statusline+=\ %P                            " Percent through file
