# DataPad
DataPad is a modular system administration tool with a convenient built in system troubleshooting tool, admin access to drives and remote computers without switching accounts, and a basic PowerShell commandline. The tool also features 16 configurable buttons that can be programmed with simple one line scripts to perfom menial tasks one may find themselves doing far too often manually, or linking to webpage you go to often. 
## Compatibility
Should be compatible with any Windows OS with PowerShell capabilities
* Windows 10
* Server 2008,2012,2016, and 2019
* Not tested on Windows 8 and below, or Server 2003 and below.
## Usage
Extract (preferably to C:\DataPad) and run DataPad.exe. To configure the buttons, open src\config.ini and use the included example butons as a template. If you reference any external scripts in a button, its a good idea to put them somewhere in the DataPad directory and reference them variably (like .\src\scripts\exampleScript.ps1). Source code is available to download from GitHub or by running `Datapad.exe -extract:source.ps1` in commandline.
