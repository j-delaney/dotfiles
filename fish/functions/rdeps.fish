function rdeps
    if test (count $argv) -ne 1
        echo "Usage: rdeps <package-path>" >&2
        return 1
    end

    if not set -q JDOME_PATH
        echo "JDOME_PATH is not defined" >&2
        return 1
    end

    if not test -f go.mod
        echo "No go.mod found in current directory" >&2
        return 1
    end

    set -f module (head -n 1 go.mod | awk '{print $2}')
    if test -z "$module"
        echo "Failed to parse module path from go.mod" >&2
        return 1
    end

    set -f rdeps_file "$JDOME_PATH/$module/$argv[1].rdeps"

    if test -e "$rdeps_file"
        cat "$rdeps_file"
    else
        echo "No rdeps file found at $rdeps_file" >&2
        return 1
    end
end
