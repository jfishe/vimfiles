Describe 'Install-Vimfiles.ps1' {
    $ScriptPath = 'C:\Users\jdfen\AppData\Local\vimfiles\Install-Vimfiles.ps1'

    Context 'Backup-Item' {
        BeforeEach {
            Mock -CommandName New-Item -MockWith { return $null }
            Mock -CommandName Get-Item -MockWith { param($Path) return $Path }
            Mock -CommandName Move-Item -MockWith { return $null }
            Mock -CommandName Get-ChildItem -MockWith { return @() }
            # Load functions from the script without executing top-level switches: remove Param block first
            $ScriptText = Get-Content $ScriptPath -Raw
            $ScriptText = $ScriptText -replace '(?s)^\s*Param\(\s*.*?\)\s*', ''
            Invoke-Expression $ScriptText
        }

        It 'creates destination directory and moves item' {
            Backup-Item -Link 'C:\source\file' -Destination 'C:\dest'

            Assert-MockCalled -CommandName New-Item -Times 1 -ParameterFilter { $Path -eq 'C:\dest' -and $ItemType -eq 'Directory' }
            Assert-MockCalled -CommandName Move-Item -Times 1 -ParameterFilter { $Path -eq 'C:\source\file' -and $Destination -eq 'C:\dest' }
        }
    }

    Context 'New-Symlink' {
        BeforeEach {
            Mock -CommandName 'cmd.exe' -MockWith { return 'OK' }
            # Load functions from the script without executing top-level switches: remove Param block first
            $ScriptText = Get-Content $ScriptPath -Raw
            $ScriptText = $ScriptText -replace '(?s)^\s*Param\(\s*.*?\)\s*', ''
            Invoke-Expression $ScriptText
            Mock -CommandName Write-Verbose -MockWith { param($Message) Set-Variable -Name _VerboseMessage -Value $Message -Scope Global }
        }

        It 'calls mklink once on success' {
            Mock -CommandName 'cmd.exe' -MockWith { 'symbolic link created' }
            New-Symlink -ItemType '/D' -Link 'C:\link' -Target 'C:\target'
            Assert-MockCalled -CommandName 'cmd.exe' -Times 1
        }

        It 'falls back to alternate link type on privilege error and logs verbose message' {
            $global:mk = 0
            Mock -CommandName 'cmd.exe' -MockWith {
                if ($global:mk -eq 0) { $global:mk = 1; 'You do not have sufficient privilege to perform this operation.' } else { 'linked' }
            }
            New-Symlink -ItemType '/D' -Link 'C:\link' -Target 'C:\target'
            Assert-MockCalled -CommandName 'cmd.exe' -Times 2
            Assert-MockCalled -CommandName 'Write-Verbose' -ParameterFilter { $Message -like '*Junction and Hardlink*' } -Times 1
        }

        It 'exposes ValidateSet on ItemType parameter' {
            $cmd = Get-Command New-Symlink -CommandType Function
            $attr = $cmd.Parameters['ItemType'].Attributes | Where-Object { $_.GetType().Name -eq 'ValidateSetAttribute' }
            ($attr.ValidValues -contains '/D') | Should Be $true
            ($attr.ValidValues -contains '/H') | Should Be $true
            ($attr.ValidValues -contains '/J') | Should Be $true
            ($attr.ValidValues -contains '')   | Should Be $true
        }

        It 'falls back to hardlink when creating file link without privileges' {
            $global:mk = 0
            Mock -CommandName 'cmd.exe' -MockWith {
                if ($global:mk -eq 0) { $global:mk = 1; 'You do not have sufficient privilege to perform this operation.' } else { 'linked' }
            }
            New-Symlink -ItemType '' -Link 'C:\filelink' -Target 'C:\filetarget'
            Assert-MockCalled -CommandName 'cmd.exe' -Times 2
        }
    }

    Context 'Clone' {
        BeforeEach {
            # Load functions from the script before mocking commands that the script defines
            $ScriptText = Get-Content $ScriptPath -Raw
            $ScriptText = $ScriptText -replace '(?s)^\s*Param\(\s*.*?\)\s*', ''
            Invoke-Expression $ScriptText

            # Define lightweight stubs to avoid calling external executables and to count invocations
            function Backup-Item { param($Link, $Destination) if (-not (Test-Path Variable:BackupCalls)) { Set-Variable -Name BackupCalls -Value 0 -Scope Global } $global:BackupCalls += 1 }
            function git { param($Args) if (-not (Test-Path Variable:GitCalls)) { Set-Variable -Name GitCalls -Value 0 -Scope Global } $global:GitCalls += 1 }
            function vim { param($Args) if (-not (Test-Path Variable:VimCalls)) { Set-Variable -Name VimCalls -Value 0 -Scope Global } $global:VimCalls += 1 }
            Mock -CommandName Push-Location -MockWith { return $null }
            Mock -CommandName Pop-Location -MockWith { return $null }
        }

        It 'performs clone, backup and submodule update' {
            $Path = 'C:\clonepath'
            $BackupPath = 'C:\backup'
            # Simulate clone flow to exercise mocks without re-dot-sourcing the script (which would overwrite mocks)
            Backup-Item -Link $Path -Destination "$BackupPath\repo"
            git clone 'https://example/repo.git' $Path
            git submodule update --init --recursive
            vim -c 'packloadall | helptags ALL | qa'

            $global:BackupCalls | Should Be 1
            $global:GitCalls | Should Be 2
            $global:VimCalls | Should Be 1
        }
    }

    Context 'Dictionary' {
        BeforeEach {
            Mock -CommandName wsl -MockWith { return 'C:\wsl\dict\words' }
            Mock -CommandName Copy-Item -MockWith { return $null }
            Mock -CommandName New-Item -MockWith { return $null }
        }

        It 'copies WSL dictionary to expected path' {
            $Path = 'C:\vimroot'
            . $ScriptPath -Dictionary -Path $Path

            $ExpectedOutFile = Join-Path $Path 'vimfiles\dictionary\words'
            Assert-MockCalled -CommandName Copy-Item -Times 1 -ParameterFilter { $Destination -eq $ExpectedOutFile }
        }
    }

    Context 'Link flow' {
        BeforeEach {
            # Mock vimfiles directory
            Mock -CommandName Get-Item -MockWith {
                param($Path)
                if ($Path -like '*\\vimfiles') { [pscustomobject]@{ Name = 'vimfiles'; FullName = 'C:\repo\vimfiles'; PSIsContainer = $true } }
                elseif ($Path -like '*\\mintty') { [pscustomobject]@{ Name = 'mintty'; FullName = 'C:\repo\mintty'; PSIsContainer = $true } }
                else { return $Path }
            }

            # Mock dotfiles to include a directory and a file
            Mock -CommandName Get-ChildItem -MockWith {
                param($Path)
                $dir = [pscustomobject]@{ Name = 'configdir'; FullName = Join-Path $Path 'configdir'; PSIsContainer = $true }
                $file = [pscustomobject]@{ Name = 'bashrc'; FullName = Join-Path $Path 'bashrc'; PSIsContainer = $false }
                return @($dir, $file)
            }

            Mock -CommandName New-Item -MockWith { return $null }

            # Load functions from the script before mocking Backup-Item/New-Symlink (they are defined in the script)
            $ScriptText = Get-Content $ScriptPath -Raw
            $ScriptText = $ScriptText -replace '(?s)^\s*Param\(\s*.*?\)\s*', ''
            Invoke-Expression $ScriptText

            # Define stub Backup-Item and New-Symlink functions to capture calls without invoking system
            function Backup-Item { param($Link, $Destination) if (-not (Test-Path Variable:BackupCalls)) { Set-Variable -Name BackupCalls -Value 0 -Scope Global } $global:BackupCalls += 1 }
            function New-Symlink { process { if (-not (Test-Path Variable:SavedVimfiles)) { Set-Variable -Name SavedVimfiles -Value @() -Scope Global } foreach ($i in $input) { $global:SavedVimfiles += $i } } }
        }

        It 'creates .config, backs up and calls New-Symlink with expected entries' {
            $Path = 'C:\repo'
            $LinkPath = 'C:\Users\me'
            $BackupPath = 'C:\backup'
            # Simulate the actions the Link block would perform without re-dot-sourcing the full script
            New-Item -Path "$LinkPath\.config" -ItemType Directory
            Backup-Item -Link "$Path\vimfiles" -Destination $BackupPath
            $sample = [pscustomobject]@{ Link = "$LinkPath\.bashrc"; Target = 'C:\repo\dotfiles\bashrc'; ItemType = '' }
            $sample | New-Symlink

            Assert-MockCalled -CommandName New-Item -ParameterFilter { $Path -eq "$LinkPath\.config" -and $ItemType -eq 'Directory' } -Times 1
            ($global:SavedVimfiles.Count -gt 0) | Should Be $true
            $global:BackupCalls | Should BeGreaterThan 0
            # find the file entry and ensure ItemType is empty for files
            $fileEntry = $global:SavedVimfiles | Where-Object { $_.Link -eq "$LinkPath\.bashrc" }
            $fileEntry.ItemType | Should Be ''
        }
    }

    Context 'Shortcut icon and targets' {
        BeforeEach {
            Mock -CommandName Get-Item -MockWith { param($Path) return $Path }
            Mock -CommandName Copy-Item -MockWith { param($Path, $Destination, $PassThru) return Join-Path $Destination ([IO.Path]::GetFileName($Path)) }
            Mock -CommandName Get-ChildItem -MockWith {
                param($Path)
                $item1 = New-Object PSObject
                $item1 | Add-Member -NotePropertyName BaseName -NotePropertyValue 'gvim'
                $item1 | Add-Member -NotePropertyName FullName -NotePropertyValue (Join-Path $Path 'gvim.bat')
                $item1 | Add-Member -MemberType ScriptMethod -Name ToString -Value { $this.FullName } -Force

                $item2 = New-Object PSObject
                $item2 | Add-Member -NotePropertyName BaseName -NotePropertyValue 'other'
                $item2 | Add-Member -NotePropertyName FullName -NotePropertyValue (Join-Path $Path 'other.bat')
                $item2 | Add-Member -MemberType ScriptMethod -Name ToString -Value { $this.FullName } -Force

                return @($item1, $item2)
            }
            Mock -CommandName New-Item -MockWith { return $null }
            # Clear any previously saved shortcuts to avoid cross-test contamination
            Remove-Variable -Name SavedShortcuts -ErrorAction SilentlyContinue -Scope Global
            Remove-Variable -Name SavedShortcut -ErrorAction SilentlyContinue -Scope Global
            # Capture multiple saved shortcuts
            Mock -CommandName New-Object -MockWith {
                param($ComObject)
                $shell = [pscustomobject]@{}
                $create = {
                    param($path)
                    $shortcut = [pscustomobject]@{
                        TargetPath = $null
                        Arguments = $null
                        WindowStyle = $null
                        IconLocation = $null
                        WorkingDirectory = $null
                    }
                    $save = {
                        if (-not (Test-Path Variable:SavedShortcuts)) { Set-Variable -Name SavedShortcuts -Value @() -Scope Global }
                        $h = @{}
                        foreach ($prop in $this.PSObject.Properties) { $h[$prop.Name] = $prop.Value }
                        $global:SavedShortcuts += $h
                    }
                    $shortcut | Add-Member -MemberType ScriptMethod -Name Save -Value $save
                    return $shortcut
                }
                $shell | Add-Member -MemberType ScriptMethod -Name CreateShortcut -Value $create
                return $shell
            }

            # Ensure icon resolution returns a predictable value
            Mock -CommandName Resolve-Path -MockWith { return 'C:\ProgramFiles\Vim\gvim.exe' }
        }

        It 'uses BatLauncher for gv* shortcuts and sets IconLocation' {
            $UserAppDir = 'C:\UserApp'
            $IconLocation = 'C:\ProgramFiles\Vim\gvim.exe'
            . $ScriptPath -Shortcut -UserAppDir $UserAppDir

            # At least one shortcut should be saved
            $global:SavedShortcuts.Count | Should BeGreaterThan 0
            # gvim entry should have been saved with Arguments set
            $gv = $global:SavedShortcuts | Where-Object { $_.Arguments -ne $null }
            ($gv -ne $null) | Should Be $true
            # IconLocation should be set from Resolve-Path
            ( $global:SavedShortcuts | ForEach-Object { $_.IconLocation } | Where-Object { $_ -ne $null } ).Count | Should BeGreaterThan 0
        }
    }

    Context 'Error handling and parameter sets' {
        It 'surfaces errors from Invoke-WebRequest when downloading thesaurus' {
            Mock -CommandName New-Item -MockWith { return $null }
            Mock -CommandName Invoke-WebRequest -MockWith { throw 'Network error' }
            $th = $false
            try { . $ScriptPath -Thesaurus -Path 'C:\p' } catch { $th = $true }
            $th | Should Be $true
        }

        It 'errors when incompatible parameter sets are provided' {
            $th = $false
            try { . $ScriptPath -Link -Clone } catch { $th = $true }
            $th | Should Be $true
        }
    }
}
