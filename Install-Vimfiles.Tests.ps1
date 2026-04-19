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
    }

    Context 'Shortcut' {
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
                $item2 | Add-Member -NotePropertyName BaseName -NotePropertyValue 'view'
                $item2 | Add-Member -NotePropertyName FullName -NotePropertyValue (Join-Path $Path 'view.bat')
                $item2 | Add-Member -MemberType ScriptMethod -Name ToString -Value { $this.FullName } -Force

                return @($item1, $item2)
            }
            Mock -CommandName New-Item -MockWith { return $null }

            Mock -CommandName New-Object -MockWith {
                param($ComObject)
                # Build a faux WScript.Shell object without calling New-Object to avoid recursion
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
                        $h = @{}
                        foreach ($prop in $this.PSObject.Properties) { $h[$prop.Name] = $prop.Value }
                        Set-Variable -Name SavedShortcut -Value $h -Scope Global -Force
                    }
                    $shortcut | Add-Member -MemberType ScriptMethod -Name Save -Value $save
                    return $shortcut
                }
                $shell | Add-Member -MemberType ScriptMethod -Name CreateShortcut -Value $create
                return $shell
            }

            # Load functions from the script without executing top-level switches: remove Param block first
            $ScriptText = Get-Content $ScriptPath -Raw
            $ScriptText = $ScriptText -replace '(?s)^\s*Param\(\s*.*?\)\s*', ''
            Invoke-Expression $ScriptText
        }

        It 'creates start menu shortcuts and saves them' {
            $env:LOCALAPPDATA = 'C:\repo'
            $UserAppDir = 'C:\UserApp'
            . $ScriptPath -Shortcut -UserAppDir $UserAppDir

            Assert-MockCalled -CommandName Copy-Item -Times 2
            Assert-MockCalled -CommandName New-Object -Times 1 -ParameterFilter { $ComObject -eq 'WScript.Shell' }
            ($null -ne $global:SavedShortcut) | Should Be $true
            $global:SavedShortcut['WorkingDirectory'] | Should Be '%HOMEDRIVE%%HOMEPATH%'
        }
    }

    Context 'Thesaurus' {
        BeforeEach {
            Mock -CommandName New-Item -MockWith { return $null }
            Mock -CommandName Invoke-WebRequest -MockWith { return $null }
        }

        It 'downloads thesaurus to expected path' {
            $Path = 'C:\vimroot'
            # Dot-source the script with the Thesaurus switch so the Thesaurus block runs
            . $ScriptPath -Thesaurus -Path $Path

            $ExpectedOutFile = Join-Path $Path 'vimfiles\thesaurus\mthesaur.txt'
            Assert-MockCalled -CommandName Invoke-WebRequest -Times 1 -ParameterFilter { $Uri -eq 'https://raw.githubusercontent.com/zeke/moby/master/words.txt' -and $OutFile -eq $ExpectedOutFile }
        }
    }
}
