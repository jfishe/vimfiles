
<#PSScriptInfo

.VERSION 3.0

.GUID e7b6d3ed-1459-4dee-9dcf-675756b14510

.AUTHOR John D. Fisher <jdfenw@gmail.com>

.COMPANYNAME

.COPYRIGHT 2023 John D. Fisher

.TAGS

.LICENSEURI https://github.com/jfishe/vimfiles/blob/master/LICENSE

.PROJECTURI https://github.com/jfishe/vimfiles

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES


.PRIVATEDATA

#>

<#
.SYNOPSIS
    Install and symlink vimfiles to $HOME
.DESCRIPTION
    Backup existing installation to BackupPath.

    Clone Repository to Path and update submodules.

    Symlink dotfiles and vimfiles to LinkPath. Use Junction and Hardlink if
    SeCreateSymbolicLink permission denied.

    Copy Ubuntu wamerican dictionary and Moby-thesaurus to the locations
    specified in the vimrc.

    Create/update compatible conda environment for Vim and modify Vim batch
    files to activate the conda environment.

    Create Start Menu shortcuts for Vim batch files.
.EXAMPLE
    PS> .\Install-Vimfiles.ps1 -Clone
.EXAMPLE
    PS> .\Install-Vimfiles.ps1 -Link
#>
[CmdletBinding()]
Param(
    # Symlink dotfiles and vimfiles to $HOME. Use Junction and Hardlink if
    # SeCreateSymbolicLink permission denied.
    [Parameter(
        Mandatory = $true,
        ParameterSetName = 'Link',
        HelpMessage = 'Symlink dotfiles and vimfiles to $HOME. Use Junction and Hardlink if SeCreateSymbolicLink permission denied.'
    )]
    [switch]
    $Link
    ,
    # Clone Repository to Path and update submodules.
    [Parameter(
        Mandatory = $true,
        ParameterSetName = 'Clone',
        HelpMessage = 'Clone Repository to Path and update submodules.'
    )]
    [switch]
    $Clone
    ,
    # Create/update Ubuntu wamerican dictionary.
    [Parameter(
        Mandatory = $true,
        ParameterSetName = 'Dictionary',
        HelpMessage = 'Create/update Ubuntu wamerican dictionary.'
    )]
    [switch]
    $Dictionary
    ,
    # Create/update Moby-thesaurus.
    [Parameter(
        Mandatory = $true,
        ParameterSetName = 'Thesaurus',
        HelpMessage = 'Create/update Moby-thesaurus.'
    )]
    [switch]
    $Thesaurus
    ,
    # Create/update conda environment for Vim (vim_python).
    # Copy Vim batch files to UserAppDir.
    [Parameter(
        Mandatory = $true,
        ParameterSetName = 'Conda',
        HelpMessage = 'Create/update conda environment for Vim (vim_python).'
    )]
    [switch]
    $Conda
    ,
    # Create Start Menu folder and shortcuts for Vim batch files.
    # Create shortcut for default WSL gvim.
    [Parameter(
        Mandatory = $true,
        ParameterSetName = 'Shortcut',
        HelpMessage = 'Create Start Menu folder and shortcuts for Vim batch files.'
    )]
    [switch]
    $Shortcut
    ,
    # Path to clone repository.
    [Parameter(
        Mandatory = $false,
        ParameterSetName = 'Clone',
        HelpMessage = 'Path to clone repository.'
    )]
    [Parameter(ParameterSetName = 'Link')]
    [Parameter(ParameterSetName = 'Dictionary')]
    [Parameter(ParameterSetName = 'Thesaurus')]
    [Parameter(ParameterSetName = 'Conda')]
    [Alias("PSPath")]
    [ValidateNotNullOrEmpty()]
    [string]
    $Path = "$env:LOCALAPPDATA\vimfiles"
    ,
    # URI for git repository.
    [Parameter(
        Mandatory = $false,
        ParameterSetName = 'Clone',
        HelpMessage = 'URI for git repository'
    )]
    [string]
    $Repository = 'https://github.com/jfishe/vimfiles.git'
    ,
    # Path for backups.
    [Parameter(
        Mandatory = $false,
        ParameterSetName = 'Clone',
        HelpMessage = 'Path for backups.'
    )]
    [Parameter(ParameterSetName = 'Link')]
    [string]
    $BackupPath = "$HOME\old"
    ,
    # Path to directory to create symbolic links.
    [Parameter(
        Mandatory = $false,
        ParameterSetName = 'Link',
        HelpMessage = 'Path to directory to create symbolic links.'
    )]
    [string]
    $LinkPath = "$HOME"
    ,
    # Path to directory to copy user modified Vim batch files
    # to activate conda environment vim_python.
    # The directory should be in $Env:PATH.
    [Parameter(
        Mandatory = $false,
        ParameterSetName = 'Conda',
        HelpMessage = 'Path to directory to copy user modified Vim batch files.'
    )]
    [Parameter(ParameterSetName = 'Shortcut')]
    [string]
    $UserAppDir = "$env:LOCALAPPDATA\Microsoft\WindowsApps"
    ,
    # Path to directory where Vim installer placed batch files.
    # Not used if UserAppDir already contains Vim batch files.
    [Parameter(
        Mandatory = $false,
        ParameterSetName = 'Conda',
        HelpMessage = 'Path to directory where Vim installer placed batch files.'
    )]
    [string]
    $GlobalAppDir = "$env:WINDIR"
    ,
    # Path to Vim icon file, e.g., gvim.exe.
    [Parameter(
        Mandatory = $false,
        ParameterSetName = 'Shortcut',
        HelpMessage = 'Path to Vim icon file.'
    )]
    [string]
    $IconLocation = (
        "$env:ProgramFiles",
        "${env:ProgramFiles(x86)}",
        "$env:SystemDrive\tools",
        "$env:LOCALAPPDATA\Programs"
    ).ForEach(
        {
            Resolve-Path -Path "$_\Vim\*\gvim.exe" -ErrorAction SilentlyContinue
        }
    )
)

<#
.SYNOPSIS
  Create a symbolic link.
.DESCRIPTION
  Creates a symbolic link.

  MKLINK [[/D] | [/H] | [/J]] Link Target

        /D      Creates a directory symbolic link.  Default is a file
                symbolic link.
        /H      Creates a hard link instead of a symbolic link.
        /J      Creates a Directory Junction.
        Link    Specifies the new symbolic link name.
        Target  Specifies the path (relative or absolute) that the new link
                refers to.
#>
function New-Symlink {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $false,
            Position = 0,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet("", '/D', '/H', '/J')]
        [string]
        $ItemType = ""
        ,
        [Parameter(
            Mandatory = $true,
            Position = 1,
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $Link
        ,
        [Parameter(
            Mandatory = $true,
            Position = 2,
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $Target
    )

    begin {
    }

    process {
        Write-Verbose "cmd.exe /c mklink $ItemType $Link $Target"
        $Output = cmd.exe /c mklink $ItemType $Link $Target 2>&1
        $Output | Out-String | Write-Verbose

        $ErrorMessage = "You do not have sufficient privilege to perform this operation."
        if ("$Output" -eq "$ErrorMessage") {
            Write-Verbose "Trying Junction and Hardlink instead."
            if ( $ItemType -eq "/D" ) {
                $OldItemType = "/J"
            } else {
                $OldItemType = "/H"
            }
            $Output = cmd.exe /c mklink $OldItemType $Link $Target 2>&1
            $Output | Out-String | Write-Verbose
        }
    }

    end {

    }
}

function Backup-Item {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipelineByPropertyName = $true
        )]
        [string]
        $Link,
        [Parameter(
            Mandatory = $false
        )]
        [string]
        $Destination = "$HOME\old"
    )

    begin {
        Write-Verbose "Validate/create $Destination"
        New-Item -Path "$Destination" -ItemType Directory -ErrorAction SilentlyContinue | Out-String | Write-Verbose
        $Destination = Get-Item -Path "$Destination" -ErrorAction Stop
    }

    process {
        Move-Item -Path $Link -Destination "$Destination" `
            -ErrorAction SilentlyContinue
    }

    end {
        Get-ChildItem -Path "$Destination" | Out-String | Write-Verbose
    }
}

if ($Clone) {
    Backup-Item -Link "$Path" -Destination "$BackupPath\repo" -ErrorAction Stop

    git config --global core.eol lf
    git config --global core.autocrlf false
    $Output = git clone "$Repository" "$Path" 2>&1
    $Output | Out-String | Write-Verbose

    Push-Location -Path "$Path"
    $Output = git submodule update --init --recursive 2>&1
    $Output | Out-String | Write-Verbose
    vim -c 'packloadall | helptags ALL | qa'
    Pop-Location
}

if ($Link) {
    [array] $Vimfiles = Get-Item -Path "$Path\vimfiles" | ForEach-Object -Process {
        # ~\vimfiles for Windows Vim
        [PSCustomObject]@{
            Link     = "$LinkPath\$($_.Name)"
            Target   = "$($_.FullName)"
            ItemType = '/D'
        },
        # ~\.vim for Mintty and git-scm Vim
        [PSCustomObject]@{
            Link     = "$LinkPath\.vim"
            Target   = "$($_.FullName)"
            ItemType = '/D'
        }
    }

    # Terminal config for Mintty and git-scm Vim
    [array] $Vimfiles += Get-Item -Path "$Path\mintty" | ForEach-Object -Process {
        [PSCustomObject]@{
            Link     = "$LinkPath\.config\$($_.Name)"
            Target   = "$($_.FullName)"
            ItemType = '/D'
        }
    }
    New-Item -Path "$LinkPath\.config" -ItemType Directory -ErrorAction SilentlyContinue

    [array] $Vimfiles += Get-ChildItem -Path "$Path\dotfiles" | ForEach-Object -Process {
        if ($_.PSIsContainer) {
            $ItemType = '/D'
        } else {
            $ItemType = ''
        }
        [PSCustomObject]@{
            Link     = "$LinkPath\.$($_.Name)"
            Target   = "$($_.FullName)"
            ItemType = "$ItemType"
        }
    }

    $Vimfiles | Backup-Item -Destination "$BackupPath"

    $Vimfiles | New-Symlink
}

if ($Dictionary) {
    # Assume WSL defaults to Ubuntu.
    $WslDictionary = '/usr/share/dict/words'
    wsl --exec bash -c "sudo apt-get update && sudo apt-get install wamerican"
    $Words = wsl --exec bash -c "wslpath -w ``realpath $WslDictionary``"
    $OutFile = "$Path\vimfiles\dictionary\words"
    New-Item -Path (Split-Path $OutFile) -ItemType Directory -ErrorAction SilentlyContinue
    Copy-Item -Path $Words -Destination $OutFile
}

if ($Thesaurus) {
    $Uri = 'https://raw.githubusercontent.com/zeke/moby/master/words.txt'
    $OutFile = "$Path\vimfiles\thesaurus\mthesaur.txt"
    New-Item -Path (Split-Path $OutFile) -ItemType Directory -ErrorAction SilentlyContinue
    Invoke-WebRequest -Uri $Uri -OutFile $OutFile
}

if ($Conda) {
    # Install Miniconda3 if needed.
    try {
        Get-Command Invoke-Conda -ErrorAction Stop
    } catch [System.Management.Automation.CommandNotFoundException] {
        $_ | Out-String | Write-Verbose
        $webrequestParams = @{
            Uri     = 'https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe'
            OutFile = "$HOME\Downdloads\Miniconda3-latest-Windows-x86_64.exe"
        }
        Invoke-WebRequest @webrequestParams
        & "$($webrequestParams.OutFile)"

        # Miniconda3 may install in different locations.
        "$env:LOCALAPPDATA", "$env:USERPROFILE" | ForEach-Object -Process {
            if (Test-Path ($condaexe = Join-Path $_ "miniconda3\Scripts\conda.exe") -PathType Leaf) {
                break
            }
        }
        (& "$condaexe" "shell.powershell" "hook") | Out-String | ? {$_} | Invoke-Expression
    } finally {
        Get-Command Invoke-Conda -ErrorAction Stop | Out-String | Write-Verbose
    }

    # Create or update conda env vim_python.
    Push-Location "$Path"
    Get-Item .\environment.yml -ErrorAction Stop | Out-String | Write-Verbose
    if (Invoke-Conda env list | Select-String -Pattern 'vim_python' -CaseSensitive) {
        Invoke-Conda env update --file environment.yml
    } else {
        Invoke-Conda env create --file environment.yml
    }
    Pop-Location

    # Copy Vim batch files to userappdir.
    $UserAppDir = Get-Item "$UserAppDir"
    $GlobalAppDir = Get-Item "$GlobalAppDir"

    $UserVimCmd = Join-Path $UserAppDir '*vim*' | Get-ChildItem
    $GlobalVimCmd = Join-Path $GlobalAppDir '*vim*' | Get-ChildItem

    if (-not $UserVimCmd -and $GlobalVimCmd) {
        $GlobalVimCmd | Copy-Item -Destination $UserAppDir
    }

    Write-Verbose 'reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_EXPAND_SZ /d "%"USERPROFILE"%\.init.cmd" /f'
    cmd /c 'reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_EXPAND_SZ /d "%"USERPROFILE"%\.init.cmd" /f'
}

if ($Shortcut) {
    # Copy WSL gvim script.
    $Wslscript = Get-Item -Path "$Path\pwsh\gvim-wsl.bat"
    $Wslscript = Copy-Item -Path $Wslscript -Destination $UserAppDir -PassThru
    Write-Verbose "$Wslscript assumes default WSL add wsl --distro, as needed."

    # Locate Vim batch files.
    $UserAppDir = Get-Item "$UserAppDir"
    [array] $SourceFileLocation = Join-Path $UserAppDir '*vim*.bat' | Get-ChildItem
    [array] $SourceFileLocation += Join-Path $UserAppDir '*view*.bat' | Get-ChildItem

    # Destination directory needs to exist.
    $ShortcutLocation = "$Env:AppData\Microsoft\Windows\Start Menu\Programs\Vim"
    New-Item $ShortCutLocation -ItemType Directory -ErrorAction SilentlyContinue

    # Copy Visual Basic Script to open gv*.bat without cmd.exe window.
    $BatLauncher = Get-Item -Path "$Path\pwsh\bat-launcher.vbs"
    $BatLauncher = Copy-Item -Path $BatLauncher -Destination $UserAppDir -PassThru

    $WorkingDirectory = '%HOMEDRIVE%%HOMEPATH%'

    $SourceFileLocation | ForEach-Object -Process {
        $item = Join-Path $ShortcutLocation "$($_.BaseName).lnk"
        # New-Object : Creates an instance of a Microsoft .NET Framework or COM object.
        # -ComObject WScript.Shell: This creates an instance of the COM object that represents the WScript.Shell for invoke CreateShortCut
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Newlink = $WScriptShell.CreateShortcut($item)
        if ( $_.BaseName -match '^gv' ) {
            $Newlink.TargetPath = "$BatLauncher"
            $Newlink.Arguments = "$($_.BaseName) --"
        } else {
            $Newlink.TargetPath = "$_"
        }
        $Newlink.WindowStyle = 7 # Minimized
        $Newlink.IconLocation = "$IconLocation"
        $Newlink.WorkingDirectory = "$WorkingDirectory"
        $Newlink | Out-String | Write-Verbose
        #Save the Shortcut to the TargetPath
        $Newlink.Save()
    }
}

