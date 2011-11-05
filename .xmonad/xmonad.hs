import XMonad
import XMonad.Layout.NoBorders
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.Shell
import XMonad.Actions.Search
import XMonad.Actions.UpdateFocus
import XMonad.Actions.FindEmptyWorkspace
import qualified XMonad.Actions.FlexibleResize as Flex
import System.IO
import System.Process(runInteractiveCommand)
import System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

myTerminal :: String
myTerminal          = "urxvtc -e tmux"

myBorderWidth :: Dimension
myBorderWidth       = 1

myBrowser :: String
myBrowser           = "xxxterm"

myMomsBrowser :: String
myMomsBrowser       = "firefox-bin"

scroogle :: SearchEngine
scroogle          = intelligent $ searchEngine "scroogle" "https://ssl.scroogle.org/cgi-bin/nbbwssl.cgi?Gw="

myModMask :: KeyMask
myModMask           = mod4Mask

myNumlockMask :: KeyMask
myNumlockMask       = mod2Mask

myWorkspaces :: [String]
myWorkspaces        = map show [1::Integer .. 9::Integer]

myNormalBorderColor :: String
myNormalBorderColor = "#000000"

myFocusedBorderColor :: String
myFocusedBorderColor= "#ff0000"

myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    , ((0,                     xK_F1    ), spawn $ XMonad.terminal conf)
    , ((0,                     xK_F2    ), shellPrompt defaultXPConfig)
    , ((0,                     xK_F3    ), tmuxAttachPromptCompl defaultXPConfig)
    , ((0,                     xK_F4    ), spawn myBrowser)
    , ((0,                     xK_F6    ), promptSearchBrowser greenXPConfig myBrowser scroogle)
    , ((0,                     xK_F7    ), promptSearchBrowser greenXPConfig myBrowser wikipedia)
    , ((0,                     xK_F8    ), selectSearchBrowser myBrowser scroogle)
    , ((0,                     xK_F12   ), spawn myMomsBrowser)

    , ((0,                     xK_Print ), spawn "scrot '%Y-%m-%d_%R:%S_$wx$h_scrot.png'")

    , ((0,                     xf86AudioLowerVolume ), spawn "amixer -c 0 -- sset Master playback 5%- unmute&")
    , ((0,                     xf86AudioRaiseVolume ), spawn "amixer -c 0 -- sset Master playback 5%+ unmute&")
    , ((0,                     xf86AudioMute ), spawn "amixer -c 0 -- sset Master mute&")

    , ((modMask,               xK_c     ), kill)

    , ((modMask,               xK_space ), sendMessage NextLayout)
    , ((modMask,               xK_n     ), refresh)

    , ((modMask,               xK_Tab   ), windows W.focusDown)
    , ((modMask,               xK_j     ), windows W.focusDown)
    , ((modMask .|. shiftMask, xK_Tab   ), windows W.focusUp)
    , ((modMask,               xK_k     ), windows W.focusUp)

    , ((modMask,               xK_Return), windows W.swapMaster)
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )

    , ((modMask,               xK_h     ), sendMessage Shrink)
    , ((modMask,               xK_l     ), sendMessage Expand)

    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)

    , ((modMask,               xK_comma ), sendMessage (IncMasterN 1))
    , ((modMask,               xK_period), sendMessage (IncMasterN (-1)))

    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
    , ((modMask,               xK_q     ), restart "xmonad" True)

    , ((modMask,               xK_grave ), viewEmptyWorkspace)
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
        xf86AudioLowerVolume = 0x1008ff11
        xf86AudioMute        = 0x1008ff12
        xf86AudioRaiseVolume = 0x1008ff13
        tmuxAttachSession tc s = io $ if s `prefixOfElem` tc
                then spawn ("urxvtc -e tmux attach -t " ++ s)
                else spawn ("urxvtc -e tmux new-session -s " ++ s)

        tmuxCompletion :: IO [String]
        tmuxCompletion = do
            (_, stdout, _, _) <- runInteractiveCommand "tmux-init 1>/dev/null; tmux list-sessions|cut -f1 -d:"
            contents <- hGetContents stdout
            return $ lines contents

        tmuxAttachPromptCompl config= do
            tc <- io tmuxCompletion
            inputPromptWithCompl config "tmux attach" (mkComplFunFromList' tc) ?+ tmuxAttachSession tc

        prefixOfElem :: Eq a => [a] -> [[a]] -> Bool
        prefixOfElem el = any (isPrefixOf el)


myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $
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
    borderWidth        = myBorderWidth,
    modMask            = myModMask,
    numlockMask        = myNumlockMask,
    workspaces         = myWorkspaces,
    normalBorderColor  = myNormalBorderColor,
    focusedBorderColor = myFocusedBorderColor,

    keys               = myKeys,
    mouseBindings      = myMouseBindings,

    layoutHook         = myLayout,
    manageHook         = myManageHook,
    logHook            = myLogHook xmobar,
    startupHook        = adjustEventInput,
    handleEventHook    = focusOnMouseMove
    }
