# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/jeanuchoa/code/overol-parsers/google-cloud-sdk/path.zsh.inc' ]; then . '/home/jeanuchoa/code/overol-parsers/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/home/jeanuchoa/code/overol-parsers/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/jeanuchoa/code/overol-parsers/google-cloud-sdk/completion.zsh.inc'; fi

#configure zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# configure fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh
