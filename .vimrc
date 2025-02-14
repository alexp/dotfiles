set encoding=utf-8
call pathogen#infect()
call pathogen#helptags()
syntax enable
"nnoremap ,m :w <BAR> !lessc % > %:t:r.css<CR><space>
"
"
"
filetype plugin indent on
set autoindent
set tabstop=2
set shiftwidth=2
set softtabstop=0
set expandtab
set smarttab
set nowrap
set showmatch
set ignorecase
set hlsearch
set cursorline
set smartcase
set ruler
" set list listchars=tab:»·,trail:·
set nofoldenable
set backspace=2
" set clipboard=unnamed
set wildmenu
set wildmode=list:longest,full
set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [%l,%c]\ [%L,%p%%]
" set paste
set laststatus=2
set number
set relativenumber
let g:Powerline_symbols = 'fancy'
let g:NERDSpaceDelims = 1

" ~/.vimrc
" colorscheme base16-railscasts
" colorscheme dracula
" colorscheme solarized
" set background=dark
" set background=light
"
"set termguicolors
" colorscheme base16-default-dark

" let base16colorspace=256

" if filereadable(expand("~/.vimrc_background"))
"   let base16colorspace=256
"   source ~/.vimrc_background
" endif

" highlight clear SignColumn
" highlight VertSplit    ctermbg=236
" highlight ColorColumn  ctermbg=237
" highlight LineNr       ctermbg=236 ctermfg=240
" highlight CursorLineNr ctermbg=236 ctermfg=240
" highlight CursorLine   ctermbg=236
" highlight StatusLineNC ctermbg=238 ctermfg=0
" highlight StatusLine   ctermbg=240 ctermfg=12
" highlight IncSearch    ctermbg=3   ctermfg=1
" highlight Search       ctermbg=1   ctermfg=3
" highlight Visual       ctermbg=3   ctermfg=0
" highlight Pmenu        ctermbg=240 ctermfg=12
" highlight PmenuSel     ctermbg=3   ctermfg=1
" highlight SpellBad     ctermbg=0   ctermfg=1

let mapleader = ","

set runtimepath^=~/.vim/bundle/ctrlp.vim
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|tmp|\.|node_modules|webpack)$',
  \ 'file':  '\v[\/]\.(.gitignore)$',
  \ }
let g:ctrlp_lazy_update = 1

map <leader>. :CtrlPTag<cr>
map <leader>f :CtrlP<cr>
nnoremap <leader>to i<C-R>=strftime("[%Y-%m-%d %H:%M] ---")<CR><Esc>

" highlight the status bar when in insert mode
" if version >= 700
  " au InsertEnter * hi StatusLine ctermfg=235 ctermbg=2
  " au InsertLeave * hi StatusLine ctermbg=240 ctermfg=12
" endif

" highlight trailing spaces in annoying red
highlight ExtraWhitespace ctermbg=1 guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" nnoremap Q <nop>

" map git commands
map <leader>b :Gblame<cr>
map <leader>l :!clear && git log -p %<cr>
map <leader>d :!clear && git diff %<cr>

" hint to keep lines short
" if exists('+colorcolumn')
"   set colorcolumn=90
" end

" add :Plain command for converting text to plaintext
" command! Plain execute "%s/’/'/ge | %s/[“”]/\"/ge | %s/—/-/ge"

" clear the command line and search highlighting
noremap <C-c> :nohlsearch<CR>

function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  :silent !clear
  exec ":!bundle exec rspec --color " . a:filename
endfunction

function! GoToFile()
  let l:line = getline('.')
  let l:col = col('.')
  let l:start = match(l:line, '\v\%'.l:col.'c\S*')
  let l:end = matchend(l:line, '\v\%'.l:col.'c\S*')
  let l:file = substitute(strpart(l:line, l:start, l:end - l:start), "'", '', 'g')
  execute 'edit' l:file
endfunction

nnoremap <leader>gf :call GoToFile()<CR>

function! SetTestFile()
  " set the spec file that tests will be run for.
  let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " run the tests for the previously-marked file.
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile(":" . spec_line_number . " -b")
endfunction

" run test runner
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>

nnoremap <leader>xp O require 'pry'; binding.pry<ESC>^V=

" Enable vim-lsp
if executable('solargraph')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'solargraph',
        \ 'cmd': {server_info->['solargraph', 'stdio']},
        \ 'whitelist': ['ruby'],
        \ })
endif

if executable('pylsp')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'whitelist': ['python'],
        \ })
endif
