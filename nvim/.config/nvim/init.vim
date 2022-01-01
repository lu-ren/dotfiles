call plug#begin('~/.local/share/nvim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-surround'
Plug 'leafgarland/typescript-vim'
Plug 'tpope/vim-commentary'
Plug 'morhetz/gruvbox'
Plug 'airblade/vim-gitgutter'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'mattn/emmet-vim'
Plug 'preservim/nerdtree'
Plug 'kchmck/vim-coffee-script'
Plug 'jparise/vim-graphql'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
call plug#end()

:set number
:set guioptions=c
:set noincsearch "Cursor does not jump at search highlighting
let g:vim_json_conceal=0 "Disable quote concealing in JSON files
let g:python3_host_prog='/usr/bin/python3'
let g:loaded_matchparen=1
"vim-javascript plugin enable highlighting for html/css
let g:javascript_enable_domhtmlcss=1
"activate rainbow parenthesis
let g:rainbow_active=1
:set mouse=n

set tabstop=2       " The width of a TAB is set to 4.
		   " Still it is a \t. It is just that
		   " Vim will interpret it to be having
		   " a width of 4.
set shiftwidth=2    " Indents will have a width of 4
set softtabstop=2   " Sets the number of columns for a TAB
set expandtab       " Expands tabs to spaces

set termguicolors

let g:neoterm_position='vertical'

"ctags setup
set tags=tags;

"NERDTree
map <C-n> :NERDTreeToggle<CR>
silent! map <F3> :NERDTreeFind<CR>
let g:NERDTreeMapActivateNode="<F3>"
let g:NERDTreeMapPreview="<F4>"

:set ic "Case insensitive

"Tagbar
nmap <F8> :TagbarToggle<CR>

"highlight disable
map <C-h> :nohlsearch<CR>

"ctrlp to fzf
map <C-p>f :FZF<CR>
map <C-p>b :Buffer<CR>

" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

"Disable line number in term
au TermOpen * setlocal nonumber norelativenumber

"Git-gutter settings
set updatetime=100

"Airline settings
set laststatus=2
"Vim colorschemes
set background=dark
colo gruvbox

lua << EOF
require'lspconfig'.pyright.setup{}
EOF
lua require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}
