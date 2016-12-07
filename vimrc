runtime bundle/vim-pathogen/autoload/pathogen.vim

execute pathogen#infect()
syntax on
filetype plugin indent on

runtime! plugin/sensible.vim
set encoding=utf-8

"colorscheme wombat
syntax enable
set background=dark
colorscheme solarized
let g:solarized_termcolors=256

"""" vim-airline config

"sets the powerline to show up
set laststatus=2
"sets to display all buffers when there is only 1 tab open
let g:airline#extensions#tabline#enabled=1

let g:airline_powerline_fonts = 1

let g:airline_theme='solarized'

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

set t_Co=256
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
