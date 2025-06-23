/opt/homebrew/bin/brew shellenv | source
direnv hook fish | source
mise activate fish | source

set -U --export EDITOR nvim
set -U --export THOR_MERGE "nvim -d"
set -U --export RUBY_YJIT_ENABLE 1
set -U --export ERL_AFLAGS "-kernel shell_history enabled"

alias vim="nvim"
alias whois="$(brew --prefix whois)/bin/whois"
alias weather="curl wttr.in/st.catharines,ca"

fish_add_path $HOME/bin
fish_add_path $HOME/.local/bin

# Configure local::lib for Perl
#eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib)"

if status is-interactive
    # Easily jump to projects and open nvim
    function p
        set selected_dir (fd --max-depth 3 -t d . ~/code | fzf)
        if test -n "$selected_dir"
            cd "$selected_dir"
            # nvim .
        end
    end
end
