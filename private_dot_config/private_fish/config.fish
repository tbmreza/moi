if status is-interactive
    # Commands to run in interactive sessions can go here
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /home/tbmreza/.ghcup/bin $PATH # ghcup-env

set -g fish_greeting ""

function fish_prompt
    printf '\n %s\n' (pwd)

    set -l branch (git branch --show-current 2>/dev/null)
    if test -n "$branch"
        printf '(🔀 %s)\n' $branch
    else
        printf '(no git ⎇ )\n'
    end

    printf '> '
end
