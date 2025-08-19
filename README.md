[![Releases](https://img.shields.io/badge/Releases-download-blue?logo=github&style=for-the-badge)](https://github.com/kittipat-Nung/Powershell_Scripts/releases)

https://github.com/kittipat-Nung/Powershell_Scripts/releases

# PowerShell Scripts Hub — Admin Tools, Automation, Kiosk Mode

🛠️ ⚙️ 🔒  
![PowerShell Logo](https://raw.githubusercontent.com/github/explore/main/topics/powershell/powershell.png)  
![Windows Logo](https://raw.githubusercontent.com/github/explore/main/topics/windows/windows.png)

Table of Contents
- About this repo
- Key features
- Badge links
- Quick start (download & run)
- Install and prerequisites
- Common scripts and examples
- Automation & scheduling
- Kiosk mode and Edge configuration
- Security & best practices
- Troubleshooting
- Contributing
- Releases
- License

About this repo
This repository stores PowerShell scripts I use for system administration, automation, and kiosk deployments. It collects tools for batch processing, security checks, configuration, and utilities for Windows environments. The scripts focus on clarity, idempotence, and small surface area.

Key features
- Admin tools for user, service, and process management.
- Automation for software install, updates, and cleanup.
- Kiosk-mode helpers for Microsoft Edge lockdown and profile management.
- Security-awareness scripts for audit, logs, and indicators.
- Utilities for batch processing and system reporting.
- Scripts use standard PowerShell (PS5+ and PS7 compatible where noted).

Badge links
- Releases: [![Releases](https://img.shields.io/badge/Releases-download-blue?logo=github)](https://github.com/kittipat-Nung/Powershell_Scripts/releases)
- Topics: admin-tools | automation | powershell | windows | kiosk-mode

Quick start (download & run)
The releases page hosts packaged scripts and signed assets. Download the release asset you need and run the included .ps1 file.

Example: download and run a release script
1. Open PowerShell as Administrator.
2. Download the asset (replace NAME with the actual file name found on the releases page):
   ```
   Invoke-WebRequest -Uri "https://github.com/kittipat-Nung/Powershell_Scripts/releases/download/v1.0.0/Deploy-Kiosk.ps1" -OutFile .\Deploy-Kiosk.ps1
   ```
3. Execute the script with a bypass policy:
   ```
   powershell -ExecutionPolicy Bypass -File .\Deploy-Kiosk.ps1
   ```
If the releases link does not work, visit the Releases section on the repository page and download the latest asset:
https://github.com/kittipat-Nung/Powershell_Scripts/releases

Install and prerequisites
- PowerShell 5.1 or PowerShell 7+.
- Administrative rights for system-level changes.
- For Edge kiosk scripts: Microsoft Edge installed (Chromium).
- Optional: Chocolatey for package automation.
Commands to check environment:
```
$PSVersionTable.PSVersion
Get-Command pwsh -ErrorAction SilentlyContinue
```
Install PowerShell 7 (if needed):
```
winget install --id=Microsoft.PowerShell --source winget
```

Common scripts and examples
Scripts grouped by task. Each folder contains README notes and usage examples.

1) system/
- Get-SystemReport.ps1 — dump CPU, memory, disk, network, and running services.
- Cleanup-TempAndLogs.ps1 — rotate logs, clear temp folders, and compress archives.
Example:
```
.\Get-SystemReport.ps1 -OutputPath C:\Reports\sysreport.json
```

2) users/
- Create-LocalUser.ps1 — create local users with secure password handling.
- Set-UserExpiration.ps1 — set account expiration and notify via event log.

3) services/
- Ensure-ServiceRunning.ps1 — check and start service, set recovery options.
- Service-ConfigBackup.ps1 — export service key settings to JSON.

4) security/
- Audit-LocalAdmins.ps1 — list local admin memberships and create a report.
- Check-EventLogAlerts.ps1 — scan Security and System logs for defined patterns.

5) kiosk/
- Deploy-Kiosk.ps1 — configure Windows for kiosk mode using assigned access.
- Edge-KioskConfig.ps1 — configure Edge kiosk policies, favorites, and homepage.
Example of deploying kiosk:
```
.\Deploy-Kiosk.ps1 -DeviceName KIOSK-001 -UserAccount kiosk_user -EdgeMode singleApp
```

6) automation/
- Silent-Install-Choco.ps1 — install Chocolatey and common packages.
- Update-AllApps.ps1 — run updates for installed apps and log results.

Usage patterns
- Parameter-driven scripts: most scripts accept parameters for target paths, users, and log levels.
- Logging: scripts write structured logs to C:\ProgramData\PSScripts\logs by default.
- Idempotent design: scripts check state before changing it.

Automation & scheduling
Use Task Scheduler or ScheduledJobs to automate scripts.

Create a scheduled task example:
```
$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument '-ExecutionPolicy Bypass -File C:\Scripts\Cleanup-TempAndLogs.ps1'
$trigger = New-ScheduledTaskTrigger -Daily -At 3am
Register-ScheduledTask -TaskName "Daily-Cleanup" -Action $action -Trigger $trigger -User "SYSTEM"
```
Use Scheduled Jobs (PowerShell module) for jobs that persist across reboots:
```
Register-ScheduledJob -Name "HourlyReport" -FilePath C:\Scripts\Get-SystemReport.ps1 -Trigger (New-JobTrigger -Once -At (Get-Date).AddMinutes(5) -RepetitionInterval (New-TimeSpan -Hours 1) -RepetitionDuration ([TimeSpan]::MaxValue))
```

Kiosk mode and Edge configuration
Scripts configure kiosk scenarios and apply Edge policies.

Common steps performed by scripts:
- Create a local kiosk user with limited rights.
- Configure AssignedAccess for single app or multi-app kiosk.
- Apply Group Policy Preferences for Edge via registry keys or local policies.
- Deploy a curated favorites list and homepage for Edge.

Edge kiosk example:
```
.\Edge-KioskConfig.ps1 -KioskUser kiosk_user -StartupUrl "https://intranet.example.local" -FavoritesFile .\edge-favorites.json
```
Scripts create a backup of current Edge policies before applying changes.

Security & best practices
- Run privileged scripts from an admin context only.
- Use secure strings for passwords:
  ```
  $pw = Read-Host -AsSecureString
  ```
- Audit changes: scripts append actions to an event log and to JSON audit files.
- Sign scripts in production where possible.
- Limit scope: test in a lab environment before running in production.
- Principle of least privilege: create accounts with minimal rights needed for kiosk or automation.

Troubleshooting
- Script fails with execution policy error: run with -ExecutionPolicy Bypass or sign the script.
- Module not found: install required module via Install-Module or include module vendor link.
- Network blocked: ensure the device can reach internal package sources.

Common debug steps
- Run script with -Verbose and -WhatIf where supported:
  ```
  .\Create-LocalUser.ps1 -UserName tempuser -WhatIf
  ```
- Check log files at:
  ```
  C:\ProgramData\PSScripts\logs
  ```
- Review Windows Event Viewer > Applications and Services Logs > PowerShell.

Contributing
- Fork the repo, create a feature branch, and open a PR.
- Use clear commit messages and keep changes focused.
- Add tests where applicable. For scripts that change system state, provide a dry-run mode or -WhatIf support.
- Follow script style: Verb-Noun, parameter validation, and comment blocks for help.
- Example PR checklist:
  - Script includes comment-based help.
  - Script passes PSScriptAnalyzer rules or an agreed subset.
  - README updates if you add features or new scripts.

Releases
Visit the releases page to download packaged assets and signed scripts:
https://github.com/kittipat-Nung/Powershell_Scripts/releases

The releases page contains build notes and direct assets. When a release includes a .ps1 asset, download that file and execute it per instructions. Example asset names you may find:
- Deploy-Kiosk-v1.0.0.ps1
- Admin-Toolset-v1.1.2.zip (contains multiple scripts and README)
- Edge-KioskPolicy-v0.9.5.ps1

Use the release notes to match versions and breaking changes. If a release asset includes an installer or bundle, follow included README for order of operations.

Checklist before running a release asset
- Validate the file hash if provided in the release notes.
- Run in a test environment.
- Check the scripts for expected actions and parameters.
- Run with -WhatIf when available.

Examples of commands to validate and run a downloaded release file:
```
# Download
Invoke-WebRequest -Uri "https://github.com/kittipat-Nung/Powershell_Scripts/releases/download/v1.2.0/Admin-Toolset-v1.2.0.zip" -OutFile .\Admin-Toolset-v1.2.0.zip

# Unzip and inspect
Expand-Archive .\Admin-Toolset-v1.2.0.zip -DestinationPath .\Admin-Toolset-v1.2.0
Get-ChildItem .\Admin-Toolset-v1.2.0 -Recurse

# Run a script from the bundle
powershell -ExecutionPolicy Bypass -File .\Admin-Toolset-v1.2.0\Install-Tools.ps1
```

Script catalog (example entries)
- Deploy-Kiosk.ps1 — set up assigned access and kiosk user.
- Edge-KioskConfig.ps1 — configure Edge policies and favorites.
- Get-SystemReport.ps1 — full inventory and health report.
- Audit-LocalAdmins.ps1 — report local admin group members.
- Cleanup-TempAndLogs.ps1 — rotate logs, clear temp directories.
- Ensure-ServiceRunning.ps1 — manage Windows services and set recovery.
- Silent-Install-Choco.ps1 — bootstrap Chocolatey and common packages.
- Update-AllApps.ps1 — run update checks for supported apps.
- Create-LocalUser.ps1 — create a local user with secure password options.

Style and support
- Scripts follow Verb-Noun naming and use parameter validation.
- Each script includes comment-based help and examples.
- Use GitHub Issues for bug reports and feature requests. Use PRs for fixes and additions.

License
This repository uses the MIT License. See LICENSE for terms.

Contact & metadata
Repository topics: admin-tools, automation, batch-processing, devops, edge-browser, kiosk-mode, open-source, personal-project, powershell, scripts, security-awareness, shell-scripts, system-administration, utilities, windows

Images and assets used come from public sources and the GitHub topics images above.

