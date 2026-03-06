function tmux-send
    argparse 'enter' -- $argv
    or return

    if test (count $argv) -ne 2
        echo "Usage: tmux-send [--enter] <session> <text>" >&2
        return 1
    end

    set -f session $argv[1]
    set -f text $argv[2]

    set -f panes (tmux list-panes -s -t $session -F '#{session_name}:#{window_index}.#{pane_index}')
    for pane in $panes
        if set -q _flag_enter
            tmux send-keys -t $pane "$text" Enter
        else
            tmux send-keys -t $pane "$text"
        end
    end
end

function __fish_tmux_sessions -d 'available sessions'
    tmux list-sessions -F "#S"\t"#{session_windows} windows created: #{session_created_string} [#{session_width}x#{session_height}]#{session_attached}" | sed 's/0$//;s/1$/ (attached)/' 2>/dev/null
end

function __fish_tmux_send_needs_session
    set -l args (commandline -opc)
    set -e args[1]
    test (count (string match -rv -- '^-' $args)) -eq 0
end

complete --command tmux-send --no-files --long-option enter -d 'Send Enter keystroke after text'
complete --command tmux-send --no-files --keep-order --condition __fish_tmux_send_needs_session -a "(__fish_tmux_sessions)"