""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" Maintainer:   Daniel Hamilton
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype off

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" --------------------------------------------------------------------------
" Basic Editor settings
" --------------------------------------------------------------------------

filetype on         " Automatic file type detection

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

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" --------------------------------------------------------------------------
" Folding
" --------------------------------------------------------------------------

if has('folding') |
    " Fix for issue with Go files and tab. See:
    " https://github.com/govim/govim/issues/656#issuecomment-573089241
    " https://github.com/vim/vim/issues/5454
    " https://github.com/neoclide/coc.nvim/issues/1048
    "
    " For Go files the foldmethod must be set to manual or Vim errors:
    " E967: text property info corrupted
    " This is fixed in Vim >= 8.2.0109
    if has("autocmd") |
        autocmd Filetype *
                \   if &ft == "go" |
                \       setlocal foldmethod=manual |
                \   else |
                \       setlocal foldmethod=syntax |
                \   endif
    endif
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

" Map sort function to key
vnoremap <Leader>s :sort<CR>

" Quick toggle of folds
nnoremap <space> za
vnoremap <space> za
" Quick unfold of nested folds
nnoremap <Leader><space> zA
vnoremap <Leader><space> zA

" Fast switching between buffers
nnoremap <Leader>, :bp<CR>
nnoremap <Leader>. :bn<CR>

" Easier moving of highlighted code blocks in visual mode - This prevents
" loss of visual highlight on change of indent
vnoremap < <gv
vnoremap > >gv

" Don't use Ex mode, use Q for formatting
map Q gq

" Faster scrolling using ctrl
map <C-j> 5j
map <C-k> 5k
map <C-h> 5h
map <C-l> 5l

" Paste mode toggle. Helps avoid unexpected effects when pasting into vim
map <C-p> :set invpaste<CR>

" Show line numbers toggle
map <Leader>l :set invnumber<CR>

" Quick method of dismissing syntastic checks and error
nnoremap <Leader>e :SyntasticReset<CR>

" Toggle NERDTree
map <C-n> :NERDTreeToggle<CR>

" Y should have the same behaviour as D e.g. yank to end, but instead works
" like yy. Fix here:
map Y y$

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

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

  " smartindent:
  " By default When typing '#' as the first character in a new line, the
  " indent for that line is removed and the '#' is put in the first column.
  " If you don't want this, use this mapping:
  "
  " :inoremap # X^H#
  "
  " where ^H is entered with CTRL-V CTRL-H.
  " When using the '>>' command, lines starting with '#' are not shifted
  " right.
  autocmd FileType python,php,vim inoremap # X#

else

  set autoindent        " Always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and
" the file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
          \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif

" --------------------------------------------------------------------------
" Plugins settings
" --------------------------------------------------------------------------

" Pathogen
" https://github.com/tpope/vim-pathogen
"
" Manage your 'runtimepath' with ease. In practical terms, pathogen.vim
" makes it super easy to install plugins and runtime files in their own
" private directories.
" All plugins extracted to a subdirectory under ~/.vim/bundle will be added to
" the 'runtimepath' automatically
call pathogen#infect()      " Load Pathogen Plugins
call pathogen#helptags()    " Generate documentation for Plugins

" Automatically managed plugins:
"
" neos-irblack
"       - https://github.com/DanHam/neos-irblack.git
"       - A custom version of the Vim IR Black colour scheme
"       - The main theme must be loaded first so that all other plugins
"         that set some form of highlighting can take effect
"
" Set the theme
colorscheme neos_irblack
" Let vim know we are using a dark console/transparent with dark background
set background=dark
"

" ansible-vim
"       - https://github.com/pearofducks/ansible-vim.git
"       - A VIM syntax plugin for Ansible 2.0
"       - Supports playbooks, Jinja2 templates and Ansibles host files
"       - When the file type is not automatically detected use the
"         following stanza at the head of the file:
"         # vim: ft=ansible:
"
" Highlighting for attributes. Available flags are:
"   a: highlight all instances of key=
"   o: highlight only instances of key= found on newlines
"   d: dim the instances of key= found
"   b: brighten the instances of key= found
"   n: turn off this highlight completely
let g:ansible_attribute_highlight = 'ab'
" Highlight for additional keywords
let g:ansible_extra_keywords_highlight = 1
"

" jedi-vim:
"       - https://github.com/davidhalter/jedi-vim
"       - Awesome Python autocompletion with VIM
"       - Required jedi to be installed from macports or recursive clone
"         of the jedi-vim repo (includes jedi)
"

" nerdcommenter
"       - https://github.com/scrooloose/nerdcommenter.git
"       - Vim plugin for intensely orgasmic commenting
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

" nerdtree
"       - https://github.com/scrooloose/nerdtree.git
"       - The NERD tree allows you to explore your filesystem and to open
"         files and directories.
"
" Set mouse click behaviour: single click to open directories, double for
" files
let g:NERDTreeMouseMode=2
" Set to auto close the NERDTree pane when a file is opened
let g:NERDTreeQuitOnOpen=1
"

" syntastic:
"       - https://github.com/scrooloose/syntastic.git
"       - Syntastic is a syntax checking plugin for Vim that runs files
"         through external syntax checkers and displays any resulting
"         errors to the user.
"
" Fill the error location-list with errors found by the checkers
let g:syntastic_always_populate_loc_list = 1
" Allow auto open/close of the error window
let g:syntastic_auto_loc_list = 1
" Whether to invoke checkers when the file is opened
let g:syntastic_check_on_open = 0
" Whether to invoke checkers when we write/quit
let g:syntastic_check_on_wq = 0
" Enable rubocop (gem install rubocop) and default mri checkers for ruby
let g:syntastic_ruby_checkers = ['rubocop', 'mri']
" Disable checkers for java. This prevents the appearance of a really
" annoying pop-up on OS X prompting you to install a JDK because the javac
" command line tool was not found!
let g:syntastic_java_checkers = ['']
" Settings for Go and integration with vim-go
let g:syntastic_go_checkers = ['golint', 'go-vet', 'errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go']}
"

" Tabular
"       - https://github.com/godlygeek/tabular.git
"       - A plugin for automatic alignment of text
"       - See http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
"

" vim-better-whitespace:
"       - https://github.com/ntpeters/vim-better-whitespace.git
"       - This plugin causes all trailing whitespace characters (spaces and
"         tabs) to be highlighted. Whitespace for the current line will not
"         be highlighted while in insert mode.
"       - A helper function :StripWhitespace is also provided to make
"         whitespace cleaning painless.
"
" Set to auto strip trailing whitespace on file save
autocmd BufWritePre * StripWhitespace
"

" vim-endwise
"       - https://github.com/tpope/vim-endwise.git
"       - A plugin that helps to end certain structures automatically
"

" vim-fugitive
"       - https://github.com/tpope/vim-fugitive
"       - Git wrapper for vim
"

" vim-go
"       - https://github.com/fatih/vim-go.git
"       - Provides Go (golang) support for vim
"       - Run :GoInstallBinaries to install the required Go Tools
"       - Install YouCompleteMe for auto completion
"
" Additional Go syntax highlighting
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
" Fix problem with location list window (that contains the output of
" commands from :GoBuild, :GoTest etc) not appearing when Syntastic is
" also installed
let g:go_list_type = "quickfix"
" Run GoFmt on save
let g:go_fmt_command = "gofmt"
" Use gopls for :GoDef and :GoInfo
let g:go_def_mode = "gopls"
let g:go_info_mode = "gopls"
" Auto display function signatures, types etc
let g:go_auto_type_info = 1
"

" vim-markdown-folding
"       - https://github.com/nelstrom/vim-markdown-folding.git
"       - This plugin enables folding by section headings in markdown
"         documents.
"
" Prefer the nested style of folding; Can be toggled with :FoldToggle
let g:markdown_fold_style = 'nested'
"

" vim-ps1
"       - https://github.com/PProvost/vim-ps1.git
"       - Provides nice syntax coloring and indenting for Windows
"         PowerShell (.ps1) files, and also includes a filetype plugin so
"         Vim can autodetect your PS1 scripts.
"

" vim-puppet
"       - https://github.com/rodjek/vim-puppet.git
"       - Make vim more Puppet friendly!
"       - Formatting based on Puppetlabs Style Guide
"       - Syntax highlighting
"       - Automatic => alignment (when the Tabular plugin is installed)
"

" vim-ruby
"       - https://github.com/vim-ruby/vim-ruby.git
"       - Vim configuration files for editing and compiling Ruby within Vim
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
" Run terraform fmt automatically when saving a *.tf or *.tfvars file
let g:terraform_fmt_on_save = 1
"

" vim-indent-guides
"       - https://github.com/nathanaelkane/vim-indent-guides.git
"       - Visually display indent levels in Vim
"
" Override the default colours
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=232
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=234
"

" bats.vim
"       - https://github.com/aliou/bats.vim.git
"       - Adds syntax highlighting for Bats test files
"

" YouCompleteMe
"       - https://github.com/ycm-core/YouCompleteMe.git
"       - A code completion engine for Vim
"
" Explicitly set the path to the Python2 interpreter
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
let g:ycm_global_ycm_extra_conf = '/home/dan/.vim/bundle/YouCompleteMe/third_party/ycmd/.ycm_extra_conf.py'
"

" UltiSnips
"       - https://github.com/SirVer/ultisnips.git
"       - The ultimate snippet tool for Vim
"
" Set the Ultisnip edit window to open either vertically or horizontally
" depending on context
let g:UltiSnipsEditSplit = "context"
" Use snippets defined by third party plugins (~/.vim/UltiSnips) and user
" defined snippets (~/.vim/local-snippets)
let g:UltiSnipsSnippetDirectories = ["UltiSnips", "local-snippets"]
" Key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<C-Space>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" supertab:
"       - https://github.com/ervandew/supertab.git
"       - Supertab is a vim plugin which allows you to use <Tab> for all
"         your insert completion needs (:help ins-completion).
"
"
let g:SuperTabDefaultCompletionType = '<C-n>'
"

" delimitMate
"       - https://github.com/Raimondi/delimitMate.git
"       - delimitMate provides automatic closing of quotes, parenthesis,
"         brackets, and so on.
"

" vim-toml
"       - Vim syntax for TOML
"       - https://github.com/cespare/vim-toml

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
" Local overrides of main Vim Theme
" --------------------------------------------------------------------------

" Main theme 'ir-black' is loaded by pathogen: see above

" vim-better-whitespace
" Set to highlight whitespace in green rather than the default red
hi ExtraWhitespace ctermbg=green

" Highlight current selection in omnicomplete popup menu
hi PMenuSel ctermfg=green ctermbg=236

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

" NERDTree highlighting
hi NERDTreeDir ctermfg=blue ctermbg=none
hi NERDTreeCWD ctermfg=grey ctermbg=none
hi NERDTreeExecFile ctermfg=green ctermbg=none

" Highlight current line
set cursorline
" Adjust colours for the line itself and line number highlighting
hi CursorLine cterm=none ctermbg=none
hi CursorLineNr ctermfg=226 ctermbg=none

" Set a custom highlight group for use with the statusline
if &t_Co>2 && &t_Co<=16
    " For basic color terminals
    hi User1 ctermbg=grey ctermfg=green guibg=grey guifg=green
    hi User2 ctermbg=grey ctermfg=blue  guibg=grey guifg=blue
    hi User3 ctermbg=grey ctermfg=red   guibg=grey guifg=red
elseif &t_Co>16
    " For terminals with 256 color support
    hi User1 ctermbg=235 ctermfg=208 guibg=#262626 guifg=#ff8700
    hi User2 ctermbg=235 ctermfg=27  guibg=#262626 guifg=#005fff
    hi User3 ctermbg=235 ctermfg=160 guibg=#262626 guifg=#d70000
endif

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
set statusline+=%#warningmsg#                   " Syntastic warning messages
set statusline+=%{SyntasticStatuslineFlag()}    " Syntastic status
set statusline+=%*                              " Syntastic status
