<#PSScriptInfo

.VERSION 1.1

.GUID d1b03e66-ac73-4127-b821-2dc9dc3066d4

.AUTHOR jdfisher@energy-northwest.com

.COMPANYNAME Energy Northwest

.COPYRIGHT John D. Fisher, Energy Northwest, 2020 All Rights Reserved

.TAGS vim vimwiki Microsoft Word pandoc

.LICENSEURI https://mit-license.org/

.PROJECTURI

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES pandoc

.RELEASENOTES
  Word does not handle ordered lists after code blocks. Right click and select Continue Number to fix.

#>

<#
.DESCRIPTION
  Convert Vimwiki Diary to Microsoft Word. Remove Vimwiki tags to avoid
  cluttering PREPM.
.LINK
   Requires pandoc (https://pandoc.org/installing.html)
.LINK
  The default Pandoc template layout is portrait; PREPM uses landscape.
  (Get-Help Convert-VimwikiToMSWord.ps1 -Parameter ReferenceDoc) to change
  layout.
.EXAMPLE
  PS C:\> Convert-VimwikiToMSWord.ps1 9/8/2020,9/9/2020 -Verbose

    VERBOSE: Add to PREPM Insert:
    ~\Documents\vimwiki\diary\2020-09-08.wiki
    VERBOSE: Add to PREPM Insert:
    ~\Documents\vimwiki\diary\2020-09-09.wiki

    Confirm
    Are you sure you want to perform this action?
    Performing the operation "Convert-VimwikiToMSWord.ps1" on target "Write
    ~\AppData\Local\Temp\1\prepm_insert.docx".
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help
    (default is "Y"):
    VERBOSE: PREPM Insert written to:
    ~\AppData\Local\Temp\1\prepm_insert.docx
#>
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
Param(
  [Parameter( Position = 0 )]
  # Start date for diary conversion. Default Monday this week.
  [datetime]$StartDate = (Get-Date).AddDays( - ([int](Get-date).DayOfWeek) + 1).Date
  ,
  [Parameter( Position = 1 )]
  [ValidateScript( {
      if ( $PSBoundParameters['StartDate'] -le $_ ) {
        $true
      } else {
        throw @("EndDate $_ earlier than ",
          "StartDate $($PSBoundParameters['StartDate'])"
        )
      }
    })]
  # End date for diary conversion. Default today.
  [datetime]$EndDate = (Get-Date).Date
  ,
  [Parameter()]
  [ValidateScript( {Test-Path $_} )]
  # Path(s) to Vimwiki Diary
  [String[]]$Path = "~\Documents\vimwiki\diary\"
  ,
  [ValidateScript( {Test-Path $_} )]
  # Path to Pandoc --reference-doc conversion template. Create with
  # pandoc -o  "$Env:APPDATA\Pandoc\templates\prepm-reference.docx" --print-default-data-file reference.docx
  # Change Layout to Landscape and margins to Narrow.
  [string]$ReferenceDoc = "$Env:APPDATA\Pandoc\templates\prepm-reference.docx"
  ,
  # Path to PREPM insert file
  [string]$PrepmInsert = "$Env:TEMP\prepm_insert.docx"
)

$DateFormat = 'yyyy-MM-dd'
$Pattern = '\d{4}-\d{2}-\d{2}'
$Path = Join-Path $Path '*.wiki'

Write-Verbose "Start Date: $StartDate"
Write-Verbose "End Date: $EndDate"

$VimwikiFile = Get-ChildItem -Path $Path |
  Where-Object -Property BaseName -Match $Pattern | Sort-Object -Property Name -CaseSensitive |
  ForEach-Object -Process {
  [datetime]$VimwikiDate = Get-Date -Format $DateFormat $($_.BaseName)
  if ( $StartDate -le $VimwikiDate -and $VimwikiDate -le $EndDate ) {
    Write-Verbose "Add to PREPM Insert: $_"
    $_
  }
}

try {
  $null = Get-Command pandoc -ErrorAction Stop
} catch  [System.Management.Automation.CommandNotFoundException] {
  $ErrorMessage = @(
    "Requires Pandoc to convert Vimwiki.",
    "See https://pandoc.org/installing.html for installation instructions.",
    $_Exception
  )
  throw "$ErrorMessage"
}

Write-Verbose "Clean PREPM Insert $PrepmInsert to $Env:TEMP\prepm.wiki"
$NotPattern = @(
  '^:.*:$',
  '-\s\[\s\]',
  '^\s{0,}\*\s',
  '\d{1,}.\s\[\s\]'
)

$ConfirmMessage = @("Write $PrepmInsert")
if ($PSCmdlet.ShouldProcess($ConfirmMessage)) {
  ($VimwikiFile |  Get-Content | Select-String -NotMatch -Pattern $NotPattern
  ) -join "`n" |
    Out-File -NoNewline -Encoding utf8 -FilePath "$Env:TEMP\prepm.wiki"
  $null = vim -n -e -s -u "~\vimfiles\vimrc" `
    "$Env:TEMP\prepm.wiki" `
    -c  'g/^\(=\{1,}\).*\1\n\{3,\}/d' `
    -c '%s/\n\{3,\}/\r\r/' `
    -c 'g/^\(=\{1,}\).*\1\(\n\s*\)\+\%$/d' `
    -c 'VimwikiRenumberAllLists' -c 'update' +quit `
    2>&1
  Write-Verbose "PREPM Insert written to: $PrepmInsert"
  pandoc --from=vimwiki --to=docx  "$Env:TEMP\prepm.wiki" -o "$PrepmInsert" `
    --shift-heading-level-by=1 --reference-doc="$ReferenceDoc"
}
