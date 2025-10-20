; Work Activity Script with Smart Idle Detection
; Manual Controls:
; Ctrl+Alt+Shift+M = Start Mouse Scroll + Keyboard
; Ctrl+Alt+Shift+K = Start Mouse Only (Movement + Scroll)  
; Ctrl+Alt+Shift+L = Start Keyboard Only
; Ctrl+Alt+Shift+C = Start All Combined
; Ctrl+Alt+Shift+A = TOGGLE Auto Idle Detection ON/OFF
; Ctrl+Alt+Shift+Z = Emergency Stop

; Global variables
global g_stop_script := false
global g_script_running := false
global g_mouse_move := false
global g_mouse_scroll := false
global g_keyboard := false
global g_auto_mode := false
global g_auto_detection_enabled := false
global g_last_activity_time := A_TickCount
global g_idle_threshold := 30000  ; 30 seconds idle threshold
global g_ignore_next_input := 0   ; Counter to ignore self-generated input

; Initialize idle detection
SetTimer(CheckIdleTime, 5000)

; Start Mouse Scroll + Keyboard
^!+M::
{
    global g_script_running, g_stop_script, g_mouse_scroll, g_keyboard, g_auto_mode
    StopAllActivities()
    g_script_running := true
    g_auto_mode := false
    g_mouse_scroll := true
    g_keyboard := true
    g_stop_script := false
    SetTimer(MouseScrollKeyboardActivity, Random(15000, 45000))
    TrayTip("Activity", "Manual: Mouse Scroll + Keyboard STARTED", 2)
}

; Start Mouse Only (Movement + Scroll)
^!+K::
{
    global g_script_running, g_stop_script, g_mouse_move, g_mouse_scroll, g_auto_mode
    StopAllActivities()
    g_script_running := true
    g_auto_mode := false
    g_mouse_move := true
    g_mouse_scroll := true
    g_stop_script := false
    SetTimer(MouseOnlyActivity, Random(20000, 60000))
    TrayTip("Activity", "Manual: Mouse Only STARTED", 2)
}

; Start Keyboard Only
^!+L::
{
    global g_script_running, g_stop_script, g_keyboard, g_auto_mode
    StopAllActivities()
    g_script_running := true
    g_auto_mode := false
    g_keyboard := true
    g_stop_script := false
    SetTimer(KeyboardOnlyActivity, Random(30000, 90000))
    TrayTip("Activity", "Manual: Keyboard Only STARTED", 2)
}

; Start All Combined
^!+C::
{
    global g_script_running, g_stop_script, g_mouse_move, g_mouse_scroll, g_keyboard, g_auto_mode
    StopAllActivities()
    g_script_running := true
    g_auto_mode := false
    g_mouse_move := true
    g_mouse_scroll := true
    g_keyboard := true
    g_stop_script := false
    SetTimer(CombinedAllActivity, Random(15000, 30000))
    TrayTip("Activity", "Manual: ALL Activities STARTED", 2)
}

; TOGGLE Auto Idle Detection
^!+A::
{
    global g_auto_detection_enabled
    g_auto_detection_enabled := !g_auto_detection_enabled
    
    if (g_auto_detection_enabled) {
        TrayTip("Activity", "Auto Idle Detection ENABLED", 2)
    } else {
        TrayTip("Activity", "Auto Idle Detection DISABLED", 2)
        if (g_auto_mode) {
            StopAllActivities()
        }
    }
}

; Emergency stop with Ctrl+Alt+Shift+Z
^!+Z::
{
    StopAllActivities()
    TrayTip("Activity", "EMERGENCY STOP - All terminated!", 3)
}

; Check idle time and auto-start/stop activities
CheckIdleTime()
{
    global g_last_activity_time, g_idle_threshold, g_script_running, g_auto_mode
    global g_mouse_move, g_mouse_scroll, g_keyboard, g_stop_script, g_auto_detection_enabled
    
    if (!g_auto_detection_enabled) {
        return
    }
    
    current_time := A_TickCount
    idle_time := current_time - g_last_activity_time
    
    if (idle_time > g_idle_threshold and !g_script_running and !g_auto_mode) {
        AutoStartActivities()
    } else if (idle_time < 5000 and g_script_running and g_auto_mode) {
        AutoStopActivities()
    }
}

; Track user activity - SMART version that ignores self-generated input
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
    global g_last_activity_time, g_script_running, g_auto_mode, g_auto_detection_enabled, g_ignore_next_input
    
    ; If we're ignoring self-generated input, decrement counter and return
    if (g_ignore_next_input > 0) {
        g_ignore_next_input -= 1
        return
    }
    
    ; Only process real user input
    if (g_auto_detection_enabled) {
        g_last_activity_time := A_TickCount
        if (g_script_running and g_auto_mode) {
            AutoStopActivities()
        }
    }
}

; Auto-start activities when idle
AutoStartActivities()
{
    global g_script_running, g_stop_script, g_mouse_scroll, g_keyboard, g_auto_mode
    global g_mouse_move, g_last_activity_time, g_auto_detection_enabled
    
    if (!g_auto_detection_enabled) {
        return
    }
    
    StopAllActivities()
    g_script_running := true
    g_auto_mode := true
    g_mouse_move := true
    g_mouse_scroll := true
    g_keyboard := true
    g_stop_script := false
    
    SetTimer(MouseScrollKeyboardActivity, Random(5000, 15000))
}

; Auto-stop activities when user becomes active
AutoStopActivities()
{
    global g_script_running, g_auto_mode, g_auto_detection_enabled
    if (g_script_running and g_auto_mode and g_auto_detection_enabled) {
        StopAllActivities()
    }
}

; Stop all activities function
StopAllActivities()
{
    global g_script_running, g_stop_script, g_mouse_move, g_mouse_scroll, g_keyboard, g_auto_mode
    g_script_running := false
    g_auto_mode := false
    g_mouse_move := false
    g_mouse_scroll := false
    g_keyboard := false
    g_stop_script := true
    SetTimer(MouseScrollKeyboardActivity, 0)
    SetTimer(MouseOnlyActivity, 0)
    SetTimer(KeyboardOnlyActivity, 0)
    SetTimer(CombinedAllActivity, 0)
}

; Mouse Scroll + Keyboard Activity
MouseScrollKeyboardActivity()
{
    global g_stop_script, g_mouse_scroll, g_keyboard
    
    if (g_stop_script) {
        return
    }
   
    activityChoice := Random(1, 2)
    
    if (activityChoice = 1 and g_mouse_scroll) {
        PerformMouseScroll()
    } else if (activityChoice = 2 and g_keyboard) {
        PerformKeyboardActivity()
    }
    
    SetTimer(MouseScrollKeyboardActivity, Random(20000, 60000))
}

; Mouse Only Activity (Movement + Scroll)
MouseOnlyActivity()
{
    global g_stop_script, g_mouse_move, g_mouse_scroll
    
    if (g_stop_script) {
        return
    }
    
    activityChoice := Random(1, 2)
    
    if (activityChoice = 1 and g_mouse_move) {
        PerformMouseMove()
    } else if (activityChoice = 2 and g_mouse_scroll) {
        PerformMouseScroll()
    }
    
    SetTimer(MouseOnlyActivity, Random(30000, 120000))
}

; Keyboard Only Activity
KeyboardOnlyActivity()
{
    global g_stop_script, g_keyboard
    
    if (g_stop_script) {
        return
    }
    
    if (g_keyboard) {
        PerformKeyboardActivity()
    }
    
    SetTimer(KeyboardOnlyActivity, Random(45000, 180000))
}

; Combined All Activity
CombinedAllActivity()
{
    global g_stop_script, g_mouse_move, g_mouse_scroll, g_keyboard
    
    if (g_stop_script) {
        return
    }

    activityChoice := Random(1, 3)
    
    if (activityChoice = 1 and g_mouse_move) {
        PerformMouseMove()
    } else if (activityChoice = 2 and g_mouse_scroll) {
        PerformMouseScroll()
    } else if (activityChoice = 3 and g_keyboard) {
        PerformKeyboardActivity()
    }
    
    SetTimer(CombinedAllActivity, Random(25000, 70000))
}

; Perform Mouse Movement
PerformMouseMove()
{
    MouseGetPos(&currentX, &currentY)
    screenWidth := A_ScreenWidth
    screenHeight := A_ScreenHeight
    
    targetX := currentX + Random(-150, 150)
    targetY := currentY + Random(-100, 100)
    
    targetX := Max(50, Min(targetX, screenWidth - 50))
    targetY := Max(50, Min(targetY, screenHeight - 50))
    
    NaturalMouseMove(currentX, currentY, targetX, targetY)
    Sleep(Random(100, 800))
}

; Perform Mouse Scroll
PerformMouseScroll()
{
    global g_ignore_next_input
    
    ; Set flag to ignore next input events (scroll wheel generates events)
    g_ignore_next_input := 2  ; Ignore next 2 events
    
    scrollCount := Random(2, 6)
    Loop scrollCount {
        if (Random(1, 2) = 1)
            Send("{WheelDown}")
        else
            Send("{WheelUp}")
        Sleep(Random(150, 400))
    }
    Sleep(Random(300, 1500))
}

; Perform Keyboard Activity - MODIFIED to ignore self-generated input
PerformKeyboardActivity()
{
    global g_ignore_next_input
    
    keyChoice := Random(1, 4)
    
    if (keyChoice = 1) {
        funcKeys := ["{F4}", "{F6}"]
        randomKey := funcKeys[Random(1, funcKeys.Length)]
        ; Set flag to ignore the next few input events
        g_ignore_next_input := 1
        Send(randomKey)
    } else if (keyChoice = 2) {
        navKeys := ["{Left}", "{Right}", "{Up}", "{Down}"]
        randomKey := navKeys[Random(1, navKeys.Length)]
        ; Set flag to ignore the next few input events (1 key = 1 event)
        g_ignore_next_input := 1
        Send(randomKey)
    } else if (keyChoice = 3) {
        modKeys := ["{Ctrl down}{Ctrl up}", "{Shift down}{Shift up}", "{Blind}{Alt down}{Tab}{Alt up}"]
        randomKey := modKeys[Random(1, modKeys.Length)]
        ; Estimate how many events this will generate
        if (randomKey = "{Ctrl down}{Ctrl up}" or randomKey = "{Shift down}{Shift up}")
            g_ignore_next_input := 2
        else if (randomKey = "{Blind}{Alt down}{Tab}{Alt up}")
            g_ignore_next_input := 3
        Send(randomKey)
    } else {
        ; Alt+Tab sequence
        g_ignore_next_input := 3  ; Alt down, Tab, Alt up = 3 events
        Send("{Alt down}")
        Sleep(50)
        Send("{Tab}")
        Sleep(100)
        Send("{Alt up}")
    }
    
    Sleep(Random(200, 1200))
}

; Natural mouse movement
NaturalMouseMove(startX, startY, endX, endY)
{
    distance := Sqrt((endX - startX)**2 + (endY - startY)**2)
    steps := Random(50, 120)
    
    Loop steps {
        t := A_Index / steps
        easedT := t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t
        
        x := startX + (endX - startX) * easedT
        y := startY + (endY - startY) * easedT
        
        if (Random(1, 5) = 1) {
            x += Random(-2, 2)
            y += Random(-2, 2)
        }
        
        MouseMove(x, y, Random(0, 2))
        Sleep(Random(10, 40))
    }
}

; Exit script
^!x::ExitApp()

; Helper functions
Max(a, b) {
    return a > b ? a : b
}

Min(a, b) {
    return a < b ? a : b
}

Sqrt(value) {
    return value ** 0.5
}