function! MatchDir(arg)
   let filename=expand('%:p')
   if filename =~ a:arg
      return 1
   else
      return 0
   endif
endfunction

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

"Take the visual map and dump it into scratch file
"vmap <C-m> :call AppendScratch()<enter>
function! AppendScratch()
let scratch_file=$HOME . "/.vim/scratch_files/scratch." . &filetype 
"yank current visual selection to reg x
normal "xY
let m = readfile(scratch_file)
let mp = split(@x,"\n")
call writefile(m + mp,scratch_file)
endfunction

"Append the scratch file for the filetype at the end of the current file
"vmap <C-c> :call CatScratch()<enter>
function! CatScratch()
   let scratch_file=$HOME "/.vim/scratch_files/scratch." . &filetype 
   normal Go
   exec('.!cat ' . scratch_file )
endfunction

function! ToggleHtmlFT()
   if ! exists("g:my_file_type")
      let g:my_file_type = 0
      "echom "no exist"
      "echom g:my_file_type
   endif
   if g:my_file_type == 0
      set ft=html
      let g:my_file_type = 1
      "echom "html"
      "echom g:my_file_type
   else
     filetype detect
     let g:my_file_type = 0
      "echom "detect"
      "echom g:my_file_type
   endif
endfunction
