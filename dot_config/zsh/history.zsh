## History wrapper
function omz_history {
  local clear list
  zparseopts -E c=clear l=list

  if [[ -n "$clear" ]]; then
    echo -n >| "$HISTFILE"
    fc -p "$HISTFILE"
    echo >&2 "History file deleted."
  elif [[ -n "$list" ]]; then
    builtin fc "$@"
  else
    local timestamp_format="%F %T" # default format 'yyyy-mm-dd hh:mm:ss'
    case ${HIST_STAMPS-} in
      "mm/dd/yyyy") timestamp_format="%m/%d/%Y %T" ;;
      "dd.mm.yyyy") timestamp_format="%d.%m.%Y %T" ;;
      "yyyy-mm-dd") timestamp_format="%F %T" ;;
    esac
    [[ ${@[-1]-} = *[0-9]* ]] && builtin fc -l -t "$timestamp_format" "$@" || builtin fc -l -t "$timestamp_format" "$@" 1
  fi
}
alias history='omz_history'

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
#setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history          # share command history data
setopt inc_append_history_time # command written after the command is finished
