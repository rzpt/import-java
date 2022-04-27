if exists("b:loaded_import_java")
    finish
endif
let b:loaded_import_java = 1

let s:save_cpo = &cpo
set cpo-=C

let b:root = trim(system("git rev-parse --show-toplevel"))

function! ImportJavaAdd(class)
    let l:spot = search("^import ", "n")
    if l:spot == 0
        let l:spot = search("^package ", "n")
    endif
    call append(l:spot, "import " . a:class . ";")
endfunction

function! s:getCandidatesCmd(word)
    return "sed -n '/^" . a:word . " /s/^" . a:word . " //p' " . b:root . "/.raw.import"
endfunction

function! ImportJavaPick(word)
    call fzf#run({'source': s:getCandidatesCmd(a:word), 'sink': function('ImportJavaAdd'), 'options': '-1'})
endfunction

function! ImportJavaGenerate()
    execute("!git -C '" . b:root . "' grep -E -h '^import (static )?[0-9a-zA-Z._]*;$' |" .
                \ " sort -u |" .
                \ " sed 's/^import \\(.*\\);$/\\1/' |" .
                \ " awk -F . '{ print $NF, $0 }' > '" . b:root . "/.raw.import'")
endfunction

nnoremap <buffer> <plug>(import-java-n) :call ImportJavaPick(expand('<cword>'))<CR>

let &cpo = s:save_cpo
unlet s:save_cpo
