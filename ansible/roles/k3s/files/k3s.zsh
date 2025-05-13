alias k=kubectl

command -v kubectl >/dev/null 2>&1 && source <(kubectl completion zsh)
