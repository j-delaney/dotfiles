#!/usr/bin/env fish

# Greatly inspired by https://github.com/dbalatero/dotfiles/blob/main/apply

set dotfiles_dir (realpath (dirname (status --current-filename)))

function symlink -a src destination
    set --function full_src_path "$dotfiles_dir/$src"

    if not test -e "$destination"
        echo "Symlinking $full_src_path -> $destination"
        mkdir -p (dirname "$destination")
        ln -s "$full_src_path" "$destination"
    else 
        echo "[WARN] Skipping symlink $full_src_path -> $destination due to already existing"
    end
end

function force_symlink -a src destination
    set --function full_src_path "$dotfiles_dir/$src"
    echo "Symlinking $full_src_path -> $destination with overwrite"
    mkdir -p (dirname "$destination")
    ln -s -i "$full_src_path" "$destination"
end

# Fish
force_symlink fish/config.fish "$HOME/.config/fish/config.fish"
for f in fish/functions/*
    symlink $f "$HOME/.config/fish/functions/"(basename $f)
end
for f in fish/conf.d/*
    symlink $f "$HOME/.config/fish/conf.d/"(basename $f)
end

# Git
symlink git/config "$HOME/.config/git/config"
symlink git/config.user "$HOME/.config/git/config.user"

# Karabiner
symlink karabiner/karabiner.json "$HOME/.config/karabiner/karabiner.json"