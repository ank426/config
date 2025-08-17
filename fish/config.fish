source $XDG_CONFIG_HOME/zsh/.zshenv

if status is-interactive
    # source $XDG_CONFIG_HOME/fish/themes/kanagawa.fish

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
    abbr --add s systemctl
    abbr --add ss sudo systemctl
    abbr --add v nvim

    abbr --add g git
    abbr --add gst git status
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
    abbr --add gs git switch
    abbr --add gsc git switch -c
    abbr --add gd git diff
    abbr --add gdh git diff HEAD
    abbr --add gds git diff --staged
    abbr --add gl git log
    abbr --add glo git log --oneline
    abbr --add gb git branch
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

    alias cp=advcp
    alias mv=advmv

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
    alias tree='tree -aC --dirsfirst'
    alias git-tree='git ls-tree -r --name-only HEAD | tree --fromfile'

    alias arm="$XDG_CONFIG_HOME/bin/arm.sh"
    alias brave='brave --enable-features=UseOzonePlatform,TouchpadOverscrollHistoryNavigation --ozone-platform-hint=auto' # --disable-gpu
    alias mariadb='mariadb --user=ankit --password=$(pass code/mariadb/ankit)'
    # alias wey='ip -4 -brief address && weylus --no-gui'
    alias wey="$XDG_CONFIG_HOME/bin/weylus.sh"
    # alias weylus='weylus --auto-start --access-code $(head /dev/urandom | tr -cd A-Za-z0-9 | head -c 20)'
    alias mgr="~/code/mgr/bin/mgr"

    alias adb="HOME=$XDG_DATA_HOME/android command adb"
    alias wget="wget --hsts-file=$XDG_CACHE_HOME/wget-hsts"
    alias R='R --no-save'

    alias ttyper-quote="curl -s https://quotes-api-self.vercel.app/quote | jq -r '.quote' | sed 's/’/\'/g' | tr ' –' '\n-' | ttyper -"
end
