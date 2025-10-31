function cwd -d "Copy the working directory to the clipboard"
    pwd | tr -d '\n' | pbcopy
end