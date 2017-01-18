#!/usr/bin/env bash
#
# install all files to ~ by symlinking them,
# this way, updating them is as simple as git pull
#
# Author: Dave Eddy <dave@daveeddy.com>
# Date: May 25, 2012
# License: MIT

# makes "defaults" command print to screen
defaults() {
	echo defaults "$@"
	command defaults "$@"
}

# verbose ln, because `ln -v` is not portable
symlink() {
	printf '%40s -> %s\n' "${1/#$HOME/~}" "${2/#$HOME/~}"
	ln -sf "$@"
}

git submodule init
git submodule update

# Link dotfiles
for f in bash_completion bash_profile bashrc gitconfig htoprc jshintrc screenrc tmux.conf vimrc vim; do
	[[ -d ~/.$f ]] && rm -r ~/."$f"
	symlink "$PWD/$f" ~/."$f"
done

# Setup bics
if [[ ! -d ~/.bics ]]; then
	echo 'installing bics'
	bash <(curl -sSL https://raw.githubusercontent.com/bahamas10/bics/master/bics) init
	rm -r ~/.bics/plugins
	symlink "$PWD/bics-plugins" ~/.bics/plugins
fi

# Keyboard shortcuts for Mac OS X
if [[ -d ~/Library ]]; then
	echo 'installing mac keyboard shourtcuts'
	mkdir -p ~/Library/KeyBindings
	symlink "$PWD/DefaultKeyBinding.dict" ~/Library/KeyBindings/DefaultKeyBinding.dict
fi

# Mac OS X homebrew
if [[ $(uname) == 'Darwin' ]]; then
	if ! brew help &> /dev/null; then
		echo 'installing homebrew'
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	else
		echo 'updating homebrew'
		brew update
	fi

	brew install node
	brew install the_silver_searcher
	brew install wget
fi

# Mac OS X NSUserDefaults modifications
# Some based on https://github.com/mathiasbynens/dotfiles/blob/master/.osx
if defaults read com.apple.finder &>/dev/null; then
	echo 'modifying NSUserDefaults'

	# Keyboard: Disable autocorrect
	defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

	# Keyboard: Set a shorter Delay until key repeat
	defaults write -g InitialKeyRepeat -int 15

	# Keyboard: Set a fast keyboard repeat rate
	defaults write -g KeyRepeat -int 2

	# Keyboard: Reenable key repeat for pressing and holding keys
	defaults write -g ApplePressAndHoldEnabled -bool false

	# Finder: Show all extenions
	defaults write -g AppleShowAllExtensions -bool true

	# Global: Minimize on double click
	defaults write -g AppleMiniaturizeOnDoubleClick -bool true

	# Global: Expand save panel by default
	defaults write -g NSNavPanelExpandedStateForSaveMode -bool true
	defaults write -g NSNavPanelExpandedStateForSaveMode2 -bool true

	# Global: Expand print panel by default
	defaults write -g PMPrintingExpandedStateForPrint -bool true
	defaults write -g PMPrintingExpandedStateForPrint2 -bool true

	# Global: Save to disk (not to iCloud) by default
	defaults write -g NSDocumentSaveNewDocumentsToCloud -bool false

	# Global: Disable smart quotes as they’re annoying when typing code
	defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

	# Global: Disable smart dashes as they’re annoying when typing code
	defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

	# Finder: Show ~/Library in finder
	chflags nohidden ~/Library

	# Trackpad: enable tap to click for this user and for the login screen
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -int 1
	defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
	defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
	defaults write -g com.apple.mouse.tapBehavior -int 1

	# Trackpad: map bottom right corner to right-click
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
	defaults -currentHost write -g com.apple.trackpad.trackpadCornerClickBehavior -int 1
	defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool true

	# Trackpad: haptic firm press
	defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 2
	defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 2

	# Trackpad: three finger drag
	defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
	defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

	# Menubar: battery percentage display
	defaults write com.apple.menuextra.battery ShowPercent -bool YES

	# Global: Enable full keyboard access for all controls
	# (e.g. enable Tab in modal dialogs)
	defaults write -g AppleKeyboardUIMode -int 3

	# Global: Use scroll gesture with the Ctrl (^) modifier key to zoom
	defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
	defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

	# Global: Follow the keyboard focus while zoomed in
	defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

	# Printer: Automatically quit printer app once the print jobs complete
	defaults write com.apple.print.PrintingPrefs 'Quit When Finished' -bool true

	# Global: Disable the "Are you sure you want to open this application?" dialog
	defaults write com.apple.LaunchServices LSQuarantine -bool false

	# Finder: Full POSIX path in finder windows
	defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

	# Finder: Show Status bar in Finder
	defaults write com.apple.finder ShowStatusBar -bool true

	# Finder: Show icons for hard drives, servers, and removable media on the desktop
	defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
	defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
	defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
	defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

	# Finder: new windows start at home directory
	defaults write com.apple.finder NewWindowTarget -string PfHm
	defaults write com.apple.finder NewWindowTargetPath -string "file:///$HOME"

	# Finder: only search the current direcotry
	defaults write com.apple.finder FXDefaultSearchScope -string SCcf

	# Dashboard: Disable dashboard
	defaults write com.apple.dashboard mcx-disabled -bool true

	# Mission Control: Don't automatically rearrange Spaces based on most recent use
	defaults write com.apple.dock mru-spaces -bool false

	# Dock: Automatically hide and show the Dock
	defaults write com.apple.dock autohide -bool true

	# Dock: Dock on the left
	defaults write com.apple.dock orientation -string left

	# Hot corners
	# Possible values:
	#  0: no-op
	#  2: Mission Control
	#  3: Show application windows
	#  4: Desktop
	#  5: Start screen saver
	#  6: Disable screen saver
	#  7: Dashboard
	# 10: Put display to sleep
	# 11: Launchpad
	# 12: Notification Center
	# Top left / Top Right screen corner → Mission Control
	defaults write com.apple.dock wvous-tl-corner -int 2
	defaults write com.apple.dock wvous-tl-modifier -int 0
	defaults write com.apple.dock wvous-tr-corner -int 2
	defaults write com.apple.dock wvous-tr-modifier -int 0
	# Bottom right screen corner → Start screen saver
	defaults write com.apple.dock wvous-br-corner -int 5
	defaults write com.apple.dock wvous-br-modifier -int 0
	# Bottom left screen corner → Show Desktop
	defaults write com.apple.dock wvous-bl-corner -int 4
	defaults write com.apple.dock wvous-bl-modifier -int 0

	# Spotlight: don't send stuff to apple
	defaults write com.apple.lookup lookupEnabled -dict-add suggestionsEnabled -bool no

	# Preview: Disable autosave for Preview
	defaults write com.apple.Preview ApplePersistence -bool no

	# Terminal: Fix weird copy+paste with apple terminal
	defaults write com.apple.Terminal CopyAttributesProfile com.apple.Terminal.no-attributes

	# Terminal: use pro theme
	defaults write com.apple.Terminal 'Startup Window Settings' -string Pro
	defaults write com.apple.Terminal 'Default Window Settings' -string Pro

	# Terminal: new tabs use default profile and CWD
	defaults write com.apple.Terminal NewTabSettingsBehavior -int 1
	defaults write com.apple.Terminal NewTabWorkingDirectoryBehavior -int 1

	# Spotlight: Don't index mounted volumes
	echo 'sudo needed to update spotlight settings'
	sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array /Volumes

	echo 'done: killing Dock and Finder'
	killall Dock Finder
fi
