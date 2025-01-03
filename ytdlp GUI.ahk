#Requires AutoHotkey v2.0
#NoTrayIcon

; **********************Gui zone*******************************************

yt := Gui()
yt.Opt("-DPIScale") yt.MarginX := 0 yt.MarginY := 5 yt.OnEvent("Close", (*) => ExitApp())
yt.AddText "w48 h24 ", "yt-dlp "
;搜索框的展示与数据获取
weburl := yt.AddEdit("yp w780 h24 vedit1", "please input some message!")
Down := yt.AddButton("Default w80 h24 yp", "下载")
toggle:=yt.AddCheckbox("w95 h24 yp -Wrap","禁用快捷键") 
toggle.Value:=0
yt.Show("w1440 h800")

; **********************Gui event********************************************
Down.OnEvent("Click", Downlo)

Downlo(*) {
    temp := "yt-dlp " temp .= weburl.Text
    MsgBox toggle.Value
    Run("cmd /c timeout /t 2",A_WorkingDir . "/Download" )
}


waitforclip(datatype) {
    if InStr(A_Clipboard, "https://") || InStr(A_Clipboard, "http://")
        weburl.Text := A_Clipboard
    else return
}
OnClipboardChange waitforclip

; #HotIf (toggle.Value=0)
#HotIf toggle.Value=0
~^Space:: Downlo()
#HotIf