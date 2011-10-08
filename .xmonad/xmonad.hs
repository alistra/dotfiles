import XMonad
import XMonad.Layout.NoBorders
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Util.Run(spawnPipe)
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.Shell
import XMonad.Prompt.Ssh
import XMonad.Actions.Search
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import System.Process(runInteractiveCommand)
import System.Exit
import Data.List
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

myTerminal          = "urxvtc -e tmux"
myBorderWidth       = 1
myBrowser           = "xxxterm"
myMomsBrowser      = "firefox-bin"
duckduckgo          = intelligent $ searchEngine "duckduckgo" "https://duckduckgo.com/?q="
myModMask           = mod4Mask
myNumlockMask       = mod2Mask
myWorkspaces        = map show [1..9]
myNormalBorderColor = "#000000"
myFocusedBorderColor= "#ff0000"

prefixOfElem el = any (isPrefixOf el)

tmuxAttachSession tc s = io $ if s `prefixOfElem` tc
        then spawn ("urxvtc -e tmux attach -t " ++ s)
        else spawn ("urxvtc -e tmux new-session -s " ++ s)

tmuxCompletion = do
    (stdin, stdout, stderr, ph) <- runInteractiveCommand "tmux-init 1>/dev/null; tmux list-sessions|cut -f1 -d:"
    contents <- hGetContents stdout
    return $ lines contents

tmuxAttachPromptCompl config= do
    tc <- io tmuxCompletion
    inputPromptWithCompl config "tmux attach" (mkComplFunFromList' tc) ?+ tmuxAttachSession tc

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    , ((0,             xK_F1    ), spawn $ XMonad.terminal conf)

    , ((0,             xK_F2    ), shellPrompt defaultXPConfig)

    , ((0,             xK_F3    ), tmuxAttachPromptCompl defaultXPConfig)

    , ((0,             xK_F4    ), spawn myBrowser)

    , ((0,             xK_F12   ), spawn myMomsBrowser)

    , ((0,             xK_F6    ), promptSearchBrowser greenXPConfig myBrowser duckduckgo)

    , ((0,             xK_F7    ), promptSearchBrowser greenXPConfig myBrowser wikipedia)

    , ((0,             xK_F8    ), selectSearchBrowser myBrowser duckduckgo)

    , ((0,             xK_Print ), spawn "scrot '%Y-%m-%d_%R:%S_$wx$h_scrot.png'")

    , ((0,             xf86AudioLowerVolume ), spawn "amixer -c 0 -- sset Master playback 5%- unmute&")

    , ((0,             xf86AudioRaiseVolume ), spawn "amixer -c 0 -- sset Master playback 5%+ unmute&")

    , ((0,             xf86AudioMute ), spawn "amixer -c 0 -- sset Master mute&")

    -- close focused window
    , ((modMask,               xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modMask,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modMask,               xK_n     ), refresh)

    , ((modMask,               xK_Tab   ), windows W.focusDown)
    , ((modMask,               xK_j     ), windows W.focusDown)
    , ((modMask .|. shiftMask, xK_Tab   ), windows W.focusUp)
    , ((modMask,               xK_k     ), windows W.focusUp)

    -- Swap the focused window and the master window
    , ((modMask,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modMask,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modMask,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))

    -- toggle the status bar gap
    -- TODO, update this binding with avoidStruts , ((modMask              , xK_b     ),

    -- Quit xmonad
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modMask              , xK_q     ), restart "xmonad" True)
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    where  xf86AudioLowerVolume = 0x1008ff11
           xf86AudioMute        = 0x1008ff12
           xf86AudioRaiseVolume = 0x1008ff13



------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), \w -> focus w >> mouseMoveWindow w)

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), \w -> focus w >> windows W.swapMaster)

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), \w -> focus w >> mouseResizeWindow w)

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

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
myLayout = avoidStruts $ smartBorders $ tiled ||| Mirror tiled ||| Full
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

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
myManageHook = manageDocks <+> composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "qemu"           --> doFloat
    , className =? "qemu-system-x86_64" --> doFloat
    , className =? "Wine"           --> doFloat
    , className =? "Window"         --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True


------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--
myLogHook xmobar = dynamicLogWithPP $ xmobarPP
                { ppOutput = hPutStrLn xmobar
        , ppTitle = xmobarColor "white" "" . shorten 50
        }

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
        xmobar <- spawnPipe "xmobar"
        xmonad (defaults xmobar)

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will 
-- use the defaults defined in xmonad/XMonad/Config.hs
-- 
-- No need to modify this.
--
defaults xmobar = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        logHook            = myLogHook xmobar,
        startupHook        = myStartupHook
    }
