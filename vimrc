if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'elixir-lang/vim-elixir'
" Plug 'fatih/vim-go'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'powerline/fonts'
Plug 'avakhov/vim-yaml'
Plug 'flazz/vim-colorschemes'
Plug 'scrooloose/syntastic'
Plug 'hashivim/vim-terraform'
Plug 'lifepillar/pgsql.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'slashmili/alchemist.vim'
Plug 'mhinz/vim-mix-format'

call plug#end()

" runtime ~/.vim/bundle/vim-pathogen/autoload/pathogen.vim

" execute pathogen#infect()
syntax on
filetype plugin indent on

runtime! plugin/sensible.vim
set encoding=utf-8

"colorscheme wombat
syntax enable
set background=dark
" colorscheme solarized
colorscheme gruvbox
" colorschem molokai
set t_Co=256
" let g:solarized_termcolors=256

"""" vim-airline config

"sets the powerline to show up
set laststatus=2
"sets to display all buffers when there is only 1 tab open
let g:airline#extensions#tabline#enabled=1

let g:airline_powerline_fonts = 1

let g:airline_theme='molokai'

"don't need the default mode indicator
set noshowmode

"set up for powerline symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

function! AirlineInit()
	let g:airline_section_a = airline#section#create(['mode',' ', 'branch'])
	let g:airline_section_b = airline#section#create_left(['hunks', '%f'])
	let g:airline_section_c = airline#section#create(['filetype'])
	let g:airline_section_x = airline#section#create(['%P'])
	let g:airline_section_y = airline#section#create(['%B'])
	let g:airline_section_x = airline#section#create_right(['%l','%c'])
endfunction

autocmd VimEnter * call AirlineInit()

""""

"""" git-gutter config

"I don't really want this on all the time, but I like it in the airline
"let g:gitgutter_enabled = 0

""""

"""" vim-go config

map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
	let l:file = expand('%')
	if l:file =~# '^\f\+_test\.go$'
		call go#cmd#Test(0, 1)
	elseif l:file =~# '^\f\+\.go$'
		call go#cmd#Build(0)
	endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>

""" run go import not go fmt
let g:go_fmt_command = "goimports"

""""

"""terraform
let g:terraform_align=1
"""

"""pgsql
let g:sql_type_default = 'pgsql'
"""

"""NERDcommenter
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Remove trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

"""vim-mix-formatter
"Will turn on auto formatting
" let g:mix_format_on_save = 1

"""
