
" ---------------------------------------------------------------------------
" General
" ---------------------------------------------------------------------------
 
set nocompatible                      " essential
set history=1000                      " lots of command line history
set cf                                " error files / jumping
set ffs=unix,dos,mac                  " support these files
" filetype plugin indent on             " load filetype plugin
set isk+=_,$,@,%,#,-                  " none word dividers
set viminfo='1000,f1,:100,@100,/20
set modeline                          " make sure modeline support is enabled
set autoread                          " reload files (no local changes only)
set tabpagemax=50                     " open 50 tabs max

" ----------------------------------------------------------------------------
"  Backups
" ----------------------------------------------------------------------------
 
set nobackup                           " do not keep backups after close
set nowritebackup                      " do not keep a backup while working
set noswapfile                         " don't keep swp files either
set backupdir=$HOME/.vim/backup        " store backups under ~/.vim/backup
set backupcopy=yes                     " keep attributes of original file
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set directory=~/.vim/swap,~/tmp,.      " keep swp files under ~/.vim/swap

" ----------------------------------------------------------------------------
"  UI
" ----------------------------------------------------------------------------
 
set ruler                  " show the cursor position all the time
set noshowcmd              " don't display incomplete commands
set nolazyredraw           " turn off lazy redraw
set number                 " line numbers
set wildmenu               " turn on wild menu
set wildmode=list:longest,full
set ch=2                   " command line height
set backspace=2            " allow backspacing over everything in insert mode
set whichwrap+=<,>,h,l,[,] " backspace and cursor keys wrap to
set shortmess=filtIoOA     " shorten messages
set report=0               " tell us about changes
set nostartofline          " don't jump to the start of line when scrolling
 
" ----------------------------------------------------------------------------
" Visual Cues
" ----------------------------------------------------------------------------
 
set showmatch              " brackets/braces that is
set mat=5                  " duration to show matching brace (1/10 sec)
set incsearch              " jumps to search word as you type 
set laststatus=2           " always show the status line
set ignorecase             " ignore case when searching
set smartcase              " case-sensitive if search contains an uppercase character
" set nohlsearch             " don't highlight searches
set visualbell             " shut the fuck up
"set cursorline

set completeopt=longest,menuone " Completion inserts longest common, not first
set expandtab
set tabstop=2 shiftwidth=2 softtabstop=2
set autoindent
set pastetoggle=<F3>
set title

" The following map uses F7 to highlight/unhighlight all occurrences of the current word
" http://vim.wikia.com/wiki/The_super_star
nnoremap <F7> :set invhls<CR>:exec "let @/='\\<".expand("<cword>")."\\>'"<CR>/<BS>

" Set an orange cursor in insert mode, and a red cursor otherwise.
:silent !echo -ne "\033]12;red\007"
let &t_SI = "\033]12;orange\007"
let &t_EI = "\033]12;red\007"
autocmd VimLeave * :!echo -ne "\033]12;red\007"

" ----------------------------------------------------------------------------
" Tab tricks
" ----------------------------------------------------------------------------
function! InsertTabWrapper(direction)
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  elseif "backward" == a:direction
    return "\<c-p>"
  else
    return "\<c-n>"
  endif
endfunction

inoremap <tab> <c-r>=InsertTabWrapper ("forward")<cr>
inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<cr> 
imap <C-A> <C-X><C-O>

imap <S-CR>   <CR><CR>end<Esc>-cc
nnoremap <Tab> <Esc>:tabnext<CR>
nnoremap <S-Tab> <Esc>:tabprev<CR>

au bufnewfile,bufread  *.arc  set ft=arc


" ----------------------------------------------------------------------------
"  Mappings
" ----------------------------------------------------------------------------

" sane movement with wrap turned on
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

let g:fuzzy_ignore = "*.class,*.jar,*.zip,*.png,*.jpg,*.jpeg"
let g:fuzzy_matching_limit = 30
let g:fuzzy_ceiling = 500000
let g:fuzzy_roots = ['.', '/Users/am/w', '/Users/am/s']

map <leader>t :FuzzyFinderTextMate<CR>
map <leader>b :FuzzyFinderBuffer<CR>
map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>
map <leader>f :FuzzyFinderFile<CR>

syntax on             " Enable syntax highlighting
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

" ---------------------------------------------------------------------------
"  " File Types
"  "
"  ---------------------------------------------------------------------------
"   
au BufRead,BufNewFile *.rpdf       set ft=ruby
au BufRead,BufNewFile buildfile       set ft=ruby " buildr buildfile 
au Filetype html,xml,xsl source ~/.vim/scripts/closetag.vim