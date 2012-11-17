import XMonad.Util.Run(spawnPipe)
import XMonad.Util.PasteP
import XMonad.Prompt.Shell
import XMonad.Prompt.Input
import XMonad.Prompt
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Actions.WindowGo
import XMonad.Actions.Volume
import XMonad.Actions.UpdateFocus
import XMonad.Actions.Search
import XMonad.Actions.GridSelect
import XMonad.Actions.CycleWS
import XMonad
import Graphics.X11.Xlib.Misc
import Graphics.X11.Xlib.Extras
import System.Process(runInteractiveCommand)
import System.IO
import System.Exit
import qualified XMonad.StackSet as W
import qualified XMonad.Actions.FlexibleResize as Flex
import qualified Data.Map        as M
import Graphics.X11.ExtraTypes.XF86
import Control.Monad
import Control.Arrow hiding ((|||), (<+>))

myTerminal :: String
myTerminal          = "urxvtc -e tmux"

myBrowser :: String
myBrowser           = "google-chrome"

email :: String
email               = "balicki.aleksander@gmail.com"

email2 :: String
email2              = "wszystkie.inne.byly.zajete@gmail.com"

myMomsBrowser :: String
myMomsBrowser       = "firefox-bin"


myWorkspaces :: [String]
myWorkspaces        = map show ([1..9] :: [Integer])

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    , ((0,                     xK_F1    ), spawn $ XMonad.terminal conf)
    , ((0,                     xK_F2    ), shellPrompt defaultXPConfig)
    , ((0,                     xK_F3    ), tmuxAttachPromptCompl defaultXPConfig)
    , ((0,                     xK_F4    ), spawn myBrowser)
    , ((0,                     xK_F6    ), promptSearchBrowser greenXPConfig myBrowser (intelligent google))
    , ((0,                     xK_F7    ), promptSearchBrowser greenXPConfig myBrowser (intelligent wikipedia))
    , ((0,                     xK_F8    ), selectSearchBrowser myBrowser (intelligent google))
    , ((0,                     xK_F12   ), spawn myMomsBrowser)

    , ((0,                     xK_Print ), spawn "scrot '%Y-%m-%d_%R:%S_$wx$h_scrot.png'")

    , ((0,                     xF86XK_AudioRaiseVolume ), setMute False >> void (raiseVolume 5))
    , ((0,                     xF86XK_AudioLowerVolume ), void $ lowerVolume 5)
    , ((0,                     xF86XK_AudioMute        ), setMute True)

    , ((modMask,               xK_s     ), withDisplay (io . flip ungrabKeyboard currentTime) >> spawn "scrot -s '%Y-%m-%d_%R:%S_$wx$h_scrot.png'")
    , ((modMask,               xK_g     ), goToSelected defaultGSConfig)

    , ((modMask,               xK_a     ), XMonad.Util.PasteP.pasteString "alistra")
    , ((modMask,               xK_m     ), XMonad.Util.PasteP.pasteString email)
    , ((modMask .|. shiftMask, xK_m     ), XMonad.Util.PasteP.pasteString email2)
    , ((modMask,               xK_b     ), XMonad.Util.PasteP.pasteString "Aleksander Balicki")

    , ((modMask,               xK_p     ), pastePassword)

    , ((modMask,               xK_c     ), kill)

    , ((modMask,               xK_space ), sendMessage NextLayout)

    , ((modMask,               xK_Tab   ), windows W.focusUp)
    , ((modMask .|. shiftMask, xK_Tab   ), windows W.focusDown)

    , ((modMask,               xK_Left  ), windows W.focusUp)
    , ((modMask,               xK_Right ), windows W.focusDown)

    , ((modMask .|. shiftMask, xK_Left  ), windows W.swapUp)
    , ((modMask .|. shiftMask, xK_Right ), windows W.swapDown)

    , ((modMask,               xK_Up    ), windows W.focusUp)
    , ((modMask,               xK_Down  ), windows W.focusDown)

    , ((modMask .|. shiftMask, xK_Up    ), windows W.swapUp)
    , ((modMask .|. shiftMask, xK_Down  ), windows W.swapDown)

    , ((modMask,               xK_Return), windows W.swapMaster)

    , ((modMask,               xK_h     ), sendMessage Shrink)
    , ((modMask,               xK_l     ), sendMessage Expand)

    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)

    , ((modMask,               xK_comma ), sendMessage (IncMasterN 1))
    , ((modMask,               xK_period), sendMessage (IncMasterN (-1)))

    , ((modMask .|. shiftMask, xK_q     ), io exitSuccess)
    , ((modMask,               xK_q     ), restart "xmonad" True)

    , ((modMask,               xK_grave ), moveTo Next EmptyWS)
    , ((modMask .|. shiftMask, xK_grave ), shiftTo Next EmptyWS)
    ]
    ++

    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
    where
        tmuxAttachSession tc s = io $ if any (isPrefixOf s) tc
                then spawn ("urxvtc -e tmux attach -t " ++ s)
                else spawn ("urxvtc -e tmux new-session -s " ++ s)

        tmuxCompletion = do
            (_, stdout, _, _) <- runInteractiveCommand "tmux-init 1>/dev/null; tmux list-sessions|cut -f1 -d:"
            contents <- hGetContents stdout
            return $ lines contents

        tmuxAttachPromptCompl config = do
            tc <- io tmuxCompletion
            inputPromptWithCompl config "tmux attach" (mkComplFunFromList' tc) ?+ tmuxAttachSession tc

        pastePassword = do
            cont <- io $ readFile "/home/alistra/.pwdb"
            let keyVals = map (second tail) . map (span (/=':')) . lines $ cont
            let keys = map fst keyVals
            inputPromptWithCompl defaultXPConfig "pass-name" (mkComplFunFromList' keys) ?+
                (\key -> case lookup key keyVals of
                    Nothing -> return ()
                    Just val -> XMonad.Util.PasteP.pasteString val)

myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList
    [ ((modMask, button1), \w -> focus w >> mouseMoveWindow w)
    , ((modMask, button2), \w -> focus w >> windows W.swapMaster)
    , ((modMask, button3), \w -> focus w >> Flex.mouseResizeWindow w)
    ]

myLayout = avoidStruts $ smartBorders $ tiled ||| Mirror tiled ||| Full
  where
    tiled   = Tall nmaster delta ratio
    nmaster = 1
    ratio   = 1/2
    delta   = 3/100

myManageHook :: ManageHook
myManageHook = manageDocks <+> composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "mplayer2"       --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "qemu"           --> doFloat
    , className =? "qemu-system-x86_64" --> doFloat
    , className =? "Wine"           --> doFloat
    , className =? "Window"         --> doFloat
    , className =? "xmessage"       --> doFloat
    , className =? "Xmessage"       --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

myLogHook :: Handle -> X ()
myLogHook xmobar = dynamicLogWithPP $ xmobarPP {
    ppOutput = hPutStrLn xmobar,
    ppTitle = xmobarColor "white" "" . shorten 50
    }

main :: IO ()
main = do
    xmobar <- spawnPipe "xmobar"
    xmonad (defaults xmobar)

defaults xmobar = defaultConfig {
    terminal           = myTerminal,
    focusFollowsMouse  = True,
    borderWidth        = 1,
    modMask            = mod4Mask,
    workspaces         = myWorkspaces,
    normalBorderColor  = "#000000",
    focusedBorderColor = "#ff0000",

    keys               = myKeys,
    mouseBindings      = myMouseBindings,

    layoutHook         = myLayout,
    manageHook         = myManageHook,
    logHook            = myLogHook xmobar,
    startupHook        = adjustEventInput,
    handleEventHook    = focusOnMouseMove
    }
