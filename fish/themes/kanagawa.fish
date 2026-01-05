#!/usr/bin/fish

# Kanagawa Fish shell theme
# A template was taken and modified from Tokyonight:
# https://github.com/folke/tokyonight.nvim/blob/main/extras/fish_tokyonight_night.fish
# set -l foreground DCD7BA normal
# set -l selection 2D4F67 brcyan
# set -l comment 727169 brblack
# set -l red C34043 red
# set -l orange FF9E64 brred
# set -l yellow C0A36E yellow
# set -l green 76946A green
# set -l purple 957FB8 magenta
# set -l cyan 7AA89F cyan
# set -l pink D27E99 brmagenta
set -l foreground normal
set -l selection brcyan
set -l comment brblack
set -l red red
set -l orange brred
set -l yellow yellow
set -l green green
set -l purple magenta
set -l cyan cyan
set -l pink brmagenta

# Syntax Highlighting Colors
set -gx fish_color_normal $foreground
set -gx fish_color_command $cyan
set -gx fish_color_keyword $pink
set -gx fish_color_quote $yellow
set -gx fish_color_redirection $foreground
set -gx fish_color_end $orange
set -gx fish_color_error $red
set -gx fish_color_param $purple
set -gx fish_color_comment $comment
set -gx fish_color_selection --background=$selection
set -gx fish_color_search_match --background=$selection
set -gx fish_color_operator $green
set -gx fish_color_escape $pink
set -gx fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
