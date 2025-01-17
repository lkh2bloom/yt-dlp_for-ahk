#Requires AutoHotkey v2.0
#NoTrayIcon
#SingleInstance Force
if not DirExist("Download")
    DirCreate("Download")
if not DirExist("bin") {
    DirCreate("bin")
    FileInstall("yt-dlp.exe", "bin/yt-dlp.exe")
    FileInstall("ffmpeg.exe", "bin/ffmpeg.exe")
    FileInstall("ffprobe.exe", "bin/ffprobe.exe")
}

; **********************Gui zone*******************************************

yt := Gui()
yt.Opt("-DPIScale") yt.MarginX := 0 yt.MarginY := 5 yt.OnEvent("Close", (*) => ExitApp())
yt.AddText "w48 h24 ", "yt-dlp "
;搜索框的展示与数据获取
weburl := yt.AddEdit("yp w780 h24 vedit1", "https://www.bilibili.com/video/BV1KnteevEXT?spm_id_from=333.788.videopod.sections&vd_source=8e1125d27ce0192b5bca860631f1ba57")
Down := yt.AddButton("Default w80 h24 yp hp", "下载")
toggle := yt.AddCheckbox("w150 h24 yp -Wrap", "禁用快捷键:Ctrl+B")

;还差一个change事件没有写
yt.AddText("xs w80", "视频格式：")
outtype := yt.AddComboBox("yp w60", ["mp4", "webm", "avi", "flv", "mkv", "mov"])
yt.AddText("w80 yp -Wrap ", "装载cookies")
yt.AddText("w70  yp Border", "浏览位置").OnEvent("Click", choose_cookies)
cookies:=yt.AddEdit("w500  yp", A_WorkingDir . "bin\cookies.txt")
yt.AddGroupBox("w1400 h480 xs", "从源码提取视频地址")
; yt.AddButton("Default w80 xp5 yp20","ok")
yt.AddText("w40 xp5 yp20 h24 ", "url-:")
crawler_url := yt.AddEdit("yp w780 hp", "https://www.bilibili.com/video/BV1KnteevEXT?spm_id_from=333.788.videopod.sections&vd_source=8e1125d27ce0192b5bca860631f1ba57")
crawler := yt.AddButton("yp w80 Default hp", "源码解析")
crawler.OnEvent("Click", crawlerfun)
crawler_key := yt.AddCheckbox("yp w150 hp -Wrap", "禁用快捷键:Ctrl+F")
crawler_key.Value := 1
crawler_console := yt.AddEdit("xp-915 yp30 w1040 h400 ")
yt.AddGroupBox("w900 h48 xs ")
yt.AddText("xp0 yp0 w60 h48 ", "使用命令行操作：")
yt.AddEdit("w800 h48 yp ", "参考说明文档：`nhttps://github.com/yt-dlp/yt-dlp")
yt.AddText("yp w90","使用模板下载")
;这里最好做成一个复选框，既有分辨率又有其他模式的复合模板
yt.AddComboBox("w80",["4K视频","2K视频","1080P","720P"])
yt.AddButton("Default w80 xs", "检查更新").OnEvent("Click", update)
yt.Title := "视频下载器"
toggle.Value := 0
yt.Show("w1440 h800")

; **********************Gui event********************************************
Down.OnEvent("Click", Downlo)
outtype.Text := "mp4" outtype.OnEvent("Change", (*) => MsgBox("ok"))
Downlo(*) {
    temp := "yt-dlp " temp .= weburl.Text
    ; MsgBox toggle.Value
    ; Run("cmd /c timeout /t 2", A_WorkingDir . "/Download") ;两秒后cmd结束的示例。
    Run("cmd /c .\yt-dlp.exe " . "`"" . weburl.Text . "`" " . "-P " . "`"../Download`"", A_WorkingDir . "/bin")
}

crawlerfun(*) {
    global WinHttp := ComObject("WinHttp.WinHttpRequest.5.1")
    global XmlHttp := ComObject("Msxml2.XMLHTTP.6.0")
}
update(*) {
    Run("cmd  /k .\yt-dlp.exe -U", A_WorkingDir . "/bin")
    ; Run("cmd .\yt-dlp.exe yt-dlp -U")
    ; Run("cmd cd " . "`"" . "bin" . "`"")
}
choose_cookies(*) {
    cookies.Text := FileSelect()
    ;这里记得写一个移动文件事件。 目前写完还没开始测试
    if cookies.Text != ""
        FileCopy(cookies.Text, A_WorkingDir . "/bin")
}
waitforclip(datatype) {
    if InStr(A_Clipboard, "https://") || InStr(A_Clipboard, "http://")
        weburl.Text := A_Clipboard
    else return
}
OnClipboardChange waitforclip

; #HotIf (toggle.Value=0)
#HotIf toggle.Value = 0
~^b:: Downlo()
#HotIf
#HotIf crawler.Value = 0 and WinActive("视频下载器")
~^f:: crawlerfun()
#HotIf

; DllCall ___ LoadLibrary、wininet\InternetOpen、wininet\InternetOpenUrl、wininet\InternetQueryDataAvailable、
; wininet\InternetReadFile、wininet\InternetCloseHandle、wininet\InternetCloseHandle

; Global wh := ComObject("WinHTTP.WinHTTPRequest.5.1") ;WinHTTP Object Call
; , req := ComObject("MSXML2.XMLHTTP.6.0") ;XMLHTTP Object Call
