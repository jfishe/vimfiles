
<#PSScriptInfo

.VERSION 1.0

.GUID e7b6d3ed-1459-4dee-9dcf-675756b14510

.AUTHOR John D. Fisher <jdfenw@gmail.com>

.COMPANYNAME

.COPYRIGHT 2021 John D. Fisher

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

.DESCRIPTION
 Symlink dotfiles and vimfiles to $HOME. Use Junction and Hardlink if
 SeCreateSymbolicLink permission denied.

#> 
[CmdletBinding()]
Param(
    # Clone repository to $env:LOCALAPPDATA\vimfiles and update submodules.
    [Parameter(
      Mandatory = $false
    )]
    [switch]
    $Clone
    ,
    [Parameter(
      Mandatory = $false
    )]
    # Path to clone repository.
    [Parameter(Mandatory=$false,
               HelpMessage="Path to clone repository.")]
    [Alias("PSPath")]
    [ValidateNotNullOrEmpty()]
    [string]
    $Path = "$env:LOCALAPPDATA\vimfiles"
    ,
    # Vimfiles repository (origin/remote)
    [Parameter(
      Mandatory = $false,
      HelpMessage = "URI for git repository"
      )]
    [string]
    $Repository = 'https://github.com/jfishe/vimfiles.git'
    ,
    # Path for backups.
    [Parameter(Mandatory=$false,
               HelpMessage="Path for backups.")]
    [string]
    $BackupPath = "$HOME\old"
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
    $Command = 'mklink '
    $Command += "$ItemType $Link $Target"
    Write-Verbose "cmd.exe /c mklink $ItemType $Link $Target"
    $Output = cmd.exe /c mklink $ItemType $Link $Target 2>&1
    Write-Verbose $Output

    $ErrorMessage = "You do not have sufficient privilege to perform this operation."
    if ("$Output" -eq "$ErrorMessage") {
      Write-Verbose "Trying Junction and Hardlink instead."
      if ( $ItemType -eq "/D" ) {
        $OldItemType = "/J"
      } else {
        $OldItemType = "/H"
      }
      $Output = cmd.exe /c mklink $OldItemType $Link $Target 2>&1
      Write-Verbose $Output
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
    New-Item -Path "$Destination" -ItemType Directory -ErrorAction SilentlyContinue
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
  $Vimfiles = Get-Item -Path $Path.FullName
  Backup-Item -Link "$Vimfiles" -Destination $BackupPath -ErrorAction Stop
  Get-Command -Name git -ErrorAction Stop
  git config --global core.eol lf
  git config --global core.autocrlf false
  git clone "$Repository" "$Path"
  Push-Location -Path "$Path"
  git submodule update --init --recursive
}

[array] $Vimfiles = Get-Item -Path "$PSScriptRoot\vimfiles" | ForEach-Object -Process {
  [PSCustomObject]@{
  Link = "$HOME\$($_.Name)"
  Target = "$($_.FullName)"
  ItemType = '/D'
  }
}
[array] $Dotfiles = Get-ChildItem -Path "$PSScriptRoot\dotfiles" | ForEach-Object -Process {
  if ($_.PSIsContainer) {
    $ItemType = '/D'
  } else {
    $ItemType = ''
  }
  [PSCustomObject]@{
  Link = "$HOME\.$($_.Name)"
  Target = "$($_.FullName)"
  ItemType = "$ItemType"
  }
}
[array] $Vimfiles += $Dotfiles

$Vimfiles | Backup-Item

$Vimfiles | New-Symlink
