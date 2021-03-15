" General {{{
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
set number
set foldmethod=marker
let mapleader = '-'
" }}}

" My own ;) {{{
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap de <esc>viwd
nnoremap ye <esc>viwy
noremap <silent> gb :bn<enter>
noremap <silent> gy :bp<enter>
noremap <silent> <c-n> :bd<cr>
nnoremap <c-a> gg^vG$
nnoremap <silent> <F4> :set relativenumber!<cr>
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>
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
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdcommenter'

Plug 'scrooloose/nerdtree'

Plug 'tpope/vim-fugitive'

Plug 'romainl/vim-cool'

Plug 'psliwka/vim-smoothie'

Plug 'google/vim-searchindex'

Plug 'RRethy/vim-illuminate'

Plug 'vim-airline/vim-airline'

Plug 'vim-airline/vim-airline-themes'

call plug#end()
" }}}
