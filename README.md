PSVultrAPI
=============

This is a PowerShell module for invoking the [Vultr API](https://www.vultr.com/api/?ref=7238481) (affiliate link).

I created this tool as an exercise to learn PowerShell, its best practices, and some associated tools.
As such, this is not fully featured or tested, but pull requests are welcome!

# Credits

This project is based heavily on the [PSStackExchange](https://github.com/RamblingCookieMonster/PSStackExchange) project by 
[Warren Frame](https://github.com/ramblingcookiemonster) aka Rambling Cookie Monster.

If you are interested in learning PowerShell, I highly recommend Warren's blog as well as that of [Kevin Marquette]().
I've found these guys to be clear and concise in explaining things. There's also the YouTube series (and book) 
[PowerShell in a Month of Lunches](https://www.youtube.com/playlist?list=PL6D474E721138865A) by Don Jones.

	* [How do I Learn PowerShell?]() - _Warren Frame_
	* [Building a PowerShell Module](http://ramblingcookiemonster.github.io/Building-A-PowerShell-Module/) - _Warren Frame_
	* [Powershell Module Building Basics](https://kevinmarquette.github.io/2017-05-27-Powershell-module-building-basics/) - _Kevin Marquette_

Although I didn't reference it, there is another PS Vultr module by [vektorprime](https://gitlab.com/vektorprime/Vultr-PowerShell).
	
# Instructions

```powershell
# One time setup
    # Download the repository
    # Unblock the zip
    # Extract the PSVultrAPI folder to a module path (e.g. $env:USERPROFILE\Documents\WindowsPowerShell\Modules\)

    #Simple alternative, if you have PowerShell 5, or the PowerShellGet module:
        Install-Module PSVultrAPI

# Import the module.
    Import-Module PSVultrAPI    #Alternatively, Import-Module \\Path\To\PSVultrAPI

# Get commands in the module
    Get-Command -Module PSVultrAPI

# Get help
    Get-Help Get-WANIP -Full
    Get-Help about_PSVultrAPI
```

#Examples

### TODO: Examples

```PowerShell
	# TODO: Example
```

### Search Stack Exchange Questions

```PowerShell
	# TODO: Example
```