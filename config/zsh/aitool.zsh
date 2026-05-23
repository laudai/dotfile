# aitool.zsh — Local AI tooling daemons: Anytype + agentmemory
#
# Sourced by ~/.dotfile/config/zsh/zshrc.
# Provides three user-facing functions:
#
#   aitool-up      Start Anytype (GUI app) + agentmemory server (HTTP :3111).
#                  Idempotent — already running services are skipped.
#
#   aitool-down    Quit Anytype + stop agentmemory server cleanly.
#                  Also kills the orphan iii subprocess (agentmemory's
#                  shutdown does not always propagate SIGTERM to children).
#
#   aitool-status  Print "RUNNING" / "stopped" for each service.
#
# Optional autostart: uncomment the two lines at the bottom of this file
# to have aitool-up run on the first interactive shell of each session.

aitool-up() {
  # 1. Anytype (GUI app)
  case "$(uname -s)" in
    Darwin)
      pgrep -f "Anytype.app" >/dev/null || open -a Anytype
      ;;
    Linux)
      pgrep -f "^anytype" >/dev/null \
        || (anytype --no-sandbox &>/tmp/anytype.log &)
      ;;
  esac

  # 2. agentmemory (skip if /livez already responding)
  if ! curl -fsSL --max-time 1 http://localhost:3111/agentmemory/livez >/dev/null 2>&1; then
    # cd to $HOME/.agentmemory before launching the server.
    # WHY: agentmemory's bundled iii-engine config uses RELATIVE paths for state
    # storage (data/state_store.db, data/stream_store/), so the SQLite DB lands
    # in whatever cwd the daemon was started from. Without cd, running aitool-up
    # from ~/.dotai pollutes the dotai repo with a `data/` dir (shows up in
    # `git status`); next time you run from ~ instead, the daemon writes to
    # ~/data/ and "loses" all prior memories because it's looking at the wrong
    # path.
    #
    # The fix mirrors what agentmemory's cloud deploy templates do (Docker
    # entrypoint overrides config to use absolute /data paths). Locally, we
    # achieve the same outcome by anchoring the cwd to a stable, conventional
    # spot — $HOME/.agentmemory, where the daemon already writes its other
    # metadata (engine-state.json, iii.pid, preferences.json).
    #
    # The `(...)` subshell scopes the cd: aitool-up's own cwd doesn't change.
    # `~/.dotai/.gitignore` also has /data/ as defense in depth.
    mkdir -p "$HOME/.agentmemory"
    (cd "$HOME/.agentmemory" \
      && AGENTMEMORY_TOOLS=all nohup agentmemory >/tmp/agentmemory.log 2>&1 &
      disown)
  fi

  echo "[aitool-up] Anytype + agentmemory starting"
}

aitool-down() {
  # 1. Anytype
  case "$(uname -s)" in
    Darwin) osascript -e 'quit app "Anytype"' 2>/dev/null ;;
    Linux)  pkill -TERM -f "^anytype" 2>/dev/null ;;
  esac

  # 2. agentmemory parent + orphan iii subprocess
  pkill -TERM -f "agentmemory" 2>/dev/null
  sleep 1
  pkill -TERM -f "^iii$" 2>/dev/null

  echo "[aitool-down] Anytype + agentmemory stopped"
}

aitool-status() {
  local at_status am_status
  case "$(uname -s)" in
    Darwin) pgrep -f "Anytype.app" >/dev/null && at_status=RUNNING || at_status=stopped ;;
    Linux)  pgrep -f "^anytype" >/dev/null && at_status=RUNNING || at_status=stopped ;;
  esac
  curl -fsSL --max-time 1 http://localhost:3111/agentmemory/livez >/dev/null 2>&1 \
    && am_status=RUNNING || am_status=stopped
  printf "  Anytype:     %s\n  agentmemory: %s\n" "$at_status" "$am_status"
}

# Optional: autostart on first interactive shell of the session.
# Nested shells inherit AITOOL_DEV_AUTOSTART=1 from the parent and skip the call.
# Uncomment to enable:
# [[ -n "$AITOOL_DEV_AUTOSTART" ]] || aitool-up
# export AITOOL_DEV_AUTOSTART=1
