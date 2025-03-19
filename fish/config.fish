source $XDG_CONFIG_HOME/zsh/.zshenv

if status is-interactive
    # tide prompt prints blank line on startup / clear screen (bug)
    # set tide layout to compact and do this to do manual sparse
    set first_line true
    function manual_sparse --on-event fish_prompt
        $first_line
        and set first_line false
        or echo
    end
    function clear
        set first_line true
        command clear
    end

    set --global --export SHELL /usr/bin/fish
    set --global --export fish_greeting
    set --global --export fzf_fd_opts --hidden --no-ignore
    set --global --export fish_color_command blue

    # automatically loads same name file in functions
    bind \es 'me_commandline_prepend sudo'
    bind \e, 'commandline prevd && commandline --function execute'
    bind \e. 'commandline nextd && commandline --function execute'
    bind \ec 'me_fzf cd'
    bind \ev 'me_fzf nvim'

    # fish doesn't realize abbr after sudo when using position command
    abbr --add c clear
    abbr --add lg lazygit
    abbr --add slg sudo lazygit
    abbr --add pm pacman
    abbr --add spm sudo pacman
    abbr --add p paru
    abbr --add py python
    abbr --add ipy ipython
    abbr --add v nvim

    # abbr --add --set-cursor gca git commit -a
    # abbr --add --set-cursor gcam git commit -am \'%\'

    alias diff='diff --color=always'
    alias fd='fd --color=always'
    alias grep='grep --color=always'
    alias ip='ip -color=always'
    alias info='info --vi-keys'
    alias less='less --IGNORE-CASE --RAW-CONTROL-CHARS --incsearch --use-color'
    alias ls='LC_COLLATE=C command ls --almost-all --color --group-directories-first'
    alias ncdu='ncdu --color=dark'
    alias pacman='pacman --color=always'
    alias paru='paru --color=always'
    alias tldr='tldr --color always'
    alias tree='tree -aC --dirsfirst'
    alias tree-git='tree -aC --dirsfirst --gitignore -I .git'

    alias arm="$XDG_CONFIG_HOME/bin/arm.sh"
    alias brave='brave --ozone-platform-hint=auto --disable-gpu --enable-features="TouchpadOverscrollHistoryNavigation"'
    alias mariadb='mariadb --user=ankit --password=$(pass code/mariadb/ankit)'
    alias wey='ip -4 -brief address && weylus --no-gui'
    alias weylus='weylus --auto-start --access-code $(head /dev/urandom | tr -cd A-Za-z0-9 | head -c 20)'

    alias adb="HOME=$XDG_DATA_HOME/android adb"
    alias wget="wget --hsts-file=$XDG_CACHE_HOME/wget-hsts"
    alias R='R --no-save'
end
