function _setup-defaults-trackpad() {
  # System Settings > Trackpad > Point & Click > Click
  defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
  defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0
  # System Settings > Trackpad > Point & Click > Tap to click
  defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
}

function _setup-defaults-global() {
  defaults write NSGlobalDomain InitialKeyRepeat -int 10
  defaults write NSGlobalDomain KeyRepeat -int 1

  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
  # System Settings > Mouse > Scrolling Speed
  defaults write NSGlobalDomain com.apple.scrollwheel.scaling -float '2.5'
  # System Settings > Mouse > Tracking Speed
  defaults write NSGlobalDomain com.apple.mouse.scaling -float '2.5'
  # System Settings > Mouse > Double-Click Speed
  defaults write NSGlobalDomain com.apple.mouse.doubleClickThreshold -float '0.5'

  # System Settings > Trackpad > Point & Click > Tracking Speed
  defaults write NSGlobalDomain com.apple.trackpad.scaling -float '1.5'
  # System Settings > Trackpad > Scroll & Zoom > Natural Scrolling
  defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

  # System Settings > Apperance > Show scroll bars
  defaults write NSGlobalDomain AppleShowScrollBars -string 'WhenScrolling'

  # Disable all global animations
  # https://gist.github.com/vanities/57171d34b7f458ebc5d24069aafd0c3e
  defaults write NSGlobalDomain NSScrollViewRubberbanding -int 0
  defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
  defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false
  defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
  defaults write NSGlobalDomain QLPanelAnimationDuration -float 0
  defaults write NSGlobalDomain NSScrollViewRubberbanding -bool false
  defaults write NSGlobalDomain NSDocumentRevisionsWindowTransformAnimation -bool false
  defaults write NSGlobalDomain NSToolbarFullScreenAnimationDuration -float 0
  defaults write NSGlobalDomain NSBrowserColumnAnimationSpeedMultiplier -float 0
  defaults write NSGlobalDomain NSWindowResizeTime .001

  defaults write NSGlobalDomain AppleKeyboardUIMode -int 2
}

function _setup-defaults-accessibility() {
  defaults write com.apple.universalaccess reduceMotion -bool true
  defaults write com.apple.universalaccess reduceTransparency -bool true
  defaults write com.apple.universalaccess differentiateWithoutColor -bool true
}

function _setup-defaults-dock() {
  defaults write com.apple.dock autohide-time-modifier -float 0
  defaults write com.apple.dock orientation -string "left"
  defaults write com.apple.dock autohide-delay -float 10000
  defaults write com.apple.dock no-bouncing -bool true
  defaults write com.apple.dock tilesize -float 36 # make dock really small
  defaults write com.apple.dock expose-animation-duration -float 0
  defaults write com.apple.dock springboard-show-duration -float 0
  defaults write com.apple.dock springboard-hide-duration -float 0
  defaults write com.apple.dock springboard-page-duration -float 0
  defaults write com.apple.dock expose-animation-duration -int 0
  defaults write com.apple.dock expose-animation-duration -float 0.1

  # disable all hot corners
  for corner in bl br tl tr
  do
    for opt in corner modifer
    do defaults write com.apple.dock "wvous-${corner}-${opt}" -int 0
    done
  done

  defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

  killall Dock
}

function _setup-defaults-finder() {
  defaults write com.apple.finder DisableAllAnimations -bool true
  defaults write com.apple.finder QuitMenuItem -bool false

  killall Finder
}

function _setup-defaults-mail() {
  defaults write com.apple.Mail DisableSendAnimations -bool true
  defaults write com.apple.Mail DisableReplyAnimations -bool true

  killall Mail
}

function _setup-defaults-screencapture() {
  mkdir -p "$HOME/Screenshots"
  defaults write com.apple.screencapture show-thumbnail -bool true
  defaults write com.apple.screencapture location -string "$HOME/Screenshots"
  killall SystemUIServer
}


function setup-defaults() {
  local all_defaults=(
    global
    dock
    finder
    trackpad
    mail
    screencapture
    accessibility
  )

  while true; do
    if [[ $# -eq 0 ]]
    then
      for opt in $all_defaults
      do "_setup-defaults-$opt"
      done
      break
    fi

    case "$1" in
     global|dock|finder|trackpad|mail|screencapture|accessibility)
      "_setup-defaults-$1" ;;
    esac
    shift
  done

  echo -e 'For changes to take effect the user needs to be logged out.'
  vared -p 'Press Y to preceed... ' -c REPLY

  if [[ $REPLY == "Y" ]]
    then sudo pkill loginwindow
  fi
}
