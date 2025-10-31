function countdown -a seconds
    if test -z $seconds
        echo "Usage: countdown SECONDS" >&2
        return 1
    end

    if not string match -qr '^\d+$' $seconds
        echo "Error: Please provide a valid positive integer for seconds." >&2
        return 1
    end

    set -f end_time (math (date +%s) + $seconds)
    while true 
        set -f left (math $end_time - (date +%s))
        if test $left -le 0
            break
        end

        printf "\r%d" $left
        sleep 1
    end
    printf "\rCountdown complete!\n"
end