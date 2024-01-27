"https://github.com/christoomey/vim-tmux-navigator
"https://cscope.sourceforge.net/cscope_vim_tutorial.html
"syntax enable
"set background=dark
"colorscheme solarized
set autoindent
set number
set tabstop=4
hi Visual cterm=NONE    ctermbg=cyan  ctermfg=black
hi Search cterm=reverse ctermbg=black ctermfg=yellow

let mapleader = " "
map <leader>\ :noh<CR>
imap ;for for (i = 0; i < ; i++) {<CR><CR>}<UP><UP><right><right><right><right><right><right><right><right><right><right><right><right><right><right><right>
imap ;if if () {<CR><CR>}<UP><UP><right><right><right>
imap ;pr printf("\n");<left><left><left><left><left>
imap ;; <esc>

"Creates a new command, Silent, which takes in one argument (which replaces <q-args>). It then executes
"the argument as a bash command in the background, and redraws the screen afterwords
command! -nargs=1 Silent execute ':silent !'.<q-args> | execute ':redraw!'

"Creates a new command, WL (write LaTeX), which executes the shell script ~/tools/write_latex.sh
command WL execute ':silent !~/tools/write_latex.sh' | execute ':redraw!'
