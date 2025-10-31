function new-script --argument-names language path
    if test -z "$language"
        or test -z $path
        echo "Usage: new-script <language> <path>"
        return 1
    end

    if test -e $path
        echo "$path already exists. Cannot create it"
        return 1
    end

    set -l preamble ""
    switch $language
        case "bash" "shell" "sh" "zsh"
            set preamble "#!/bin/bash\nset -eu"
        case "ruby" "rb"
            set preamble "#!/usr/bin/env ruby"
        case "fish"
            set preamble "#!/usr/bin/env fish"
        case "*"
            echo "Unrecognized language \"$language\""
            echo "Usage: new-script <language> <path>"
            return 1
    end
    touch $path
    chmod +x $path
    echo -e "$preamble\n" > $path
end

