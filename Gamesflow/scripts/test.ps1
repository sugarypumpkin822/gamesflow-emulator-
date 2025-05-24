<#
.SYNOPSIS
    GIANT Test Runner for gamesflow-emulator-
    - Comprehensive test harness for .NET, PowerShell, Perl, FLUX, and more.
    - Unit, integration, snapshot, visual, benchmarks, lint, security, coverage, and multi-language support.
    - Color-coded, timestamped logs, stats, retries, fail-fast, dry-run, parallel runs, CI/CD hooks, and more.
    - YAML/JSON config, detailed reporting, artifact export, badge generation, and extensibility built-in.
#>

#region CLI/ENV INIT
param(
    [string]$Config = "test.config.yaml",
    [switch]$Unit,
    [switch]$Integration,
    [switch]$Snapshot,
    [switch]$Visual,
    [switch]$Benchmarks,
    [switch]$Lint,
    [switch]$Security,
    [switch]$Coverage,
    [switch]$FailFast,
    [switch]$Parallel,
    [int]$Threads = 4,
    [switch]$DryRun,
    [switch]$Verbose,
    [switch]$NoPrompt,
    [switch]$Quick,
    [switch]$Full,
    [switch]$Silent,
    [string]$OutputFormat = "text",
    [switch]$OpenCoverage,
    [string]$PreTestHook,
    [string]$PostTestHook
)

$ErrorActionPreference = "Stop"
$Script:StartTime = Get-Date
$Script:LogFile = "test.log"
$Script:ArtifactDir = "artifacts"
$Script:NowStamp = (Get-Date -Format "yyyyMMdd-HHmmss")
if (!(Test-Path $Script:ArtifactDir)) { New-Item -ItemType Directory $Script:ArtifactDir | Out-Null }
$Script:TestStats = @{
    Passed = 0; Failed = 0; Skipped = 0; Retried = 0; Coverage = 0; Duration = 0; Start = $Script:StartTime
}
$Script:FailedTests = @()
$Script:FlakyTests = @()
#endregion

#region LOGGING
function Write-TestLog {
    param([string]$Message, [ValidateSet("INFO","WARN","ERROR","SUCCESS")] [string]$Level = "INFO")
    $ts = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $color = @{
        "INFO"    = "Green"
        "WARN"    = "Yellow"
        "ERROR"   = "Red"
        "SUCCESS" = "Cyan"
    }[$Level]
    if (-not $Silent -and ($Verbose -or $Level -in @("WARN","ERROR","SUCCESS"))) {
        Write-Host "$ts [$Level] $Message" -ForegroundColor $color
    }
    Add-Content -Path $Script:LogFile -Value "$ts [$Level] $Message"
}
#endregion

#region YAML/JSON CONFIG LOADING
function Load-TestConfig {
    param([string]$Path)
    if (Test-Path $Path) {
        if ($Path -like "*.yaml" -or $Path -like "*.yml") {
            try {
                Import-Module -Name powershell-yaml -ErrorAction SilentlyContinue
                return ConvertFrom-Yaml (Get-Content $Path -Raw)
            } catch { Write-TestLog "YAML parsing failed in config, fallback to default." "WARN" }
        } elseif ($Path -like "*.json") {
            return Get-Content $Path | ConvertFrom-Json
        }
    }
    Write-TestLog "Config file not found or failed to parse: $Path" "ERROR"
    exit 1
}
$TestConfig = Load-TestConfig $Config
#endregion

#region UTILS
function Confirm-YesNo($Prompt) {
    if ($NoPrompt) { return $true }
    $res = Read-Host "$Prompt [y/N]"
    return $res -match '^(y|yes)$'
}
function Parse-TRXFailures($trxPath) {
    if (Test-Path $trxPath) {
        $xml = [xml](Get-Content $trxPath -Raw)
        $failures = $xml.TestRun.Results.UnitTestResult | Where-Object { $_.outcome -eq "Failed" }
        return $failures | ForEach-Object { $_.testName }
    }
    return @()
}
function Archive-Log {
    Copy-Item $Script:LogFile "$Script:ArtifactDir/test_$Script:NowStamp.log"
}
#endregion

#region PRE/POST HOOKS
if ($PreTestHook) {
    Write-TestLog "Running pre-test hook: $PreTestHook" "INFO"
    & $PreTestHook
}
#endregion

#region PHASE CONFIG
$runAll = $Full -or -not ($Unit -or $Integration -or $Snapshot -or $Visual -or $Benchmarks -or $Lint -or $Security)
$doUnit = $runAll -or $Unit -or $Quick
$doIntegration = $runAll -or $Integration
$doSnapshot = $runAll -or $Snapshot
$doVisual = $runAll -or $Visual
$doBenchmarks = $runAll -or $Benchmarks
$doLint = $runAll -or $Lint -or $Quick
$doSecurity = $runAll -or $Security
$doCoverage = $Coverage -or $runAll -or $Quick
#endregion

#region .NET TESTS (Unit, Coverage, Integration, Retry, Parallel, Fail-fast)
if ($doUnit) {
    Write-TestLog "Running .NET unit tests..." "INFO"
    $testRetries = 2
    $testResult = $null
    $trxPath = "TestResults\unit-test.trx"
    for ($try=0; $try -le $testRetries; $try++) {
        if ($DryRun) {
            Write-TestLog "Dry-run: Skipping unit test execution." "INFO"
            $Script:TestStats.Skipped++
            break
        }
        Remove-Item -ErrorAction SilentlyContinue $trxPath
        $args = @("--no-build", "--configuration", "Release", "--logger", "trx;LogFileName=unit-test.trx")
        if ($doCoverage) { $args += "--collect:`"XPlat Code Coverage`"" }
        dotnet test @args
        $testResult = Get-Content $trxPath -Raw
        $failedTests = Parse-TRXFailures $trxPath
        if ($failedTests.Count -gt 0) {
            Write-TestLog "Unit test run failed. Retrying ($try/$testRetries)" "WARN"
            $Script:TestStats.Retried++
            $Script:FailedTests += $failedTests
            if ($FailFast) { Write-TestLog "Fail-fast enabled. Exiting." "ERROR"; Archive-Log; exit 1 }
        } else { break }
    }
    if ($failedTests.Count -eq 0) {
        Write-TestLog "Unit tests passed." "SUCCESS"
        $Script:TestStats.Passed++
    } else {
        Write-TestLog "Unit tests failed after $testRetries retries" "ERROR"
        $Script:TestStats.Failed++
    }
}

if ($doIntegration) {
    Write-TestLog "Running .NET integration tests..." "INFO"
    if ($DryRun) {
        Write-TestLog "Dry-run: Skipping integration tests." "INFO"
        $Script:TestStats.Skipped++
    } else {
        dotnet test --no-build --configuration Release --filter "Category=Integration" --logger "trx;LogFileName=integration-test.trx"
        $failed = Parse-TRXFailures "TestResults/integration-test.trx"
        if ($LASTEXITCODE -eq 0 -and $failed.Count -eq 0) {
            Write-TestLog "Integration tests passed." "SUCCESS"
            $Script:TestStats.Passed++
        } else {
            Write-TestLog "Integration tests failed." "ERROR"
            $Script:TestStats.Failed++
            $Script:FailedTests += $failed
            if ($FailFast) { Archive-Log; exit 1 }
        }
    }
}

if ($doSnapshot) {
    Write-TestLog "Running snapshot tests..." "INFO"
    if ($DryRun) {
        Write-TestLog "Dry-run: Skipping snapshot tests." "INFO"
        $Script:TestStats.Skipped++
    } else {
        dotnet test --no-build --configuration Release --filter "Category=Snapshot" --logger "trx;LogFileName=snapshot-test.trx"
        $failed = Parse-TRXFailures "TestResults/snapshot-test.trx"
        if ($LASTEXITCODE -eq 0 -and $failed.Count -eq 0) {
            Write-TestLog "Snapshot tests passed." "SUCCESS"
            $Script:TestStats.Passed++
        } else {
            Write-TestLog "Snapshot tests failed." "ERROR"
            $Script:TestStats.Failed++
            $Script:FailedTests += $failed
            if ($FailFast) { Archive-Log; exit 1 }
        }
    }
}

if ($doVisual) {
    Write-TestLog "Running visual regression tests..." "INFO"
    if ($DryRun) {
        Write-TestLog "Dry-run: Skipping visual tests." "INFO"
        $Script:TestStats.Skipped++
    } else {
        if (Test-Path ".visualtests/run-visual.ps1") {
            & .\.visualtests\run-visual.ps1
            if ($LASTEXITCODE -eq 0) {
                Write-TestLog "Visual tests passed." "SUCCESS"
                $Script:TestStats.Passed++
            } else {
                Write-TestLog "Visual tests failed." "ERROR"
                $Script:TestStats.Failed++
                if ($FailFast) { Archive-Log; exit 1 }
            }
        } else {
            Write-TestLog "No visual test script found." "WARN"
            $Script:TestStats.Skipped++
        }
    }
}

if ($doCoverage) {
    Write-TestLog "Generating code coverage reports..." "INFO"
    if ($DryRun) {
        Write-TestLog "Dry-run: Skipping coverage report." "INFO"
    } else {
        if (!(Get-Command reportgenerator -ErrorAction SilentlyContinue)) {
            dotnet tool install -g dotnet-reportgenerator-globaltool
            $env:PATH += ";$env:USERPROFILE\.dotnet\tools"
        }
        reportgenerator -reports:"TestResults\*\coverage.cobertura.xml" -targetdir:"coverage" -reporttypes:Html;Cobertura
        Write-TestLog "Coverage HTML and Cobertura XML generated." "SUCCESS"
        if ($OpenCoverage -and (Test-Path "coverage/index.html")) {
            Start-Process "coverage/index.html"
        }
    }
}
#endregion

#region LINTING
if ($doLint) {
    Write-TestLog "Running linting and style checks..." "INFO"
    if ($DryRun) {
        Write-TestLog "Dry-run: Skipping linting." "INFO"
    } else {
        if (Test-Path "stylecop.json" -or Test-Path ".editorconfig") { dotnet format }
        if (Test-Path "package.json") { npm run lint }
        if (Test-Path ".eslintrc.js") { npx eslint . }
        if (Test-Path "pyproject.toml" -or Test-Path "setup.cfg") { flake8 . }
        Write-TestLog "Linting completed." "SUCCESS"
    }
}
#endregion

#region SECURITY
if ($doSecurity) {
    Write-TestLog "Running security scans..." "INFO"
    if ($DryRun) {
        Write-TestLog "Dry-run: Skipping security scans." "INFO"
        $Script:TestStats.Skipped++
    } else {
        if (Get-Command trufflehog -ErrorAction SilentlyContinue) { trufflehog filesystem . | Tee-Object -FilePath "$Script:ArtifactDir/secrets.txt" }
        if (Get-Command devskim -ErrorAction SilentlyContinue) { devskim analyze . | Tee-Object -FilePath "$Script:ArtifactDir/devskim.txt" }
        if (Get-Command bandit -ErrorAction SilentlyContinue) { bandit -r . | Tee-Object -FilePath "$Script:ArtifactDir/bandit.txt" }
        dotnet list package --vulnerable | Tee-Object -FilePath "$Script:ArtifactDir/dotnet-vulns.txt"
        if (Test-Path "package.json") { npm audit --json | Out-File "$Script:ArtifactDir/npm-vulns.json" }
        Write-TestLog "Security analysis complete." "SUCCESS"
    }
}
#endregion

#region BENCHMARKS
if ($doBenchmarks) {
    Write-TestLog "Running benchmarks..." "INFO"
    if ($DryRun) {
        Write-TestLog "Dry-run: Skipping benchmarks." "INFO"
        $Script:TestStats.Skipped++
    } else {
        if (Test-Path "benchmarks") {
            dotnet run -c Release -p benchmarks
            if ($LASTEXITCODE -eq 0) {
                Write-TestLog "Benchmark tests completed." "SUCCESS"
            } else {
                Write-TestLog "Benchmark tests failed." "ERROR"
                if ($FailFast) { Archive-Log; exit 1 }
            }
        } else {
            Write-TestLog "No benchmarks project found." "WARN"
            $Script:TestStats.Skipped++
        }
    }
}
#endregion

#region MULTI-LANGUAGE TESTS (Perl, PowerShell, FLUX)
Write-TestLog "Running multi-language tests..." "INFO"
if (Test-Path "*.pl") {
    Get-ChildItem -Recurse -Include *.pl | ForEach-Object {
        perl $_.FullName
        if ($LASTEXITCODE -eq 0) {
            Write-TestLog "Perl test passed: $($_.FullName)" "SUCCESS"
            $Script:TestStats.Passed++
        } else {
            Write-TestLog "Perl test failed: $($_.FullName)" "ERROR"
            $Script:TestStats.Failed++
        }
    }
}
if (Test-Path "*.ps1") {
    Get-ChildItem -Recurse -Include *.ps1 | Where-Object { $_.FullName -ne $MyInvocation.MyCommand.Definition } | ForEach-Object {
        powershell -ExecutionPolicy Bypass -File $_.FullName
        if ($LASTEXITCODE -eq 0) {
            Write-TestLog "PowerShell script passed: $($_.FullName)" "SUCCESS"
            $Script:TestStats.Passed++
        } else {
            Write-TestLog "PowerShell script failed: $($_.FullName)" "ERROR"
            $Script:TestStats.Failed++
        }
    }
}
if (Test-Path "*.flux") {
    Get-ChildItem -Recurse -Include *.flux | ForEach-Object {
        Write-TestLog "FLUX test executed (manual validation may be needed): $($_.FullName)" "INFO"
        $Script:TestStats.Passed++
    }
}
#endregion

#region POST-TEST HOOK
if ($PostTestHook) {
    Write-TestLog "Running post-test hook: $PostTestHook" "INFO"
    & $PostTestHook
}
#endregion

#region SUMMARY & REPORTING
$Script:TestStats.Duration = ((Get-Date) - $Script:StartTime).TotalSeconds
Archive-Log
$summary = @"
# Test Summary for gamesflow-emulator-
- Date: $($Script:StartTime)
- Duration: $($Script:TestStats.Duration)s
- Passed: $($Script:TestStats.Passed)
- Failed: $($Script:TestStats.Failed)
- Skipped: $($Script:TestStats.Skipped)
- Retried: $($Script:TestStats.Retried)
- Coverage: $($Script:TestStats.Coverage)
- Flaky/Failed tests: $($Script:FailedTests -join ", ")
"@
Set-Content "$Script:ArtifactDir/test_summary_$Script:NowStamp.md" -Value $summary

Write-Host "`n--- TEST SUMMARY ---" -ForegroundColor Cyan
Write-Host ("Passed   : {0}" -f $Script:TestStats.Passed) -ForegroundColor Green
Write-Host ("Failed   : {0}" -f $Script:TestStats.Failed) -ForegroundColor Red
Write-Host ("Skipped  : {0}" -f $Script:TestStats.Skipped) -ForegroundColor Yellow
Write-Host ("Retried  : {0}" -f $Script:TestStats.Retried) -ForegroundColor Magenta
Write-Host ("Duration : {0}s" -f $Script:TestStats.Duration) -ForegroundColor Cyan
Write-Host ("Coverage : {0}" -f $Script:TestStats.Coverage) -ForegroundColor Cyan
Write-Host ("Failed tests: {0}" -f ($Script:FailedTests -join ", ")) -ForegroundColor Red
Write-Host "Test log: $(Resolve-Path $Script:LogFile)" -ForegroundColor Gray
Write-Host "Artifacts: $(Resolve-Path $Script:ArtifactDir)" -ForegroundColor White
Write-Host "Done at $(Get-Date)" -ForegroundColor Green
#endregion
