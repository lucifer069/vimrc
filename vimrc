
" Personal preference .vimrc file
" Gunther Groenewege
" based upon the file by Vincent Driessen
"
" To start vim without using this .vimrc file, use:
"     vim -u NORC
"
" To start vim without loading any .vimrc or plugins, use:
"     vim -u NONE
"

" This must be first, because it changes other options as a side effect.
set nocompatible

" Use pathogen to easily modify the runtime path to include all plugins under
" the ~/.vim/bundle directory
call pathogen#infect()
filetype plugin indent on       " enable detection, plugins and indenting in one step

" Change the mapleader from \ to ,
let mapleader=","


" ==============================================================================
" Editing behaviour
" ==============================================================================

set showmode                    " always show what mode we're currently editing in
set nowrap                      " don't wrap lines
set tabstop=4                   " a tab is four spaces
set softtabstop=4               " when hitting <BS>, pretend like a tab is removed, even if spaces
set expandtab                   " expand tabs by default (overloadable per file type later)
set shiftwidth=4                " number of spaces to use for autoindenting
set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set autoindent                  " always set autoindenting on
set copyindent                  " copy the previous indentation on autoindenting
set number                      " always show line numbers
set showmatch                   " set show matching parenthesis
set ignorecase                  " ignore case when searching
set smartcase                   " ignore case if search pattern is all lowercase,
                                "    case-sensitive otherwise
set smarttab                    " insert tabs on the start of a line according to
                                "    shiftwidth, not tabstop
set scrolloff=4                 " keep 4 lines off the edges of the screen when scrolling
"set virtualedit=all            " allow the cursor to go in to invalid places
set hlsearch                    " highlight search terms
set incsearch                   " show search matches as you type
set gdefault                    " search/replace 'globally' (on a line) by default
set listchars=tab:▸\ ,trail:·,extends:#,nbsp:·,eol:¬

" regex fix
nnoremap / /\v
vnoremap / /\v

" folding settings
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction
 
function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction


" ==============================================================================
" Editor layout
" ==============================================================================

set termencoding=utf-8
set encoding=utf-8
set lazyredraw                  " don't update the display while executing macros
set laststatus=2                " tell VIM to always put a status line in
set ch=2                        " Make command line two lines high
if has('statusline')
  set statusline=%<%f\   " Filename
  set statusline+=%w%h%m%r " Options
  set statusline+=%{fugitive#statusline()} "  Git Hotness
  set statusline+=\ [%Y]            " filetype
  set statusline+=\ [%{getcwd()}]          " current dir
  set statusline+=%=%-14.(line\ %l\ of\ %L\ -\ col\ %c%)  " Right aligned file nav info
endif


" ==============================================================================
" Vim behaviour
" ==============================================================================

set hidden                      " hide buffers instead of closing them this
"    means that the current buffer can be put
"    to background without being written; and
"    that marks and undo history are preserved
set switchbuf=useopen           " reveal already opened files from the
" quickfix window instead of opening new
" buffers
set history=1000                " remember more commands and search history
set undolevels=1000             " use many muchos levels of undo
set backupdir=~/.vim/backup		" swap files
set directory=~/.vim/backup
set wildmenu                    " make tab completion for files/buffers act like bash
set wildmode=list:full          " show a list when pressing tab and complete
"    first full match
set wildignore+=.git,.svn
set title                       " change the terminal's title
set visualbell                  " don't beep
set noerrorbells                " don't beep
set showcmd                     " show (partial) command in the last line of the screen
set nomodeline                  " disable mode lines (security measure)
set ttyfast                     " always use a fast terminal
set clipboard=unnamed           " share with system clipboard

" ============================================================================== 
" Spelling
" ============================================================================== 

set nospell
set spelllang=en,fr
set spellsuggest=5
map <F3> :set nospell!<CR>

" ==============================================================================
" Highlighting
" ==============================================================================

if &t_Co >= 256 || has("gui_running")
"  let g:molokai_original = 1
"  colorscheme molokai
  set background=dark
  let g:solarized_termtrans=1
  let g:solarized_termcolors=256
  let g:solarized_contrast="high"
  let g:solarized_visibility="high"
  colorscheme solarized
  call togglebg#map("<F4>")
endif

if &t_Co > 2 || has("gui_running")
  syntax on                    " switch syntax highlighting on, when the terminal has colors
endif

" Show syntax highlighting groups for word under cursor
nmap <leader>sh :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc


" ==============================================================================
" Filetypes
" ==============================================================================

" Help files
au filetype help set nonumber      " no line numbers when viewing help
au filetype help nnoremap <buffer><CR> <C-]>   " Enter selects subject
au filetype help nnoremap <buffer><BS> <C-T>   " Backspace to go back


" ==============================================================================
" PHP settings
" ==============================================================================

let php_sql_query=1
let php_htmlInStrings=1
let php_folding=1
let php_parent_error_close=1
let php_parent_error_open=1

" ctrl-p to comment php code
inoremap <silent> <C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <silent> <C-P> :call PhpDocSingle()<CR>
vnoremap <silent> <C-P> :call PhpDocRange()<CR> 

" Loads a tag file from ~/.vim.tags/, based on the argument provided. The
" command "Ltag"" is mapped to this function.
function! LoadTags(file)
  let tagspath = $HOME . "/.vim.tags/" . a:file
  let tagcommand = 'set tags+=' . tagspath
  execute tagcommand
endfunction
command! -nargs=1 Ltag :call LoadTags("<args>")

" Load a project : change directory - load tags - show nerdtree
function! LoadProject(name)
  let projectpath = "/Library/Webserver/Documents/" . a:name
  let cdcommand = 'cd ' . projectpath
  execute cdcommand
  call LoadTags(a:name)
  NERDTree
endfunction
command! -nargs=1 Project : call LoadProject("<args>")

" ==============================================================================
" Shortcut mappings
" ==============================================================================

" Maps for jj to act as Esc
ino jj <esc>
cno jj <c-c>

" Show current tag for word under the cursor
nnoremap <silent> <leader>t <C-]>
nnoremap <silent> <leader>st <C-w><C-]>
" Show current tag list for word under the cursor
nnoremap <silent> <leader>tj g<C-]>
nnoremap <silent> <leader>stj <C-w>g<C-]>

" Open omnicomplete menu
" inoremap <silent> <C-space> <C-x><C-o>
inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
\ "\<lt>C-n>" :
\ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
\ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
\ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
imap <C-@> <C-Space>


" Quickly close the current window
nnoremap <silent> <leader>q :q<CR>

" Use the damn hjkl keys
" map <up> <nop>
" map <down> <nop>
" map <left> <nop>
" map <right> <nop>

" Remap j and k to act as expected when used on long, wrapped, lines
nnoremap j gj
nnoremap k gk

" Bubble single lines
nmap <leader><Up> ddkP
nmap <leader><Down> ddp
" Bubble multiple lines
vmap <leader><Up> xkP`[V`]
vmap <leader><Down> xp`[V`]

" wrap text
command! -nargs=* Wrap set wrap linebreak nolist
map <F2> :set nowrap! <CR>

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nnoremap <leader>w <C-w>v<C-w>l

" Edit the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>
" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Open file in current directory
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <silent> <leader>ew :e %%
map <silent> <leader>es :vsp %%
" Change directory to directory of current file
map <silent> <leader>cd :cd %% <CR>

" Expand to local webserver root
cnoremap ## <C-R>='/Library/Webserver/Documents/'<cr>

" Clears the search register
nmap <silent> <leader>/ :nohlsearch<CR>

" Shortcut to rapidly toggle hidden characters
nmap <silent> <leader>h :set list!<CR>

" Strip all trailing whitespace from a file, using ,w
nnoremap <silent> <leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Run Ack fast
nnoremap <silent> <leader>a :Ack<Space>

" Preview markdown documents in the browser from vim
nmap <silent> <leader>md :Mm<CR>

" Preview file in safari
map <silent> <leader>s :!open -a Safari %<CR><CR>

" surround with strong or em tags
map <silent> <leader>b lbi<strong><Esc>ea</strong><Esc>
map <silent> <leader>i lbi<em><Esc>ea</em><Esc>

" space as pagedown like web browser 
nmap <space> <pagedown>

" colorpicker
map <silent> <leader>x :PickHEX<CR>

" Underline the current line with dashes in normal mode
nnoremap <F5> yyp<c-v>$r-

" Underline the current line with dashes in insert mode
inoremap <F5> <Esc>yyp<c-v>$r-A

" Underline the current line with double dashes in normal mode
nnoremap <F6> yyp<c-v>$r=

" Underline the current line with double dashes in insert mode
inoremap <F6> <Esc>yyp<c-v>$r=A

" ==============================================================================
" Abreviations
" ==============================================================================

ab GG Gunther Groenewege
ab "= " ==============================================================================


" ==============================================================================
" NERDTree settings
" ==============================================================================

let NERDChristmasTree=1
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=1
let NERDTreeIgnore=['\.DS_Store', '^Icon']
nmap <silent> <leader>n :NERDTreeToggle<CR>
nmap <silent> <leader>N :NERDTreeClose<CR>
nmap <silent> <leader>f :NERDTreeFind<CR>


" ==============================================================================
" Taglist settings
" ==============================================================================

nmap <silent> <leader>l :TlistToggle<CR>
nmap <silent> <leader>L :TlistClose<CR>
" TagListTagName - Used for tag names
highlight MyTagListTagName gui=italic guifg=#dc322f guibg=#ffffff
" TagListTitle - Used for tag titles
highlight MyTagListTitle gui=italic guifg=#333333 guibg=#cb4b16
" TagListFileName - Used for filenames
highlight MyTagListFileName gui=bold guifg=#000000 guibg=#859900
let Tlist_Ctags_Cmd = "/usr/local/bin/ctags"
let Tlist_Show_One_File = 1
let Tlist_Enable_Fold_Column = 0
let Tlist_Use_Right_Window = 1
let Tlist_Compact_Format = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_File_Fild_Auto_Close = 1
let Tlist_Inc_Winwidth = 0
let Tlist_Close_On_Select = 1
let Tlist_Process_File_Always = 1
let Tlist_Display_Prototype = 0
let Tlist_Display_Tag_Scope = 1
let tlist_php_settings = 'php;c:class;f:Functions'
let tlist_markdown_settings='markdown;h:Headings'
let tlist_css_settings='css;s:Selectors'
let tlist_html_settings = 'html;h:Headers;o:Objects(ID);c:Classes'
let tlist_xhtml_settings = 'html;h:Headers;o:Objects(ID);c:Classes'


" ============================================================================== 
" Snipmate settings
" ============================================================================== 

let g:snips_author = 'Gunther Groenewege' 
let g:snippets_dir = $HOME . "/.vim/snippets/"
" Use HTML and PHP snippets in .php files
nmap <silent> <leader>ph :set filetype=php.html<CR>
" Shortcut for reloading snippets, useful when developing
nnoremap <silent> <leader>r <esc>:exec ReloadAllSnippets()<cr>

" ==============================================================================
" delimitMate settings
" ============================================================================== 

" let delimitMate_excluded_ft = "vim,markdown"
" disable delimitMate
let loaded_delimitMate = 1

" ==============================================================================
" Lusty-Jugller settings
" ==============================================================================

let g:LustyJugglerAltTabMode = 1
let g:LustyJugglerSuppressRubyWarning = 1
noremap <silent> <C-TAB> :LustyJuggler<CR>


" ==============================================================================
" Sparkup configuration
" ==============================================================================

" DEFAULT : let g:sparkupExecuteMapping = '<c-e>'
let g:sparkupNextMapping = '<c-y>'


" ============================================================================== 
" Gundo settings
" ============================================================================== 

nnoremap <silent> <leader>g :GundoToggle<CR>


" ============================================================================== 
" Gist-vim settings
" ============================================================================== 

if has('mac')
    let g:gist_clip_command = 'pbcopy'
endif
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1


" ============================================================================== 
" HexHighlight settings
" <leader>F2
" ============================================================================== 

nmap <Leader>rc <Plug>RefreshColorScheme


" ============================================================================== 
" HTML5.vim settings
" ============================================================================== 

" Disable event-handler attributes support
let g:event_handler_attributes_complete = 0
" Disable RDFa attributes support
let g:rdfa_attributes_complete = 0
" Disable microdata attributes support
let g:microdata_attributes_complete = 0
" Disable WAI-ARIA attribute support
let g:aria_attributes_complete = 0

" ==============================================================================
" GUI
" ==============================================================================

" Shift Key
if has("gui_macvim")
  let macvim_hig_shift_movement = 1
endif


" ==============================================================================
" Filetype specific handling
" ==============================================================================

if has("autocmd")
  au BufNewFile,BufRead *.less set filetype=less
  autocmd FileType html,css,less,yaml,vim setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType markdown setlocal wrap linebreak nolist
endif

