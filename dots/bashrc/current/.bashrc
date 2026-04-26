# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# conda alias
#alias conda='~/anaconda3/bin/conda'






# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/foobar/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/foobar/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/foobar/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/foobar/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion







echo ""
echo "=== USER ==="

echo ""
echo "w"
w

echo ""
echo "=== SYSTEM ==="

echo ""
echo "uptime -p"
uptime -p

echo ""
echo "df -h"
df -h

echo ""
echo "=== Network ==="

echo ""
echo "ifconfig"
if command -v ifconfig &>/dev/null; then
    ifconfig
else
    echo "(ifconfig not found — install net-tools)"
fi

echo ""
echo "curl -s ifconfig.me"
curl -s ifconfig.me

echo ""
echo "ss -tuln"
ss -tuln

#echo ""
#echo "neofetch"
#neofetch

echo ""
echo "=== VERSIONS ==="

echo "bash --verison | grep bash"
bash --version | grep bash
echo "python3 --version"
python3 --version
if command -v node &>/dev/null; then
    echo "node --version"
    node --version
fi
if command -v npm &>/dev/null; then
    echo "npm --version"
    npm --version
fi
if command -v nvm &>/dev/null; then
    echo "nvm --version"
    nvm --version
fi
if command -v ollama &>/dev/null; then
    echo "ollama --version"
    ollama --version
fi
echo "git --version"
git --version

echo ""
echo "=== ssh running ==="
echo ""

echo ""
echo "=== docker ==="
echo ""
if command -v docker &>/dev/null; then
    docker ps
else
    echo "(docker not installed)"
fi

echo ""
echo "=== AI ==="

if command -v ollama &>/dev/null; then
    echo "ollama list"
    ollama list
else
    echo "(ollama not installed)"
fi


echo ""
echo "=== GPU ==="

if command -v nvidia-smi &>/dev/null; then
    echo ""
    echo "nvidia-smi --query-gpu=name,temperature.gpu,utilization.gpu,memory.used,memory.free --format=csv,noheader'"
    nvidia-smi --query-gpu=name,temperature.gpu,utilization.gpu,memory.used,memory.free --format=csv,noheader

    # set gpu fan spin (needs to be set on startup not terminal)
    # only runs when an X display is active, otherwise nvidia-settings errors
    if [ -n "$DISPLAY" ] && command -v nvidia-settings &>/dev/null; then
        nvidia-settings -c :1 -a '[gpu:0]/GPUFanControlState=1' -a '[fan:0]/GPUTargetFanSpeed=50' -a '[fan:1]/GPUTargetFanSpeed=50'
    fi
else
    echo "(nvidia-smi not found — NVIDIA drivers not installed or no NVIDIA GPU)"
fi

echo ""
echo "=== ABOUT ==="

echo ""
echo "hostnamectl"
hostnamectl

echo ""
echo "neofetch"
if command -v neofetch &>/dev/null; then
    neofetch
else
    echo "(neofetch not installed)"
fi


alias obsidian="~/APPIMAGES/Obsidian-1.12.7.AppImage --no-sandbox"


# -z "$1" — true if the string is empty (zero length)
# -lt 0 = less than 0
# -gt 100 = greater than 100
# -c :1 — connect to X display :1
# -a — assign a value to an attribute
# The || between the conditions is just "or"
gpu-fan() {
    if [[ -z "$1" || "$1" -lt 0 || "$1" -gt 100 ]]; then
        echo "Usage: gpu-fan <0-100>"
        return 1
    fi
    nvidia-settings -c :1 -a '[gpu:0]/GPUFanControlState=1' -a "[fan:0]/GPUTargetFanSpeed=$1" -a "[fan:1]/GPUTargetFanSpeed=$1"
}
