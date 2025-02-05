function me_fzf_nvim
    set fd_cmd fd --type=file --color=always $fzf_fd_opts
    set fzf_cmd _fzf_wrapper --ansi --scheme=path --preview='_fzf_preview_file {}'
    set path ($fd_cmd | $fzf_cmd)
    commandline --function repaint # fzf bug so needed when height specified in fzf in script
    if test -n "$path"
        commandline "nvim $path"
        commandline --function execute
    end
end
