files_to_load=(
  "/usr/share/doc/fzf/examples/completion.zsh"
  #"/usr/share/doc/fzf/examples/key-bindings.zsh"
  "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  "$HOME/code/dotfiles/zsh/machines/$(hostname).sh"
)
for file in "${files_to_load[@]}"; do [ -f "$file" ] && source "$file"; done
