call plug#begin()

function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

 Plug 'tpope/vim-sexp-mappings-for-regular-people'
 Plug 'guns/vim-sexp'
"Plug 'tpope/vim-repeat' " TODO fix the error this triggers on undo
 Plug 'tpope/vim-surround'

 " search file navigation (fuzzy find)
 Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
 Plug 'junegunn/fzf.vim'

 " session management; i.e. open up to the same files when you start vim
 Plug 'xolox/vim-misc'
 Plug 'xolox/vim-session'

 " used for goto definition
 " conflicts with CoC -- system uses tons of memory and becomes unresponsive when both are enabled
 "Plug 'ludovicchabant/vim-gutentags'

 " hierarchical file navigation
 Plug 'scrooloose/nerdtree'

 " shows you what lines in the current file have been added/modified/deleted
 Plug 'airblade/vim-gitgutter'

 " handy git commands like Gread and Gblame
 " example: see version of current file on master with `:Gread master:%`
 Plug 'tpope/vim-fugitive'
 " enable the :GBrowse fugitive command
 Plug 'tpope/vim-rhubarb'

 Plug 'junegunn/gv.vim'

 " handy way to see a list of your open files
 " nice for when you have a lot of open files
 "Plug 'jlanzarotta/bufexplorer'

 " tweak: makes closing files better
 "Plug 'rbgrouleff/bclose.vim'

 " make parentheses have matching colors
 Plug 'luochen1990/rainbow'

 Plug 'Olical/conjure' ", {'tag': 'v4.18.0'}
 "Plug 'joukevandermaas/vim-ember-hbs'
 "Plug 'github/copilot.vim'

 Plug 'neoclide/coc.nvim', {'branch': 'release'}

 "Plug 'autozimu/LanguageClient-neovim', {
 "    \ 'branch': 'next',
 "    \ 'do': 'bash install.sh',
 "    \ }

 "Plug 'MattesGroeger/vim-bookmarks'
 "
 "Plug 'psf/black', { 'branch': 'stable' }

Plug 'img-paste-devs/img-paste.vim'

Plug 'junegunn/vim-easy-align'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()



"======PLUGIN CONFIG=====

" vim-sexp -- even the mapping from vim-sexp-mappings-for-regular-people need some improvement imo
nmap <M-k> <Plug>(sexp_emit_head_element)
nmap <M-j> <Plug>(sexp_capture_prev_element)
nmap H <Plug>(sexp_emit_tail_element)
nmap L <Plug>(sexp_capture_next_element)

let mapleader=","
let maplocalleader="\<space>"

" FZF
let $FZF_DEFAULT_COMMAND = 'ag -l --nocolor --hidden --ignore=node_modules --ignore=.clj-kondo --ignore=.shadow-cljs --ignore=target --ignore=__pycache__ -U -g ""'
function! FzfTagsCurrentWord()
  let l:word = expand('<cword>')
  let l:list = taglist(l:word)
  if len(l:list) == 1
    execute ':tag ' . l:word
  else
    call fzf#vim#tags(l:word)
  endif
endfunction
noremap <c-]> :call FzfTagsCurrentWord()<cr>
map <c-p> :Files<cr>
map \ :BLines<cr>

" vim-session
let g:session_autosave = 'yes'
let g:session_autosave_periodic = 1
let g:session_autosave_silent = 1

let g:session_default_to_last = 1
"let g:session_autoload = 'yes'
cnoreabbrev SS SaveSession
cnoreabbrev OS OpenSession

set sessionoptions=curdir,folds,help,tabpages,winsize

" gutentags
" use <C-]> for go to definition
"let g:gutentags_trace = 1
set tags=./.tags,.tags;
"let g:gutentags_enabled = 1
let g:gutentags_ctags_tagfile = '.tags'
let g:gutentags_file_list_command = {
      \ 'markers': {
      \ '.git': 'git-ls-files',
      \ },
      \ }
let g:gutentags_generate_on_new = 1
let g:gutentags_define_advanced_commands = 1

" nerdtree
let g:NERDTreeWinSize=55
let g:NERDTreeDirArrows=0
map <leader>f :NERDTreeFind<cr>
map <m-o> :NERDTreeToggle<cr>

" gitgutter
let g:gitgutter_map_keys = 0
set updatetime=250

" bufexplorer
let g:bufExplorerFindActive=0

" bclose
"map <leader>d :Bclose<cr>

"" rainbow parentheses
"let g:rainbow_active = 1
let g:rainbow_conf = {
    \    'guifgs': ['cyan', 'orange', 'seagreen3', 'red'],
    \    'ctermfgs': ['white', 'red', 'green', 'blue', 'yellow'],
    \    'operators': '_,_',
    \    'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
    \    'separately': {
    \        '*': {},
    \        'tex': {
    \            'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
    \        },
    \        'lisp': {
    \            'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
    \        },
    \        'vim': {
    \            'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
    \        },
    \        'html': {
    \            'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
    \        },
    \        'css': 0,
    \    }
    \}

" conjure / clojure
map <leader>CB :ConjureConnect 7888<cr><cr>
map <leader>R :ConjureEval ((requiring-resolve 'development/restart))<cr>
map <leader>CC :ConjureEval ((requiring-resolve 'com.tybaenergy.lib.expose-api/generate-stub-vars!))<cr>
map <leader>S :ConjureShadowSelect main<cr>
map <leader>P :ConjureEval (user.local/start-portal)<cr>

" img paste
autocmd FileType markdown nmap <buffer><silent> <leader>p :call mdip#MarkdownClipboardImage()<CR>
" there are some defaults for image directory and image name, you can change them
let g:mdip_imgdir_absolute = '/home/jacob/dev/com.biffweb/resources/public/images'
let g:mdip_imgdir_intext = '/images'
" let g:mdip_imgname = 'image'

"======END PLUGIN CONFIG=====

" Clojure
let g:clojure_maxlines = 500
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let', '^go', '-join$', 'submit-tx$', 'list-when$', '^do$', '^comment$', 'cond$',
\ '^try$', '^finally$', '^future$',
\ '^div$', '^span$', '^button$', '^table$', '^thead$', '^tbody$', '^tr$',
\ '^th$', '^td$', '^label$', '^h1$', '^h2$', '^h3$', '^h4$', '^h5$', '^h6$',
\ '^svg$', '^path$', '^p$', '^input$', '^form$', '^i$', '^a$', '^em$',
\ '^strong$', '^hr$', '^ul$', '^ol$', '^li$', '^textarea$', '^set-state!$',
\ '^specification$', '^component$', '^for-all$', '^ui-.*$']
let g:clojure_align_subforms = 1
let g:clojure_special_indent_words =
   \ 'deftype,defrecord,reify,proxy,extend-type,extend-protocol,letfn,defmutation'
let g:clojure_align_multiline_strings = 1

set conceallevel=0
set guicursor=
set list
set laststatus=1
set expandtab
set tabstop=2       " hard tabs
set shiftwidth=2    " soft tabs
set softtabstop=2   " soft tabs when backspacing, etc
set scrolloff=8
set hidden
set number
set nojoinspaces
set ignorecase
set smartcase
set spellcapcheck=false
set nowrap
set nostartofline
set autoindent
set nofixendofline
set exrc
set textwidth=100
set wildmode=longest,list

nnoremap    s           :set invspell<cr>
noremap ; :
map <c-l> gt
map <c-h> gT
map j gj
map k gk
imap <c-c> <esc>
map <leader>h :nohlsearch<cr>
" get the highlight name of the text under the cursor
map <F12> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
map <C-W>t :tab split<cr>
noremap <f9> :syntax sync fromstart<cr>
map <leader>s :s/\(^\\|$\)/"/g<cr>:nohlsearch<cr>
nnoremap cp :let @" = expand("%")<cr>
map <leader>c :tabc<cr>

" Navigation
" jump to symbol from nav file
"nnoremap <leader>j :tab split<cr>0yE$gfgg/<C-r>"<cr>:nohlsearch<cr>
"" yank current symbol into nav file
"nnoremap <leader>y yiw<c-w>v:e nav.txt<cr>Go<esc>pa <esc><c-w><c-w>:let @" = expand("%")<cr><c-w><c-w>p:w<cr>
"" Open nav file
"nnoremap <leader>n <c-w>v:e nav.txt<cr>
"nnoremap <leader>m yiw:BookmarkToggle<cr>:BookmarkAnnotate <c-r>"<cr>
"nnoremap <leader>M <cr>:BookmarkToggle<cr>Y<cr><cr>
"let g:bookmark_no_default_key_mappings = 1
"let g:bookmark_auto_close = 1
"nmap mm <Plug>BookmarkShowAll

filetype plugin on
"filetype plugin indent on
syntax on

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  " TODO only search files tracked by git
  "set grepprg=ag\ --nogroup\ --nocolor
  set grepprg=rg\ --vimgrep
endif
nnoremap <Leader>* :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

autocmd BufNewFile,BufRead *.bb set ft=clojure
autocmd BufNewFile,BufRead *.bb set ft=clojure

autocmd VimEnter * set indentexpr=<cr>

" `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
"autocmd FileChangedShellPost * echohl WarningMsg | echo \"File changed on disk. Buffer reloaded. \" . exapnd(\"%\") | echohl None


" let g:black_quiet = 1
" let g:black_target_version = "py310"
" let g:black_linelength = 120
" let g:black_preview = 1
autocmd FileType html setlocal indentkeys=

" TODO
"autocmd BufWritePre *.py Black
"let g:zprint#options_map = '{:search-config? true}'

"map <leader>b :!cd deep-dispatch; black-fmt<cr>
"map <leader>z :!cd tyba; zprint-fmt<cr>

set clipboard+=unnamedplus
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * if v:event.operator ==# 'y' | call system(s:clip, @0) | endif
    augroup END
endif

"autocmd VimEnter * Copilot disable
"nnoremap <localleader>pe :Copilot enable<cr>
"nnoremap <localleader>pd :Copilot disable<cr>

"let g:LanguageClient_serverCommands = {
"    \ 'clojure': ['/usr/local/bin/clojure-lsp'],
"    \ }
"nmap <F5> <Plug>(lcn-menu)
"
let g:ftplugin_sql_omni_key = '<C-j>'

"let g:python3_host_prog = '/home/jacob/dev/py-nvim-env/bin/python'
"TODO
let g:python3_host_prog = '/home/jacob/.pyenv/shims/python'

nnoremap <LeftMouse> ma<LeftMouse>`a

" THEME
set termguicolors
syntax enable

" Light
color peachpuff
hi MatchParen guifg=white
hi Todo gui=bold guibg=None guifg=darkorange
hi CocInlayHint guifg=darkorange

" Dark
"color desert
"hi default link BufTabLineCurrent WildMenu
"hi Search cterm=NONE ctermfg=white ctermbg=darkblue
"hi VertSplit cterm=NONE ctermfg=white ctermbg=NONE
"hi NormalFloat ctermbg=234 ctermfg=NONE guibg=NONE guifg=NONE
"hi Statement gui=NONE
"hi diffAdded guifg=#34d399
"hi diffRemoved guifg=#f87171
"hi StatusLineNC guifg=#444444
"hi ColorColumn guibg=#3f3f3f
"hi Todo gui=bold guibg=None guifg=Yellow

set colorcolumn=101


nnoremap <silent> <C-]> <leader>gd
" COC
nmap <silent> gd <Plug>(coc-definition)
nmap gr <Plug>(coc-references)
inoremap <silent><expr> <c-space> coc#refresh()
map <leader>t :CocList -I symbols<cr>
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
nmap <leader>d :call CocAction("diagnosticToggle")<cr>

function! Expand(exp) abort
    let l:result = expand(a:exp)
    return l:result ==# '' ? '' : "file://" . l:result
endfunction

nnoremap <silent> crcn :call CocRequest('clojure-lsp', 'workspace/executeCommand', {'command': 'clean-ns', 'arguments': [Expand('%:p'), line('.') - 1, col('.') - 1]})<CR>

hi CocMenuSel guibg=#666666 guifg=white



"let g:conjure#client#python#stdio#command = 'poetry -C /home/jacob/work/deep-dispatch run python'

