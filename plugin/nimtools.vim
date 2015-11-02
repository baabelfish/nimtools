if exists("b:nimtools_loaded")
    finish
else
    let b:nimtools_loaded = 1
endif

if executable('nim')
    let g:neomake_nim_nim_maker = {
        \ 'args': ['c', '--verbosity:0', '--colors:off'],
        \ 'errorformat': 
        \   '%A%f(%l\, %c) Hint: %m,' .
        \   '%W%f(%l\, %c) Warning: %m,' .
        \   '%E%f(%l\, %c) Error: %m'
        \ }

    let g:neomake_nim_enabled_makers = ['nim']
endif

if executable('nimsuggest')
    let s:nimsug_server_job = -1
    let s:nimsug_server_file = ""
    let s:nimsug_server_port = "6000"

    function! s:debug()
    endfunction

    function! s:stop_server()
        exec "!killall nimsuggest"
        " if s:nimsug_server_job > 0
        "     call jobstop(s:nimsug_server_job)
        "     let s:nimsug_server_job = -1
        " endif
    endfunction

    function! s:start_server(...)
        if s:nimsug_server_job > 0
            echo "Server already running. Stop it first with \"NimServerStop\""
        else
            let s:nimsug_server_file = len(a:000) > 0 ? expand(a:1) : expand("%")
            let s:nimsug_server_port = len(a:000) > 1 ? a:2 : "6000"
            exec "!nimsuggest " . s:nimsug_server_file . " --port:" . s:nimsug_server_port . "&"

            " FIXME: Somehow jobstart fails randomly
            " let s:nimsugcmd = ['nimsuggest', s:nimsug_server_file, '--port:' . s:nimsug_server_port]
            " let s:nimsugopts = {
            "             \ 'pty': 'true' }

            " let s:nimsug_server_job = jobstart(s:nimsugcmd, s:nimsugopts)

            " let s:jobw = jobwait([s:nimsug_server_job], 1000)
            " if s:jobw[0] != -1
            "     let s:nimsug_server_job = -2
            " endif

            " if s:nimsug_server_job < 1
            "     echoerr "Starting of nimsuggest server failed"
            " else
            "     echo "Nimsuggest:" .
            "                 \ " " . s:nimsug_server_file .
            "                 \ "@localhost:" . s:nimsug_server_port .
            "                 \ " (neovim job: " . s:nimsug_server_job . ")"
            " endif
        endif
    endfunction

    command! -complete=custom,s:start_server -nargs=* NimServerStart call s:start_server(<f-args>)
    command! NimServerStop call s:stop_server()
    command! NimServerDebug call s:debug()
    autocmd! VimLeave NimServerStop 
endif

nnoremap <silent><C-]> :YcmCompleter GoTo<cr>
nnoremap <silent><C-LeftMouse> :YcmCompleter GoTo<cr>
