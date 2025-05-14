command -v argocd >/dev/null 2>&1 && { source <(argocd completion zsh); compdef _argocd argocd; }
