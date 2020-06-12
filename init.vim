" Stuff to consider adding:
"   find something to indent sql?

" Set Leader
let mapleader=","

" Set working directory
let $HOME = $USERPROFILE
:cd $USERPROFILE
" Load plugins
call plug#begin()
    " Visuals
    Plug 'morhetz/gruvbox'
    Plug 'itchyny/lightline.vim'

    " Extend Repeating
    Plug 'tpope/vim-repeat'

    " Custom Operators
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'vim-scripts/ReplaceWithRegister'
    Plug 'christoomey/vim-titlecase'
    Plug 'christoomey/vim-sort-motion'
    Plug 'christoomey/vim-system-copy'

    " Custom Text Objects
    Plug 'michaeljsmith/vim-indent-object'
    Plug 'kana/vim-textobj-user'
    Plug 'kana/vim-textobj-entire'
    Plug 'kana/vim-textobj-line'

    " Nerdtree
    Plug 'preservim/nerdtree'

call plug#end()

" set autochdir          " Switch to current file's directory - disabled for
" advanced file searching
set nocompatible       " Disables vi compatibility
syntax enable          " Enables syntax highlighting (neovim default)
filetype plugin on     " Built-in file browsing

" Colorscheme options.
    colorscheme gruvbox

" Use <C-L> to clear search highlighting
    if maparg('<C-L>', 'n') ==# ''
        nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
    endif

" Whitespace
    " Characers for TAB, Trailing whitespace, and end of line
    if &listchars ==# 'eol:$'
        set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
    endif
    set list           " Show problematic characters.

    " Remove trailing spaces.
    function! TrimWhitespace()
        let l:save = winsaveview()
        %s/\s\+$//e
        call winrestview(l:save)
    endfunction
    " FIXME: Do not call this on makefile and sv files.
    autocmd BufWritePre * call TrimWhitespace()
    nnoremap <leader>W :call TrimWhitespace()<CR>

    " Also highlight all tabs and trailing whitespace characters.
    highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
    match ExtraWhitespace /\s\+$\|\t/

" Line Numbering
    set number
    set rnu

    " Relative numbering
    function! NumberToggle()
        if(&relativenumber == 1)
            set nornu
            set number
        else
            set rnu
        endif
    endfunc

    " Toggle between normal and relative numbering.
    nnoremap <leader>r :call NumberToggle()<cr>

" Tabs
    set expandtab
    set tabstop=4
    set shiftwidth=4
    set nojoinspaces

" File Finding - No FuzzyFinder Plugin!!
    " Search through sub-directories when searching
    " Provides tab-completion in all file finding functions
    set path+=**

    " Display all matching files on tab complete
    set wildmenu

" Autocompletion
    " See |ins-completion| help file
    " ^x^n for JUST this file
    " ^x^f for filenames
    " ^n for anything specified by the 'complete' option
    " ^n and ^p to go back and forth in the suggestion list

" netrw (File Browser)

        " Tweaks for browsing
    let g:netrw_banner=0        " disable annoying banner
    let g:netrw_browse_split=4  " open in prior window
    let g:netrw_altv=1          " open splits to the right
    let g:netrw_liststyle=3     " tree view
    let g:netrw_list_hide=netrw_gitignore#Hide()
    let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

    " NOW WE CAN:
    " - :edit a folder to open a file browser
    " - <CR>/v/t to open in an h-split/v-split/tab
    " - check |netrw-browse-maps| for more mappings

" Lightline
    let g:lightline = {
    \ 'colorscheme': 'gruvbox',
    \ 'active': {
    \   'left': [['mode', 'paste'], ['filename', 'modified']],
    \   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors']]
    \ },
    \ 'component_expand': {
    \   'linter_warnings': 'LightlineLinterWarnings',
    \   'linter_errors': 'LightlineLinterErrors'
    \ },
    \ 'component_type': {
    \   'readonly': 'error',
    \   'linter_warnings': 'warning',
    \   'linter_errors': 'error'
    \ },
    \ }
    function! LightlineLinterWarnings() abort
        let l:counts = neomake#statusline#LoclistCounts()
    let l:warnings = get(l:counts, 'W', 0)
    return l:warnings == 0 ? '' : printf('%d ◆', l:warnings)
    endfunction
    function! LightlineLinterErrors() abort
    let l:counts = neomake#statusline#LoclistCounts()
    let l:errors = get(l:counts, 'E', 0)
    return l:errors == 0 ? '' : printf('%d ✗', l:errors)
    endfunction

    " Ensure lightline updates after neomake is done.
    autocmd! User NeomakeFinished call lightline#update()

" NERDTree
    " Opens NERDTree by default
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

    " Map opening NERDTree
    nnoremap <Leader>f :NERDTreeToggle<Enter>

    " Closing automatically
    let NERDTreeQuitOnOpen = 1
    autocmd bufenter * if (winnr("$") == 1 && exists ("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " Cosmetics
    let NERDTreeMinimalUI = 1
    let NERDTreeDirArrows = 1
    
" Commentary
    autocmd FileType vb setlocal commentstring='\%s
