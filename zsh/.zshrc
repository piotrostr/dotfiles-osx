clip() {
    if [ $# -eq 0 ]; then
        pbcopy
    else
        cat "$@" | pbcopy
    fi
}

assume-role() {
    if [ -z "$1" ]; then
        echo "Usage: assume-role <role-arn> [session-name]"
        return 1
    fi

    local role_arn=$1
    local session_name=${2:-$(whoami)}

    echo "Assuming role..."

    # Get credentials in text format
    local creds=$(aws sts assume-role \
        --role-arn "$role_arn" \
        --role-session-name "$session_name" \
        --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]' \
        --output text)

    if [ -z "$creds" ]; then
        echo "Failed to assume role"
        return 1
    fi

    # Export credentials
    export AWS_ACCESS_KEY_ID=$(echo "$creds" | awk '{print $1}')
    export AWS_SECRET_ACCESS_KEY=$(echo "$creds" | awk '{print $2}')
    export AWS_SESSION_TOKEN=$(echo "$creds" | awk '{print $3}')

    echo "✓ Role assumed successfully"
    aws sts get-caller-identity --query 'Arn' --output text
}

cdx() {
    codex \
	--model "gpt-5-codex" \
	--full-auto \
	-c model_reasoning_summary_format=experimental
}


if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
  # Set to dark theme (light_theme: false)
  sed -i '' 's/light_theme: true/light_theme: false/' "$HOME/Library/Application Support/aichat/config.yaml"
else
  # Set to light theme (light_theme: true)
  sed -i '' 's/light_theme: false/light_theme: true/' "$HOME/Library/Application Support/aichat/config.yaml"
fi

alias cursor="open -a Cursor"
alias k="kubectl"
alias "kgp"="kubectl get pods"
alias "kgd"="kubectl get deployments"
alias "kd"="kubectl describe"

alias nproc="sysctl -n hw.logicalcpu"

alias wip="git add . && git commit -m 'wip'"
alias gcn="git commit -m 'nit'"
alias claudec="/Users/piotrostr/.bun/bin/claude"
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

autoload -U promptinit; promptinit
prompt typewritten

function sentra_login {
  echo "Logging in to Sentra's Code Artifact..."
  export POETRY_HTTP_BASIC_SENTRA_LIBRARIES_USERNAME=aws
  POETRY_HTTP_BASIC_SENTRA_LIBRARIES_PASSWORD=$(aws codeartifact get-authorization-token --domain-owner 413014485471 --domain sentra-code-artifact-staging --query authorizationToken --output text)
  retVal=$?
  echo $retVal
  if [ $retVal -eq 255 ]; then
    aws sso login
    export POETRY_HTTP_BASIC_SENTRA_LIBRARIES_PASSWORD=$(aws codeartifact get-authorization-token --domain-owner 413014485471 --domain sentra-code-artifact-staging --query authorizationToken --output text)
  fi
  export POETRY_HTTP_BASIC_SENTRA_LIBRARIES_PASSWORD
}

# bun completions
# [ -s "/Users/piotrostr/.bun/_bun" ] && source "/Users/piotrostr/.bun/_bun"
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"

export PATH="/usr/local/opt/openjdk/bin:$PATH"
# export JAVA_HOME=$(/usr/libexec/java_home)

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform terraform
# export JAVA_HOME="/opt/homebrew/opt/openjdk@25"

# pnpm
export PNPM_HOME="/Users/piotrostr/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

alias aws-staging='AWS_PROFILE=agent-production aws'
alias aws-production='AWS_PROFILE=agent-staging aws'

# Slack PR notifications
export PATH="/Users/piotrostr/ambush/slackutils:$PATH"

createpr() {
    git push -u origin HEAD && gh pr create --fill
}
alias cl=createpr

merge() {
    gh pr merge --squash && git checkout main && git pull
}

tag() {
    git tag -l --sort=-version:refname | head -1
}
fpath=($fpath "/Users/piotrostr/.zfunctions")

