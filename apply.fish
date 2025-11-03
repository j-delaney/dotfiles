#!/usr/bin/env fish

# Greatly inspired by https://github.com/dbalatero/dotfiles/blob/main/apply

set dotfiles_dir (realpath (dirname (status --current-filename)))

function symlink -a src destination
    set --function full_src_path "$dotfiles_dir/$src"
    mkdir -p (dirname "$destination")
    echo -n "Attempting to symlink $destination -> $full_src_path: "

    if test -e "$destination" # File already exists at destination
        if test -L "$destination" # Destination is a symlink
            set --function existing_link (readlink "$destination")
            if test "$full_src_path" = "$existing_link"
                set_color green; echo "This symlink already exists, skipping!"; set_color normal
            else 
                set_color red; echo "Symlink to \"$existing_link\" already exists at destination"; set_color normal
                ln -s -i "$full_src_path" "$destination"
            end
        else
            set_color red; echo "File already exists at destination"; set_color normal
            ln -s -i "$full_src_path" "$destination"
        end
    else # No file exists at destination
        set_color green; echo "No conflict found"; set_color normal
        ln -s "$full_src_path" "$destination"
    end
end

# Fish
set_color --bold; echo "# Fish"; set_color normal
symlink fish/config.fish "$HOME/.config/fish/config.fish"
for f in fish/functions/*
    symlink $f "$HOME/.config/fish/functions/"(basename $f)
end
for f in fish/conf.d/*
    symlink $f "$HOME/.config/fish/conf.d/"(basename $f)
end

# Git
set_color --bold; echo "# Git"; set_color normal
symlink git/config "$HOME/.config/git/config"
symlink git/config.user "$HOME/.config/git/config.user"

# Karabiner
set_color --bold; echo "# Karabiner"; set_color normal
ln -s -i "$dotfiles_dir/karabiner" ~/.config # https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/

# Hammerspoon
set_color --bold; echo "# Hammerspoon"; set_color normal
for f in hammerspoon/*
    symlink $f "$HOME/.hammerspoon/"(basename $f)
end