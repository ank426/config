function me_fzf --description "Run command using fzf"
    # set fd_cmd (command --search fd) --color=always $fzf_fd_opts
    # switch "$argv[1]"
    # case cd
    #     set --append fd_cmd --type=directory
    # case nvim
    #     set --append fd_cmd --type=file
    # end

    set bfs_cmd (command --search bfs) -color -mindepth 1
    switch "$argv[1]"
    case cd
        set --append bfs_cmd -type d
    case nvim
        set --append bfs_cmd -type f
    end
    set --append bfs_cmd -printf '%P\n' # needs to be last

    set fzf_cmd _fzf_wrapper --ansi --scheme=path --preview='_fzf_preview_file {}'

    set path ($bfs_cmd 2>/dev/null | $fzf_cmd)
    commandline --function repaint # fzf bug so needed when height specified in fzf in script
    if test -n "$path"
        commandline "$argv[1] '$path'"
        commandline --function execute
    end
end
