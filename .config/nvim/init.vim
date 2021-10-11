call plug#begin() " Begin Vim Plug plugins

" Language support, syntax highlighting, etc
Plug 'neoclide/coc.nvim', {'branch': 'release'} " COC - Completion for code
Plug 'digitaltoad/vim-pug' " Vim Pug - HTML5 syntax plugin
Plug 'mattn/emmet-vim' " Emmet Vim - Emmet for vim
Plug 'PotatoesMaster/i3-vim-syntax'   "I3 Vim Syntax I3 config syntax highlighting
Plug 'neovimhaskell/haskell-vim' " Haskell-Vim - Haskell stuff 
"Utilities
Plug 'scrooloose/nerdtree' " Nerdtree - A file manager for vim
Plug 'ap/vim-css-color' " Vim CSS Color - Coloring for color codes 
"Theming 
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline' " Vim Airline - Statusline for vim
Plug 'ryanoasis/vim-devicons'
Plug 'liuchengxu/vim-which-key'

call plug#end() " End Vim Plug plugins


let g:python_host_prog = '/usr/bin/python' " Python binary
let g:python3_host_prog = '/usr/bin/python3' " Python3 binary
set noswapfile " Get rid of swapfile 
syntax enable " Enable syntax highlighting
set number " Enable line numbers 
set termguicolors " Enable termguicolors
colorscheme onedark
set t_Co=256 " Enable 256 Color 

"Mappings for navigating splits
nnoremap <C-h> <C-w>h 
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
"Spellcheck - control with keybindings
noremap \sd :set nospell<CR>
noremap \se :set spell spelllang=en_us<CR>
noremap \n :NERDTreeToggle<CR>
noremap \cv :edit ~/.config/nvim/init.vim<CR>
noremap \cd :edit ~/dwm/config.h<CR>
noremap \cc :edit ~/.config/nvim/coc-settings.json<CR>
map <A-x> :
"Mappings for resizing splits
noremap <silent> <C-Right> :vertical resize +3<CR>
noremap <silent> <C-Left> :vertical resize -3<CR>
noremap <silent> <C-Down> :resize +3<CR>
noremap <silent> <C-Up> :resize -3<CR>
	

