# Fish completions for openvpn3
# Built on `openvpn3 shell-completion` (--list-commands, --list-options, --arg-helper).

# First non-option word after "openvpn3" = the subcommand (empty/false if none yet).
function __fish_openvpn3_cmd
    set -l tokens (commandline -opc)
    set -e tokens[1]
    for t in $tokens
        if not string match -q -- '-*' $t
            echo $t
            return 0
        end
    end
    return 1
end

# Options for the current subcommand.
# - drops the "--opt=" duplicates the helper emits
# - empty word or "--..." -> long options only; a single "-" -> short ones too
function __fish_openvpn3_options
    set -l cmd (__fish_openvpn3_cmd); or return
    set -l cur (commandline -ct)
    set -l opts (openvpn3 shell-completion --list-options $cmd 2>/dev/null \
        | string split -n ' ' \
        | string match -v -- '*=')
    if test -z "$cur"; or string match -q -- '--*' $cur
        string match -- '--*' $opts
    else
        printf '%s\n' $opts
    end
end

# Values for the option just typed (e.g. config names after --config).
function __fish_openvpn3_arg_values
    set -l cmd (__fish_openvpn3_cmd); or return
    set -l tokens (commandline -opc)
    set -l prev $tokens[-1]
    string match -q -- '-*' $prev; or return
    openvpn3 shell-completion --list-options $cmd --arg-helper $prev 2>/dev/null \
        | string split -n ' '
end

# True when the previous word is an option that takes a value (the helper returns
# values for it) and the word being typed isn't itself an option.
function __fish_openvpn3_expecting_value
    set -l cur (commandline -ct)
    if test -n "$cur"; and string match -q -- '-*' $cur
        return 1
    end
    set -l v (__fish_openvpn3_arg_values)
    test (count $v) -gt 0
end

# No file completion by default
complete -c openvpn3 -f

# Subcommands
complete -c openvpn3 -n '__fish_use_subcommand' -a '(openvpn3 shell-completion --list-commands 2>/dev/null | string split -n " ")'

# Options for the current subcommand (fish filters by what has been typed)
complete -c openvpn3 -n 'not __fish_use_subcommand; and not __fish_openvpn3_expecting_value' -a '(__fish_openvpn3_options)'

# Option values (config names, session paths, etc.); only yields results right after an option
complete -c openvpn3 -n 'not __fish_use_subcommand; and __fish_openvpn3_expecting_value' -a '(__fish_openvpn3_arg_values)'
