# TupperboxPS
PowerShell module to restore Tupperbox data from an inaccessible Discord account.

## Module Functions
> [!NOTE]
> Full syntax and detailed help can be found using `Get-Help` with the function.
### Restore-Tuppers
- **Alias:** `rr-tup`
- Parses a text file containing Tupperbox data (tuppers/groups) and converts it into a Tupperbox-compatible JSON file.
- **Interactive Mode** - Displays each found tupper one-by-one, allowing you to review and edit their properties.
```powershell
Restore-Tuppers <Discord ID> <Input text file> [Output JSON file] [-Interactive]
```
<details>
  <summary>Work in progress functions - currently not implemented</summary>
  
### Test-Tuppers
- **Alias:** `t-tup`
- Checks the text file or JSON file for errors.
```powershell
Test-Tuppers <Input text/JSON file>
```

### Save-TupperAvatars
- **Alias:** `sv-tup`
- Downloads all tupper avatars into a subfolder. This is useful for avoiding link rot caused by Discord's CDN.
```powershell
Save-TupperAvatars <Input text/JSON file> [Output Folder]
```
</details>

## Installation
- Download the latest relase
- Copy the **TupperboxPS** folder into your PowerShell module directory
    - by default, this is **Documents\PowerShell\Modules**
    - otherwise, you can type `$env:PSModulePath` in a PowerShell session to list all possible module paths

> [!IMPORTANT]
> By default, PowerShell on Windows blocks the execution of downloaded scripts that are not digitally signed. There are two options to allow execution of remote scripts:
> 1. Set the **ExecutionPolicy** to **Unrestricted**
>     - `Set-ExecutionPolicy Unrestricted -Scope CurrentUser`
> 2. Unblock the module file
>     - In the **TupperboxPS** folder: `Unblock-File .\TupperboxPS.psm1`

The module will be imported automatically, once you start a new PowerShell session.

## Development
The source code contains debug settings for development in **Visual Studio Code**. The `debug` folder contains PowerShell scripts to import the module and run the specified function inside the built-in terminal for easy debugging. It might be necessary to edit the debug scripts, as the contents are currently tailored to my workspace.
<<<<<<< HEAD

At the time of testing, this module works with PowerShell 7.3.
=======
At the time of testing, this module works with PowerShell 7.3
>>>>>>> 5b9406df168f000f4fd35fe2b1b2a42cbdfa9b88

-----
## Why this module?
<details>
<summary>Read the full story here.</summary>

### 📖 Backstory
One of my friends accidentally dropped their phone in the pool. When they got a new one, they found themselves locked out of their Discord account, because the 2FA stopped working (despite the Google Authenticator cloud backup). We've tried every possible solution to get their account back, but ultimately had to create a new one.

However, they have a lot of tuppers, so it would be sad to see them all go and remake them from scratch. Fortunately, the tupper list from their old account was public, so I thought that - in theory - I could reconstruct the tupper data for them using that list.

So I copied all the tupper information - page by page. Then I made a quick (not really) and (definitely) dirty script using Microsoft's **Power Automate**, because I wanted to give it a try. The script worked and soon enough, I had a JSON file ready to be imported. I temporarily used my account to import them and - because I had Tupperbox Premium - reupload all the avatars to Tupperbox's CDN, so they would be safe from link rot. I don't think that's how it was intended to be used, but I just wanted to help my friend out. (I promise I won't do it again, pls don't hurt me-)

### 🛑 Limitations of the original script
The script worked fine for what I had to work with, but it had its issues, that made it unsuitable for sharing it with others:
- :x: It didn't account for nicknames and descriptions. That was fine for my friend, because they didn't use any of that, but if I were to use it, say, on my own tupper list, the script would most likely break.
- :x: **Power Automate scripts are tied to the author's Microsoft account.** As such, there is simply no way for me to share the original script.

### 📝 Rewrite in PowerShell
Recently, I've been learning more PowerShell at school. During that time, I've had the idea to rewrite the old script in PS, to make it more accessible for everyone. I also decided to make it a module, in order to include some other useful functions. The **TupperboxPS** module right here is the result of that.
</details>

## Where is my Discord ID?
Enable **Developer Mode** in your Discord client, then right-click your profile and select **Copy User ID**.

## How do I obtain the tupper list from another account?
In a Discord server with Tupperbox, enter `tul!list` along with mentioning the user.

**Example:** `tul!list @chaosspindash`

This will show all tuppers of that user, along with group information, if applicable. Copy all tuppers and groups into a text file, separating each entry with a blank line. Omit the "Next Group" lines.

> [!IMPORTANT]
> This will not work if the user has set their tupper list to **Private**.

## Why do I still have to obtain the list manually? Can't you just automate it too?
I believe it might be possible to automate this process in the future. However, there is a risk that your account might get flagged for "self-botting", which is against Discord's Terms of Service. So for now, it's best to play it safe.