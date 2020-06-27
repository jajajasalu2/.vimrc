" General {{{
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
set number
set foldmethod=marker
let mapleader = '-'
" }}}

" My own ;) {{{
execute 'set rtp+=/home/jaskaran/repos/vim-ocamlyacc-jump'
execute 'set rtp+=/home/jaskaran/repos/vim-word-count'

nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap de <esc>viwd
nnoremap ye <esc>viwy
noremap <silent> gb :bn<enter>
noremap <silent> gy :bp<enter>
noremap <silent> <c-n> :bd<cr>
nnoremap <c-a> gg^vG$
nnoremap <silent> <F4> :set relativenumber!<cr>
nnoremap <silent> <leader>pru :call VimOCamlYaccJump()<cr>
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

let g:wordcount_descending_order = 1
map <leader>gc <Plug>CountWords
" }}}

" LKMP functions & mappings {{{
let g:linux_directory = "~/linux/"

function! Lkmp_goto_file_loc_cfile(append_dir)
	let par_buf = bufnr('%')
	execute 'normal! ^f/lllvf "ay'
	if a:append_dir == 1
		execute 'n '.g:linux_directory.@a
	else
		execute 'n '.@a
	endif
	let cur_buf = bufnr('%')
	execute 'b '.par_buf
	execute 'normal! ^f/f*f*hhviw"ay'
	execute 'b '.cur_buf
	execute 'normal! '.@a.'G'
endfunction

function! Lkmp_get_line_for_failures(ipstring)
	let res_file = "~/lkmp/test-suite/functionpointers"
	let par_buf = bufnr('%')
	execute 'normal! j'
	call Lkmp_goto_file_loc_cfile(1)
	execute 'normal! V"ly'
	execute 'silent! bd'
	execute 'silent! n '.res_file
	execute 'normal! Go'.@l
	execute 'silent! w'
	execute 'silent! bd'
	execute 'silent! b '.par_buf
	return a:ipstring
endfunction

function! Lkmp_goto_rule_in_cocci_file()
	execute 'normal! ^f lviw"ay^mz'
	execute 'silent! ?--sp-file'
	execute 'normal! $hhgfgg'
	execute 'silent! /r'.@a
endfunction

function! Lkmp_add_symbol_in_rule_from_warning()
	let par_buf = bufnr('%')
	execute 'normal! ^2f:hviw"ly'
	execute 'normal! ^4f lviw"sy'
	execute 'silent! ?--sp-file'
	execute 'normal! $hhvF l"cy'
	execute 'silent! n '.@c
	execute 'normal! '.@l.'G'
	execute 'silent! ?@ r'
	execute 'normal! j$i,'.@s
	execute 'silent! w'
	execute 'silent! bd'
	execute 'silent! b '.par_buf
endfunction

function! Lkmp_get_failures_into_doc(ipstring)
	let op_file = "~/lkmp/c-files/linux-failures-5"
	let par_buf = bufnr('%')
	execute 'normal! ^f lviw"ay^mz'
	execute 'silent! ?--sp-file'
	execute 'normal! $hhvF l"cy'
	execute 'normal! j^vf h"dy'

	execute 'silent! n '.@c
	execute 'normal! gg'
	execute 'silent! /r'.@a
	execute 'silent! /@@'
	execute 'normal! j'
	execute 'normal! V"by'

        execute 'silent! /@@'
	execute 'normal! jjjj'
	execute 'normal! 2f[llviw"ly'

	execute 'silent! bd'
	execute 'silent! n '.@d
	execute 'normal! '@l.'G'
	execute 'normal! ^f/v2f*l"fy'

	execute 'silent! bd'
	execute 'silent! n '.op_file
	execute 'normal! Go'.@b.' '.@f.' '.@c.' '.@d.':'.@l
	execute 'silent! w'
	execute 'silent! b '.par_buf
        execute "normal! 'z"
	return a:ipstring
endfunction

function! Lkmp_get_files_for_cmd()
	let par_buf = bufnr('%')
	let cmd_file = "~/lkmp/test-suite/linux-cmd"
	execute 'normal! $viw"ny'
	execute 'silent! n! '.cmd_file
	execute 'normal! gg'
	execute 'silent! /NUM='.@n
	execute 'normal! ^f lvf "fy'
	execute 'silent! bd'
	execute 'silent! b '.par_buf
	execute 'normal! gg'
	execute 'silent! /NUM='.@n
	execute 'normal! ^f "fp'
	execute 'silent! w'
endfunction

"function! Lkmp_goto_parser_rule()
	"execute 'normal! m`viw"ry'
	"execute 'silent! /^\(%inline \)\{0,1}'.@r.'\((.*)\)\{0,1}:'
"endfunction

function! Lkmp_show_test_cocci()
	execute 'normal! $F.hviw"ty'
	execute 'silent! n! ./tests/'.@t.'.cocci'
endfunction

function! Lkmp_exec_parse_c()
	execute 'normal! V"uy'
	execute '!./spatch --parse-c '.@u
endfunction

function! Lkmp_exec_parse_cocci()
	execute 'normal! V"uy'
	execute '!./spatch --parse-cocci '.@u
endfunction

nnoremap <silent> <leader>gal :call Lkmp_goto_file_loc_cfile(1)<cr>
nnoremap <silent> <leader>gol :call Lkmp_goto_file_loc_cfile(0)<cr>
nnoremap <silent> <leader>gor :call Lkmp_goto_rule_in_cocci_file()<cr>
nnoremap <silent> <leader>gow :call Lkmp_add_symbol_in_rule_from_warning()<cr>
nnoremap <silent> <leader>goad :call Lkmp_get_failures_into_doc()<cr>
nnoremap <silent> <leader>grt :call Lkmp_show_test_cocci()<cr>
nnoremap <silent> <leader>gtr :call Lkmp_exec_parse_c()<cr>
nnoremap <silent> <leader>gtc :call Lkmp_exec_parse_cocci()<cr>
" }}}

" Grep word mask {{{
function! Grep_word_mask(visual)
	let g:grepper.prompt = 0
	if a:visual
		normal! gv
		normal! y
	else
		normal! viwy
	endif
	execute 'Grepper -tool rg -query "\b'.@0.'\b"'
	let g:grepper.prompt = 1
endfunction

nnoremap <silent> <leader>grp :call Grep_word_mask(0)<cr>
vnoremap <silent> <leader>grp :call Grep_word_mask(1)<cr>
" }}}

" asyncrun config {{{
noremap <silent> <F7> :AsyncRun make<cr>
" }}}

" merlin config {{{
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute 'set rtp+=' . g:opamshare . '/merlin/vim'
execute 'helptags ' . g:opamshare . '/merlin/vim/doc'
" }}}

" vim-markbar config {{{
let g:markbar_enable_peekaboo = v:false

nmap <Leader>m <Plug>ToggleMarkbar
" }}}

" vim-header config {{{
let g:header_auto_add_header = 0
let g:header_field_author = 'Jaskaran Singh'
let g:header_field_author_email = 'jaskaransingh7654231@gmail.com'
" }}}

" vim-airline config {{{
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'minimalist'
" }}}

" vim-illuminate config {{{
hi link illuminatedWord Visual
let g:Illuminate_delay = 1000
" }}}

" Plugins {{{
call plug#begin('~/.local/share/nvim/plugged')

Plug 'scrooloose/nerdcommenter'

Plug 'scrooloose/nerdtree'

Plug 'tpope/vim-fugitive'

Plug 'romainl/vim-cool'

Plug 'psliwka/vim-smoothie'

Plug 'python-mode/python-mode'

Plug 'jajajasalu2/cocci-syntax', {'branch': 'syntax'}

Plug 'vimlab/split-term.vim'

Plug 'simeji/winresizer'

Plug 'google/vim-searchindex'

Plug 'RRethy/vim-illuminate'

Plug 'skywind3000/asyncrun.vim'

Plug 'skywind3000/asynctasks.vim'

Plug 'plasticboy/vim-markdown'

Plug 'ntpeters/vim-better-whitespace'

Plug 'mhinz/vim-grepper'

Plug 'Yilin-Yang/vim-markbar'

Plug 'reasonml-editor/vim-reason-plus'

Plug 'alpertuna/vim-header'

Plug 'ctrlpvim/ctrlp.vim'

Plug 'vim-airline/vim-airline'

Plug 'vim-airline/vim-airline-themes'

call plug#end()
" }}}
