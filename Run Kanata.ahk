SetWorkingDir %A_ScriptDir%

KanataExe := "kanata_windows_tty_winIOv2_x64.exe"
ConfigFile := "kanata.kbd"

; Run, "%KanataExe%" --cfg "%ConfigFile%"
Run, wt.exe -w 0 new-tab -d "%A_ScriptDir%" cmd /k ""%KanataExe%" --cfg "%ConfigFile%""

MsgBox, 64, Kanata Status, Kanata wurde gestartet!, 2

WinWait, ahk_exe PccNt.exe, , 5 ; Wartet max. 5 Sekunden
if (!ErrorLevel) {
    WinActivate, ahk_exe PccNt.exe
    Sleep, 200
    Send, +{Tab}
    Sleep, 100
    Send, {Enter}
}

/*
zum debuggen dieser befehl zum starten in cmd
kanata_windows_gui_winIOv2_cmd_allowed_x64.exe --cfg kanata.kbd --debug
================================================================================
ÜBERSICHT DER KANATA EXE-DATEIEN (FÜR DEN ARBEITSRECHNER)
================================================================================

1. winIOv2 Versionen (DEINE WAHL OHNE ADMIN-RECHTE)
   Nutzt den Standard-Windows-Hook (LLHOOK). Benötigt keine Treiberinstallation.

   - kanata_windows_gui_winIOv2_x64.exe
     VORTEILE: Läuft komplett im Hintergrund (kein schwarzes Fenster).
     NACHTEILE: Beenden nur über Task-Manager oder AHK möglich.
     
   - kanata_windows_gui_winIOv2_cmd_allowed_x64.exe
     VORTEILE: Wie oben, erlaubt aber Steuerung über Befehle von außen.
     
   - kanata_windows_tty_winIOv2_x64.exe
     VORTEILE: Öffnet ein Konsolenfenster. Ideal zum Testen (Fehlermeldungen!).
     NACHTEILE: Fenster muss offen bleiben (kann nerven).

2. Wintercept Versionen (BENÖTIGEN INTERCEPTION-TREIBER & ADMIN)
   Nur nutzbar, wenn "install-interception.exe" erfolgreich ausgeführt wurde.

   - kanata_windows_gui_wintercept_x64.exe
     VORTEILE: Extrem stabil, löst das AltGr-Problem perfekt.
     NACHTEILE: "Zugriff verweigert" ohne installierten Treiber/Admin-Rechte.

3. Begriffe erklärt:
   - gui: Kein Konsolenfenster (silent).
   - tty: Mit Konsolenfenster (für Debugging/Fehlersuche).
   - cmd_allowed: Erlaubt Fernsteuerung der Kanata-Instanz.

EMPFEHLUNG FÜR DICH:
Nutze zuerst die "tty_winIOv2", um zu sehen, ob das Skript lädt. 
Wenn alles läuft, wechsle auf "gui_winIOv2" für den Alltag.
================================================================================
*/
