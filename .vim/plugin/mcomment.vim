" Plugin for reasonably nicely formatted commenting, based on
" filetype and comment strings

if exists("loaded_MComment")
    finish
endif
let loaded_MComment = 1

let s:save_cpo = &cpo
set cpo&vim

let s:commentStrings = [
\   [ "c", "/*", "*/"],
\   [ "cpp", "//", ""],
\   [ "conf", "#", ""],
\   [ "go", "//", ""],
\   [ "haml", "-#", ""],
\   ]

function! s:getCommentStrings()
    for l in s:commentStrings 
        if &ft == l[0]
            return l[1: 2]
        endif
    endfor
    let str1 = matchstr(&commentstring, '^.*\ze%s')
    let str2 = matchstr(&commentstring, '%s\zs.*$')
    return [str1, str2]
endfunction

"Positions of comments are signficant in haml
function! s:commentAfterSpace()
    return &ft == "haml"
endfunction

function! s:escapeString(str)
    return escape(a:str, '\*')
endfunction

function! s:virtlen(lineno)
    call cursor(a:lineno, 0)
    return virtcol("$")
endfunction

function! MCommentOneLine(lineno, startstr, endstr, len)
    let line = getline(a:lineno)
    let padding = ""
    if a:endstr != ""
        let topad = a:len - s:virtlen(a:lineno)
        for i in range(topad)
            let padding = padding . " "
        endfor
    endif
    let prefix = ""
    if s:commentAfterSpace()
        let m = matchlist(line, '\(\s*\)\(.*\)')
        let prefix = m[1]
        let line = m[2]
    endif
    let newline = prefix . a:startstr . line . padding . a:endstr
    call setline(a:lineno, newline)
endfunction

function! s:getStartCommentPos(line, startstr)
    let pos = match(a:line, '^\s*\zs' . s:escapeString(a:startstr))
    return pos
endfunction

function! s:getEndCommentPos(line, endstr)
    let pos = match(a:line, s:escapeString(a:endstr) . '\ze\s*$')
    return pos
endfunction

function! MUncommentOneLine(lineno, startstr, endstr)
    let line = getline(a:lineno)
    let pos = s:getStartCommentPos(line, a:startstr)
    if pos >= 0
        let newline = substitute(line, s:escapeString(a:startstr), "", "")
        "This also strips trailing whitespace 
        let newline = substitute(newline, 
            \ '\s*' .  s:escapeString(a:endstr) . '\s*$', "", "")
        call setline(a:lineno, newline)
    endif
endfunction


function! MCommentRange() range
    let uncomment = 1
    let lineLen = 0
    let commentStrings = s:getCommentStrings()
    if commentStrings == []
        echo "No known comments for this filetype"
        return
    endif
    let startstr = commentStrings[0]
    let endstr = commentStrings[1]
    for lineno in range(a:firstline, a:lastline)
        let line = getline(lineno)
        let lineLen = max([lineLen, s:virtlen(lineno)])
        let pos = s:getStartCommentPos(line, startstr)
        let endpos = s:getEndCommentPos(line, endstr)
        if pos < 0 || (endstr != "" && endpos < 0)
            let uncomment = 0
        endif
    endfor
    let oldexpandtab = &expandtab
    for lineno in range(a:firstline, a:lastline)
        call cursor(lineno)
        set expandtab
        retab!
        if uncomment == 1
            call MUncommentOneLine(lineno, startstr, endstr)
        else
            call MCommentOneLine(lineno, startstr, endstr, lineLen)
        endif
        let &expandtab=oldexpandtab
        retab!
    endfor
    let nlines = a:lastline - a:firstline + 1
    let comstr = "commented."
    if uncomment == 1
        let comstr = "uncommented."
    endif
    echo nlines . " line(s) " . comstr
endfunction

function! MCommentOperator(type)
        exe "'[,']call MCommentRange()"
endfunction
        
nmap <silent> <Plug>MCommentToggleN :call MCommentRange()<CR>
nmap <silent> <Plug>MCommentToggleOp :set opfunc=MCommentOperator<CR>g@
vmap <silent> <Plug>MCommentToggleV :call MCommentRange()<CR>gv

nmap <silent> <M-c><M-c> <Plug>MCommentToggleN
nmap <silent> <C-c><C-c> <Plug>MCommentToggleN
nmap <silent> <M-c> <Plug>MCommentToggleOp
nmap <silent> <C-c> <Plug>MCommentToggleOp
vmap <silent> <M-c> <Plug>MCommentToggleV

let &cpo = s:save_cpo
