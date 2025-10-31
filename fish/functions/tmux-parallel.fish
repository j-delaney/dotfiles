function tmux-parallel \
    --description "Create a tmux session with a window ready to run each line piped in" \
    -a session_name

    # If no session name is given use a random dictionary word for it
    if test -z $session_name
        set session_name (cat /usr/share/dict/words | sort -R | head -n 1)
    end

    set -l first_run "true"
    while read -l line
        set -l parts (string split \t "$line")
        set -l cmd $parts[1]

        set -l window_name "fish"
        if test (count $parts) -eq 2
            set window_name $parts[2]
        else
            set -l found_cluster (echo "$cmd" | grep --extended-regexp --only-matching '(bom|northwest|cmh)\-[4-6]' | string join ',')
            if test -n $found_cluster
                set window_name $found_cluster
            end
        end
    
        if test $first_run = "true"
            tmux new-session -d -s "$session_name" -n "$window_name" fish; or return
            set first_run "false"
        else
            tmux new-window -t "$session_name" -n "$window_name" fish
        end

        tmux send-keys -t "$session_name" "$cmd"
    end

    echo "tmux a -t $session_name"
end