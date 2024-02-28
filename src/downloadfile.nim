
# ███╗░░░███╗███████╗██╗░░░░░░█████╗░███╗░░██╗░░░░░░░█████╗░░█████╗░██████╗░███████╗░░░██╗░░░██╗██╗░░██╗
# ████╗░████║██╔════╝██║░░░░░██╔══██╗████╗░██║░░░░░░██╔══██╗██╔══██╗██╔══██╗██╔════╝░░░██║░░░██║██║░██╔╝
# ██╔████╔██║█████╗░░██║░░░░░██║░░██║██╔██╗██║█████╗██║░░╚═╝██║░░██║██║░░██║█████╗░░░░░██║░░░██║█████═╝░
# ██║╚██╔╝██║██╔══╝░░██║░░░░░██║░░██║██║╚████║╚════╝██║░░██╗██║░░██║██║░░██║██╔══╝░░░░░██║░░░██║██╔═██╗░
# ██║░╚═╝░██║███████╗███████╗╚█████╔╝██║░╚███║░░░░░░╚█████╔╝╚█████╔╝██████╔╝███████╗██╗╚██████╔╝██║░╚██╗
# ╚═╝░░░░░╚═╝╚══════╝╚══════╝░╚════╝░╚═╝░░╚══╝░░░░░░░╚════╝░░╚════╝░╚═════╝░╚══════╝╚═╝░╚═════╝░╚═╝░░╚═╝



# Autor: https://github.com/MelonCodeUK
# version: 0.0.1
# description: code for the download file.
# buildCommand: nim c -d:release -d:danger --app:lib downloadfile.nim





import puppy
import suru
import strutils
proc downloadfile(url: cstring, path: cstring): cstring {.exportc, dynlib.} =
  try:
    let response = get($url)
    if response.code == 404:
      echo "404: Page not found"
      return "404"
    elif response.code == 12007:
      echo "12007: Check your internet connection and try again"
      return "12007"
    else:
      var desc = response.headers["Content-Disposition"]
      let filename = desc.split("=")[1]
      # echo type(response.body)
      var file = open($path & "/" & filename, fmWrite)
      for i in suru(response.body):
        file.write(i)
        discard
      return $path & "/" & filename
  except:
    var err = getCurrentExceptionMsg()
    if err == "WinHttpSendRequest error: 12007":
      echo "12007: Check your internet connection and try again"
      return "12007: Check your internet connection and try again"
    else:
      echo err
      return "err"