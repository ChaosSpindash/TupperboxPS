Function Restore-Tuppers
{
    <#
    .SYNOPSIS
    Restores Tupperbox data from a text file and generates a valid Tupperbox JSON file.
    .DESCRIPTION
    The 'Restore-Tuppers' cmdlet parses a text file containing a list of Tupperbox data ('tuppers') from a Discord account. This is useful if the Discord account in question is no longer accessible, in which case the Tupperbox Bot's Export command cannot be used. Passing the text file to this cmdlet along with the user's Discord ID will generate a valid JSON file, that can be imported by another Discord account.

    To retrieve the list of tuppers from any Discord account, use the List bot command along with mentioning the user in question:
        tul!list @<User>
    
    Then copy all the tupper and group information to a text file, page by page.
    NOTE: If the user has set their tupper list to Private, you will not be able to retrieve the data at all.
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
    Allows you to review and edit each tupper found during the restore.
    If not provided, will automatically restore all tuppers without user action required.
    .PARAMETER Verify
    Interactive mode without saving data. Allows you to check the input file for errors and inconsistencies.
    .NOTES
    This cmdlet is licensed under the MIT License.

    Copyright (c) 2023 Chaos Spindash

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
    #>
    [CmdletBinding()]
    param (
        [string][Parameter(Mandatory,HelpMessage="Enter your Discord User ID.`nYou can retrieve it by enabling Developer Mode in your Discord client, then go to your profile and select 'Copy User ID'.")]$DiscordID,
        [string][Parameter(Mandatory,HelpMessage="Provide the file containing your list of tuppers. Must be a text file. (*.txt)")][ValidatePattern("^*\.txt$",ErrorMessage="Input must be a text file. (*.txt)")]$InputFile,
        [string][Parameter()][ValidatePattern("^*\.json$",ErrorMessage="Output must be a JSON file. (*.json)")]$OutputFile=".\tuppers.json",
        [switch][Parameter()]$Interactive,
        [switch][Parameter()]$Verify
    )
    
}

Export-ModuleMember -Function "Restore-Tuppers"