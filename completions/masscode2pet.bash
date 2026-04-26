# Bash completion for masscode2pet
# Source: ~/.dotfile/completions/masscode2pet.bash

_masscode2pet() {
  local cur opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  opts="--vault --pet-file --max-lines --show-conflicts --dry-run --sync --help"

  case "${COMP_WORDS[COMP_CWORD-1]}" in
    --vault)
      COMPREPLY=($(compgen -d -- "$cur"))
      return 0
      ;;
    --pet-file)
      COMPREPLY=($(compgen -f -- "$cur"))
      return 0
      ;;
    --max-lines)
      return 0
      ;;
  esac

  COMPREPLY=($(compgen -W "$opts" -- "$cur"))
}

complete -F _masscode2pet masscode2pet
