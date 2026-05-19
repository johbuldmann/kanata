#Requires AutoHotkey v2.0
SetWorkingDir(A_ScriptDir)
SendMode("Input") ; Maximale Geschwindigkeit für Tastendrücke

; Dateinamen definieren
GuiExe := "kanata_windows_gui_winIOv2_x64.exe"
TtyExe := "kanata_windows_tty_winIOv2_x64.exe"
ConfigFile := "kanata.kbd"

; FALL 1: Kanata läuft bereits? Dann beenden wir BEIDE Versionen (egal welche läuft)
if ProcessExist(GuiExe) || ProcessExist(TtyExe) {
    if ProcessExist(GuiExe)
        ProcessClose(GuiExe)
    if ProcessExist(TtyExe)
        ProcessClose(TtyExe)

    TrayTip("Kanata wurde beendet.", "Kanata Status", 1)
    Sleep(1500)
    ExitApp()
}

; FALL 2: Starten. Prüfen, ob die Shift-Taste beim Start gehalten wird
if GetKeyState("Shift", "P") {
    ; --- DEBUG-MODUS (Mit Konsole) ---
    FullExePath := A_ScriptDir "\" TtyExe
    FullConfigPath := A_ScriptDir "\" ConfigFile

    try {
        ; Startet die TTY-Version im Debug-Modus (-d) und ohne Delay (-n)
        ; Wir nutzen hier KEIN Hide, damit das Fenster sichtbar bleibt!
        Run('"' FullExePath '" --cfg "' FullConfigPath '" -d')
        TrayTip("Kanata im DEBUG-Modus gestartet!", "Kanata Status", 1)
    } catch Error as err {
        MsgBox("Fehler beim Starten der TTY-Version:`n`n" err.Message, "Startfehler", 16)
    }
} else {
    ; --- NORMALER MODUS (Unsichtbare GUI) ---
    FullExePath := A_ScriptDir "\" GuiExe
    FullConfigPath := A_ScriptDir "\" ConfigFile

    ToolTip("Kanata startete...")
    Sleep(200)
    ToolTip()

    try {
        Run('"' FullExePath '" --cfg "' FullConfigPath '" -n')
        TrayTip("Kanata (GUI) erfolgreich gestartet!", "Kanata Status", 1)
    } catch Error as err {
        MsgBox("Fehler beim Starten der GUI-Version:`n`n" err.Message, "Startfehler", 16)
    }
}

Sleep(1500)
ExitApp()
/*
================================================================================
ÜBERSICHT DER KANATA EXE-DATEIEN & PARAMETER (FÜR ARBEITSRECHNER OHNE ADMIN)
================================================================================

1. WICHTIGE PARAMETER ZUM BESCHLEUNIGEN:
   - --no-init-delay
     Deaktiviert die standardmäßigen 2 Sekunden Wartezeit beim Starten.
     Das spart beim ständigen Wechseln zwischen internen/externen Tastaturen massiv Zeit.

   - Zum Debuggen in der CMD nutzt man:
     kanata_windows_gui_winIOv2_cmd_allowed_x64.exe --cfg kanata.kbd --debug

2. winIOv2 Versionen (DEINE WAHL OHNE ADMIN-RECHTE)
   Nutzt den Standard-Windows-Hook (LLHOOK). Benötigt KEINE Treiberinstallation.

   - kanata_windows_gui_winIOv2_x64.exe
     VORTEILE: Läuft nativ im Hintergrund (kein schwarzes CMD-Fenster).
     NACHTEILE: Beenden nur über Task-Manager oder dieses AHK-Skript möglich.

   - kanata_windows_gui_winIOv2_cmd_allowed_x64.exe
     VORTEILE: Wie oben, erlaubt aber Steuerung über Befehle von außen.

   - kanata_windows_tty_winIOv2_x64.exe
     VORTEILE: Öffnet standardmäßig ein Konsolenfenster. Ideal zum Testen (Fehlermeldungen!).
     NACHTEILE: Das Fenster nervt im Alltag. (Tipp: Wird durch das AHK-"Hide" oben unsichtbar!)

3. Wintercept Versionen (BENÖTIGEN INTERCEPTION-TREIBER & ADMIN)
   Nur nutzbar, wenn "install-interception.exe" erfolgreich ausgeführt wurde.

   - kanata_windows_gui_wintercept_x64.exe
     VORTEILE: Extrem stabil, löst das Windows-AltGr-Problem perfekt.
     NACHTEILE: "Zugriff verweigert" ohne installierten Treiber/Admin-Rechte.

4. Begriffe erklärt:
   - gui: Nativ ohne Konsolenfenster (silent).
   - tty: Mit Konsolenfenster (gut für Fehlersuche).
   - cmd_allowed: Erlaubt Fernsteuerung der Kanata-Instanz.

EMPFEHLUNG FÜR DEN ALLTAG:
Da dieses AHK-Skript das tty-Konsolenfenster über den Parameter "Hide" sowieso unsichtbar
im Hintergrund startet, kannst du beruhigt bei der "tty_winIOv2" bleiben. Sollte deine Config
mal einen Fehler haben, nimmst du das "Hide" im Skript kurz raus, um die Fehlermeldung zu sehen.
================================================================================
*/
