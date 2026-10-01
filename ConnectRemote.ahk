#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent

; Uncomment ONLY if the target application runs as Administrator
; (otherwise Windows UIPI silently blocks our clicks):
; #RequireAdmin

CoordMode("Pixel", "Screen")
CoordMode("Mouse", "Screen")
CoordMode("ToolTip", "Screen")

; ================= SETTINGS =================

; How often the screen is scanned, in milliseconds. 1000 = once per second.
ScanIntervalMs := 1000

; Minimum gap between two clicks, in milliseconds.
; Prevents hammering the same target while it is still on screen.
ClickCooldownMs := 5000

; Full path of the template image (PNG or BMP recommended).
; IMPORTANT: capture it at the SAME zoom / DPI scaling / theme
; that will be on screen when the script runs.
ImagePath := "A:\ajstyles-github\manage-idle-time\image.png"

; Color tolerance for matching (0-255). 0 = exact pixels only.
; 40 absorbs small rendering differences (fonts, anti-aliasing, themes).
Tolerance := 40

; Minimum time (in ms) the user must be inactive before scanning starts.
; 10000 = 10 seconds of no physical mouse/keyboard activity.
IdleThresholdMs := 10000

; true  = detect only, show tooltip, NEVER click (testing mode)
; false = production mode, real clicks are performed
DryRun := false

; Grace period after wake-from-sleep before scanning resumes (ms).
ResumeGraceMs := 3000

; Back-off delay after a failed scan (screen off / locked session) (ms).
RetryBackoffMs := 3000

; ================= RUNTIME STATE =================

IsPaused      := false
LastClickTick := 0
SkipUntilTick := 0
ImgW := 0
ImgH := 0

; Search region = entire virtual screen (covers every monitor).
SearchX1 := SysGet(76)                  ; SM_XVIRTUALSCREEN
SearchY1 := SysGet(77)                  ; SM_YVIRTUALSCREEN
SearchX2 := SearchX1 + SysGet(78)       ; SM_CXVIRTUALSCREEN
SearchY2 := SearchY1 + SysGet(79)       ; SM_CYVIRTUALSCREEN

; ================= STARTUP =================

if !FileExist(ImagePath) {
    MsgBox("Template image not found:`n" ImagePath, "AutoClicker Error")
    ExitApp()
}

; Read the template's real pixel size once, so every click can
; target its exact center without any manual width/height config.
if !GetImageSize(ImagePath, &ImgW, &ImgH) {
    MsgBox("Template image could not be loaded (corrupt or unsupported):`n" ImagePath, "AutoClicker Error")
    ExitApp()
}

; Listen for Windows power notifications (resume from sleep).
OnMessage(0x218, PowerBroadcast)        ; WM_POWERBROADCAST

SetTimer(ScanAndClick, ScanIntervalMs)

ToolTip("AutoClicker running - will only scan when idle for " IdleThresholdMs "ms", 0, 0)
SetTimer(ClearToolTip, 3000)
return

; ================= HOTKEYS =================

; F9 = pause / resume the auto clicker
F9:: {
    global IsPaused
    IsPaused := !IsPaused
    ToolTip(IsPaused ? "Paused" : "Running", 0, 0)
    SetTimer(ClearToolTip, 1000)
}

; F10 = one-shot diagnostic: run a single search RIGHT NOW and
; report whether the template was found and where it would click.
; (Bypasses the idle check so you can test it anytime)
F10:: {
    global SearchX1, SearchY1, SearchX2, SearchY2, ImgW, ImgH
    fx := 0, fy := 0
    try {
        if ImageSearch(&fx, &fy, SearchX1, SearchY1, SearchX2, SearchY2, BuildSearchParam()) {
            ToolTip(Format("FOUND at {},{}  ->  would click center {},{}",
                           fx, fy, fx + ImgW // 2, fy + ImgH // 2), 0, 0)
        } else {
            ToolTip("NOT FOUND - template does not match anything on screen", 0, 0)
        }
    } catch as err {
        ToolTip("Search error: " err.Message, 0, 0)
    }
    SetTimer(ClearToolTip, 3000)
}

; Esc = exit the script
Esc::ExitApp()

; ================= FUNCTIONS =================

; Builds the ImageSearch parameter, e.g. "*40 C:\img.png"
BuildSearchParam() {
    global Tolerance, ImagePath
    return (Tolerance > 0 ? "*" Tolerance " " : "") ImagePath
}

; Reacts to sleep/resume events so we never scan a dead screen.
PowerBroadcast(wParam, lParam, msg, hwnd) {
    global SkipUntilTick, ResumeGraceMs
    ; 7 = PBT_APMRESUMESUSPEND, 18 = PBT_APMRESUMEAUTOMATIC
    if (wParam = 7 || wParam = 18)
        SkipUntilTick := A_TickCount + ResumeGraceMs
}

; Main worker: find the template, click its center, respect cooldown.
ScanAndClick() {
    global ClickCooldownMs, DryRun, SearchX1, SearchY1, SearchX2, SearchY2
    global IsPaused, LastClickTick, SkipUntilTick, RetryBackoffMs, ImgW, ImgH
    global IdleThresholdMs

    if IsPaused
        return

    ; Skip scanning if the user is actively using the keyboard/mouse.
    ; We use A_TimeIdlePhysical instead of A_TimeIdle so it ignores our own automated clicks!
    if (A_TimeIdlePhysical < IdleThresholdMs)
        return

    ; Screen not ready yet (just woke up / still locked) -> wait.
    if (A_TickCount < SkipUntilTick)
        return

    fx := 0, fy := 0
    found := 0

    ; try/catch = protection against "Error: (6) The handle is invalid",
    ; which Windows throws when the display is off or the session is locked.
    try {
        found := ImageSearch(&fx, &fy, SearchX1, SearchY1, SearchX2, SearchY2, BuildSearchParam())
    } catch {
        SkipUntilTick := A_TickCount + RetryBackoffMs
        return
    }

    if !found
        return

    ; Cooldown: ignore the target for a while after each click.
    now := A_TickCount
    if (LastClickTick != 0 && now - LastClickTick < ClickCooldownMs)
        return
    LastClickTick := now

    ; Click the EXACT CENTER of the matched area.
    ; Size comes from the image file itself - nothing to configure.
    clickX := fx + ImgW // 2
    clickY := fy + ImgH // 2

    if DryRun {
        ToolTip(Format("Found (dry-run): center {},{}", clickX, clickY), 0, 0)
    } else {
        Click(clickX, clickY)
        ToolTip(Format("Clicked {},{}", clickX, clickY), 0, 0)
    }
    SetTimer(ClearToolTip, 1000)
}

; Reads pixel width/height of an image file via GDI+ -> HBITMAP -> GetObject.
GetImageSize(path, &w, &h) {
    hBm := LoadPicture(path, "GDI+", &imageType)
    if !hBm
        return false
    bm := Buffer(32, 0)                 ; sizeof(BITMAP) on x64
    ok := DllCall("GetObject", "Ptr", hBm, "Int", 32, "Ptr", bm)
    if ok {
        w := NumGet(bm, 4, "Int")       ; bmWidth
        h := NumGet(bm, 8, "Int")       ; bmHeight
    }
    DllCall("DeleteObject", "Ptr", hBm)
    return (ok && w > 0 && h > 0)
}

ClearToolTip() {
    ToolTip()
    SetTimer(ClearToolTip, 0)
}