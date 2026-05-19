Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "asosar-cli-bak - Windows User Backup"
$form.Size = New-Object System.Drawing.Size(650, 550)
$form.BackColor = [System.Drawing.Color]::FromArgb(12, 12, 12)
$form.ForeColor = [System.Drawing.Color]::Lime
$form.Font = New-Object System.Drawing.Font("Consolas", 10)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false

$title = New-Object System.Windows.Forms.Label
$title.Text = "=== asosar-cli-bak ==="
$title.Location = New-Object System.Drawing.Point(10, 10)
$title.Size = New-Object System.Drawing.Size(610, 25)
$title.ForeColor = [System.Drawing.Color]::Cyan
$title.TextAlign = "MiddleCenter"

$grpMode = New-Object System.Windows.Forms.GroupBox
$grpMode.Text = " Backup Mode "
$grpMode.Location = New-Object System.Drawing.Point(10, 40)
$grpMode.Size = New-Object System.Drawing.Size(610, 60)
$grpMode.ForeColor = [System.Drawing.Color]::Lime

$radioLocal = New-Object System.Windows.Forms.RadioButton
$radioLocal.Text = "Local only (C:\Users\... paths)"
$radioLocal.Location = New-Object System.Drawing.Point(10, 20)
$radioLocal.Size = New-Object System.Drawing.Size(280, 25)
$radioLocal.ForeColor = [System.Drawing.Color]::Lime
$radioLocal.Checked = $true

$radioOneDrive = New-Object System.Windows.Forms.RadioButton
$radioOneDrive.Text = "OneDrive + Local (all sources)"
$radioOneDrive.Location = New-Object System.Drawing.Point(300, 20)
$radioOneDrive.Size = New-Object System.Drawing.Size(290, 25)
$radioOneDrive.ForeColor = [System.Drawing.Color]::Lime

$grpMode.Controls.AddRange(@($radioLocal, $radioOneDrive))

$grpFolders = New-Object System.Windows.Forms.GroupBox
$grpFolders.Text = " Folders to Backup "
$grpFolders.Location = New-Object System.Drawing.Point(10, 110)
$grpFolders.Size = New-Object System.Drawing.Size(610, 140)
$grpFolders.ForeColor = [System.Drawing.Color]::Lime

$folderNames = @('Desktop', 'Documents', 'Downloads', 'Pictures', 'Music', 'Videos')
$folderChecks = @{}
$x = 10
$y = 20
foreach ($name in $folderNames) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = $name
    $cb.Location = New-Object System.Drawing.Point($x, $y)
    $cb.Size = New-Object System.Drawing.Size(130, 25)
    $cb.ForeColor = [System.Drawing.Color]::Lime
    $cb.Checked = $true
    $folderChecks[$name] = $cb
    $grpFolders.Controls.Add($cb)
    $x += 140
    if ($x -gt 480) { $x = 10; $y += 30 }
}

$grpDest = New-Object System.Windows.Forms.GroupBox
$grpDest.Text = " Destination "
$grpDest.Location = New-Object System.Drawing.Point(10, 260)
$grpDest.Size = New-Object System.Drawing.Size(610, 60)
$grpDest.ForeColor = [System.Drawing.Color]::Lime

$txtDest = New-Object System.Windows.Forms.TextBox
$txtDest.Text = "C:\Backup"
$txtDest.Location = New-Object System.Drawing.Point(10, 25)
$txtDest.Size = New-Object System.Drawing.Size(480, 25)
$txtDest.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
$txtDest.ForeColor = [System.Drawing.Color]::Lime

$btnBrowse = New-Object System.Windows.Forms.Button
$btnBrowse.Text = "Browse..."
$btnBrowse.Location = New-Object System.Drawing.Point(500, 23)
$btnBrowse.Size = New-Object System.Drawing.Size(90, 28)
$btnBrowse.BackColor = [System.Drawing.Color]::FromArgb(0, 40, 0)
$btnBrowse.ForeColor = [System.Drawing.Color]::Lime
$btnBrowse.FlatStyle = "Flat"
$btnBrowse.UseVisualStyleBackColor = $false

$grpDest.Controls.AddRange(@($txtDest, $btnBrowse))

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(10, 330)
$progressBar.Size = New-Object System.Drawing.Size(610, 25)
$progressBar.Style = "Continuous"

$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Location = New-Object System.Drawing.Point(10, 365)
$outputBox.Size = New-Object System.Drawing.Size(610, 100)
$outputBox.BackColor = [System.Drawing.Color]::FromArgb(5, 5, 5)
$outputBox.ForeColor = [System.Drawing.Color]::Lime
$outputBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$outputBox.ReadOnly = $true
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Vertical"

$btnBackup = New-Object System.Windows.Forms.Button
$btnBackup.Text = "Start Backup"
$btnBackup.Location = New-Object System.Drawing.Point(10, 475)
$btnBackup.Size = New-Object System.Drawing.Size(150, 30)
$btnBackup.BackColor = [System.Drawing.Color]::FromArgb(0, 60, 0)
$btnBackup.ForeColor = [System.Drawing.Color]::Lime
$btnBackup.FlatStyle = "Flat"
$btnBackup.UseVisualStyleBackColor = $false

$btnClose = New-Object System.Windows.Forms.Button
$btnClose.Text = "Close"
$btnClose.Location = New-Object System.Drawing.Point(530, 475)
$btnClose.Size = New-Object System.Drawing.Size(90, 30)
$btnClose.BackColor = [System.Drawing.Color]::FromArgb(40, 0, 0)
$btnClose.ForeColor = [System.Drawing.Color]::Lime
$btnClose.FlatStyle = "Flat"
$btnClose.UseVisualStyleBackColor = $false

$form.Controls.AddRange(@($title, $grpMode, $grpFolders, $grpDest, $progressBar, $outputBox, $btnBackup, $btnClose))

function Write-Output {
    param([string]$Text, [string]$Color = "Lime")
    $outputBox.AppendText("[$([DateTime]::Now.ToString('HH:mm:ss'))] $Text`r`n")
    $outputBox.SelectionStart = $outputBox.TextLength
    $outputBox.ScrollToCaret()
}

$btnBrowse.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select backup destination folder"
    $folderBrowser.SelectedPath = $txtDest.Text
    if ($folderBrowser.ShowDialog() -eq "OK") {
        $txtDest.Text = $folderBrowser.SelectedPath
    }
})

$btnBackup.Add_Click({
    $btnBackup.Enabled = $false
    $outputBox.Clear()
    $startTime = Get-Date
    $totalFailed = 0

    $dest = $txtDest.Text.Trim()
    if (-not $dest) {
        Write-Output "Enter a destination path." "Yellow"
        $btnBackup.Enabled = $true
        return
    }

    $mode = if ($radioLocal.Checked) { "Local" } else { "OneDrive" }
    Write-Output "Mode: $(if ($mode -eq 'Local') { 'Local only' } else { 'OneDrive + Local' })"
    Write-Output "Destination: $dest"

    if (-not (Test-Path -LiteralPath $dest)) {
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
    }

    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $logFile = Join-Path $dest "backup-$timestamp.log"

    $selectedFolders = @()
    foreach ($name in $folderNames) {
        if ($folderChecks[$name].Checked) {
            if ($mode -eq "Local") {
                $path = "$HOME\$name"
                if (Test-Path -LiteralPath $path -PathType Container) {
                    $selectedFolders += @{ Name = $name; Path = $path }
                } else {
                    Write-Output "Skipping $name (path not found: $path)" "Yellow"
                }
            } else {
                $active = Get-ActivePath $name
                $localPath = "$HOME\$name"
                $seen = @{}
                if ($active -and (Test-Path -LiteralPath $active -PathType Container)) {
                    $selectedFolders += @{ Name = $name; Path = $active }
                    $seen[$active.ToLower()] = $true
                }
                if ($localPath -and (Test-Path -LiteralPath $localPath -PathType Container) -and -not $seen[$localPath.ToLower()]) {
                    $label = if ($active -and $active -ne $localPath) { ' (local)' } else { '' }
                    $selectedFolders += @{ Name = "$name$label"; Path = $localPath }
                }
            }
        }
    }

    if ($selectedFolders.Count -eq 0) {
        Write-Output "No valid folders selected for backup." "Yellow"
        $btnBackup.Enabled = $true
        return
    }

    Write-Output "Backing up $($selectedFolders.Count) folder(s)..."

    $progressBar.Maximum = $selectedFolders.Count
    $progressBar.Value = 0

    $i = 0
    foreach ($folder in $selectedFolders) {
        $i++
        $src = $folder.Path
        $folderDest = Join-Path $dest $folder.Name
        Write-Output "[$i/$($selectedFolders.Count)] Processing $($folder.Name)..."
        if (-not (Test-Path -LiteralPath $folderDest)) {
            New-Item -ItemType Directory -Path $folderDest -Force | Out-Null
        }
        & robocopy $src $folderDest /E /COPY:DAT /R:3 /W:3 /NDL /NFL /NP /NC /NS /NJH /NJS
        $exitCode = $LASTEXITCODE
        if ($exitCode -ge 8) {
            Write-Output "ERROR: $($folder.Name) (robocopy exit $exitCode)" "Red"
            $totalFailed++
        } elseif ($exitCode -eq 0) {
            Write-Output "Skipped $($folder.Name) (no changes)" "Green"
        } else {
            Write-Output "Copied $($folder.Name)" "Green"
        }
        $progressBar.Value = $i
        $form.Refresh()
    }

    $endTime = Get-Date
    $duration = $endTime - $startTime
    $durationStr = "{0:hh}h {0:mm}m {0:ss}s" -f $duration

    Write-Output "Completed in $durationStr"
    if ($totalFailed -gt 0) {
        Write-Output "$totalFailed folder(s) had errors." "Red"
    } else {
        Write-Output "All folders backed up successfully." "Green"
    }
    $btnBackup.Enabled = $true
})

$btnClose.Add_Click({ $form.Close() })

function Get-UserShellFolder {
    param([string]$Key)
    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
    try {
        $val = Get-ItemProperty -Path $regPath -Name $Key -ErrorAction Stop
        return [Environment]::ExpandEnvironmentVariables($val.$Key)
    } catch {
        return $null
    }
}

function Get-DownloadsPath {
    $path = Get-UserShellFolder -Key '{374DE290-123F-4565-9164-39C4925E467B}'
    if (-not $path) { $path = Join-Path $HOME 'Downloads' }
    return $path
}

function Get-ActivePath {
    param([string]$Folder)
    switch ($Folder) {
        'Desktop'   { return [Environment]::GetFolderPath('Desktop') }
        'Documents' { return [Environment]::GetFolderPath('MyDocuments') }
        'Downloads' { return Get-DownloadsPath }
        'Pictures'  { return [Environment]::GetFolderPath('MyPictures') }
        'Music'     { return [Environment]::GetFolderPath('MyMusic') }
        'Videos'    { return [Environment]::GetFolderPath('MyVideos') }
    }
}

[void]$form.ShowDialog()
