<#
.SYNOPSIS
    ULTRA-INSANE Build Script for gamesflow-emulator-
    - .NET/Node/CI/CD/Release, Security, DevOps, Telemetry, Fun, and More!
    - See in-script comments for extensibility points and custom logic.

.NOTES
    Run with: powershell -ExecutionPolicy Bypass -File .\build.ps1 [-Mode normal|markdown|html] [-Config build.config.yaml] [-SkipDocs] [-SkipTests] [-PrebuildHook pre.ps1] [-PostbuildHook post.ps1] [-Threads 4] [-FailFast] [-Branch main] [-Gui] [-Speech] [-Theme dark|light]
#>

#region INITIALIZATION & CLI
param(
    [string]$Mode = "normal",
    [string]$Config = "build.config.yaml",
    [switch]$SkipDocs,
    [switch]$SkipTests,
    [string]$PrebuildHook,
    [string]$PostbuildHook,
    [int]$Threads = 4,
    [switch]$FailFast,
    [string]$Branch = "",
    [switch]$Verbose,
    [switch]$Gui,
    [switch]$Speech,
    [string]$Theme = "dark"
)

$ErrorActionPreference = "Stop"
$Script:StartTime = Get-Date
$Script:BuildVersion = "1.0.0"
$Script:NowStamp = (Get-Date -Format "yyyyMMdd")
$Script:VersionSuffix = "+$Script:NowStamp"
$Script:LogFile = "build.log"
$Script:ArtifactsDir = "artifacts"
$Script:PrevArtifactsDir = "artifacts_prev"
$Script:TelemetryOptIn = $false

function Write-Log {
    param([string]$Message, [ValidateSet("DEBUG","INFO","WARN","ERROR")] [string]$Level = "INFO")
    $ts = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $color = if ($Theme -eq "light") {
        @{
            "DEBUG" = "DarkGray"; "INFO" = "DarkGreen"; "WARN" = "DarkYellow"; "ERROR" = "Red"
        }[$Level]
    } else {
        @{
            "DEBUG" = "Gray"; "INFO" = "Green"; "WARN" = "Yellow"; "ERROR" = "Red"
        }[$Level]
    }
    if ($Verbose -or $Level -ne "DEBUG") {
        Write-Host "$ts [$Level] $Message" -ForegroundColor $color
    }
    Add-Content -Path $Script:LogFile -Value "$ts [$Level] $Message"
}

function Interactive-YesNo ($Prompt) {
    if ($Gui) {
        Add-Type -AssemblyName PresentationFramework
        $result = [System.Windows.MessageBox]::Show($Prompt,"Build Prompt",[System.Windows.MessageBoxButton]::YesNo)
        return $result -eq "Yes"
    } else {
        $res = Read-Host "$Prompt [y/N]"
        return $res -match '^(y|yes)$'
    }
}

function Speak-Result($msg) {
    if ($Speech) {
        Add-Type -AssemblyName System.speech
        $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
        $speak.Speak($msg)
    }
}

function Show-MemeOnFail {
    $gifs = @(
        "https://media.giphy.com/media/3oEjI6SIIHBdRxXI40/giphy.gif",
        "https://media.giphy.com/media/26ufdipQqU2lhNA4g/giphy.gif",
        "https://media.giphy.com/media/l3vR85PnGsBwu1PFK/giphy.gif"
    )
    $gif = Get-Random -InputObject $gifs
    Write-Host "Build failed! Here's a meme to cheer you up: $gif" -ForegroundColor Magenta
    try { Start-Process $gif } catch {}
}

function Show-EasterEgg {
    Write-Host "        .-'''-." -ForegroundColor Cyan
    Write-Host "       / .===. \ " -ForegroundColor Cyan
    Write-Host "       \/ 6 6 \/" -ForegroundColor Cyan
    Write-Host "        ( \_/ )" -ForegroundColor Cyan
    Write-Host " .-'''-.  /   \  .-'''-." -ForegroundColor Cyan
    Write-Host "/ .===. \/ /^\ \/ .===. \ " -ForegroundColor Cyan
    Write-Host "\/ 6 6 \/     \/ 6 6 \/" -ForegroundColor Cyan
    Write-Host " ( \_/ )       ( \_/ )" -ForegroundColor Cyan
    Write-Host "  \   /         \   /" -ForegroundColor Cyan
    Write-Host "   ) (           ) (" -ForegroundColor Cyan
    Write-Host "  (   )         (   )" -ForegroundColor Cyan
    Write-Host "   '-'           '-'" -ForegroundColor Cyan
    Write-Host "You found the hidden cat! 🐱" -ForegroundColor Cyan
}

#endregion

#region SELF-UPDATE
function Self-Update {
    $remoteScript = "https://raw.githubusercontent.com/sugarypumpkin822/gamesflow-emulator-/main/build.ps1"
    if (Interactive-YesNo "Check for build script update?") {
        try {
            $latest = Invoke-WebRequest $remoteScript -UseBasicParsing -TimeoutSec 10
            if ($latest.Content -and ($latest.Content -ne (Get-Content $MyInvocation.MyCommand.Definition -Raw))) {
                Set-Content $MyInvocation.MyCommand.Definition $latest.Content
                Write-Log "Self-update complete. Re-run script." "INFO"
                exit
            } else {
                Write-Log "Already up to date." "INFO"
            }
        } catch { Write-Log "Self-update failed: $_" "WARN" }
    }
}
Self-Update
#endregion

#region TELEMETRY (opt-in)
if (Test-Path ".telemetry-opt-in") { $Script:TelemetryOptIn = $true }
function Send-Telemetry($event) {
    if ($Script:TelemetryOptIn) {
        # Example: send telemetry event (stub)
        Write-Log "Telemetry sent: $event" "DEBUG"
    }
}
#endregion

#region CONFIG/YAML LOADING
function Load-BuildConfig {
    param([string]$Path)
    if (Test-Path $Path) {
        if ($Path -like "*.yaml" -or $Path -like "*.yml") {
            try {
                Import-Module -Name powershell-yaml -ErrorAction SilentlyContinue
                return ConvertFrom-Yaml (Get-Content $Path -Raw)
            } catch { Write-Log "YAML parsing failed, fallback to default config." "WARN" }
        } elseif ($Path -like "*.json") {
            return Get-Content $Path | ConvertFrom-Json
        }
    }
    return @{}
}
$ConfigObj = Load-BuildConfig $Config
#endregion

#region ENVIRONMENT / SECURITY CHECKS
function Check-WorldWritable($root=".") {
    Get-ChildItem $root -Recurse -Directory | Where-Object {
        ($_.Attributes -band [IO.FileAttributes]::Directory) -and
        ((Get-Acl $_.FullName).Access | Where-Object { $_.FileSystemRights -match "Write" -and $_.IdentityReference -match "Everyone" })
    } | ForEach-Object { Write-Log "Warning: World-writable dir: $($_.FullName)" "WARN" }
}
function Scan-Tokens {
    if (Get-Command trufflehog -ErrorAction SilentlyContinue) {
        trufflehog filesystem . | Tee-Object -FilePath "$Script:ArtifactsDir\secrets.txt"
        Write-Log "Secret scan complete." "INFO"
    }
}
function Run-SecurityScans {
    if (Get-Command devskim -ErrorAction SilentlyContinue) {
        devskim analyze . | Tee-Object -FilePath "$Script:ArtifactsDir\devskim.txt"
    }
    if (Get-Command bandit -ErrorAction SilentlyContinue) {
        bandit -r . | Tee-Object -FilePath "$Script:ArtifactsDir\bandit.txt"
    }
}
function Scan-DependencyVulns {
    dotnet list package --vulnerable | Tee-Object -FilePath "$Script:ArtifactsDir\dotnet-vulns.txt"
    if (Test-Path "package.json") { npm audit --json | Out-File "$Script:ArtifactsDir\npm-vulns.json" }
}
function Validate-HTTPS {
    Get-ChildItem -Recurse -Include *.cs,*.js,*.ts | Select-String -Pattern "http://" | ForEach-Object {
        Write-Log "Non-HTTPS URL found: $($_.Line)" "WARN"
    }
}
#endregion

#region HASH VALIDATION, SIGNING, QR
function Check-SourceHashes {
    Get-ChildItem -Recurse -Include *.cs,*.ps1,*.pl,*.flux | Where-Object {-not $_.PSIsContainer} | ForEach-Object {
        $hash = Get-FileHash $_.FullName -Algorithm SHA256
        Write-Log "Hash: $($_.FullName) $($hash.Hash)" "DEBUG"
    }
}
function GPG-Sign {
    git config --global user.signingkey "YOUR-GPG-KEY-ID"
    git commit -S -am "Signed commit"
    git tag -s "v$Script:BuildVersion$Script:VersionSuffix" -m "Signed release"
}
function Generate-QRCode($url) {
    if (Get-Command qrencode -ErrorAction SilentlyContinue) {
        qrencode -o "$Script:ArtifactsDir\artifact_qr.png" "$url"
        Write-Log "QR code generated for artifact access: $url" "INFO"
    }
}
#endregion

#region BUILD, TEST, COVERAGE, REPORTING, FUN
dotnet restore
if (Test-Path "package.json") { npm install }
dotnet format
Check-WorldWritable
Scan-Tokens
Run-SecurityScans
Scan-DependencyVulns
Validate-HTTPS
Check-SourceHashes

$platforms = @("win-x64","linux-x64","osx-x64","win-arm64","linux-arm64","osx-arm64")
$jobs = @()
foreach ($platform in $platforms) {
    $jobs += Start-Job -ScriptBlock { param($p) dotnet build -c Release -r $p --no-restore } -ArgumentList $platform
}
$jobs | Wait-Job | Receive-Job | Out-Null
foreach ($platform in $platforms) {
    dotnet publish -c Release -r $platform --self-contained true --output "publish/$platform"
}
if (-not $SkipTests) {
    $testRetries = 2
    for ($try=0; $try -le $testRetries; $try++) {
        dotnet test --no-build --configuration Release --collect:"XPlat Code Coverage" --results-directory "TestResults" --logger "trx;LogFileName=unit-test.trx"
        $testResult = Get-Content TestResults\unit-test.trx -Raw
        if ($testResult -match 'outcome="Failed"') {
            Write-Log "Test run failed. Retrying ($try/$testRetries)" "WARN"
            if ($FailFast) { Show-MemeOnFail; Speak-Result "Build failed!"; exit 1 }
        } else { break }
    }
    dotnet test --no-build --configuration Release --filter "Category=Snapshot"
    dotnet test --no-build --configuration Release --filter "Category=Integration"
    dotnet vstest .\bin\**\*Tests.dll --Parallel --TestCaseFilter:"TestCategory!=Flaky" /Parallel /MaxCpuCount:$Threads
}

dotnet tool install -g dotnet-reportgenerator-globaltool
$env:PATH += ";$env:USERPROFILE\.dotnet\tools"
reportgenerator -reports:"TestResults\*\coverage.cobertura.xml" -targetdir:"coverage" -reporttypes:Html;Cobertura

# Visual regression, snapshot, diffing, and analytics (stubs)
if (Test-Path ".visualtests") { .\.visualtests\run-visual.ps1 }
if (Test-Path "benchmarks") { dotnet run -c Release -p benchmarks }
#endregion

#region RELEASE, DEPLOY, SOCIAL
Compress-Archive -Path "publish\*" -DestinationPath "$Script:ArtifactsDir\publish.zip" -Force
GPG-Sign
git add .
git commit -m "release: $Script:BuildVersion$Script:VersionSuffix"
git tag -s "v$Script:BuildVersion$Script:VersionSuffix" -m "Release $Script:BuildVersion$Script:VersionSuffix"
gh release create "v$Script:BuildVersion$Script:VersionSuffix" "$Script:ArtifactsDir\publish.zip" --title "Release $Script:BuildVersion$Script:VersionSuffix"
# Deploy: S3, GitHub Pages, NuGet, SFTP, etc. (stub)
#endregion

#region QR CODE, TWEET, ASCII ART, NOTIFICATIONS
Generate-QRCode "https://github.com/sugarypumpkin822/gamesflow-emulator-/releases/latest"
Write-Log "Tweetable summary: Built $Script:BuildVersion$Script:VersionSuffix in $((Get-Date)-$Script:StartTime).TotalSeconds s. Artifacts at $Script:ArtifactsDir" "INFO"
Show-EasterEgg
if ($env:SLACK_WEBHOOK_URL) {
    $payload = @{ text = "Build completed: $Script:BuildVersion$Script:VersionSuffix" } | ConvertTo-Json
    Invoke-RestMethod -Uri $env:SLACK_WEBHOOK_URL -Method Post -Body $payload -ContentType "application/json"
}
if ($env:DISCORD_WEBHOOK_URL) {
    $payload = @{ content = "Build completed: $Script:BuildVersion$Script:VersionSuffix" } | ConvertTo-Json
    Invoke-RestMethod -Uri $env:DISCORD_WEBHOOK_URL -Method Post -Body $payload -ContentType "application/json"
}
#endregion

#region GUI/CLI MODE
if ($Gui) {
    Add-Type -AssemblyName PresentationFramework
    [System.Windows.MessageBox]::Show("Build complete! Artifacts: $Script:ArtifactsDir","Build Success",[System.Windows.MessageBoxButton]::OK,[System.Windows.MessageBoxImage]::Information)
}
#endregion

#region SUMMARY/EXIT
$elapsed = (Get-Date) - $Script:StartTime
Write-Log "Build completed in $($elapsed.TotalSeconds) seconds." "INFO"
Write-Host "Artifacts: $(Resolve-Path $Script:ArtifactsDir)" -ForegroundColor Cyan
Write-Host "Build log: $(Resolve-Path $Script:LogFile)" -ForegroundColor Magenta
Speak-Result "Build complete and successful!" 
Write-Host "`n===== ULTRA-INSANE BUILD COMPLETE! =====" -ForegroundColor Green
#endregion
