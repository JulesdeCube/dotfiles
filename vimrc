syntax on
set encoding=utf-8

let skip_defaults_vim=1
set viminfo=""

noremap ; l
noremap l k
noremap k j
noremap j h
noremap <C-w>j <C-w>h
noremap <C-w>k <C-w>j
noremap <C-w>l <C-w>k
norema <C-w>; <C-w>l

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2

set colorcolumn=80
set textwidth=80

set number

highlight Tabs ctermbg=red guibg=red
if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif

colorscheme onedark
let g:onedark_hide_endofbuffer=1
let g:onedark_terminal_italics=1


highlight EndSpaces ctermbg=173 guibg=#D89B69
match EndSpaces /\s\+$/

highlight Tabs ctermbg=196 guibg=#CB7558
match Tabs /\t/

autocmd BufWinEnter * call Hightlight()
autocmd InsertEnter * call Hightlight()
autocmd InsertLeave * call Hightlight()
autocmd BufWinLeave * call clearmatches()

function Hightlight() 
  syntax match EndSpaces /\s\+$/
  syntax match Tabs /\t/
endfunction
autocmd FileType make setlocal noexpandtab
