#!/usr/bin/env fish

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

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
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true  # Display full POSIX path as Finder window title
defaults write com.apple.finder _FXSortFoldersFirst -bool true      # Keep folders on top when sorting by name
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf" # When performing a search, search the current folder by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv" # Use list view in all Finder windows by default

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
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true    # Expand save panel by default
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001                  # Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false   # Disable opening and closing window animations
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true       # Expand print panel by default
defaults write com.apple.sound.beep.feedback -int 0                            # Disable sound feedback for keyboard

defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false # Disable auto-correct
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false     # Disable auto-capitalization
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false   # Disable smart-dashes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false  # Disable smart quotes
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false # Disable auto-periods

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
