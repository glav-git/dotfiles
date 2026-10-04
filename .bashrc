# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export COWPATH="$HOME/.config/cowsay"
export DISPLAY=:0;
export GOPATH=$HOME/go
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export XKB_DEFAULT_OPTIONS=caps:escape
export FLYCTL_INSTALL="$HOME/.fly"
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

append_to_a_path() { if [ -d "$1" ] ; then PATH="$PATH:$1"; fi }
prepend_to_a_path() { if [ -d "$1" ] ; then PATH="$1:$PATH"; fi }
prepend_to_a_path "/home/pikarchu/.opencode/bin"
prepend_to_a_path "$HOME/.local/bin"
prepend_to_a_path "/usr/local/go/bin"
prepend_to_a_path "$GOPATH/bin"
append_to_a_path "$FLYCTL_INSTALL/bin"
append_to_a_path "/home/pikarchu/.local/share/nvim/mason/bin/"
unset -f append_to_a_path
unset -f prepend_to_a_path


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# {{#if wsl}} enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# {{/if}}

gender=$(echo '--lesbian
--gay
--bisexual
--transgender
--pansexual
--gender-queer
--mlm
--polysexual
--demiboy
--demigirl
--bigender
--abrosexual
--trigender' | shuf -n 1)
saying=$(find $HOME/.config/cowsay/sayings -name '[^_]*.txt' | shuf -n 1)
cat $saying | cowthink  -f sodomized-sheep -n | gay $gender

if [ -d "~/.local/share/omarchy" ]; then
    # All the default Omarchy aliases and functions
    # (don't mess with these directly, just overwrite them here!)
    # source ~/.local/share/omarchy/default/bash/rc
    # source ~/.local/share/omarchy/default/bash/shell
    # source ~/.local/share/omarchy/default/bash/aliases
    # source ~/.local/share/omarchy/default/bash/prompt
    # source ~/.local/share/omarchy/default/bash/envs
    source ~/.local/share/omarchy/default/bash/functions
    source ~/.local/share/omarchy/default/bash/init
    [[ $- == *i* ]] && bind -f ~/.local/share/omarchy/default/bash/inputrc
fi

alias n="nvim"
alias ll="ls -lah"
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias va=". .venv/bin/activate"
alias sshh='_a=( $(cat $HOME/.ssh/my_hosts | sed s/#.*$// | sed /^\s*$/d | fzf) ); ssh ${_a[@]:1}'

open() { xdg-open "$@" >/dev/null 2>&1 & }
eval "$(starship init bash)"

function cd() {
    builtin cd "$@"

    # Auto-activate virtual environment
    if [ -f .venv/bin/activate ]; then
        source .venv/bin/activate
    elif [ -n "$VIRTUAL_ENV" ]; then
        # Deactivate if we left the project directory
        deactivate 2>/dev/null || true
    fi
}

[[ -f .venv/bin/activate ]] && . .venv/bin/activate
[[ -f ~/.cargo/env ]] && . ~/.cargo/env
[[ -f ~/.bash_mise_activate ]] && . ~/.bash_mise_activate
