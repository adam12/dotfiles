# adam12 dotfiles

These are the dotfiles I'm currently using now. I have a repository where I used
to manage the with stow [here][1].

## How do these work

Essentially, my home directory is a Git repository. I ignore what I don't want,
and add the rest.

The Git directory lives at `~/.dotfiles.git` and the work tree is `$HOME`, so
files live directly in `~` with no symlinks. A shell alias keeps the two wired
together:

```fish
alias dotfiles="git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME"
```

Then `dotfiles status`, `dotfiles add ~/.config/fish/config.fish`,
`dotfiles commit`, `dotfiles push`, etc.

## Setting up on a new machine

```fish
# Clone bare into ~/.dotfiles.git
git clone --bare https://github.com/adam12/dotfiles.git $HOME/.dotfiles.git

# Add the alias (and persist it in your shell config)
alias dotfiles="git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME"

# Hide untracked files so `dotfiles status` doesn't list all of $HOME
dotfiles config --local status.showUntrackedFiles no

# Check out into $HOME
dotfiles checkout
```

If the checkout fails because tracked files already exist in `$HOME` (e.g. a
default `.bashrc`), either back them up:

```fish
mkdir -p $HOME/.dotfiles-backup
dotfiles checkout 2>&1 | grep -E "^\s+\." | awk '{print $1}' | \
    xargs -I{} mv $HOME/{} $HOME/.dotfiles-backup/{}
dotfiles checkout
```

…or overwrite them with `dotfiles checkout -f`.

[1]: https://github.com/adam12/dotfiles-old
