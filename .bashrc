# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History Control
#
# Don't put duplicate lines or lines starting with space in the history.
export HISTCONTROL=ignoreboth:erasedups
# Ignore the following patterns when appending to the history file
# export HISTIGNORE="ls:ll:la:cd**:history**:top:exit:tree**:c:clear"
# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=100000
export HISTFILESIZE=200000
# Synchronise history across multiple sessions;
# history -a appends the current command to the history file. history -c
# then clears the history after which history -r reads and updates the
# current state of the history, thereby reading in any changes from other
# sessions. PROMPT_COMMAND is run prior to the issue of the primary prompt.
export PROMPT_COMMAND="history -a;history -c;history -r"
# Append to the history file, don't overwrite it
shopt -s histappend
# Smart handling of multiline commands - attempt to save each line of a
# multi-line command in the same history entry
shopt -s cmdhist

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# Uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    git_prompt_sh="/usr/lib/git-core/git-sh-prompt"
    if [ ${UID} == 0 ]; then
        # Root user
        if [ -e $git_prompt_sh ]; then
            source $git_prompt_sh
            PS1='${debian_chroot:+($debian_chroot)}\[\033[00;31m\]\u@\[\033[38;5;66m\]\h\[\033[01;34m\] \w \[\033[38;5;66m\]$(__git_ps1 "\n[%s] ")\[\033[01;34m\]\$\[\033[00m\] '
        else
            PS1='${debian_chroot:+($debian_chroot)}\[\033[00;31m\]\u@\[\033[38;5;66m\]\h\[\033[01;34m\] \w \$\[\033[00m\] '
        fi
    else
        # All other users
        if [ -e $git_prompt_sh ]; then
            source $git_prompt_sh
            PS1='${debian_chroot:+($debian_chroot)}\[\033[1;30m\]\u@\[\033[38;5;66m\]\h\[\033[01;34m\] \w \[\033[38;5;66m\]$(__git_ps1 "\n[%s] ")\[\033[01;34m\]\$\[\033[00m\] '
        else
            PS1='${debian_chroot:+($debian_chroot)}\[\033[1;30m\]\u@\[\033[38;5;66m\]\h\[\033[01;34m\] \w \$\[\033[00m\] '
        fi
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt git_prompt_sh


# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r $HOME/.dircolors && eval "$(dircolors -b $HOME/.dircolors)" ||\
        eval "$(dircolors -b)"
    export LS_OPTIONS='--color=auto'
fi

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Colour support for manpages
# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\e[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\e[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\e[0m'           # end mode
export LESS_TERMCAP_so=$'\e[01;38;5;154m' # begin standout-mode - info box
export LESS_TERMCAP_se=$'\e[0m'           # end standout-mode
export LESS_TERMCAP_us=$'\e[04;38;5;72m'  # begin underline
export LESS_TERMCAP_ue=$'\e[0m'           # end underline

# GPG Settings
export GPG_TTY=$(tty)

# Set up rbenv
if command -v rbenv &>/dev/null; then
    eval "$(rbenv init -)"
fi

# Set up direnv
if command -v direnv &>/dev/null; then
    eval "$(direnv hook bash)"
fi

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# tmux completions
# https://github.com/Bash-it/bash-it/blob/master/completion/available/tmux.completion.bash
tmux_completions="${HOME}/.bash_completion.d/tmux/tmux_completion.bash"
if [ -f "${tmux_completions}" ]; then
    source "${tmux_completions}"
fi
unset tmux_completions

# Vagrant Completions
base_dir="/opt/vagrant/embedded/gems"
if [ -d "${base_dir}" ]; then
    latest="$(vagrant --version | cut -d' ' -f2)"
fi
vagrant_completions="${base_dir}/${latest}/gems/vagrant-${latest}/contrib/bash/completion.sh"
if [ -f "${vagrant_completions}" ]; then
  source "${vagrant_completions}"
fi
unset base_dir latest vagrant_completions

# Test-Kitchen
# https://github.com/MarkBorcherding/test-kitchen-bash-completion
test_kitchen_completions="${HOME}/.bash_completion.d/test-kitchen/kitchen-completion.bash"
if [ -f "${test_kitchen_completions}" ]; then
    source "${test_kitchen_completions}"
fi
unset test_kitchen_completions

# Go command completions
# https://github.com/thomasf/go-bash-completion.git
go_completions="${HOME}/.bash_completion.d/go/go-bash-completion.bash"
if [ -f "${go_completions}" ]; then
    source "${go_completions}"
fi
unset go_completions

# Packer command completions
# https://github.com/mrolli/packer-bash-completion.git
packer_completions="${HOME}/.bash_completion.d/packer/packer-completion.bash"
if [ -f "${packer_completions}" ]; then
    source "${packer_completions}"
fi
unset packer_completions

# kubectl command completions
if command -v kubectl &>/dev/null; then
    source <(kubectl completion bash)
fi

# Terraform
if command -v terraform &>/dev/null; then
    complete -C "$(command -v terraform)" terraform
fi

# Helm
if command -v helm &>/dev/null; then
    source <(helm completion bash)
fi

# Istio
if command -v istioctl &>/dev/null; then
    istioctl_completions="${HOME}/.bash_completion.d/istioctl/istioctl.bash"
    if [ -e "${istioctl_completions}" ]; then
        source "${istioctl_completions}"
    fi
    unset istioctl_completions
fi

# Hugo
if command -v hugo &>/dev/null; then
    # Completions
    hugo_completions_dir="${HOME}/.bash_completion.d/hugo"
    hugo_completions="${hugo_completions_dir}/hugo.bash"
    [ ! -d "${hugo_completions_dir}" ] && mkdir -p "${hugo_completions_dir}"
    if [ ! -e "${hugo_completions}" ]; then
        hugo gen autocomplete --completionfile="${hugo_completions}" \
            &>/dev/null
    fi
    source "${hugo_completions}"
    unset hugo_completions
    # Manpages
    hugo_man_dir="${HOME}/.local/share/man/man1"
    [ ! -d "${hugo_man_dir}" ] && mkdir -p "${hugo_man_dir}"
    if ! ls "${hugo_man_dir}"/hugo* &>/dev/null; then
        hugo gen man --dir ${hugo_man_dir} &>/dev/null
    fi
    unset hugo_man_dir
fi

# Terraform
if command -v terraform &>/dev/null; then
    complete -C "$(command -v terraform)" terraform
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f "${HOME}/.bashrc_aliases" ]; then
    source "${HOME}/.bashrc_aliases"
fi

# Functions

if command -v pandoc &>/dev/null; then
    md () {
        pandoc -t plain "$1" | less
    }
fi
