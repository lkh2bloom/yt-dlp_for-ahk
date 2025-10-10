#Requires AutoHotkey v2.0
#NoTrayIcon
#SingleInstance Force
; 今日任务：写一个引导界面来提示下载bin文件里面的文件内容，可以和更新按钮放在一起
if not DirExist("Download")
    DirCreate("Download")
if not DirExist("bin") {
    DirCreate("bin")
    ; 下述列表是打包exe需要的内容，并不运行与脚本之中。
    FileInstall("bin/yt-dlp.exe", "bin/yt-dlp.exe")
    FileInstall("bin/ffmpeg.exe", "bin/ffmpeg.exe")
    FileInstall("bin/ffprobe.exe", "bin/ffprobe.exe")
}

yt := Gui()
yt.Opt("-DPIScale") yt.MarginX := 0 yt.MarginY := 5 yt.OnEvent("Close", (*) => ExitApp())
yt.OnEvent("Escape", (*) => ExitApp())
yt.AddGroupBox("w1100 h100")
yt.AddText("w48 h24 xp5 yp10", "视频网址")
;搜索框的展示与数据获取
; edit1
yt.AddEdit("yp w780 h24 vedit1", "https://www.bilibili.com/video/BV1KnteevEXT?spm_id_from=333.788.videopod.sections&vd_source=8e1125d27ce0192b5bca860631f1ba57")
yt.AddButton("Default w80 h24 yp hp", "下载").OnEvent("Click", Downlo)
Downlo(*) {
    temp := "yt-dlp "
    temp .= ControlGetText("edit1", "视频下载器")
    ; MsgBox toggle.Value
    ; Run("cmd /c timeout /t 2", A_WorkingDir . "/Download") ;两秒后cmd结束的示例。
    Run("cmd /c .\yt-dlp.exe --cookies-from-browser firefox `"" ControlGetText("edit1", "视频下载器") . "`" -P `"../Download`"", A_WorkingDir . "/bin")
}
yt.AddCheckbox("w155 h24 yp -Wrap Checked0", "禁用快捷键:Ctrl+B") ;button3

;还差一个change事件没有写
yt.AddText("xs yp30 w100 border", "查看cookies获取方法").OnEvent("click", cookies_func)
cookies_func(*) {
    MsgBox("打开浏览器插件商店，搜索插件：`n"
        . "`"Get cookies.txt LOCALLY`"" .
        " `n详情请参考：https://github.com/kairi003/Get-cookies.txt-LOCALLY/")
    A_Clipboard := "https://github.com/kairi003/Get-cookies.txt-LOCALLY/"
    MsgBox ("网址已复制到剪切板！`n在浏览器中粘贴打开即可")
}

yt.AddGroupBox("w1060 h64 xs")
yt.AddText("xp5 yp10 w60 h48 0x200 ", "使用命令行操作：")
yt.AddEdit("w800 h48 yp ", "参考说明文档：`nhttps://github.com/yt-dlp/yt-dlp") ;edit3
yt.AddButton("Default w80 h48 yp", "执行").OnEvent("Click", command_func)
command_func(*) {
    ; MsgBox "ok"
    temp := ControlGetText("edit3","视频下载器")
    ; MsgBox temp
    Run(temp)
}
yt.AddText("yp w90", "  使用模板")
;这里最好做成一个复选框，既有分辨率又有其他模式的复合模板
yt.AddComboBox("w90 xp", ["4K视频", "2K视频", "1080P", "720P"])
yt.AddButton("Default w120 xs", "下载必要组件").OnEvent("Click", download_extension)
download_extension(*) {
    ;添加下载网址来进行下载，如果可能可以把打开浏览器变为直接打开下载地址进行下载，
    ; 但是会丢失一定的可定制性以及稳定性
    MsgBox("请将下载文件放入程序的/bin文件夹中`n所需文件有 ffmpeg.exe和ffprobe.exe`n如果使用版本为完整版，必要组件已完成部署。")
    Run("https://www.ffmpeg.org/download.html")
}
yt.AddButton("Default w100 yp", "yt-dlp更新").OnEvent("Click", update)
update(*) {
    Run("cmd  /k .\yt-dlp.exe -U", A_WorkingDir . "/bin")
    ; Run("cmd .\yt-dlp.exe yt-dlp -U")
    ; Run("cmd cd " . "`"" . "bin" . "`"")
}
yt.Title := "视频下载器"
yt.Show("w" A_ScreenWidth * 0.6 "h" A_ScreenHeight * 0.6)

OnClipboardChange waitforclip
waitforclip(datatype) {
    if InStr(A_Clipboard, "https://") || InStr(A_Clipboard, "http://")
        ControlSetText(A_Clipboard, "edit1", "视频下载器")
    else return
}


#HotIf ControlGetChecked("button3", "视频下载器") = 0
~^b:: Downlo()
#HotIf

; DllCall ___ LoadLibrary、wininet\InternetOpen、wininet\InternetOpenUrl、wininet\InternetQueryDataAvailable、
; wininet\InternetReadFile、wininet\InternetCloseHandle、wininet\InternetCloseHandle

; Global wh := ComObject("WinHTTP.WinHTTPRequest.5.1") ;WinHTTP Object Call
; , req := ComObject("MSXML2.XMLHTTP.6.0") ;XMLHTTP Object Call