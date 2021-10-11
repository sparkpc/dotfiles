{-#OPTIONS_GHC -Wno-deprecations #-}
--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

-- Imports

import XMonad
import Data.Monoid
import System.Exit
import Data.Maybe (fromJust)
import System.IO (hPutStrLn)
-- Hooks
import XMonad.Hooks.ManageDocks (ToggleStruts(..), avoidStruts, docksEventHook, manageDocks) -- Used for having windows avoid overlaping the bar and to manage the bar/dock.
import XMonad.Hooks.ManageHelpers (doCenterFloat)
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
-- Layouts
import XMonad.Layout.ToggleLayouts as T (toggleLayouts,ToggleLayout(Toggle)) -- Used for toggling layouts
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders (noBorders, smartBorders) -- Layout modifier to remove borders.
import XMonad.Layout.Renamed -- Used for "custom" layouts
import XMonad.Layout.ShowWName -- Used for printing workspace names
import XMonad.Layout.Magnifier
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows
import XMonad.Layout.Maximize (maximize)
import XMonad.Layout.Tabbed 
-- Utils
import XMonad.Util.Run (spawnPipe) -- Used for spawning and running things.
import XMonad.Util.SpawnOnce
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Util.EZConfig(additionalKeysP, additionalMouseBindings)
-- Prompts
-- Actions
import XMonad.Actions.CycleWS (nextScreen, prevScreen)
import XMonad.Actions.GridSelect
import Data.Tree
import qualified XMonad.Actions.TreeSelect as TS
import XMonad.Hooks.WorkspaceHistory
import qualified XMonad.StackSet as T

myTreeConf :: TS.TSConfig a
myTreeConf = TS.TSConfig { TS.ts_hidechildren = False
                           , TS.ts_background   = 0xc2B2A2A
                           , TS.ts_font         = "xft:Ubuntu Sans"
                           , TS.ts_node         = (0xff000000, 0xff50d0db)
                           , TS.ts_nodealt      = (0xff000000, 0xff10b8d6)
                           , TS.ts_highlight    = (0xffffffff, 0xffff0000)
                           , TS.ts_extra        = 0xff000000
                           , TS.ts_node_width   = 200
                           , TS.ts_node_height  = 30
                           , TS.ts_originX      = 0
                           , TS.ts_originY      = 0
                           , TS.ts_indent       = 80
		           , TS.ts_navigate = myTSNav
			 }
myMenu =
  [ Node (TS.TSNode "Youtube" "Youtube Channels" (spawn "firefox youtube.com"))
    [ Node (TS.TSNode "Newest Videos" "" (return ()))
    	[ Node (TS.TSNode "DistroTube"	""	(spawn "firefox https://www.youtube.com/watch?v=34w7KlBAefo&list=UUVls1GmFKf6WlTraIb_IaJg&index=1")) []
	, Node (TS.TSNode "Luke Smith"	""	(spawn "firefox https://www.youtube.com/watch?v=mL9ztTzrY6Y&list=UU2eYFnH61tmytImy1mTYvhA&index=1")) []
	, Node (TS.TSNode "Chris Titus Tech"	""	(spawn "firefox https://www.youtube.com/watch?v=a2L-_MnGGDA&list=UUg6gPGh8HU2U01vaFCAsvmQ&index=1")) []
	, Node (TS.TSNode "Linus Tech Tips"	""	(spawn "firefox https://www.youtube.com/watch?v=LFC2t5I_hLA&list=UUXuqSBlHAE6Xw-yeJA0Tunw&index=1")) [] 
        ]

    , Node (TS.TSNode "DistroTube"	""	(spawn "firefox https://www.youtube.com/channel/UCVls1GmFKf6WlTraIb_IaJg")) []
    , Node (TS.TSNode "Luke Smith"	""	(spawn "firefox https://www.youtube.com/channel/UC2eYFnH61tmytImy1mTYvhA")) []
    , Node (TS.TSNode "Chris Titus Tech"	""	(spawn "firefox https://www.youtube.com/channel/UCg6gPGh8HU2U01vaFCAsvmQ")) []
    , Node (TS.TSNode "Linus Tech Tips"		""	(spawn "firefox https://www.youtube.com/c/LinusTechTips")) [] 
    ]
  ]
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
--
myBrowser="firefox"
tabConf = def { fontName            = "xft:Ubuntu:size=11"
              , activeColor         = "#81A1C1"
              , activeBorderColor   = "#81A1C1"
              , activeTextColor     = "#3B4252"
              , activeBorderWidth   = 0
              , inactiveColor       = "#3B4252"
              , inactiveBorderColor = "#3B4252"
              , inactiveTextColor   = "#ECEFF4"
              , inactiveBorderWidth = 0
              , urgentColor         = "#BF616A"
              , urgentBorderColor   = "#BF616A"
              , urgentBorderWidth   = 0
              }

myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..]
windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myTerminal      = "alacritty"

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Width of the window border in pixels.
--
myBorderWidth   = 1
myTSNav = M.fromList
    [ ((0, xK_Escape), TS.cancel)
    , ((0, xK_Return), TS.select)
    , ((0, xK_space),  TS.select)
    , ((0, xK_Up),     TS.movePrev)
    , ((0, xK_Down),   TS.moveNext)
    , ((0, xK_Left),   TS.moveParent)
    , ((0, xK_Right),  TS.moveChild)
    , ((0, xK_k),      TS.movePrev)
    , ((0, xK_j),      TS.moveNext)
    , ((0, xK_h),      TS.moveParent)
    , ((0, xK_l),      TS.moveChild)
    , ((0, xK_o),      TS.moveHistBack)
    , ((0, xK_i),      TS.moveHistForward)
    ]

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["web","term","sys","vid","mus","code","edit","chat","etc"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#46d9ff"
spawnSelectedGS ::  [(String, String)] -> X ()
spawnSelectedGS lst = gridselect defaultGSConfig lst >>= flip whenJust spawn 
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
pulseCMD = myTerminal ++ " " ++ "-c Pulseterm -e pulsemixer"


myGSapps = [("st", "st"),
	    ("Pulsemixer", "alacritty -e pulsemixer"),
	    ("Newsboat", "alacritty -e newsboat"),
	    ("Ranger", "alacritty -e ranger ~"),
	    ("Cmus", "alacritty -e cmus"),
	    ("Firefox", "firefox"),
            ("PCmanFM", "pcmanfm")]
myGSconfigs = [("XMonad", "alacritty -e nvim ~/.xmonad/xmonad.hs"),
	       ("Zsh",    "alacritty -e nvim ~/.zshrc"),	
	       ("Nvim",    "alacritty -e nvim ~/.config/nvim/init.vim"),	
	       ("Qtile",    "alacritty -e nvim ~/.config/qtile/config.py")]
myKeys :: [(String, X ())]
myKeys = 
    -- Keybindings
    -- Spawn programs
    -- START_KEYS
    [ 
      ("M-<Return>", spawn (myTerminal)) -- Spawn Terminal (Alacritty)
    , ("M-s", spawn (pulseCMD))
    , ("M-<F4>", spawn "killall screenkey || screenkey &")
    , ("M-S-p", spawn "killall pipewire && pipewire &")
    , ("M-d", spawn "dmenu_run -c -bw 5 -l 30 -sb '#005577'") -- Spawn Dmenu
    , ("M-b", spawn (myBrowser))
    , ("M-S-h k", spawn "jarbs-support keys")
    , ("M-p m", spawn "~/projects/scripts/dm/dmenu-man")
    , ("M-S-w", spawn "sxiv -N walsel -t ~/pix/wallpapers/")
    , ("M-w", kill) -- Close a window
    , ("M-f", sendMessage (T.Toggle "nbfull") >> sendMessage ToggleStruts ) -- Toggle "fullscreen"
    , ("M-j", windows W.focusDown) -- Focus next window
    , ("M-k", windows W.focusUp) -- Focus last window
    , ("M-m", windows W.focusMaster) -- Focus the master window
    , ("M-S-<Return>", windows W.swapMaster) -- Swap focused window with master
    , ("M-S-j", windows W.swapDown) -- Move a window down
    , ("M-S-k", windows W.swapUp)  -- Move a window up
    , ("M-h", sendMessage Shrink) -- Shrink master
    , ("M-l", sendMessage Expand) -- Expand master
    , ("M-t", withFocused $ windows . W.sink) -- Make a window tile
    , ("M-;", TS.treeselectAction myTreeConf myMenu) -- Increase windows in the master area
    , ("M-i", sendMessage (IncMasterN 1)) -- Increase windows in the master area
    , ("M-S-d", sendMessage (IncMasterN (-1))) -- Decrease windows in the master area
    -- Monitors
    , ("M-,", prevScreen) -- Focus previous screen
    , ("M-.", nextScreen) -- Focus next screen
    -- Layouts 
    , ("M-<Tab>", sendMessage NextLayout) -- Next layout
    -- Grid Select
    , ("M-g a", spawnSelectedGS myGSapps) -- Grid Select launch programs
    , ("M-g c", spawnSelectedGS myGSconfigs) -- Grid Select configs
    -- Bar
    , ("M-S-b", sendMessage ToggleStruts) -- Toggle Bar
    -- Xmonad
    , ("M-S-q", io (exitWith ExitSuccess)) -- Quit xmonad
    , ("M-q", spawn "xmonad --recompile; xmonad --restart; killall xmobar")]
    -- END_KEYS
    --

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myTabTheme = def { fontName            = "Ubuntu Sans"
                 , activeColor         = "#46d9ff"
                 , inactiveColor       = "#313846"
                 , activeBorderColor   = "#46d9ff"
                 , inactiveBorderColor = "#282c34"
                 , activeTextColor     = "#282c34"
                 , inactiveTextColor   = "#d0d0d0"
                 }

myLayout = avoidStruts $ T.toggleLayouts nbfull $ layouts 
layouts = tall ||| noBorders tabs

tabs = renamed [Replace "tabs"]
	$ tabbed shrinkText tabConf
nbfull  = renamed [Replace "nbfull"]	
	$ noBorders
	$ Full


tall = renamed [Replace "tall"]
	$ smartBorders
	$ mySpacing 6
	$ Tall 1 (3/100) (1/2)
magnitall = renamed [Replace "magnitall"]
	$ magnifier
	$ Tall 1 (3/100) (1/2)


------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "Zathura"	    --> doCenterFloat
    , className =? "Pulseterm"	    --> doCenterFloat
    , resource =? "walsel"	    --> doCenterFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartUpPrograms :: X ()
myStartUpPrograms = do
	spawnOnce "~/.screenlayout/screen.sh &"	
	spawnOnce "wal -i ~/pix/wallpapers &"	
	spawnOnce "setxkbmap -option caps:swapescape &"
--	spawnOnce "~/.fehbg"
	spawnOnce "pulseaudio"
	spawnOnce "xrdb -load ~/.Xresources"
	spawnOnce "picom --experimental-backends --transparent-clipping &"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }

main :: IO ()
main = do 
  xmbar0 <- spawnPipe ("DBUS_SYSTEM_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket DBUS_SESSION_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket xmobar -x 0 $HOME/.config/xmobar/xmobarrc0")
  xmbar1 <- spawnPipe ("DBUS_SYSTEM_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket DBUS_SESSION_BUS_ADDRESS=unix:path=/run/dbus/system_bus_socket xmobar -x 1 $HOME/.config/xmobar/xmobarrc1")

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
  xmonad $ def {
        -- simple stuff
            terminal           = myTerminal,
      focusFollowsMouse  = myFocusFollowsMouse,
      clickJustFocuses   = myClickJustFocuses,
      borderWidth        = myBorderWidth,
      modMask            = myModMask,
      workspaces         = myWorkspaces,
      normalBorderColor  = myNormalBorderColor,
      focusedBorderColor = myFocusedBorderColor,

    -- hooks, layouts
      layoutHook         = showWName' myShowWNameTheme $ myLayout,
      manageHook         = myManageHook <+> manageDocks,
      handleEventHook    = docksEventHook,
      startupHook        = myStartUpPrograms,
      logHook = dynamicLogWithPP $ xmobarPP 
      { ppOutput = \x -> hPutStrLn xmbar0 x
                      >> hPutStrLn xmbar1 x
      		
       , ppCurrent = xmobarColor "#3366cc" "" . wrap "[" "]"
       , ppVisible = xmobarColor  "#6a5e96" ""
       , ppHiddenNoWindows = xmobarColor "#ffffff" ""  
       , ppHidden = xmobarColor "#0099cc" ""
      ,  ppSep = "<fc=#9e9b99> <fn=4>|</fn> </fc>"
       , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]                    -- order of things in xmobar
              }
      } `additionalKeysP` myKeys


      
              -- the following variables beginning with 'pp' are settings for xmobar.

      
