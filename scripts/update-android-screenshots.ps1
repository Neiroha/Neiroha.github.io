param(
  [string]$AndroidSdk = "D:\Programs\Android_SDK",
  [string]$Serial = "emulator-5554",
  [string]$Apk = "D:\Web_Project\Neiroha\build\app\outputs\flutter-apk\app-debug.apk"
)

$ErrorActionPreference = "Stop"

$adb = Join-Path $AndroidSdk "platform-tools\adb.exe"
if (-not (Test-Path $adb)) {
  throw "adb.exe not found under $AndroidSdk"
}
if (-not (Test-Path $Apk)) {
  throw "APK not found: $Apk"
}

function Invoke-Adb {
  & $adb -s $Serial @args
  if ($LASTEXITCODE -ne 0) {
    throw "adb command failed: $args"
  }
}

function Capture-Screenshot {
  param(
    [string]$RemoteName,
    [string]$TargetPath
  )

  Invoke-Adb shell screencap -p "/sdcard/$RemoteName"
  Invoke-Adb pull "/sdcard/$RemoteName" $TargetPath
}

New-Item -ItemType Directory -Force -Path ".codex-temp\android-shots" | Out-Null

Invoke-Adb install -r -d $Apk
Invoke-Adb shell pm clear com.neiroha.neiroha
Invoke-Adb shell monkey -p com.neiroha.neiroha -c android.intent.category.LAUNCHER 1
Start-Sleep -Seconds 8

# Voice Bank overview.
Invoke-Adb shell input tap 330 360
Start-Sleep -Seconds 1
Capture-Screenshot "neiroha-overview.png" "static\img\screenshot_overview.png"

# Quick TTS character inspector.
Invoke-Adb shell input tap 1010 576
Start-Sleep -Seconds 1
Capture-Screenshot "neiroha-quick-tts.png" "static\img\screenshot_quick_tts.png"

# Providers screen.
Invoke-Adb shell input tap 72 1304
Start-Sleep -Seconds 2
Capture-Screenshot "neiroha-providers.png" "static\img\screenshot_providers.png"

# Dialog TTS project list. Open the default sample project when present.
Invoke-Adb shell input tap 72 360
Start-Sleep -Seconds 2
Invoke-Adb shell input tap 500 435
Start-Sleep -Seconds 2
Capture-Screenshot "neiroha-dialog-tts.png" "static\img\screenshot_dialog_tts.png"

Write-Host "Updated wiki screenshots from $Serial at 2560x1600."
