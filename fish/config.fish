function _fzf_run
    fzf $argv[2..] | read --local op
    commandline --function repaint # fzf bug so needed when height specified in fzf in script
    if test -n "$op"
        commandline "$argv[1] '$op'"
        commandline --function execute
    end
end

function _fzf_ins
    fzf $argv | read --local op
    commandline --function repaint
    if test -n "$op"
        commandline --insert "$op"
    end
end

function _fzf_var_preview
    for row in (set --show $argv[1])
        if set --local op (string match --groups-only --regex "\\\$$argv[1](\[[1-9][0-9]*\]): \|(.*)\|" $row)
            echo -e "$op[1] \033[34m$op[2]\033[0m"
        else if set --local op (string match --groups-only --regex "\\\$$argv[1]: (.*)" $row)
            echo -e "\033[32m$op\033[0m"
        else
            echo $row
        end
    end
end

# Batched version done in python
function _colorize_history
    while read --null --local entry
        printf "\e[90m$(string sub --length 17 $entry)\e[0m"

        set --local str (string sub --start 18 $entry | fish_indent --ansi | sed -z 's/\n\([^\n]*\)$/\1/' | string collect)
        set --local in_esc false
        set --local color \e'[0m'
        for c in (string split -- '' $str)
            if test $c = \e
                set in_esc true
                set color \e
            else if test $in_esc = true
                set color "$color$c"
                if test $c = 'm'
                    set in_esc false
                end
            end
            printf '%s' $c
            if test $c = \n
                printf "\e[90m               │ $color"
            end
        end

        printf '\0'
        or break # pipe is broken
    end
end

function _fzf_history
    if test -z "$fish_private_mode"
        history merge # merges changes from other fish sessions
    end
    set --local op (
        history --null --show-time="%m-%d %H:%M:%S │ " |
        "$XDG_CONFIG_HOME/fish/colorize_history.py" |
        # _colorize_history |
        fzf --scheme=history --read0 --preview='' --query=(commandline) |
        sed 's/^[^│]* │ *//'
    )
    commandline --function repaint
    commandline --replace $op
end

source $XDG_CONFIG_HOME/zsh/.zshenv

if status is-interactive
    source $XDG_CONFIG_HOME/fish/themes/kanagawa.fish

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

    set --global --export SHELL (command -s fish)
    set --global --export fish_greeting
    set --global --export fzf_fd_opts --hidden --no-ignore
    # set --global --export fish_color_command blue
    set --global --export fish_key_bindings fish_default_key_bindings # workaround until https://github.com/IlanCosman/tide/pull/626

    bind ctrl-shift-n 'alacritty --working-directory . & disown'

    # automatically loads same name file in functions
    bind alt-s 'me_commandline_prepend sudo'

    # Directly run bfs cuz otherwise there is a large buffering delay when fish loads my function
    bind alt-c "
        command bfs -color -follow -mindepth 1 -type d -printf %P\\n 2>/dev/null |
        _fzf_run cd --scheme=path --preview='preview.sh {}'
    "
    bind alt-v "
        command bfs -color -follow -mindepth 1 -type f -printf %P\\n 2>/dev/null |
        _fzf_run nvim --scheme=path --preview='preview.sh {}'
    "

    bind ctrl-alt-f 'command bfs -color -follow -mindepth 1 -printf %P\\n 2>/dev/null | _fzf_ins --scheme=path --accept-nth="\'{..}\'"'
    bind ctrl-v 'set --names | string match --invert history | _fzf_ins --preview="_fzf_var_preview {}"'
    bind ctrl-alt-p '
        ps axh -o pid,start_time,user,command |
        string replace --regex \'^( *[1-9][0-9]*) (.{5}) ([^ ]+) (.*)$\' \'\\e[90m$1  \\e[34m$2  \\e[35m$3  \\e[36m$4\' |
        _fzf_ins --accept-nth=1
    '

    bind ctrl-r '_fzf_history'

    # fish doesn't realize abbr after sudo when using position command
    abbr --add c clear
    abbr --add ff fastfetch
    abbr --add lg lazygit
    abbr --add slg sudo lazygit
    abbr --add lo loffice
    abbr --add oc opencode
    abbr --add pm pacman
    abbr --add spm sudo pacman
    abbr --add p paru
    abbr --add py python
    abbr --add ipy ipython
    abbr --add s systemctl
    abbr --add ss sudo systemctl
    abbr --add v nvim

    abbr --add phs py-http-server.sh
    abbr --add mkr mokuro.sh
    abbr --add sl scroll.py
    abbr --add wey weylus.sh

    abbr --add g git
    abbr --add gs git status
    abbr --add ga git add
    abbr --add gaa git add -A
    abbr --add gc git commit
    abbr --add gca git commit -a
    abbr --add gc. git commit -m .
    abbr --add gca. git commit -am .
    abbr --add --set-cursor gcm git commit -m \'%\'
    abbr --add --set-cursor gcam git commit -am \'%\'
    abbr --add gac 'git add -A && git commit'
    abbr --add --set-cursor gacm 'git add -A && git commit -m \'%\''
    abbr --add gg 'git add -A && git commit --allow-empty-message -m \'\''
    abbr --add ggp 'git add -A && git commit --allow-empty-message -m \'\' && git push'
    abbr --add gp git pull
    abbr --add gP git push
    abbr --add gsw git switch
    abbr --add gswc git switch -c
    abbr --add gd git diff
    abbr --add gdh git diff HEAD
    abbr --add gds git diff --staged
    abbr --add gl git log --graph
    abbr --add glo git log --oneline --graph
    abbr --add gb git branch
    abbr --add gst git stash
    abbr --add gstl git stash list
    abbr --add gsta git stash apply
    abbr --add gstc git stash clear
    abbr --add gstp git stash pop
    abbr --add gstP git stash push
    abbr --add grm git rm
    abbr --add grmc git rm --cached
    abbr --add gr git restore
    abbr --add gra git restore :/
    abbr --add grw git restore --worktree
    abbr --add grwa git restore --worktree :/
    abbr --add grs git restore --staged
    abbr --add grsa git restore --staged :/
    abbr --add grws git restore --worktree --staged
    abbr --add grwsa git restore --worktree --staged :/
    abbr --add grv git revert
    abbr --add grvh git revert HEAD
    abbr --add grb git rebase
    abbr --add grbi git rebase -i
    abbr --add gR git reset
    abbr --add gRh git reset HEAD~
    abbr --add gcl git clean
    abbr --add gcn git clone
    abbr --add gcn1 git clone --depth 1
    abbr --add gcnr git clone --recursive
    abbr --add gf git fetch
    abbr --add gfa git fetch --all
    abbr --add gw git worktree
    abbr --add gcf git config
    abbr --add gcfg git config --global
    abbr --add gcfe git config edit
    abbr --add gcfge git config --global edit
    abbr --add gm git merge
    abbr --add gsb git submodule

    if command --query advcp
        alias cp=advcp
    end
    if command --query advmv
        alias mv=advmv
    end

    function bfs
        command bfs -color $argv -mindepth 1 -printf '%P\n' # printf needs to be last
    end

    alias diff='diff --color=always'
    alias fd='fd --color=always'
    alias grep='grep --color=always'
    alias ip='ip -color=always'
    alias info='info --vi-keys'
    alias jq='jq -C'
    alias less='less --IGNORE-CASE --RAW-CONTROL-CHARS --incsearch --use-color'
    alias ls='LC_COLLATE=C command ls --almost-all --color --group-directories-first'
    alias ncdu='ncdu --color=dark'
    alias pacman='pacman --color=always'
    alias pactree='pactree --color'
    alias paru='paru --color=always'
    alias rg='rg --color=always'
    alias tldr='tldr --color always'
    alias tree='CLICOLOR_FORCE=true command tree -a --dirsfirst' # using CLICOLOR_FORCE instead of -C allows disabling with -n
    alias git-tree='git ls-tree -r --name-only HEAD | tree --fromfile'

    alias brave='brave --enable-features=UseOzonePlatform,TouchpadOverscrollHistoryNavigation --ozone-platform-hint=auto' # --disable-gpu
    alias mariadb='mariadb --user=ankit --password=$(pass code/mariadb/ankit)'
    alias opencode='opencode --agent nestor'

    alias adb="HOME=$XDG_DATA_HOME/android command adb"
    alias qbt="qbt --config $XDG_CONFIG_HOME/qbt/.qbt.toml"
    alias wget="wget --hsts-file=$XDG_CACHE_HOME/wget-hsts"
    alias R='R --no-save'

    alias ttyper-quote="curl -s https://quotes-api-self.vercel.app/quote | jq -r '.quote' | sed 's/’/\'/g' | tr ' –' '\n-' | ttyper -"
end
