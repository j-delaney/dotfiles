#!/usr/bin/env fish

defaults write .GlobalPreferences AppleShowAllExtensions -bool true

# Disable hot corners (disabled = 1)
defaults write com.apple.dock wvous-tl-corner -int 1
defaults write com.apple.dock wvous-tr-corner -int 1
defaults write com.apple.dock wvous-bl-corner -int 1
defaults write com.apple.dock wvous-br-corner -int 1

# Finder settings
defaults write com.apple.finder AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true # Display full POSIX path as Finder window title

# Dock settings
defaults write com.apple.dock autohide-delay -float 0.0
defaults write com.apple.dock autohide-time-modifier -float 0.25
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock expose-animation-duration -float 0.0
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock no-bouncing -bool true # Disable Dock bouncing

# NSGlobalDomain settings
defaults write NSGlobalDomain KeyRepeat -int 2 # Fastest key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false             # Disable hold to bring up accent letters
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3                       # Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleFontSmoothing -int 2                        # Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"             # Always show scrollbars
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false # Disable auto-correct
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true    # Expand save panel by default
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001                  # Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false   # Disable opening and closing window animations
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true       # Expand print panel by default
defaults write com.apple.sound.beep.feedback -int 0                            # Disable sound feedback for keyboard