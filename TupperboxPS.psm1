Function Restore-Tuppers {
    <#
    .SYNOPSIS
    Parses a text file containing Tupperbox data (tuppers/groups) and converts it into a Tupperbox-compatible JSON file.
    .DESCRIPTION
    The 'Restore-Tuppers' function parses a text file containing a list of Tupperbox data (tuppers/groups) from a Discord account. This is useful if the Discord account in question is no longer accessible, in which case the Tupperbox Bot's Export command cannot be used. Passing the text file to this cmdlet along with the user's Discord ID will generate a valid JSON file, that can be imported by another Discord account.

    To retrieve the list of tuppers from any Discord account, use the List bot command along with mentioning the user in question:
        tul!list @<User>
    
    Then copy all the tupper and group information to a text file, page by page. Separate each entry with a blank line.
    NOTE: If the user has set their tupper list to Private, you will be unable to retrieve the data from that user.
    .PARAMETER DiscordID
    User ID of the Discord account. Can be retrieved by enabling Developer Mode in your Discord client, then go to the profile and select 'Copy User ID'.
    This parameter is required.
    .PARAMETER InputFile
    Text file containing Tupperbox data. Must be a text file.
    This parameter is required.
    .PARAMETER OutputFile
    JSON file to save the data for import with Tupperbox. Must be a JSON file.
    If not provided, will save to 'tuppers.json' in the current directory.
    .PARAMETER Interactive
    [WIP]
    Allows you to review and edit each tupper found during the restore.
    If not provided, will automatically restore all tuppers without user action required.
    .PARAMETER NoGroups
    [WIP]
    Disregards group information. All restored tuppers will be ungrouped.
    .PARAMETER NoCompress
    Export JSON without compression (preserve white spaces and indentations).
    DEBUG ONLY - output file cannot be imported by Tupperbox.
    .NOTES
    This function does not break Discord's Terms of Service, as it does not interact with their API at all. All this module does is simply generate a JSON file that can be imported into Tupperbox - using a list of tuppers the user has to obtain manually.
    Automating the Tupperbox data fetching process is not recommended, as this could fall under "self-botting", which is against Discord ToS and can get your account flagged.

    TupperboxPS is licensed under the MIT License.
    Copyright (c) 2023 Chaos Spindash
    https://github.com/ChaosSpindash/TupperboxPS/blob/main/LICENSE
    #>
    [CmdletBinding()]
    param (
        [string][Parameter(Mandatory, HelpMessage = "Enter your Discord User ID.`nYou can retrieve it by enabling Developer Mode in your Discord client, then go to your profile and select 'Copy User ID'.")]$DiscordID,
        [string][Parameter(Mandatory, HelpMessage = "Provide the file containing your list of tuppers. Must be a text file.")][ValidatePattern("^*\.txt$", ErrorMessage = "Input must be a text file. (*.txt)")]$InputFile,
        [string][Parameter()][ValidatePattern("^*\.json$", ErrorMessage = "Output must be a JSON file. (*.json)")]$OutputFile = ".\tuppers.json",
        [switch][Parameter()]$Interactive,
        [switch][Parameter()]$NoGroups,
        [switch][Parameter()]$NoCompress
    )
    # Load content from text file
    $Txt = Get-Content $InputFile
    # Create blank PSObject - this will be the JSON output
    $JsonObj = [ordered]@{tuppers = @(); groups = @() }
    # Initialize iterative values for tuppers and groups
    $TupperGroupPos = $TupperID = 0
    $GroupID = -1
    $GroupFlag = $false

    foreach ($line in $Txt) {
        switch -Regex ($line) {
            "^Group: Ungrouped$" {
                $GroupID = $TupperGroupPos = $null
                $GroupFlag = $true
                break
            }
            "^Group:" {
                $GroupID += 1
                $TupperGroupPos = 0
                $GroupObj = [ordered]@{
                    id          = $GroupID
                    user_id     = "$DiscordID"
                    name        = $line.Substring(7)
                    description = $null
                    tag         = $null
                    position    = $GroupID
                }
                $JsonObj.groups += $GroupObj
                $GroupFlag = $true
                break
            }
            "^Nickname:" {
                $JsonObj.tuppers[$TupperID].nick = $line.Substring(10)
                break
            }
            "^Brackets:" {
                
                $JsonObj.tuppers[$TupperID].brackets = @($line.Substring(10).Split("text")[0]; $line.Substring(10).Split("text")[1])
                break
            }
            "^Birthday:" {
                $JsonObj.tuppers[$TupperID].birthday = "$(Get-Date($line.Substring(10)) -Format yyyy-MM-ddTHH:mm:ss.fffZ)"
                break
            }
            "^Avatar URL:" {
                $JsonObj.tuppers[$TupperID].avatar_url = $line.Substring(12)
            }
            "^Total messages sent:" {
                [int]$JsonObj.tuppers[$TupperID].posts = $line.Substring(21)
                break
            }
            "^Registered:" {
                if ($line.Contains("a long time ago")) {
                    break
                }
                else {
                    $JsonObj.tuppers[$TupperID].created_at = "$(Get-Date($line.Substring(12)) -Format yyyy-MM-ddTHH:mm:ss.fffZ)"
                    break
                }
            }
            Default {
                if ($GroupFlag -and ![string]::IsNullOrEmpty($line)) {
                    $JsonObj.groups[$GroupID].description = "$line"
                }
                elseif ($GroupFlag -and [string]::IsNullOrEmpty($line)) {
                    $GroupFlag = $false
                }
                elseif (!$GroupFlag -and ![string]::IsNullOrEmpty($line) -and $null -eq $JsonObj.tuppers[$TupperID]) {
                    $TupperObj = [ordered]@{
                        id                 = $TupperID
                        user_id            = "$DiscordID"
                        name               = "$line"
                        position           = $TupperID
                        avatar_url         = $null
                        brackets           = @()
                        posts              = 0
                        show_brackets      = $false
                        birthday           = $null
                        description        = $null
                        tag                = $null
                        group_id           = $GroupID
                        group_pos          = $TupperGroupPos
                        created_at         = "$(Get-Date -Format yyyy-MM-ddTHH:mm:ss.fffZ)"
                        nick               = $null
                        last_used          = $null
                        discord_attachment = $null
                    }
                    $JsonObj.tuppers += $TupperObj
                }
                elseif (!$GroupFlag -and ![string]::IsNullOrEmpty($line) -and $null -ne $JsonObj.tuppers[$TupperID]) {
                    $JsonObj.tuppers[$TupperID].description = "$line"
                }
                elseif (!$GroupFlag -and [string]::IsNullOrEmpty($line)) {
                    $TupperID += 1
                    if ($null -ne $TupperGroupPos) {
                        $TupperGroupPos += 1 
                    }
                }
            }
        }
    }

    if ($NoCompress) {
        $JsonObj | ConvertTo-Json -Depth 3 | Out-File $OutputFile
    }
    else {
        $JsonObj | ConvertTo-Json -Compress -Depth 3 | Out-File $OutputFile
    }

}

Function Test-Tuppers {
    [CmdletBinding()]
    param (
        [string][Parameter(Mandatory, HelpMessage = "Provide the file containing your list of tuppers. Can be a text file or JSON file.")]$InputFile
    )

}

Function Save-TupperAvatars {
    [CmdletBinding()]
    param (
        [string][Parameter(Mandatory, HelpMessage = "Provide the file containing your list of tuppers. Can be a text file or JSON file.")]$InputFile,
        [string][Parameter()]$OutputDir = ".\TupperAvatars"
    )
}

Export-ModuleMember -Function Restore-Tuppers, Test-Tuppers, Save-TupperAvatars -Alias rr-tup, t-tup, sv-tup