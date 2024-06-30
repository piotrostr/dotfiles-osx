alias vi=nvim
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Created by `pipx` on 2024-06-28 15:39:00
export PATH="$PATH:/Users/piotrostr/.local/bin"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

source $HOME/.config/zsh/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle pip
antigen bundle command-not-found

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions

antigen apply

fpath=($fpath "/Users/piotrostr/.zfunctions")

export TYPEWRITTEN_CURSOR="block"
export TYPEWRITTEN_SYMBOL="$"
export TYPEWRITTEN_ARROW_SYMBOL="git:" # 
export TYPEWRITTEN_PROMPT_LAYOUT="pure"
export TYPEWRITTEN_COLOR_MAPPINGS="primary:green"
export TYPEWRITTEN_COLORS="arrow:white;symbol:yellow;git_branch:red;arrow:yellow"

# typewritten setup
fpath+=$HOME/.zsh/typewritten
autoload -U promptinit; promptinit
prompt typewritten

