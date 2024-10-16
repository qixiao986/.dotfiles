# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/qixiao/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git macos rake bundler dotenv zsh-autosuggestions zsh-syntax-highlighting zsh-vi-mode)

export VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
export VI_MODE_SET_CURSOR=true
export VISUAL=nvim
source $ZSH/oh-my-zsh.sh
# Only changing the escape key to `jk` in insert mode, we still
# keep using the default keybindings `^[` in other modes
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
ZVM_VI_EDITOR=nvim
# autoload edit-command-line; zle -N edit-command-line
# bindkey -M vicmd v edit-command-line

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias ll='eza -al'
alias ls='eza --no-quotes'
alias python='/opt/homebrew/bin/python3.11'
alias killpy="ps aux|grep python|grep -v grep | awk '{print \$2}' | xargs kill -9"
alias rmexe="find . -maxdepth 1 -type f ! -name '*.*'  -exec rm -f {} +"
alias cfg='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias rr='ranger'
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/usr/local/lib/ruby/gems/3.3.0/bin:$PATH"
# export PATH="/usr/local/opt/llvm/bin:$PATH"
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# The plugin will auto execute this zvm_after_init function
function zvm_after_init() {
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

function pydown() {
	ls "$1" |gxargs -d'\n' -I {} ./run2.sh {} "${@:2}"
}

function small() {
  ls "$1"  |gxargs -d'\n' -I {} ffmpeg -i {} -vn -ab 64k -f mp3 {}.mp3
}

function big() {
  ls "$1"  |gxargs -d'\n' -I {} ffmpeg -i {} -vn -ab 320k -f mp3 {}.mp3
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export LC_CTYPE="en_US.UTF-8"

export PATH="/opt/homebrew/bin:$PATH"
JAVA_HOME=$HOME/Documents/jdk18
PATH=$JAVA_HOME/bin:$PATH
PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
CLASS_PATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:.
export JAVA_HOME
export PATH
export CLASS_PATH

export GOPATH=$HOME/Documents/code/github/algo/other_pl/go
export PATH=$GOPATH/bin:$PATH
eval "$(starship init zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(zoxide init zsh)"


export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
export PATH="$HOME/Documents/flutter/bin:$PATH"
export CPLUS_INCLUDE_PATH="$HOME/Downloads/ac-library/:/opt/homebrew/Cellar/gcc/14.2.0/bin/../lib/gcc/current/gcc/aarch64-apple-darwin23/14/../../../../../../include/c++/14/aarch64-apple-darwin23"
