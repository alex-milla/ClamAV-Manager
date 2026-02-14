# ClamAV-Manager.ps1
# Centralized ClamAV management script
# Author: Alex Milla - alexmilla.net
# Date: February 14, 2026
# Version: 2.0

# ============================================
# LANGUAGE CONFIGURATION
# ============================================

# Detect system language
$systemLang = (Get-Culture).TwoLetterISOLanguageName

# Prompt for language selection
function Select-Language {
    Clear-Host
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host "       ClamAV Management Console v2.0                        " -ForegroundColor Cyan
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Select Language / Seleccionar Idioma:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  [1] English" -ForegroundColor White
    Write-Host "  [2] Español" -ForegroundColor White
    Write-Host ""

    $selection = Read-Host "Selection / Selección"

    if ($selection -eq "2") {
        return "es"
    } else {
        return "en"
    }
}

$global:Language = Select-Language

# Language strings
$strings = @{
    en = @{
        WorkingDir = "Working directory"
        PressKey = "Press any key to continue..."

        # Messages
        Info = "[i]"
        Success = "[✓]"
        Warning = "[!]"
        Error = "[✗]"

        # Menu
        MenuTitle = "MAIN MENU"
        MenuSignatures = "SIGNATURE MANAGEMENT"
        MenuScanning = "SCANNING"
        MenuDaemon = "DAEMON MANAGEMENT"
        MenuAdvanced = "ADVANCED"
        MenuConfig = "CONFIGURATION"
        MenuExit = "Exit"

        Menu1 = "Update virus signatures"
        Menu2 = "View ClamAV configuration"
        Menu3 = "Quick scan (any directory/UNC)"
        Menu4 = "Scan user profile"
        Menu5 = "Start ClamD daemon"
        Menu6 = "Stop ClamD daemon"
        Menu7 = "View daemon status"
        Menu8 = "Daemon-based scan (faster)"
        Menu9 = "Full system scan (C:\)"
        Menu10 = "Initialize/repair configuration"
        Menu11 = "Create custom signature"
        Menu12 = "View logs"
        Menu0 = "Exit"

        SelectOption = "Select an option"
        InvalidOption = "Invalid option"

        # Initialize
        InitTitle = "CONFIGURATION INITIALIZATION"
        InitExists = "Configuration files already exist"
        InitRecreate = "Do you want to recreate them? (Y/N)"
        InitNotFound = "conf_examples folder not found"
        InitEnsure = "Make sure to run the script from ClamAV folder"
        InitCopying = "Copying example configuration files..."
        InitCopied = "copied"
        InitNotFoundSample = "not found"
        InitConfiguring = "Configuring"
        InitConfigured = "configured correctly"
        InitCompleted = "Configuration completed!"
        InitDirectories = "Directories created:"
        InitLogs = "Logs"
        InitDatabase = "Database"
        InitReports = "Reports"
        InitQuarantine = "Quarantine"
        InitNext = "Now you can run signature update (option 1)"

        # Update
        UpdateTitle = "SIGNATURE UPDATE"
        UpdateNotFound = "freshclam.conf not found"
        UpdateRunInit = "Run option [10] Initialize configuration first"
        UpdateStarting = "Starting database update..."
        UpdateNotFoundExe = "freshclam.exe not found"
        UpdateSuccess = "Signatures updated successfully"
        UpdateError = "Error updating signatures (code:"
        UpdateCheckLog = "Check the log:"
        UpdateLogSaved = "Log saved in:"

        # Quick Scan
        ScanTitle = "QUICK SCAN"
        ScanEnterPath = "Enter path to scan"
        ScanExamples = "Examples:"
        ScanPath = "Path"
        ScanNotExists = "The specified path does not exist or is not accessible"
        ScanStarting = "Starting RECURSIVE scan of:"
        ScanMayTake = "This may take several minutes..."
        ScanCompleted = "Scan completed - No threats detected"
        ScanThreatsFound = "THREATS DETECTED! Check the report"
        ScanError = "Error during scan (code:"
        ScanReportSaved = "Report saved in:"
        ScanOpenReport = "Do you want to open the report? (Y/N)"

        # User Profile Scan
        UserScanTitle = "USER PROFILE SCAN"
        UserScanFolders = "The following folders will be scanned RECURSIVELY:"
        UserScanContinue = "Continue? (Y/N)"
        UserScanStarting = "Starting scan..."
        UserScanThreats = "THREATS DETECTED!"
        UserScanReport = "Report:"

        # Full System Scan
        FullScanTitle = "FULL SYSTEM SCAN"
        FullScanWarning = "WARNING: This RECURSIVE scan will analyze ALL of drive C:\"
        FullScanTime = "It may take several hours depending on size"
        FullScanSure = "Are you sure you want to continue? (Y/N)"
        FullScanStarting = "Starting full scan..."
        FullScanStart = "Start time:"
        FullScanEnd = "End time:"

        # Daemon
        DaemonStartTitle = "START CLAMD DAEMON"
        DaemonStopTitle = "STOP CLAMD DAEMON"
        DaemonStatusTitle = "DAEMON STATUS"
        DaemonScanTitle = "DAEMON SCAN (FAST)"
        DaemonNotFound = "clamd.conf not found"
        DaemonRunInit = "Run option [10] Initialize configuration first"
        DaemonAlreadyRunning = "Daemon is already running (PID:"
        DaemonStarting = "Starting clamd in background..."
        DaemonStarted = "Daemon started successfully (PID:"
        DaemonPort = "TCP Port: 3310"
        DaemonErrorStart = "Error starting daemon"
        DaemonCheckLog = "Check the log:"
        DaemonStopped = "Daemon stopped successfully"
        DaemonNotRunning = "Daemon is not running"
        DaemonUseOption = "Use option [5] to start the daemon"
        DaemonActive = "Status: ACTIVE"
        DaemonInactive = "Status: INACTIVE"
        DaemonDetails = "Details:"
        DaemonPID = "PID:"
        DaemonMemory = "Memory:"
        DaemonCPU = "CPU:"
        DaemonStartTime = "Started:"
        DaemonNotActive = "Daemon is not running"
        DaemonStartFirst = "Start the daemon first with option [5]"
        DaemonScanStarting = "Starting fast RECURSIVE scan via daemon..."

        # Custom Signature
        CustomSigTitle = "CREATE CUSTOM SIGNATURE"
        CustomSigEnter = "Enter path of malicious file"
        CustomSigNotFound = "File not found"
        CustomSigMD5 = "Generating MD5 hash..."
        CustomSigSHA256 = "Generating SHA256 hash..."
        CustomSigCopy = "Copy the hashes above to create your custom signature"
        CustomSigFormat = "Format: hash:size:malware_name"

        # Configuration
        ConfigTitle = "CLAMAV CONFIGURATION"

        # Logs
        LogsTitle = "VIEW LOGS"
        LogsNotFound = "No logs found"
        LogsAvailable = "Available logs:"
        LogsSelect = "Select a log to open (0 to cancel)"

        # Errors
        ErrorMissing = "ERROR: ClamAV executables not found"
        ErrorFiles = "Missing files:"
        ErrorEnsureFolder = "Make sure to run this script from ClamAV folder"
        ErrorFirstRun = "First run detected"
        ErrorNeedInit = "Configuration initialization is required"
        ErrorInitNow = "Do you want to initialize configuration now? (Y/N)"

        # Goodbye
        Goodbye = "See you soon!"
    }

    es = @{
        WorkingDir = "Directorio de trabajo"
        PressKey = "Presiona cualquier tecla para continuar..."

        # Messages
        Info = "[i]"
        Success = "[✓]"
        Warning = "[!]"
        Error = "[✗]"

        # Menu
        MenuTitle = "MENÚ PRINCIPAL"
        MenuSignatures = "GESTIÓN DE FIRMAS"
        MenuScanning = "ESCANEO"
        MenuDaemon = "GESTIÓN DEL DAEMON"
        MenuAdvanced = "AVANZADO"
        MenuConfig = "CONFIGURACIÓN"
        MenuExit = "Salir"

        Menu1 = "Actualizar base de datos de firmas"
        Menu2 = "Ver configuración de ClamAV"
        Menu3 = "Escaneo rápido (cualquier directorio/UNC)"
        Menu4 = "Escaneo de perfil de usuario"
        Menu5 = "Iniciar daemon ClamD"
        Menu6 = "Detener daemon ClamD"
        Menu7 = "Ver estado del daemon"
        Menu8 = "Escaneo mediante daemon (más rápido)"
        Menu9 = "Escaneo completo del sistema (C:\)"
        Menu10 = "Inicializar/Reparar configuración"
        Menu11 = "Crear firma personalizada"
        Menu12 = "Ver logs"
        Menu0 = "Salir"

        SelectOption = "Selecciona una opción"
        InvalidOption = "Opción no válida"

        # Initialize
        InitTitle = "INICIALIZACIÓN DE CONFIGURACIÓN"
        InitExists = "Los archivos de configuración ya existen"
        InitRecreate = "¿Deseas recrearlos? (S/N)"
        InitNotFound = "No se encuentra la carpeta conf_examples"
        InitEnsure = "Asegúrate de ejecutar el script desde la carpeta de ClamAV"
        InitCopying = "Copiando archivos de configuración de ejemplo..."
        InitCopied = "copiado"
        InitNotFoundSample = "no encontrado"
        InitConfiguring = "Configurando"
        InitConfigured = "configurado correctamente"
        InitCompleted = "¡Configuración completada!"
        InitDirectories = "Directorios creados:"
        InitLogs = "Logs"
        InitDatabase = "Base de datos"
        InitReports = "Reportes"
        InitQuarantine = "Cuarentena"
        InitNext = "Ahora puedes ejecutar la actualización de firmas (opción 1)"

        # Update
        UpdateTitle = "ACTUALIZACIÓN DE FIRMAS"
        UpdateNotFound = "No se encuentra freshclam.conf"
        UpdateRunInit = "Ejecuta primero la opción [10] Inicializar configuración"
        UpdateStarting = "Iniciando actualización de base de datos..."
        UpdateNotFoundExe = "freshclam.exe no encontrado"
        UpdateSuccess = "Firmas actualizadas correctamente"
        UpdateError = "Error al actualizar firmas (código:"
        UpdateCheckLog = "Revisa el log:"
        UpdateLogSaved = "Log guardado en:"

        # Quick Scan
        ScanTitle = "ESCANEO RÁPIDO"
        ScanEnterPath = "Introduce la ruta a escanear"
        ScanExamples = "Ejemplos:"
        ScanPath = "Ruta"
        ScanNotExists = "La ruta especificada no existe o no es accesible"
        ScanStarting = "Iniciando escaneo RECURSIVO de:"
        ScanMayTake = "Esto puede tardar varios minutos..."
        ScanCompleted = "Escaneo completado - No se detectaron amenazas"
        ScanThreatsFound = "¡AMENAZAS DETECTADAS! Revisa el reporte"
        ScanError = "Error durante el escaneo (código:"
        ScanReportSaved = "Reporte guardado en:"
        ScanOpenReport = "¿Deseas abrir el reporte? (S/N)"

        # User Profile Scan
        UserScanTitle = "ESCANEO DE PERFIL DE USUARIO"
        UserScanFolders = "Se escanearán RECURSIVAMENTE las siguientes carpetas:"
        UserScanContinue = "¿Continuar? (S/N)"
        UserScanStarting = "Iniciando escaneo..."
        UserScanThreats = "¡AMENAZAS DETECTADAS!"
        UserScanReport = "Reporte:"

        # Full System Scan
        FullScanTitle = "ESCANEO COMPLETO DEL SISTEMA"
        FullScanWarning = "ADVERTENCIA: Este escaneo RECURSIVO analizará TODO el disco C:\"
        FullScanTime = "Puede tardar varias horas dependiendo del tamaño"
        FullScanSure = "¿Estás seguro de continuar? (S/N)"
        FullScanStarting = "Iniciando escaneo completo..."
        FullScanStart = "Hora de inicio:"
        FullScanEnd = "Hora de fin:"

        # Daemon
        DaemonStartTitle = "INICIAR DAEMON CLAMD"
        DaemonStopTitle = "DETENER DAEMON CLAMD"
        DaemonStatusTitle = "ESTADO DEL DAEMON"
        DaemonScanTitle = "ESCANEO CON DAEMON (RÁPIDO)"
        DaemonNotFound = "No se encuentra clamd.conf"
        DaemonRunInit = "Ejecuta primero la opción [10] Inicializar configuración"
        DaemonAlreadyRunning = "El daemon ya está en ejecución (PID:"
        DaemonStarting = "Iniciando clamd en segundo plano..."
        DaemonStarted = "Daemon iniciado correctamente (PID:"
        DaemonPort = "Puerto TCP: 3310"
        DaemonErrorStart = "Error al iniciar el daemon"
        DaemonCheckLog = "Revisa el log:"
        DaemonStopped = "Daemon detenido correctamente"
        DaemonNotRunning = "El daemon no está en ejecución"
        DaemonUseOption = "Usa la opción [5] para iniciar el daemon"
        DaemonActive = "Estado: ACTIVO"
        DaemonInactive = "Estado: INACTIVO"
        DaemonDetails = "Detalles:"
        DaemonPID = "PID:"
        DaemonMemory = "Memoria:"
        DaemonCPU = "CPU:"
        DaemonStartTime = "Inicio:"
        DaemonNotActive = "El daemon no está en ejecución"
        DaemonStartFirst = "Inicia el daemon primero con la opción [5]"
        DaemonScanStarting = "Iniciando escaneo RECURSIVO rápido mediante daemon..."

        # Custom Signature
        CustomSigTitle = "CREAR FIRMA PERSONALIZADA"
        CustomSigEnter = "Introduce la ruta del archivo malicioso"
        CustomSigNotFound = "Archivo no encontrado"
        CustomSigMD5 = "Generando hash MD5..."
        CustomSigSHA256 = "Generando hash SHA256..."
        CustomSigCopy = "Copia los hashes anteriores para crear tu firma personalizada"
        CustomSigFormat = "Formato: hash:tamaño:nombre_malware"

        # Configuration
        ConfigTitle = "CONFIGURACIÓN DE CLAMAV"

        # Logs
        LogsTitle = "VER LOGS"
        LogsNotFound = "No se encontraron logs"
        LogsAvailable = "Logs disponibles:"
        LogsSelect = "Selecciona un log para abrir (0 para cancelar)"

        # Errors
        ErrorMissing = "ERROR: No se encuentran los ejecutables de ClamAV"
        ErrorFiles = "Archivos faltantes:"
        ErrorEnsureFolder = "Asegúrate de ejecutar este script desde la carpeta de ClamAV"
        ErrorFirstRun = "Primera ejecución detectada"
        ErrorNeedInit = "Es necesario inicializar la configuración"
        ErrorInitNow = "¿Deseas inicializar la configuración ahora? (S/N)"

        # Goodbye
        Goodbye = "¡Hasta pronto!"
    }
}

# Get string helper function
function Get-String {
    param([string]$Key)
    return $strings[$global:Language][$Key]
}

# ============================================
# AUTOMATIC CONFIGURATION
# ============================================

# Auto-detect script path
$CLAMAV_PATH = Split-Path -Parent $MyInvocation.MyCommand.Path
$LOG_PATH = Join-Path $CLAMAV_PATH "logs"
$QUARANTINE_PATH = Join-Path $CLAMAV_PATH "quarantine"
$SCAN_REPORTS = Join-Path $CLAMAV_PATH "reports"
$DATABASE_PATH = Join-Path $CLAMAV_PATH "database"

# Create directories if they don't exist
@($LOG_PATH, $QUARANTINE_PATH, $SCAN_REPORTS, $DATABASE_PATH) | ForEach-Object {
    if (!(Test-Path $_)) { New-Item -ItemType Directory -Path $_ -Force | Out-Null }
}

# ============================================
# HELPER FUNCTIONS
# ============================================

function Show-Banner {
    Clear-Host
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host "       ClamAV Management Console v2.0                        " -ForegroundColor Cyan
    Write-Host "=============================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "$(Get-String 'WorkingDir'): $CLAMAV_PATH" -ForegroundColor Gray
    Write-Host ""
}

function Show-Message {
    param(
        [string]$Message,
        [ValidateSet('Info','Success','Warning','Error')]
        [string]$Type = 'Info'
    )

    $color = switch ($Type) {
        'Info'    { 'White' }
        'Success' { 'Green' }
        'Warning' { 'Yellow' }
        'Error'   { 'Red' }
    }

    $prefix = switch ($Type) {
        'Info'    { '[i]' }
        'Success' { '[✓]' }
        'Warning' { '[!]' }
        'Error'   { '[✗]' }
    }

    Write-Host "$prefix $Message" -ForegroundColor $color
}

function Pause-Script {
    Write-Host "`n$(Get-String 'PressKey')" -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Get-YesNo {
    param([string]$Response)
    if ($global:Language -eq "es") {
        return ($Response -eq 'S' -or $Response -eq 's')
    } else {
        return ($Response -eq 'Y' -or $Response -eq 'y')
    }
}

# ============================================
# CLAMAV FUNCTIONS
# ============================================

function Initialize-ClamAVConfig {
    Show-Banner
    Write-Host "=== $(Get-String 'InitTitle') ===`n" -ForegroundColor Yellow

    $confExamplesPath = Join-Path $CLAMAV_PATH "conf_examples"
    $freshclamConf = Join-Path $CLAMAV_PATH "freshclam.conf"
    $clamdConf = Join-Path $CLAMAV_PATH "clamd.conf"

    if ((Test-Path $freshclamConf) -and (Test-Path $clamdConf)) {
        Show-Message "$(Get-String 'InitExists')" -Type Info
        $overwrite = Read-Host "$(Get-String 'InitRecreate')"
        if (!(Get-YesNo $overwrite)) {
            Pause-Script
            return
        }
    }

    if (!(Test-Path $confExamplesPath)) {
        Show-Message "$(Get-String 'InitNotFound')" -Type Error
        Show-Message "$(Get-String 'InitEnsure')" -Type Warning
        Pause-Script
        return
    }

    Show-Message "$(Get-String 'InitCopying')" -Type Info

    $freshclamSample = Join-Path $confExamplesPath "freshclam.conf.sample"
    $clamdSample = Join-Path $confExamplesPath "clamd.conf.sample"

    if (Test-Path $freshclamSample) {
        Copy-Item -Path $freshclamSample -Destination $freshclamConf -Force
        Show-Message "freshclam.conf $(Get-String 'InitCopied')" -Type Success
    } else {
        Show-Message "freshclam.conf.sample $(Get-String 'InitNotFoundSample')" -Type Error
    }

    if (Test-Path $clamdSample) {
        Copy-Item -Path $clamdSample -Destination $clamdConf -Force
        Show-Message "clamd.conf $(Get-String 'InitCopied')" -Type Success
    } else {
        Show-Message "clamd.conf.sample $(Get-String 'InitNotFoundSample')" -Type Error
    }

    if (Test-Path $freshclamConf) {
        Show-Message "`n$(Get-String 'InitConfiguring') freshclam.conf..." -Type Info

        $freshclamContent = Get-Content $freshclamConf
        $freshclamContent = $freshclamContent -replace '^Example$', '#Example'
        $freshclamContent = $freshclamContent -replace '^#?DatabaseDirectory.*', "DatabaseDirectory $DATABASE_PATH"
        $freshclamContent = $freshclamContent -replace '^#?UpdateLogFile.*', "UpdateLogFile $LOG_PATH\freshclam.log"
        $freshclamContent = $freshclamContent -replace '^#?LogVerbose$', 'LogVerbose'
        $freshclamContent = $freshclamContent -replace '^#?DatabaseMirror database.clamav.net', 'DatabaseMirror database.clamav.net'
        $freshclamContent | Set-Content $freshclamConf -Encoding UTF8

        Show-Message "freshclam.conf $(Get-String 'InitConfigured')" -Type Success
    }

    if (Test-Path $clamdConf) {
        Show-Message "$(Get-String 'InitConfiguring') clamd.conf..." -Type Info

        $clamdContent = Get-Content $clamdConf
        $clamdContent = $clamdContent -replace '^Example$', '#Example'
        $clamdContent = $clamdContent -replace '^#?DatabaseDirectory.*', "DatabaseDirectory $DATABASE_PATH"
        $clamdContent = $clamdContent -replace '^#?LogFile.*', "LogFile $LOG_PATH\clamd.log"
        $clamdContent = $clamdContent -replace '^#?LogVerbose$', 'LogVerbose'
        $clamdContent = $clamdContent -replace '^#?TCPSocket.*', 'TCPSocket 3310'
        $clamdContent = $clamdContent -replace '^#?TCPAddr.*', 'TCPAddr 127.0.0.1'
        $clamdContent = $clamdContent -replace '^#?MaxThreads.*', 'MaxThreads 12'
        $clamdContent = $clamdContent -replace '^#?MaxDirectoryRecursion.*', 'MaxDirectoryRecursion 20'
        $clamdContent | Set-Content $clamdConf -Encoding UTF8

        Show-Message "clamd.conf $(Get-String 'InitConfigured')" -Type Success
    }

    Show-Message "`n$(Get-String 'InitCompleted')" -Type Success
    Show-Message "$(Get-String 'InitDirectories')" -Type Info
    Write-Host "  - $(Get-String 'InitLogs'): $LOG_PATH" -ForegroundColor Cyan
    Write-Host "  - $(Get-String 'InitDatabase'): $DATABASE_PATH" -ForegroundColor Cyan
    Write-Host "  - $(Get-String 'InitReports'): $SCAN_REPORTS" -ForegroundColor Cyan
    Write-Host "  - $(Get-String 'InitQuarantine'): $QUARANTINE_PATH" -ForegroundColor Cyan

    Show-Message "`n$(Get-String 'InitNext')" -Type Info

    Pause-Script
}

function Update-Signatures {
    Show-Banner
    Write-Host "=== $(Get-String 'UpdateTitle') ===`n" -ForegroundColor Yellow

    $freshclamConf = Join-Path $CLAMAV_PATH "freshclam.conf"
    if (!(Test-Path $freshclamConf)) {
        Show-Message "$(Get-String 'UpdateNotFound')" -Type Error
        Show-Message "$(Get-String 'UpdateRunInit')" -Type Warning
        Pause-Script
        return
    }

    Show-Message "$(Get-String 'UpdateStarting')" -Type Info

    $freshclamPath = Join-Path $CLAMAV_PATH "freshclam.exe"

    if (!(Test-Path $freshclamPath)) {
        Show-Message "$(Get-String 'UpdateNotFoundExe')" -Type Error
        Pause-Script
        return
    }

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $logFile = Join-Path $LOG_PATH "freshclam_$timestamp.log"

    Push-Location $CLAMAV_PATH
    & ".\freshclam.exe" --verbose --log="$logFile"
    Pop-Location

    if ($LASTEXITCODE -eq 0) {
        Show-Message "$(Get-String 'UpdateSuccess')" -Type Success
        Show-Message "$(Get-String 'UpdateLogSaved') $logFile" -Type Info
    } else {
        Show-Message "$(Get-String 'UpdateError') $LASTEXITCODE)" -Type Error
        Show-Message "$(Get-String 'UpdateCheckLog') $logFile" -Type Warning
    }

    Pause-Script
}

function Start-QuickScan {
    Show-Banner
    Write-Host "=== $(Get-String 'ScanTitle') ===`n" -ForegroundColor Yellow

    Show-Message "$(Get-String 'ScanEnterPath')" -Type Info
    Write-Host "$(Get-String 'ScanExamples'):" -ForegroundColor Cyan
    Write-Host "  - C:\Users\$env:USERNAME\Downloads" -ForegroundColor Gray
    Write-Host "  - D:\documentos" -ForegroundColor Gray
    Write-Host "  - \\192.168.0.100\directory\PDFs" -ForegroundColor Gray
    Write-Host ""

    $scanPath = Read-Host "$(Get-String 'ScanPath')"

    if (!(Test-Path $scanPath)) {
        Show-Message "$(Get-String 'ScanNotExists')" -Type Error
        Pause-Script
        return
    }

    $clamscanPath = Join-Path $CLAMAV_PATH "clamscan.exe"
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $reportFile = Join-Path $SCAN_REPORTS "scan_$timestamp.txt"

    Show-Message "$(Get-String 'ScanStarting') $scanPath" -Type Info
    Show-Message "$(Get-String 'ScanMayTake')" -Type Warning

    Push-Location $CLAMAV_PATH
    & ".\clamscan.exe" --recursive --verbose --infected --bell --log="$reportFile" "$scanPath"
    Pop-Location

    if ($LASTEXITCODE -eq 0) {
        Show-Message "$(Get-String 'ScanCompleted')" -Type Success
    } elseif ($LASTEXITCODE -eq 1) {
        Show-Message "$(Get-String 'ScanThreatsFound')" -Type Error
    } else {
        Show-Message "$(Get-String 'ScanError') $LASTEXITCODE)" -Type Warning
    }

    Show-Message "$(Get-String 'ScanReportSaved') $reportFile" -Type Info

    $openReport = Read-Host "`n$(Get-String 'ScanOpenReport')"
    if (Get-YesNo $openReport) {
        notepad $reportFile
    }

    Pause-Script
}

function Start-UserProfileScan {
    Show-Banner
    Write-Host "=== $(Get-String 'UserScanTitle') ===`n" -ForegroundColor Yellow

    $userFolders = @(
        "$env:USERPROFILE\Desktop",
        "$env:USERPROFILE\Downloads",
        "$env:USERPROFILE\Documents"
    )

    Show-Message "$(Get-String 'UserScanFolders')" -Type Info
    $userFolders | ForEach-Object { Write-Host "  - $_" -ForegroundColor Cyan }

    $confirm = Read-Host "`n$(Get-String 'UserScanContinue')"
    if (!(Get-YesNo $confirm)) { return }

    $clamscanPath = Join-Path $CLAMAV_PATH "clamscan.exe"
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $reportFile = Join-Path $SCAN_REPORTS "user_profile_scan_$timestamp.txt"

    Show-Message "$(Get-String 'UserScanStarting')" -Type Info

    Push-Location $CLAMAV_PATH
    & ".\clamscan.exe" --recursive --verbose --infected --bell --log="$reportFile" $userFolders
    Pop-Location

    if ($LASTEXITCODE -eq 0) {
        Show-Message "$(Get-String 'ScanCompleted')" -Type Success
    } elseif ($LASTEXITCODE -eq 1) {
        Show-Message "$(Get-String 'UserScanThreats')" -Type Error
    }

    Show-Message "$(Get-String 'UserScanReport') $reportFile" -Type Info

    $openReport = Read-Host "`n$(Get-String 'ScanOpenReport')"
    if (Get-YesNo $openReport) {
        notepad $reportFile
    }

    Pause-Script
}

function Start-FullSystemScan {
    Show-Banner
    Write-Host "=== $(Get-String 'FullScanTitle') ===`n" -ForegroundColor Yellow

    Show-Message "$(Get-String 'FullScanWarning')" -Type Warning
    Show-Message "$(Get-String 'FullScanTime')" -Type Warning

    $confirm = Read-Host "`n$(Get-String 'FullScanSure')"
    if (!(Get-YesNo $confirm)) { return }

    $clamscanPath = Join-Path $CLAMAV_PATH "clamscan.exe"
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $reportFile = Join-Path $SCAN_REPORTS "full_system_scan_$timestamp.txt"

    Show-Message "$(Get-String 'FullScanStarting')" -Type Info
    Show-Message "$(Get-String 'FullScanStart') $(Get-Date -Format 'HH:mm:ss')" -Type Info

    Push-Location $CLAMAV_PATH
    & ".\clamscan.exe" --recursive --verbose --infected --bell --log="$reportFile" "C:\"
    Pop-Location

    Show-Message "$(Get-String 'FullScanEnd') $(Get-Date -Format 'HH:mm:ss')" -Type Info

    if ($LASTEXITCODE -eq 0) {
        Show-Message "$(Get-String 'ScanCompleted')" -Type Success
    } elseif ($LASTEXITCODE -eq 1) {
        Show-Message "$(Get-String 'ScanThreatsFound')" -Type Error
    }

    Show-Message "$(Get-String 'ScanReportSaved') $reportFile" -Type Info

    Pause-Script
}

function Start-DaemonService {
    Show-Banner
    Write-Host "=== $(Get-String 'DaemonStartTitle') ===`n" -ForegroundColor Yellow

    $clamdConf = Join-Path $CLAMAV_PATH "clamd.conf"
    if (!(Test-Path $clamdConf)) {
        Show-Message "$(Get-String 'DaemonNotFound')" -Type Error
        Show-Message "$(Get-String 'DaemonRunInit')" -Type Warning
        Pause-Script
        return
    }

    $clamdPath = Join-Path $CLAMAV_PATH "clamd.exe"

    $existingProcess = Get-Process -Name "clamd" -ErrorAction SilentlyContinue
    if ($existingProcess) {
        Show-Message "$(Get-String 'DaemonAlreadyRunning') $($existingProcess.Id))" -Type Warning
        Pause-Script
        return
    }

    Show-Message "$(Get-String 'DaemonStarting')" -Type Info

    Push-Location $CLAMAV_PATH
    Start-Process -FilePath ".\clamd.exe" -WindowStyle Hidden -WorkingDirectory $CLAMAV_PATH
    Pop-Location

    Start-Sleep -Seconds 3

    $process = Get-Process -Name "clamd" -ErrorAction SilentlyContinue

    if ($process) {
        Show-Message "$(Get-String 'DaemonStarted') $($process.Id))" -Type Success
        Show-Message "$(Get-String 'DaemonPort')" -Type Info
    } else {
        Show-Message "$(Get-String 'DaemonErrorStart')" -Type Error
        Show-Message "$(Get-String 'DaemonCheckLog') $LOG_PATH\clamd.log" -Type Warning
    }

    Pause-Script
}

function Stop-DaemonService {
    Show-Banner
    Write-Host "=== $(Get-String 'DaemonStopTitle') ===`n" -ForegroundColor Yellow

    $process = Get-Process -Name "clamd" -ErrorAction SilentlyContinue

    if ($process) {
        Stop-Process -Name "clamd" -Force
        Show-Message "$(Get-String 'DaemonStopped')" -Type Success
    } else {
        Show-Message "$(Get-String 'DaemonNotRunning')" -Type Warning
    }

    Pause-Script
}

function Show-DaemonStatus {
    Show-Banner
    Write-Host "=== $(Get-String 'DaemonStatusTitle') ===`n" -ForegroundColor Yellow

    $process = Get-Process -Name "clamd" -ErrorAction SilentlyContinue

    if ($process) {
        Show-Message "$(Get-String 'DaemonActive')" -Type Success
        Write-Host "`n$(Get-String 'DaemonDetails'):" -ForegroundColor Cyan
        Write-Host "  $(Get-String 'DaemonPID') $($process.Id)"
        Write-Host "  $(Get-String 'DaemonMemory') $([math]::Round($process.WorkingSet64/1MB, 2)) MB"
        Write-Host "  $(Get-String 'DaemonCPU') $([math]::Round($process.CPU, 2)) segundos"
        Write-Host "  $(Get-String 'DaemonStartTime') $($process.StartTime)"
        Write-Host "  $(Get-String 'DaemonPort')"
    } else {
        Show-Message "$(Get-String 'DaemonInactive')" -Type Warning
        Show-Message "$(Get-String 'DaemonUseOption')" -Type Info
    }

    Pause-Script
}

function Start-DaemonScan {
    Show-Banner
    Write-Host "=== $(Get-String 'DaemonScanTitle') ===`n" -ForegroundColor Yellow

    $process = Get-Process -Name "clamd" -ErrorAction SilentlyContinue
    if (!$process) {
        Show-Message "$(Get-String 'DaemonNotActive')" -Type Error
        Show-Message "$(Get-String 'DaemonStartFirst')" -Type Warning
        Pause-Script
        return
    }

    $scanPath = Read-Host "$(Get-String 'ScanPath')"

    if (!(Test-Path $scanPath)) {
        Show-Message "$(Get-String 'ScanNotExists')" -Type Error
        Pause-Script
        return
    }

    $clamdscanPath = Join-Path $CLAMAV_PATH "clamdscan.exe"
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $reportFile = Join-Path $SCAN_REPORTS "daemon_scan_$timestamp.txt"

    Show-Message "$(Get-String 'DaemonScanStarting')" -Type Info

    Push-Location $CLAMAV_PATH
    & ".\clamdscan.exe" --multiscan --verbose --log="$reportFile" "$scanPath"
    Pop-Location

    if ($LASTEXITCODE -eq 0) {
        Show-Message "$(Get-String 'ScanCompleted')" -Type Success
    } elseif ($LASTEXITCODE -eq 1) {
        Show-Message "$(Get-String 'ScanThreatsFound')" -Type Error
    }

    Show-Message "$(Get-String 'ScanReportSaved') $reportFile" -Type Info

    Pause-Script
}

function Create-CustomSignature {
    Show-Banner
    Write-Host "=== $(Get-String 'CustomSigTitle') ===`n" -ForegroundColor Yellow

    $filePath = Read-Host "$(Get-String 'CustomSigEnter')"

    if (!(Test-Path $filePath)) {
        Show-Message "$(Get-String 'CustomSigNotFound')" -Type Error
        Pause-Script
        return
    }

    $sigtoolPath = Join-Path $CLAMAV_PATH "sigtool.exe"

    Push-Location $CLAMAV_PATH

    Show-Message "`n$(Get-String 'CustomSigMD5')" -Type Info
    & ".\sigtool.exe" --md5 "$filePath"

    Show-Message "`n$(Get-String 'CustomSigSHA256')" -Type Info
    & ".\sigtool.exe" --sha256 "$filePath"

    Pop-Location

    Show-Message "`n$(Get-String 'CustomSigCopy')" -Type Warning
    Show-Message "$(Get-String 'CustomSigFormat')" -Type Info

    Pause-Script
}

function Show-Configuration {
    Show-Banner
    Write-Host "=== $(Get-String 'ConfigTitle') ===`n" -ForegroundColor Yellow

    $clamconfPath = Join-Path $CLAMAV_PATH "clamconf.exe"

    Push-Location $CLAMAV_PATH
    & ".\clamconf.exe"
    Pop-Location

    Pause-Script
}

function Show-Logs {
    Show-Banner
    Write-Host "=== $(Get-String 'LogsTitle') ===`n" -ForegroundColor Yellow

    $logs = Get-ChildItem -Path $LOG_PATH -Filter "*.log" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending

    if ($logs.Count -eq 0) {
        Show-Message "$(Get-String 'LogsNotFound')" -Type Warning
        Pause-Script
        return
    }

    Show-Message "$(Get-String 'LogsAvailable'):" -Type Info
    Write-Host ""

    for ($i = 0; $i -lt $logs.Count; $i++) {
        Write-Host "[$($i+1)] $($logs[$i].Name) - $(Get-Date $logs[$i].LastWriteTime -Format 'dd/MM/yyyy HH:mm')" -ForegroundColor Cyan
    }

    Write-Host ""
    $selection = Read-Host "$(Get-String 'LogsSelect')"

    if ($selection -match '^\d+$' -and [int]$selection -gt 0 -and [int]$selection -le $logs.Count) {
        $selectedLog = $logs[[int]$selection - 1]
        notepad $selectedLog.FullName
    }

    Pause-Script
}

# ============================================
# MAIN MENU
# ============================================

function Show-MainMenu {
    do {
        Show-Banner

        Write-Host "=============================================================" -ForegroundColor White
        Write-Host " $(Get-String 'MenuTitle')" -ForegroundColor Yellow
        Write-Host "=============================================================" -ForegroundColor White
        Write-Host ""
        Write-Host " $(Get-String 'MenuSignatures')" -ForegroundColor Yellow
        Write-Host "  [1] $(Get-String 'Menu1')" -ForegroundColor White
        Write-Host "  [2] $(Get-String 'Menu2')" -ForegroundColor White
        Write-Host ""
        Write-Host " $(Get-String 'MenuScanning')" -ForegroundColor Yellow
        Write-Host "  [3] $(Get-String 'Menu3')" -ForegroundColor White
        Write-Host "  [4] $(Get-String 'Menu4')" -ForegroundColor White
        Write-Host "  [9] $(Get-String 'Menu9')" -ForegroundColor White
        Write-Host ""
        Write-Host " $(Get-String 'MenuDaemon')" -ForegroundColor Yellow
        Write-Host "  [5] $(Get-String 'Menu5')" -ForegroundColor White
        Write-Host "  [6] $(Get-String 'Menu6')" -ForegroundColor White
        Write-Host "  [7] $(Get-String 'Menu7')" -ForegroundColor White
        Write-Host "  [8] $(Get-String 'Menu8')" -ForegroundColor White
        Write-Host ""
        Write-Host " $(Get-String 'MenuAdvanced')" -ForegroundColor Yellow
        Write-Host "  [11] $(Get-String 'Menu11')" -ForegroundColor White
        Write-Host "  [12] $(Get-String 'Menu12')" -ForegroundColor White
        Write-Host ""
        Write-Host " $(Get-String 'MenuConfig')" -ForegroundColor Yellow
        Write-Host "  [10] $(Get-String 'Menu10')" -ForegroundColor White
        Write-Host ""
        Write-Host "  [0] $(Get-String 'Menu0')" -ForegroundColor White
        Write-Host ""
        Write-Host "=============================================================" -ForegroundColor White
        Write-Host ""

        $selection = Read-Host "$(Get-String 'SelectOption')"

        switch ($selection) {
            '1'  { Update-Signatures }
            '2'  { Show-Configuration }
            '3'  { Start-QuickScan }
            '4'  { Start-UserProfileScan }
            '5'  { Start-DaemonService }
            '6'  { Stop-DaemonService }
            '7'  { Show-DaemonStatus }
            '8'  { Start-DaemonScan }
            '9'  { Start-FullSystemScan }
            '10' { Initialize-ClamAVConfig }
            '11' { Create-CustomSignature }
            '12' { Show-Logs }
            '0'  { 
                Show-Message "$(Get-String 'Goodbye')" -Type Success
                Start-Sleep -Seconds 1
                return 
            }
            default { 
                Show-Message "$(Get-String 'InvalidOption')" -Type Error
                Start-Sleep -Seconds 2
            }
        }
    } while ($true)
}

# ============================================
# ENTRY POINT
# ============================================

# Verify correct folder
$requiredFiles = @("clamscan.exe", "freshclam.exe", "clamd.exe")
$missingFiles = $requiredFiles | Where-Object { !(Test-Path (Join-Path $CLAMAV_PATH $_)) }

if ($missingFiles.Count -gt 0) {
    Write-Host "$(Get-String 'ErrorMissing')" -ForegroundColor Red
    Write-Host "$(Get-String 'ErrorFiles'): $($missingFiles -join ', ')" -ForegroundColor Yellow
    Write-Host "`n$(Get-String 'ErrorEnsureFolder')" -ForegroundColor Yellow
    Pause-Script
    exit
}

# Check first run
$freshclamConf = Join-Path $CLAMAV_PATH "freshclam.conf"
$clamdConf = Join-Path $CLAMAV_PATH "clamd.conf"

if (!(Test-Path $freshclamConf) -or !(Test-Path $clamdConf)) {
    Show-Banner
    Show-Message "$(Get-String 'ErrorFirstRun')" -Type Warning
    Show-Message "$(Get-String 'ErrorNeedInit')" -Type Info
    Write-Host ""
    $init = Read-Host "$(Get-String 'ErrorInitNow')"

    if (Get-YesNo $init) {
        Initialize-ClamAVConfig
    }
}

# Start main menu
Show-MainMenu
