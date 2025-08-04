" Generic Settings
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set hlsearch
filetype plugin indent on
" colorscheme
colors desert256
" Trailing Whitespace
autocmd BufWritePre * :%s/\s\+$//e
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
" syntax Highlighting
syntax on
autocmd BufNewFile,BufRead *.bif set filetype=bif
au BufRead,BufNewFile top   set filetype=systemverilog
au BufRead,BufNewFile tb    set filetype=systemverilog
au BufRead,BufNewFile *.sv  set filetype=systemverilog
au BufRead,BufNewFile *.svh set filetype=systemverilog
au BufRead,BufNewFile *.v   set filetype=systemverilog
au BufRead,BufNewFile *.vh  set filetype=systemverilog
au BufRead,BufNewFile *.hex set filetype=sh
au BufRead,BufNewFile *.pas set filetype=delphi
au BufRead,BufNewFile *.f   set filetype=sh
au BufRead,BufNewFile *.vpp set filetype=vhdl
au BufRead,BufNewFile *.xdc set filetype=xdc
au BufRead,BufNewFile CMake*.* set filetype=cmake
au BufRead,BufNewFile Make*.* set filetype=make

" Copied all this stuff from lev

filetype on        " enable filetype detection
filetype plugin on " enable filetype-specific plugins


" Nygaard Stuff {{{

    set timeoutlen=250     " Set imap timeouts to 0.25 seconds
    let mapleader=","      " Set leader to comma (<leader> in mappings)
    let maplocalleader="," " Just like leader, except <localleader>
    let g:mapleader=","


    " Verilog movements {
    " Look at module
    " This hits handles modules with and without params
    " This is exec'd to discard and errors
    nnoremap { :exec 'normal 0[(0[(0'<cr>

    " Follow port into module
    nnoremap } m'[(F.l:let @/='\<<c-r>=expand("<cword>")<CR>\>'<CR>`':tag <c-r>=ModuleName()<cr><cr>nzz

    vnoremap <leader>r :!awk 'BEGIN{FS=OFS="="} match($2, /\ *([0-9]+) *: *([0-9]+) *\]/, a){len = a[1] - a[2]; gsub(/\[.*\]/, sprintf("[\%3d:\%3d]", x + len, x), $1); print $0; x += len + 1; next} 1{gsub(/\[.*\]/, sprintf("[\%7d]", x), $1); print $0; x++}'<cr><cr>

    " verilog module lookup
    " nmap <leader>m :exec 'normal ma0[(0[('<cr>^"ayiw`azz:echo "module:" @a<cr>
    nnoremap <leader>m :echo ModuleLine()<cr>
    nnoremap <leader>p :echo ShowPortDef()<cr>

    fun! ModuleLine()
        return substitute(getline(search('^\s*\w\+\(\_s*#\_s*\|\_s\+\w\+\_s*\)(', 'bWn')), '\s\+', ' ', 'g')
    endfun

    fun! ModuleName()
        return get(split(ModuleLine()), 0, '')
    endfun

    fun! ShowPortDef()
        if search('\.\w', 'bs', line('.')) == 0
            return ""
        endif

        call cursor(0, col('.')+1)
        let word = '\(\(in\|out\)put\|inout\).*' . '\<' .expand("<cword>") . '\>'
        call cursor(0, col("''"))

        let module = ModuleName()
        if !strlen(module)
            return "No module found"
        endif

        let tagdict = get(taglist(module), 0, '')
        if empty(tagdict)
            return "No tag for module '" . module . "' found"
        endif
        let fname = tagdict['filename']

        for line in readfile(fname, '', 500)
            if line =~ word
                return join(split(line)) . "\t(m:" . module . " f:" . fname . ")"
            endif
        endfor
        return "Can't find port '" . word . "' for module '" . module . "' in file '" . fname . "'"
    endfun

    " }
" iab <expr> dts strftime("%a, %b %d %l:%M:%S %p %Y")
" }}}

" vim:foldmethod=marker:foldlevel=0
