#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================
; Activity Monitor v3 - fixed GUI.Visible + fixed auto mode
; ============================================================
; STARTS HIDDEN in background (tray icon only).
;
; Open dashboard:  double-click tray icon / right-click tray
;                  icon -> Open Dashboard / Ctrl+Alt+Shift+G
; Hover tray icon: see live status (state, mode, uptime)
;
; Ctrl+Alt+Shift+M = Mouse Scroll + Keyboard
; Ctrl+Alt+Shift+K = Mouse Only (move + scroll)
; Ctrl+Alt+Shift+L = Keyboard Only
; Ctrl+Alt+Shift+C = All Combined
; Ctrl+Alt+Shift+A = Toggle Auto Idle Detection
; Ctrl+Alt+Shift+Z = Emergency Stop
; Ctrl+Alt+Shift+G = Show/Hide Dashboard
; Ctrl+Alt+X       = Exit
;
; Optional tray icons: icons/running.ico , icons/stopped.ico
; ============================================================

global g_stop_script := false
global g_script_running := false
global g_mouse_move := false
global g_mouse_scroll := false
global g_keyboard := false
global g_auto_mode := false
global g_auto_detection_enabled := false
global g_last_activity_time := A_TickCount
global g_idle_threshold := 30000
global g_self_input_active := false   ; true while script generates input

global g_mode_name := "Stopped"
global g_start_time := 0
global g_last_icon_state := ""
global g_last_input_display := "--"
global g_last_mouse_x := 0
global g_last_mouse_y := 0

global MainGui := ""
global txtMode := ""
global txtState := ""
global txtUptime := ""
global txtAuto := ""
global txtIdle := ""
global txtLast := ""

CoordMode("Mouse", "Screen")

MouseGetPos(&initX, &initY)
g_last_mouse_x := initX
g_last_mouse_y := initY

BuildUi()          ; built HIDDEN - no window on startup
BuildTrayMenu()

SetTimer(CheckIdleTime, 5000)
SetTimer(UpdateUi, 500)

UpdateUi()

; TrayTip("Activity Monitor", "Running in background.`nRight-click this icon for menu.", 1)

return

; ============================================================
; HOTKEYS
; ============================================================

^!+M::
{
    StartMouseKeyboard()
}

^!+K::
{
    StartMouseOnly()
}

^!+L::
{
    StartKeyboardOnly()
}

^!+C::
{
    StartAll()
}

^!+A::
{
    ToggleAutoDetection()
}

^!+Z::
{
    StopAllActivities()
    TrayTip("Activity", "EMERGENCY STOP - All terminated!", 3)
}

^!+G::
{
    ToggleMainWindow()
}

^!x:: ExitApp()

; ============================================================
; USER INPUT TRACKING
; ============================================================

~LButton::
~RButton::
~MButton::
~WheelUp::
~WheelDown::
~a::
~b::
~c::
~d::
~e::
~f::
~g::
~h::
~i::
~j::
~k::
~l::
~m::
~n::
~o::
~p::
~q::
~r::
~s::
~t::
~u::
~v::
~w::
~x::
~y::
~z::
~1::
~2::
~3::
~4::
~5::
~6::
~7::
~8::
~9::
~0::
~Space::
~Enter::
~Backspace::
~Delete::
~Esc::
~Tab::
~Up::
~Down::
~Left::
~Right::
~F1::
~F2::
~F3::
~F4::
~F5::
~F6::
~F7::
~F8::
~F9::
~F10::
~F11::
~F12::
~Ctrl::
~Alt::
~Shift::
{
    UpdateUserActivity()
}

; ============================================================
; DASHBOARD UI
; ============================================================

BuildUi()
{
    global MainGui, txtMode, txtState, txtUptime, txtAuto, txtIdle, txtLast

    MainGui := Gui("+MinSize520x670", "Activity Monitor Dashboard")
    MainGui.SetFont("s10", "Segoe UI")

    MainGui.Add("GroupBox", "x14 y12 w492 h200", "Current status")

    MainGui.Add("Text", "x30 y44 w160", "Mode:")
    txtMode := MainGui.Add("Text", "x200 y44 w290", "Stopped")

    MainGui.Add("Text", "x30 y72 w160", "State:")
    txtState := MainGui.Add("Text", "x200 y72 w290", "STOPPED")
    txtState.SetFont("bold")

    MainGui.Add("Text", "x30 y100 w160", "Running for:")
    txtUptime := MainGui.Add("Text", "x200 y100 w290", "--")

    MainGui.Add("Text", "x30 y128 w160", "Auto idle detection:")
    txtAuto := MainGui.Add("Text", "x200 y128 w290", "Off")

    MainGui.Add("Text", "x30 y156 w160", "Idle time:")
    txtIdle := MainGui.Add("Text", "x200 y156 w290", "0 sec")

    MainGui.Add("Text", "x30 y184 w160", "Last real input:")
    txtLast := MainGui.Add("Text", "x200 y184 w290", "--")

    MainGui.Add("GroupBox", "x14 y224 w492 h112", "Start activity")

    MainGui.Add("Button", "x30 y252 w224 h34", "Mouse Scroll + Keyboard").OnEvent("Click", StartMouseKeyboardCallback)
    MainGui.Add("Button", "x266 y252 w224 h34", "Mouse Only").OnEvent("Click", StartMouseOnlyCallback)
    MainGui.Add("Button", "x30 y292 w224 h34", "Keyboard Only").OnEvent("Click", StartKeyboardOnlyCallback)
    MainGui.Add("Button", "x266 y292 w224 h34", "All Combined").OnEvent("Click", StartAllCallback)

    MainGui.Add("GroupBox", "x14 y348 w492 h70", "Controls")

    MainGui.Add("Button", "x30 y370 w224 h34", "Toggle Auto Detection").OnEvent("Click", ToggleAutoCallback)
    MainGui.Add("Button", "x266 y370 w224 h34", "EMERGENCY STOP").OnEvent("Click", StopCallback)

    MainGui.Add("GroupBox", "x14 y430 w492 h222", "Hotkeys and tray help")

    docText := ""
    docText .= "Ctrl+Alt+Shift+M   Start Mouse Scroll + Keyboard`n"
    docText .= "Ctrl+Alt+Shift+K   Start Mouse Only (move + scroll)`n"
    docText .= "Ctrl+Alt+Shift+L   Start Keyboard Only`n"
    docText .= "Ctrl+Alt+Shift+C   Start All Combined`n"
    docText .= "Ctrl+Alt+Shift+A   Toggle Auto Idle Detection`n"
    docText .= "Ctrl+Alt+Shift+Z   Emergency Stop`n"
    docText .= "Ctrl+Alt+Shift+G   Show / Hide this window`n"
    docText .= "Ctrl+Alt+X         Exit script`n"
    docText .= "`n"
    docText .= "TRAY ICON`n"
    docText .= "Double-click ..... Open dashboard`n"
    docText .= "Hover ............ See live status + uptime`n"
    docText .= "Right-click ...... Menu (start/stop/exit)`n"
    docText .= "`n"
    docText .= "AUTO MODE`n"
    docText .= "Starts after 30 sec of no real user input.`n"
    docText .= "Stops instantly on any real key/click/mouse move.`n"
    docText .= "`n"
    docText .= "Optional icons: icons/running.ico, icons/stopped.ico"

    txtHelp := MainGui.Add("Edit", "x30 y454 w460 h184 ReadOnly", docText)
    txtHelp.SetFont("s9", "Consolas")

    MainGui.OnEvent("Close", GuiClose)
    ; NOTE: no MainGui.Show() here -> starts hidden in background
}

; ============================================================
; TRAY MENU
; ============================================================

BuildTrayMenu()
{
    A_TrayMenu.Delete()

    A_TrayMenu.Add("Open Dashboard", OpenDashboardCallback)
    A_TrayMenu.Add()
    A_TrayMenu.Add("Start: Mouse Scroll + Keyboard", StartMouseKeyboardCallback)
    A_TrayMenu.Add("Start: Mouse Only", StartMouseOnlyCallback)
    A_TrayMenu.Add("Start: Keyboard Only", StartKeyboardOnlyCallback)
    A_TrayMenu.Add("Start: All Combined", StartAllCallback)
    A_TrayMenu.Add()
    A_TrayMenu.Add("Toggle Auto Idle Detection", ToggleAutoCallback)
    A_TrayMenu.Add("Emergency Stop", StopCallback)
    A_TrayMenu.Add()
    A_TrayMenu.Add("Exit", ExitAppCallback)

    A_TrayMenu.Default := "Open Dashboard"
}

; ============================================================
; CALLBACK WRAPPERS
; ============================================================

OpenDashboardCallback(p1 := "", p2 := "", p3 := "")
{
    ToggleMainWindow()
}

StartMouseKeyboardCallback(p1 := "", p2 := "", p3 := "")
{
    StartMouseKeyboard()
}

StartMouseOnlyCallback(p1 := "", p2 := "", p3 := "")
{
    StartMouseOnly()
}

StartKeyboardOnlyCallback(p1 := "", p2 := "", p3 := "")
{
    StartKeyboardOnly()
}

StartAllCallback(p1 := "", p2 := "", p3 := "")
{
    StartAll()
}

ToggleAutoCallback(p1 := "", p2 := "", p3 := "")
{
    ToggleAutoDetection()
}

StopCallback(p1 := "", p2 := "", p3 := "")
{
    StopAllActivities()
    TrayTip("Activity", "All activities stopped.", 3)
}

ExitAppCallback(p1 := "", p2 := "", p3 := "")
{
    ExitApp()
}

GuiClose(p1 := "", p2 := "", p3 := "")
{
    global MainGui
    MainGui.Hide()
    return true
}

; FIXED: Gui object has no .Visible property in AHK v2
ToggleMainWindow()
{
    global MainGui
    if (DllCall("IsWindowVisible", "Ptr", MainGui.Hwnd))
        MainGui.Hide()
    else
        MainGui.Show()
}

; ============================================================
; STATUS REFRESH (GUI + tray hover tooltip + icon)
; ============================================================

UpdateUi()
{
    global txtMode, txtState, txtUptime, txtAuto, txtIdle, txtLast
    global g_script_running, g_mode_name, g_auto_detection_enabled
    global g_last_activity_time, g_last_input_display, g_start_time
    global g_last_icon_state, g_idle_threshold
    global g_self_input_active, g_last_mouse_x, g_last_mouse_y
    global g_auto_mode

    ; ---- detect REAL mouse movement as user activity ----
    MouseGetPos(&mx, &my)
    moved := (mx != g_last_mouse_x || my != g_last_mouse_y)
    g_last_mouse_x := mx
    g_last_mouse_y := my

    if (moved && !g_self_input_active)
    {
        g_last_activity_time := A_TickCount
        g_last_input_display := A_Hour . ":" . A_Min . ":" . A_Sec
        if (g_auto_detection_enabled && g_script_running && g_auto_mode)
            AutoStopActivities()
    }

    idleSec := Floor((A_TickCount - g_last_activity_time) / 1000)

    if (IsObject(txtMode))
    {
        displayMode := g_mode_name
        if (!g_script_running && g_auto_detection_enabled)
            displayMode := "Stopped - Auto armed (starts after " . Floor(g_idle_threshold / 1000) . "s idle)"

        txtMode.Text := displayMode

        if (g_script_running)
        {
            txtState.Text := "RUNNING"
            txtState.Opt("+c008000")
            txtUptime.Text := FormatUptime(A_TickCount - g_start_time)
        }
        else
        {
            txtState.Text := "STOPPED"
            txtState.Opt("+cCC0000")
            txtUptime.Text := "--"
        }

        txtAuto.Text := g_auto_detection_enabled ? "On" : "Off"
        txtIdle.Text := idleSec . " / " . Floor(g_idle_threshold / 1000) . " sec"
        txtLast.Text := g_last_input_display
    }

    ; ---- Tray hover tooltip: full live details ----
    tip := (g_script_running ? "RUNNING" : "STOPPED") . "`nMode: " . g_mode_name
    if (g_script_running)
        tip .= "`nRunning for: " . FormatUptime(A_TickCount - g_start_time)
    tip .= "`nAuto: " . (g_auto_detection_enabled ? "On" : "Off") . " | Idle: " . idleSec . "s"

    A_IconTip := tip

    ; ---- Tray icon change (optional custom icons) ----
    state := g_script_running ? "Running" : "Stopped"
    if (state != g_last_icon_state)
    {
        runningIcon := A_ScriptDir "\icons\running.ico"
        stoppedIcon := A_ScriptDir "\icons\stopped.ico"

        if (g_script_running)
        {
            if FileExist(runningIcon)
                TraySetIcon(runningIcon, 1, true)
            else
                TraySetIcon()
        }
        else
        {
            if FileExist(stoppedIcon)
                TraySetIcon(stoppedIcon, 1, true)
            else
                TraySetIcon()
        }
        g_last_icon_state := state
    }
}

FormatUptime(ms)
{
    totalSec := Floor(ms / 1000)
    h := Floor(totalSec / 3600)
    m := Floor(Mod(totalSec, 3600) / 60)
    s := Mod(totalSec, 60)
    return Format("{:02}:{:02}:{:02}", h, m, s)
}

; ============================================================
; USER ACTIVITY / AUTO IDLE LOGIC
; ============================================================

UpdateUserActivity()
{
    global g_self_input_active, g_auto_detection_enabled
    global g_last_activity_time, g_last_input_display
    global g_script_running, g_auto_mode

    ; Ignore the script's OWN simulated input completely
    if (g_self_input_active)
        return

    ; Real user input
    g_last_activity_time := A_TickCount
    g_last_input_display := A_Hour . ":" . A_Min . ":" . A_Sec

    if (g_auto_detection_enabled && g_script_running && g_auto_mode)
        AutoStopActivities()
}

CheckIdleTime()
{
    global g_last_activity_time, g_idle_threshold, g_script_running
    global g_auto_mode, g_auto_detection_enabled

    if (!g_auto_detection_enabled)
        return

    idle_time := A_TickCount - g_last_activity_time

    if (idle_time > g_idle_threshold && !g_script_running && !g_auto_mode)
        AutoStartActivities()
    else if (idle_time < 5000 && g_script_running && g_auto_mode)
        AutoStopActivities()
}

AutoStartActivities()
{
    global g_script_running, g_stop_script, g_mouse_scroll, g_keyboard
    global g_auto_mode, g_mouse_move, g_mode_name, g_auto_detection_enabled, g_start_time

    if (!g_auto_detection_enabled)
        return

    StopAllActivities()

    g_script_running := true
    g_auto_mode := true
    g_mouse_move := true
    g_mouse_scroll := true
    g_keyboard := true
    g_stop_script := false
    g_mode_name := "Auto: Idle Detection"
    g_start_time := A_TickCount

    SetTimer(MouseScrollKeyboardActivity, Random(5000, 15000))
    ; TrayTip("Activity", "Auto idle activity started.", 1)
}

AutoStopActivities()
{
    global g_script_running, g_auto_mode, g_auto_detection_enabled
    if (g_script_running && g_auto_mode && g_auto_detection_enabled)
    {
        StopAllActivities()
        ; TrayTip("Activity", "User activity detected. Auto mode stopped.", 1)
    }
}

; ============================================================
; START / STOP MODES
; ============================================================

StartMouseKeyboard()
{
    global g_script_running, g_stop_script, g_mouse_scroll, g_keyboard
    global g_auto_mode, g_mode_name, g_start_time

    StopAllActivities()
    g_script_running := true
    g_auto_mode := false
    g_mouse_scroll := true
    g_keyboard := true
    g_stop_script := false
    g_mode_name := "Mouse Scroll + Keyboard"
    g_start_time := A_TickCount

    SetTimer(MouseScrollKeyboardActivity, Random(15000, 45000))
    TrayTip("Activity", "Started: Mouse Scroll + Keyboard", 2)
}

StartMouseOnly()
{
    global g_script_running, g_stop_script, g_mouse_move, g_mouse_scroll
    global g_auto_mode, g_mode_name, g_start_time

    StopAllActivities()
    g_script_running := true
    g_auto_mode := false
    g_mouse_move := true
    g_mouse_scroll := true
    g_stop_script := false
    g_mode_name := "Mouse Only"
    g_start_time := A_TickCount

    SetTimer(MouseOnlyActivity, Random(20000, 60000))
    TrayTip("Activity", "Started: Mouse Only", 2)
}

StartKeyboardOnly()
{
    global g_script_running, g_stop_script, g_keyboard, g_auto_mode
    global g_mode_name, g_start_time

    StopAllActivities()
    g_script_running := true
    g_auto_mode := false
    g_keyboard := true
    g_stop_script := false
    g_mode_name := "Keyboard Only"
    g_start_time := A_TickCount

    SetTimer(KeyboardOnlyActivity, Random(30000, 90000))
    TrayTip("Activity", "Started: Keyboard Only", 2)
}

StartAll()
{
    global g_script_running, g_stop_script, g_mouse_move, g_mouse_scroll
    global g_keyboard, g_auto_mode, g_mode_name, g_start_time

    StopAllActivities()
    g_script_running := true
    g_auto_mode := false
    g_mouse_move := true
    g_mouse_scroll := true
    g_keyboard := true
    g_stop_script := false
    g_mode_name := "All Combined"
    g_start_time := A_TickCount

    SetTimer(CombinedAllActivity, Random(15000, 30000))
    TrayTip("Activity", "Started: ALL Combined", 2)
}

ToggleAutoDetection()
{
    global g_auto_detection_enabled, g_auto_mode

    g_auto_detection_enabled := !g_auto_detection_enabled

    if (g_auto_detection_enabled)
        TrayTip("Activity", "Auto Idle Detection ENABLED`n(will start after 30s idle)", 1)
    else
    {
        TrayTip("Activity", "Auto Idle Detection DISABLED", 2)
        if (g_auto_mode)
            StopAllActivities()
    }
}

StopAllActivities()
{
    global g_script_running, g_stop_script, g_mouse_move, g_mouse_scroll
    global g_keyboard, g_auto_mode, g_mode_name

    g_script_running := false
    g_auto_mode := false
    g_mouse_move := false
    g_mouse_scroll := false
    g_keyboard := false
    g_stop_script := true
    g_mode_name := "Stopped"

    SetTimer(MouseScrollKeyboardActivity, 0)
    SetTimer(MouseOnlyActivity, 0)
    SetTimer(KeyboardOnlyActivity, 0)
    SetTimer(CombinedAllActivity, 0)
}

; ============================================================
; ACTIVITY TIMERS
; ============================================================

MouseScrollKeyboardActivity()
{
    global g_stop_script, g_mouse_scroll, g_keyboard
    if (g_stop_script)
        return

    activityChoice := Random(1, 2)
    if (activityChoice = 1 && g_mouse_scroll)
        PerformMouseScroll()
    else if (activityChoice = 2 && g_keyboard)
        PerformKeyboardActivity()

    if (g_stop_script)
        return
    SetTimer(MouseScrollKeyboardActivity, Random(20000, 60000))
}

MouseOnlyActivity()
{
    global g_stop_script, g_mouse_move, g_mouse_scroll
    if (g_stop_script)
        return

    activityChoice := Random(1, 2)
    if (activityChoice = 1 && g_mouse_move)
        PerformMouseMove()
    else if (activityChoice = 2 && g_mouse_scroll)
        PerformMouseScroll()

    if (g_stop_script)
        return
    SetTimer(MouseOnlyActivity, Random(30000, 120000))
}

KeyboardOnlyActivity()
{
    global g_stop_script, g_keyboard
    if (g_stop_script)
        return

    if (g_keyboard)
        PerformKeyboardActivity()

    if (g_stop_script)
        return
    SetTimer(KeyboardOnlyActivity, Random(45000, 180000))
}

CombinedAllActivity()
{
    global g_stop_script, g_mouse_move, g_mouse_scroll, g_keyboard
    if (g_stop_script)
        return

    activityChoice := Random(1, 3)
    if (activityChoice = 1 && g_mouse_move)
        PerformMouseMove()
    else if (activityChoice = 2 && g_mouse_scroll)
        PerformMouseScroll()
    else if (activityChoice = 3 && g_keyboard)
        PerformKeyboardActivity()

    if (g_stop_script)
        return
    SetTimer(CombinedAllActivity, Random(25000, 70000))
}

; ============================================================
; ACTIVITY ACTIONS (self-input flag protects auto mode)
; ============================================================

PerformMouseMove()
{
    global g_self_input_active
    g_self_input_active := true

    MouseGetPos(&currentX, &currentY)
    screenWidth := A_ScreenWidth
    screenHeight := A_ScreenHeight

    targetX := currentX + Random(-150, 150)
    targetY := currentY + Random(-100, 100)

    targetX := Max(50, Min(targetX, screenWidth - 50))
    targetY := Max(50, Min(targetY, screenHeight - 50))

    NaturalMouseMove(currentX, currentY, targetX, targetY)
    Sleep(Random(100, 800))

    g_self_input_active := false
}

PerformMouseScroll()
{
    global g_self_input_active
    g_self_input_active := true

    scrollCount := Random(2, 6)
    Loop scrollCount
    {
        if (Random(1, 2) = 1)
            Send("{WheelDown}")
        else
            Send("{WheelUp}")
        Sleep(Random(150, 400))
    }
    Sleep(Random(300, 1500))

    g_self_input_active := false
}

PerformKeyboardActivity()
{
    global g_self_input_active
    g_self_input_active := true

    keyChoice := Random(1, 4)

    if (keyChoice = 1)
    {
        funcKeys := ["{F4}", "{F6}"]
        randomKey := funcKeys[Random(1, funcKeys.Length)]
        Send(randomKey)
    }
    else if (keyChoice = 2)
    {
        navKeys := ["{Left}", "{Right}", "{Up}", "{Down}"]
        randomKey := navKeys[Random(1, navKeys.Length)]
        Send(randomKey)
    }
    else if (keyChoice = 3)
    {
        modKeys := ["{Ctrl down}{Ctrl up}", "{Shift down}{Shift up}", "{Blind}{Alt down}{Tab}{Alt up}"]
        randomKey := modKeys[Random(1, modKeys.Length)]
        Send(randomKey)
    }
    else
    {
        Send("{Alt down}")
        Sleep(50)
        Send("{Tab}")
        Sleep(100)
        Send("{Alt up}")
    }
    Sleep(Random(200, 1200))

    g_self_input_active := false
}

NaturalMouseMove(startX, startY, endX, endY)
{
    steps := Random(50, 120)
    Loop steps
    {
        t := A_Index / steps
        easedT := t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t

        x := startX + (endX - startX) * easedT
        y := startY + (endY - startY) * easedT

        if (Random(1, 5) = 1)
        {
            x += Random(-2, 2)
            y += Random(-2, 2)
        }
        MouseMove(x, y, Random(0, 2))
        Sleep(Random(10, 40))
    }
}