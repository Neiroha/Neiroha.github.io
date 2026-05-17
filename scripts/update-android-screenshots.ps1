param(
  [string]$AndroidSdk = "D:\Programs\Android_SDK",
  [string]$Serial = "emulator-5554",
  [string]$Apk = "D:\Web_Project\Neiroha\build\app\outputs\flutter-apk\app-debug.apk",
  [string]$Sqlite = ""
)

$ErrorActionPreference = "Stop"

$adb = Join-Path $AndroidSdk "platform-tools\adb.exe"
if (-not (Test-Path $adb)) {
  throw "adb.exe not found under $AndroidSdk"
}
if (-not (Test-Path $Apk)) {
  throw "APK not found: $Apk"
}
if (-not $Sqlite) {
  $candidateSqlite = Join-Path $AndroidSdk "platform-tools\sqlite3.exe"
  if (Test-Path $candidateSqlite) {
    $Sqlite = $candidateSqlite
  } else {
    $Sqlite = "D:\Programs\Anaconda\Library\bin\sqlite3.exe"
  }
}
if (-not (Test-Path $Sqlite)) {
  throw "sqlite3.exe not found. Pass -Sqlite <path>."
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

# Seed a small, deterministic dialog project so screenshots are not empty.
$dbBase64 = ".codex-temp\android-shots\neiroha-db.b64"
$dbPath = ".codex-temp\android-shots\neiroha-db.sqlite"
Invoke-Adb shell run-as com.neiroha.neiroha base64 files/data/neiroha.db | Out-File -Encoding ascii $dbBase64
certutil -decode $dbBase64 $dbPath | Out-Null
& $Sqlite $dbPath @"
delete from dialog_tts_lines;
insert into dialog_tts_lines
  (id, project_id, order_index, line_text, voice_asset_id, audio_path, audio_duration, error, missing)
values
  ('sample-dialog-line-1','default-dialog-project',0,
   'Welcome to Neiroha. One workspace can manage providers, voices and generated takes.',
   'default-character',NULL,NULL,NULL,0);
insert into dialog_tts_lines
  (id, project_id, order_index, line_text, voice_asset_id, audio_path, audio_duration, error, missing)
values
  ('sample-dialog-line-2','default-dialog-project',1,
   'Switch characters per line, then batch generate the whole scene.',
   'default-character',NULL,NULL,NULL,0);
"@
if ($LASTEXITCODE -ne 0) {
  throw "Failed to seed screenshot database."
}
Invoke-Adb shell am force-stop com.neiroha.neiroha
Invoke-Adb push $dbPath /data/local/tmp/neiroha-wiki.db
Invoke-Adb shell chmod 644 /data/local/tmp/neiroha-wiki.db
Invoke-Adb shell run-as com.neiroha.neiroha cp /data/local/tmp/neiroha-wiki.db files/data/neiroha.db
Invoke-Adb shell monkey -p com.neiroha.neiroha -c android.intent.category.LAUNCHER 1
Start-Sleep -Seconds 5

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
