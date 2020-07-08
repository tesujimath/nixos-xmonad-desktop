import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import qualified XMonad.StackSet as W
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys, additionalKeysP, additionalMouseBindings)
import System.IO

myManageHook = composeAll
    [ appName =? "Ediff"       --> doFloat
    , className =? "Gimp-2.8"  --> doFloat
    , className =? "Gpick"     --> doFloat
    , className =? "Sxiv"      --> doFloat
    , className =? "mpv"       --> doFloat
    , className =? "Zathura"   --> doFloat
    , className =? "Rumno-background" --> doFloat <+> hasBorder False
    , className =? "Screenruler.rb"   --> doFloat <+> hasBorder False
    -- for screen recording
    --, className =? "Google-chrome" --> hasBorder False
    , isFullscreen             --> doFullFloat
    ]

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ def
        { manageHook = manageDocks <+> myManageHook <+> manageHook def
        , layoutHook = avoidStruts  $  smartBorders  $  layoutHook def
        , handleEventHook = mconcat
                            [ docksEventHook
                            , fullscreenEventHook
                            , handleEventHook def ]
        , logHook = dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmproc
                    , ppTitle = xmobarColor "#f1eddb" "" . shorten 50
                    }
        , focusFollowsMouse  = True
        , borderWidth        = 4
        , terminal           = "gnome-terminal"
        , normalBorderColor  = "#cccccc"
        , focusedBorderColor = "#ff8c00"
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_l), spawn "lockscreen")
        , ((controlMask, xK_Print), spawn "sleep 0.2 && mkdir -p $HOME/screenshots && cd $HOME/screenshots && scrot -s")
        , ((0, xK_Print), spawn "mkdir -p $HOME/screenshots && cd $HOME/screenshots && scrot")
        , ((mod4Mask, xK_o), spawn "dmenu_run -fn xft:cantarell:pixelsize=16")
        , ((mod4Mask .|. shiftMask, xK_o), spawn "gmrun")
        , ((mod4Mask, xK_p), spawn "cycle-video-output")
        ] `additionalKeysP`
        [ ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
        , ("<XF86AudioRaiseVolume>", spawn "audio-volume +5%")
        , ("<XF86AudioLowerVolume>", spawn "audio-volume -5%")
        , ("<XF86MonBrightnessUp>", spawn "mon-brightness -A 5")
        , ("<XF86MonBrightnessDown>", spawn "mon-brightness -U 5")
        ] `additionalMouseBindings`
        [ ((mod4Mask .|. shiftMask, button1), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster) ]
