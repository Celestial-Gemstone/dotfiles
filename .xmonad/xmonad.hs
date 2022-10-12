import XMonad

import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.WindowNavigation
import XMonad.Layout.Grid
import XMonad.Layout.Master

import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Util.Cursor

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.WindowSwallowing


myTerminal           = "alacritty"
myBrowser            = "firefox"


myFocusFollowsMouse  = True
myClickJustFocuses   = False

myBorderWidth        = 0

myModMask            = mod4Mask

myWorkspaces         = ["dev", "web", "discord", "music", "games", "misc", "parking"]

myNormalBorderColor  = "#ffffff"
myFocusedBorderColor = "#308fc0"


-- key bindings
myKeys conf = M.unions $ (M.fromList numKeys) : all 
    where
        all = mkKeymap conf keys
       
        keys = 
	  [ ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +3%")
          , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -3%")
          , ( "<XF86AudioMute>"      , spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
          , ("M-w", kill)
	  , ("<Print>", spawn "flameshot gui")
	  , ("M-l", spawn "~/.config/rofi/powermenu/type-2/powermenu.sh")
	  , ("M-f", sendMessage NextLayout)
	  , ("M-S-k", setLayout $ XMonad.layoutHook conf)
	  , ("M-n", refresh)
	  , ("M-S-m", windows W.swapMaster)
	  , ("M-S-<L>", sendMessage Shrink)
	  , ("M-S-<R>", sendMessage Expand)
	  , ("M-p", sendMessage NextLayout)
	  , ("M-t", withFocused $ windows . W.sink)
	  , ("M-<Return>", spawn $ XMonad.terminal conf)
	  , ("M-<Space>", spawn "~/.config/rofi/launchers/type-1/launcher.sh")
          , ("M-m", windows W.focusMaster)
	   ] ++ map (\(c, d) -> (c, sendMessage $ Go d)) [
	   ("M-<L>", L),
	   ("M-<R>", R),
	   ("M-<U>", U),
	   ("M-<D>", D)
           ]
    

        numKeys = [((m .|. (modMask conf), k), windows $ f i)
            | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
            , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]


        metaControl = [ 
            ("M-S-q", io (exitWith ExitSuccess)),
            ("M-q", spawn "xmonad --recompile; xmonad --restart")
            ]


myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    [ ((modm, button1), (\w ->
      do focus w
         mouseMoveWindow w
         windows W.shiftMaster))

    , ((modm, button2), (\w ->
      do focus w
         windows W.shiftMaster))

    , ((modm, button3), (\w -> 
      do focus w
         mouseResizeWindow w
         windows W.shiftMaster))
    ]





-- layouts
myLayout = (spacingWithEdge 5 $ tiled ||| gridWithMaster) ||| full
  where
     incr = 1/10
     ratio = 6/10
     
     tiled = smartBorders $ windowNavigation (Tall 1 incr ratio)
     gridWithMaster = smartBorders $ windowNavigation (mastered incr ratio Grid)
     full = noBorders $ Full


-- window rules
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore 
    ]

-- event hook
myEventHook = swallowEventHook (className =? "Alacritty") (return True)

myStartupHook = do
    --spawnOnce "~/.screenlayout/laptopLeft.sh"
    spawnOnce "picom --experimental-backends"
    spawnOnce "dunst"
    spawnOnce "~/.fehbg" 
    setDefaultCursor xC_left_ptr

-- main config
main :: IO ()
main = do
  xm1 <- spawnPipe "xmobar -x 0"
  --xm2 <- spawnPipe "xmobar -x 1"
  xmonad . xmobarProp $ mconfig

mconfig = def {
      -- base
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = dynamicLog,
        startupHook        = myStartupHook
    }

