""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Maintainer:   Daniel Hamilton
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use Vim settings, rather than Vi settings (much better!).
set nocompatible

" --------------------------------------------------------------------------
" Basic Editor settings
" --------------------------------------------------------------------------

filetype on         " Automatic file type detection
syntax on           " Always use syntax highlighting

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
set esckeys         " Map missed escape sequences (enables keypad keys)
set autoindent      " Turn on autoindent
set smartindent     " Turn on smartindent
set regexpengine=1  " Use the old regex engine as its faster with Ruby
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
" Settings for better performance with plugins such as Coc and YouCompleteMe
" --------------------------------------------------------------------------

set cmdheight=2       " More space for messages below the status bar
set updatetime=300    " Shorter updatetime gives a better user experience
set shortmess+=c      " Don't pass messages to |ins-completion-menu|
set signcolumn=number " Configure the signcolumn (left of number column) to
                      " always be dislayed otherwise text is shifted when
                      " diagnostics are dislayed/resolved

set ttymouse=sgr       " Allow popup diplays on mouse hover
set completeopt+=popup " Completion menu to display additional info via popup
set balloondelay=500   " Milliseconds to delay before showing popup menu

" Configure completion menu popup settings
set completepopup=align:menu,border:off,highlight:Pmenu


" --------------------------------------------------------------------------
" Undo, Swap and Backup settings
" --------------------------------------------------------------------------

" Enable persistent undo, and put undo files in their own directory to
" prevent pollution of project directories
if exists("+undofile")
    " Create the directory if it doesn't exists
    if isdirectory($HOME . '/.vim/undo') == 0
        :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
    endif
    " Remove current directory and home directory, then add .vim/undo as
    " main dir and current dir as backup dir
    set undodir-=.
    set undodir-=~/
    set undodir+=.
    set undodir^=~/.vim/undo//
    set undofile
endif

" Set a common location for storing backup files
if exists("+backup")
    " Create the directory if it doesn't exists
    if isdirectory($HOME . '/.vim/backup') == 0
        :silent !mkdir -p ~/.vim/backup > /dev/null 2>&1
    endif
    " Remove current directory and home directory, then add .vim/backup as
    " main dir and current dir as backup dir
    set backupdir-=.
    set backupdir-=~/
    set backupdir+=.
    set backupdir^=~/.vim/backup//
    set backup
endif

" Configure the location for storing temporary swap files creating if
" required
if isdirectory($HOME . '/.vim/swap') == 0
    :silent !mkdir -p ~/.vim/swap > /dev/null 2>&1
endif
" Set the dir, falling back to /var/tmp in case the above failed
set dir=~/.vim/swap,/var/tmp

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
map <C-k> 5k
map <C-j> 5j

" Map sort function to key
vnoremap <Leader>s :sort<CR>

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
map <C-p> :set invpaste<CR>

" Show line numbers toggle
map <Leader>l :set invnumber<CR>

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

  " Set to automatically reload .vimrc when changes are made to it
  autocmd! bufwritepost .vimrc source %

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

" --------------------------------------------------------------------------
" Vim-Plug: Install the Plugin Manager
" --------------------------------------------------------------------------
"
" Manage all plugins with vim-plug
"       - https://github.com/junegunn/vim-plug
"       - A minimalist Vim plugin manager
"
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
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
call plug#begin('~/.vim/plugged')

" neos-irblack
"       - https://github.com/DanHam/neos-irblack.git
"       - A custom version of the Vim IR Black colour scheme
"       - The main theme must be loaded first so that all other plugins
"         that set some form of highlighting can take effect
"
Plug 'DanHam/neos-irblack'
"

" Coc vim
"       - https://github.com/neoclide/coc.nvim
"       - Intellisense engine for Vim8 & Neovim
"       - Full language server protocol support as VSCode
"       - NOTE: The Coc.nvim plugin is manually loaded based on the
"         filetype - see the 'Manual Plugin Management' section below. This
"         ensures the Coc plugin doesn't interfere with YouCompleteMe.
"         YouCompleteMe is used for 'c' and 'go' filetypes. Coc is used for
"         everything else.
"
Plug 'neoclide/coc.nvim', {'on': []}
"
let g:coc_global_extensions =
    \ [
    \ 'coc-yaml',
    \ 'coc-json',
    \ 'coc-sh',
    \ 'coc-markdownlint',
    \ 'coc-pyright'
    \ ]

" nerdcommenter
"       - https://github.com/scrooloose/nerdcommenter.git
"       - Vim plugin for intensely orgasmic commenting
"
Plug 'scrooloose/nerdcommenter'
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
"

" vim-better-whitespace:
"       - https://github.com/ntpeters/vim-better-whitespace.git
"       - This plugin causes all trailing whitespace characters (spaces and
"         tabs) to be highlighted. Whitespace for the current line will not
"         be highlighted while in insert mode.
"       - A helper function :StripWhitespace is also provided to make
"         whitespace cleaning painless.
"
Plug 'ntpeters/vim-better-whitespace'
"
" Set to auto strip trailing whitespace on file save
autocmd BufWritePre * StripWhitespace
"

" vim-endwise
"       - https://github.com/tpope/vim-endwise.git
"       - A plugin that helps to end certain structures automatically
"
Plug 'tpope/vim-endwise'
"

" vim-indent-guides
"       - https://github.com/nathanaelkane/vim-indent-guides.git
"       - Visually display indent levels in Vim
"
Plug 'nathanaelkane/vim-indent-guides'
"
" Override the default colours
let g:indent_guides_auto_colors = 0
"

" supertab:
"       - https://github.com/ervandew/supertab.git
"       - Supertab is a vim plugin which allows you to use <Tab> for all
"         your insert completion needs (:help ins-completion).
"
Plug 'ervandew/supertab'
"
let g:SuperTabDefaultCompletionType = '<C-n>'
"

" delimitMate
"       - https://github.com/Raimondi/delimitMate.git
"       - delimitMate provides automatic closing of quotes, parenthesis,
"         brackets, and so on.
"
Plug 'Raimondi/delimitMate'
"

" vim-go
"       - https://github.com/fatih/vim-go.git
"       - Provides Go (golang) support for vim
"       - Run :GoInstallBinaries to install the required Go Tools
"       - Install YouCompleteMe for auto completion
"
if executable('go')
    Plug 'fatih/vim-go', {'do': ':GoUpdateBinaries', 'for': 'go'}
    "
    " Additional Go syntax highlighting
    let g:go_highlight_array_whitespace_error = 1
    let g:go_highlight_build_constraints = 1
    let g:go_highlight_chan_whitespace_error = 1
    let g:go_highlight_extra_types = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_function_calls = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_interfaces = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_space_tab_error = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_trailing_whitespace_error = 1
    let g:go_highlight_types = 1
    " Run GoFmt on save
    let g:go_fmt_command = "gofmt"
    " Use gopls for :GoDef and :GoInfo
    let g:go_def_mode = "gopls"
    let g:go_info_mode = "gopls"
    " Auto display function signatures, types etc
    let g:go_auto_type_info = 1
    "
endif

" YouCompleteMe
"       - https://github.com/ycm-core/YouCompleteMe.git
"       - A code completion engine for Vim
"       - Cannot be installed automatically with vim-plug - see
"         https://github.com/junegunn/vim-plug/wiki/faq#youcompleteme-timeout
"
Plug '~/.vim/plugged/YouCompleteMe', { 'for': ['go', 'c', 'cpp'] }
"
" Explicitly set the path to the Python interpreter
let g:ycm_server_python_interpreter = '/usr/bin/python3.7'
" Configure YCM to look in strings and comments for words that it should
" offer to auto-complete. This is required for auto-completion to work
" reasonably within Bash where variables/enviroment variables are often
" surrounded with quotes e.g. "${DEBUG}"
let g:ycm_collect_identifiers_from_comments_and_strings = 1
" Configure YCM to complete in strings for the same reasons given above
let g:ycm_complete_in_strings = 1
" Configure YCM to perform completion in comments
let g:ycm_complete_in_comments = 1
" Allow YCM to seed it's completion/identifier database with keywords
let g:ycm_seed_identifiers_with_syntax = 1
" Make YCM compatible with UltiSnips (using supertab - see below)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
" Explicitly set the path to the .ycm_extra_conf.py file
let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
" Show the diagnostics ui
let g:ycm_show_diagnostics_ui = 1
"

" UltiSnips
"       - https://github.com/SirVer/ultisnips.git
"       - The ultimate snippet tool for Vim
"
Plug 'SirVer/ultisnips'
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

" vim-snippets
"       - https://github.com/honza/vim-snippets
"       - Snippet collection for use with UltiSnips
"
Plug 'honza/vim-snippets'
"

" vim-terraform
"       - https://github.com/hashivim/vim-terraform.git
"       - Adds a :Terraform command that runs terraform, with tab
"         completion of subcommands
"       - Sets up *.tf, *.tfvars, and *.tfstate files to be highlighted as
"         HCL, HCL, and JSON respectively
"       - Adds a :TerraformFmt command that runs terraform fmt against the
"         current buffer
"       - Set g:terraform_fmt_on_save to 1 to run terraform fmt
"         automatically when saving *.tf or *.tfvars files
"
Plug 'hashivim/vim-terraform'
"
" Run terraform fmt automatically when saving a *.tf or *.tfvars file
let g:terraform_fmt_on_save = 1
"

" --------------------------------------------------------------------------
" vim-plug: end auto plugin management
" --------------------------------------------------------------------------
call plug#end()

" --------------------------------------------------------------------------
" Manual Plugin Management
" --------------------------------------------------------------------------

" Conditionally load the Coc plugin based on the filetypes we (don't) use
" Coc for. Put another way - load Coc for every filetype other than those
" listed
augroup load_coc
    autocmd!
    autocmd Filetype *
                \ if &ft != "go" && &ft != "c" && &ft != "cpp" |
                \     call plug#load('coc.nvim') |
                \     autocmd! load_coc |
                \ endif
augroup END

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

" C and C++ formatting on save
" function! Formatonsave()
"   let g:clang_format_style = '{BasedOnStyle: llvm, BreakBeforeBraces: Linux}'
"   let g:clang_format_all = 1
"   py3file ~/.vim/helpers/clang-format.py
" endfunction
" autocmd BufWritePre *.h,*.cc,*.c,*.cpp call Formatonsave()

" --------------------------------------------------------------------------
" Colorscheme
" --------------------------------------------------------------------------

" Main theme 'ir-black' is loaded by vim-plug

" Set the theme
colorscheme neos_irblack
" Let vim know we are using a dark console/transparent with dark background
set background=dark

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
