# ClamAV Manager

A PowerShell-based management console for ClamAV on Windows with automated configuration, multilingual support, scanning capabilities, and daemon control.

## Features

- **Multilingual Support**: Choose between English and Spanish on startup
- **Automated Configuration**: One-click setup of ClamAV configuration files
- **Signature Management**: Easy virus definition updates via freshclam
- **Multiple Scan Modes**:
  - Quick scan (any directory or UNC path)
  - User profile scan (Desktop, Downloads, Documents)
  - Full system scan
  - Daemon-based scanning (faster)
- **Daemon Control**: Start, stop, and monitor ClamD service
- **Custom Signatures**: Generate MD5/SHA256 hashes for custom virus definitions
- **Detailed Logging**: All operations are logged with timestamps
- **Report Generation**: Comprehensive scan reports in text format

## Requirements

- Windows OS
- ClamAV for Windows installed
- PowerShell 5.1 or later

## Installation

1. Download ClamAV for Windows from the [official repository](https://www.clamav.net/downloads)
2. Extract ClamAV to a directory (e.g., `C:\clamav`)
3. Place `ClamAV-Manager.ps1` in the ClamAV directory
4. Unblock the script file:
   ```powershell
   Unblock-File -Path "C:\clamav\ClamAV-Manager.ps1"
   ```
5. Run PowerShell as Administrator:
   ```powershell
   cd C:\clamav
   .\ClamAV-Manager.ps1
   ```

## Language Selection

On first run, you'll be prompted to select your preferred language:

```
Select Language / Seleccionar Idioma:

  [1] English
  [2] Español
```

The interface will adapt to your selection, including:
- All menu options
- Messages and notifications
- Error messages
- Help text
- Input prompts (Y/N or S/N)

## First Run

On first execution, the script will:
1. Prompt for language selection (English or Spanish)
2. Detect if configuration files are missing
3. Offer to initialize configuration automatically
4. Create necessary directories (logs, reports, quarantine, database)
5. Configure `freshclam.conf` and `clamd.conf` with proper paths

## Usage

### Initialize Configuration
```powershell
# Select option [10] from the menu
```

### Update Virus Definitions
```powershell
# Select option [1] from the menu
```

### Scan a Directory
```powershell
# Select option [3] from the menu
# Enter path: C:\Users\YourName\Downloads
# Or UNC path: \\server\share\folder
```

### Start Daemon Mode
```powershell
# Select option [5] to start daemon
# Select option [8] for fast daemon-based scanning
```

## Directory Structure

```
ClamAV/
├── ClamAV-Manager.ps1
├── clamscan.exe
├── freshclam.exe
├── clamd.exe
├── logs/              # freshclam and clamd logs
├── reports/           # scan reports
├── quarantine/        # infected files (if move option used)
└── database/          # virus definitions
```

## Menu Options

| Option | Description |
|--------|-------------|
| 1 | Update virus signatures |
| 2 | View ClamAV configuration |
| 3 | Quick scan (any directory/UNC) |
| 4 | Scan user profile |
| 5 | Start ClamD daemon |
| 6 | Stop ClamD daemon |
| 7 | View daemon status |
| 8 | Daemon-based scan (faster) |
| 9 | Full system scan (C:\) |
| 10 | Initialize/repair configuration |
| 11 | Create custom signature |
| 12 | View logs |
| 0 | Exit |

## Scan Features

All scans are **recursive** by default and include:
- Real-time progress display
- Detailed logging to file
- Summary statistics (files scanned, threats found)
- Option to open report after completion

## Network Scanning

ClamAV Manager supports scanning UNC paths directly:
```
\\192.168.1.100\shared
\\server.domain.local\data
\\192.168.0.100\directory\PDFs
```

Simply use option [3] and enter the UNC path when prompted. The script will access the network path using your current Windows credentials.

## Configuration Files

The script automatically configures:

**freshclam.conf**
- Database directory
- Update log file
- Mirror servers

**clamd.conf**
- Database directory
- Log file
- TCP socket (port 3310)
- Maximum threads (12)
- Directory recursion depth (20)

## Logging

All operations generate timestamped logs in the `logs/` directory:
- `freshclam_YYYYMMDD_HHMMSS.log` - Update logs
- `clamd.log` - Daemon activity log

Scan reports are saved in the `reports/` directory:
- `scan_YYYYMMDD_HHMMSS.txt` - Quick scan reports
- `user_profile_scan_YYYYMMDD_HHMMSS.txt` - User profile scan reports
- `full_system_scan_YYYYMMDD_HHMMSS.txt` - Full system scan reports
- `daemon_scan_YYYYMMDD_HHMMSS.txt` - Daemon scan reports

## Troubleshooting

### Script not running (execution policy error)

If you see an error about unsigned scripts:

```powershell
# Option 1: Unblock the file
Unblock-File -Path ".\ClamAV-Manager.ps1"

# Option 2: Set execution policy (run as Administrator)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Option 3: Bypass for single execution
powershell -ExecutionPolicy Bypass -File ".\ClamAV-Manager.ps1"
```

### freshclam fails to update
- Check internet connectivity
- Verify `freshclam.conf` exists and is properly configured
- Run option [10] to reinitialize configuration

### Daemon won't start
- Verify `clamd.conf` exists
- Check if port 3310 is available
- Review `logs/clamd.log` for errors
- Make sure you're running from the ClamAV directory

### UNC path not accessible
- Verify network connectivity
- Ensure you have proper permissions to the network share
- Check if the path is reachable: `Test-Path "\\server\share"`
- Try accessing the share in Windows Explorer first

### Language not switching
- Language is selected on script startup
- Restart the script to change language
- Language preference is not persistent between sessions

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

### Adding New Languages

To add a new language, edit the `$strings` hashtable in the script:

```powershell
$strings = @{
    en = @{ ... }
    es = @{ ... }
    fr = @{ ... }  # Add new language here
}
```

Then update the `Select-Language` function to include the new option.

## License

This script is provided as-is for managing ClamAV installations. ClamAV itself is licensed under GPL v2.

## Author

Alex Milla - [alexmilla.dev](https://alexmilla.dev)

## Version History

- **v1.0.20260214** (February 2026)
  - Added multilingual support (English/Spanish)
  - Simplified network scanning (direct UNC path support)
  - Improved menu organization
  - Enhanced error handling
  - Better user experience with language-specific prompts

- **v1.x** (Previous versions)
  - Initial release
  - Basic ClamAV management features

## Acknowledgments

- ClamAV Team for the excellent open-source antivirus engine
- Community contributors for testing and feedback
