### Add-Type dependencies ###
    Add-Type -AssemblyName System.Windows.Forms 
    Add-Type -AssemblyName System.Drawing
    Add-Type -AssemblyName PresentationCore,PresentationFramework

## Read Config ##
    $config = Get-Content .\src\config.ini
    foreach($line in $config)
    {
        if($line -like "*=*")
        {
            Invoke-Expression $line
        }
    }

### Check if Admin ###
    $admin = ([Security.Principal.WindowsPrincipal] `
              [Security.Principal.WindowsIdentity]::GetCurrent()
              ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (!$admin)
    {
        $adminWarning = [System.Windows.Forms.MessageBox]::Show("You are not running DataPad as admin. Please run AllowAdmin and restart DataPad as admin.","Warning",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Warning)
    }

### Functions ###

    function output($text)
    {
        $mOutputBox.AppendText("$text`r`n")
        $mOutputBox.SelectionStart = $mOutputBox.TextLength;
        $mOutputBox.ScrollToCaret()
        $mOutputBox.Focus
    }

### Load Windows Form ###
    $MyForm = New-Object System.Windows.Forms.Form 
    $MyForm.Text="DataPad" 
    $MyForm.Size = New-Object System.Drawing.Size(680,550) 
    $MyForm.BackColor = "DarkGray"
    $MyForm.BackgroundImage =  $img
    $MyForm.BackgroundImageLayout = "Stretch"
    $MyForm.WindowState = "Normal"
    $MyForm.FormBorderStyle = "Fixed3D"
    $MyForm.MaximizeBox = $false
    $MyForm.Icon = [System.Drawing.Icon](".\src\datapad.ico")


### TROUBLESHOOTING ###

    ## Label ##
        $mSystem_Troubleshooting = New-Object System.Windows.Forms.Label 
            $mSystem_Troubleshooting.Text="System Troubleshooting" 
            $mSystem_Troubleshooting.Top="10" 
            $mSystem_Troubleshooting.Left="7" 
            $mSystem_Troubleshooting.Anchor="Left,Top" 
            $mSystem_Troubleshooting.BackColor = "Transparent"
            $mSystem_Troubleshooting.ForeColor = "White"
        $mSystem_Troubleshooting.Size = New-Object System.Drawing.Size(200,20) 
        $MyForm.Controls.Add($mSystem_Troubleshooting) 

    ## System Name ##
        $mSystem_Name = New-Object System.Windows.Forms.TextBox 
            $mSystem_Name.Text="Enter System Name" 
            $mSystem_Name.Top="35" 
            $mSystem_Name.Left="8" 
            $mSystem_Name.Anchor="Left,Top"
            $mSystem_Name.ADD_CLICK({$mSystem_Name.Text = ""})
            $mSystem_Name.ADD_LEAVE({if($mSystem_Name.Text -eq ""){$mSystem_Name.Text="Enter System Name"}})
        $mSystem_Name.Size = New-Object System.Drawing.Size(200,23) 
        $MyForm.Controls.Add($mSystem_Name) 

    ## If List ##
        $mMultipleHosts = New-Object System.Windows.Forms.Button
            $mMultipleHosts.Text = "Pick a host list"
            $mMultipleHosts.Top = "34"
            $mMultipleHosts.Left = "210"
            $mMultipleHosts.Anchor = "Left,Top"
            $mMultipleHosts.ADD_CLICK(
            {
                $hostBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{Filter = "Text Files (*.txt)|*.txt"}
                $hostBrowser.ShowDialog()
                $mMultipleHosts.Tag=@{Path=$hostBrowser.FileName}
                $mSystem_Name.Text = "|LIST|"
            })
            $mMultipleHosts.Size = New-Object System.Drawing.Size(100,23)
            $MyForm.controls.Add($mMultipleHosts)
         
    ## Check if Ping ##
        $mPing? = New-Object System.Windows.Forms.CheckBox 
            $mPing?.Text="Ping" 
            $mPing?.Top="60" 
            $mPing?.Left="8" 
            $mPing?.Anchor="Left,Top" 
            $mPing?.BackColor = " Transparent"
            $mPing?.ForeColor = "White"
        $mPing?.Size = New-Object System.Drawing.Size(100,23) 
        $MyForm.Controls.Add($mPing?) 

    ## Check if trace route ##
        $mTraceRoute = New-Object System.Windows.Forms.CheckBox 
            $mTraceRoute.Text="Tracert" 
            $mTraceRoute.Top="80" 
            $mTraceRoute.Left="8" 
            $mTraceRoute.Anchor="Left,Top" 
            $mTraceRoute.BackColor = " Transparent"
            $mTraceRoute.ForeColor = "White"
        $mTraceRoute.Size = New-Object System.Drawing.Size(100,23) 
        $MyForm.Controls.Add($mTraceRoute) 
         
    ## Check if ipconfig ##
        $mipconfig? = New-Object System.Windows.Forms.CheckBox 
            $mipconfig?.Text="ipconfig" 
            $mipconfig?.Top="100" 
            $mipconfig?.Left="8" 
            $mipconfig?.Anchor="Left,Top"
            $mipconfig?.BackColor = " Transparent" 
            $mipconfig?.ForeColor = "White"
        $mipconfig?.Size = New-Object System.Drawing.Size(100,23) 
        $MyForm.Controls.Add($mipconfig?) 

    ## Check if Last 5 Users ##
        $mLast5Users = New-Object System.Windows.Forms.CheckBox 
            $mLast5Users.Text="Last 5 Users" 
            $mLast5Users.Top="120" 
            $mLast5Users.Left="8" 
            $mLast5Users.Anchor="Left,Top" 
            $mLast5Users.BackColor = " Transparent"
            $mLast5Users.ForeColor = "White"
        $mLast5Users.Size = New-Object System.Drawing.Size(100,23) 
        $MyForm.Controls.Add($mLast5Users)

    ## Check FCIS ##
        $mFCIS = New-Object System.Windows.Forms.CheckBox 
            $mFCIS.Text="FCIS" 
            $mFCIS.Top="60" 
            $mFCIS.Left="110" 
            $mFCIS.Anchor="Left,Top" 
            $mFCIS.BackColor = " Transparent"
            $mFCIS.ForeColor = "White"
        $mFCIS.Size = New-Object System.Drawing.Size(100,23) 
        $MyForm.Controls.Add($mFCIS) 

    ## Select All ##
        $mSelectAll = New-Object System.Windows.Forms.CheckBox
        $mSelectAll.Text = "Select All"
        $mSelectAll.Top = 120
        $mSelectAll.Left = 110
        $mSelectAll.Anchor = "Left,Top"
        $mSelectAll.BackColor = "Transparent"
        $mSelectAll.ForeColor = "White"
        $mSelectAll.ADD_CLICK(
        {
            if($mSelectAll.Checked)
            {
                $mPing?.Checked = $true
                $mTraceRoute.Checked = $true
                $mipconfig?.Checked = $true
                $mLast5Users.Checked = $true
                $mFCIS.Checked = $true
            }
            else
            {
                $mPing?.Checked = $false
                $mTraceRoute.Checked = $false
                $mipconfig?.Checked = $false
                $mLast5Users.Checked = $false
                $mFCIS.Checked = $false
            }
        })
        $mSelectAll.Size = New-Object System.Drawing.Size(100,23) 
        $MyForm.Controls.Add($mSelectAll)

    ## Confirm ##
        $mConfirmTroubleshoot = New-Object System.Windows.Forms.Button 
            $mConfirmTroubleshoot.Text="Troubleshoot!" 
            $mConfirmTroubleshoot.Top="145" 
            $mConfirmTroubleshoot.Left="8" 
            $mConfirmTroubleshoot.Anchor="Left,Top" 
            $mConfirmTroubleshoot.BackColor = "Black"
            $mConfirmTroubleshoot.ForeColor = "White"
            $mConfirmTroubleshoot.Add_Click(
            {
                if($mSystem_Name.Text -eq "|LIST|"){$pcList = Get-Content -Path $mMultipleHosts.Tag.Path}else{$pcList = $mSystem_Name.Text}
                foreach($tComp in $pcList)
                {
                    output("TROUBLESHOOTING INFO FOR: $tComp`r`n==================================================`r`n")
                    if($tComp -eq "Enter System Name" -or $tComp -eq $null){$tComp = $env:COMPUTERNAME}
                    if($mPing?.Checked)
                    {
                        if(Test-Connection -ComputerName $tComp -Count 1 -Quiet){$tPing = "Ping successful!"}else{$tPing = "Ping unsuccessful"}
                        output($tPing)
                    }
        
                    if($mTraceRoute.Checked)
                    {
                        $tTraceRoute = tracert $tComp
                        foreach($line in $tTraceRoute)
                        {
                            output($line)
                        }
                        output("")
                    }

                    if($mipconfig?.Checked)
                    {
                        if(!$admin)
                        {
                            $ipinfo = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $tComp -Credential (Get-Credential -Message "Use Admin Account")
                            $IPAddress = ([System.Net.Dns]::GetHostByName("$tComp").Addresslist[0]).IpAddressToString
                            $MacAddress = ($ipinfo | where{$_.IpAddress -eq $IPAddress}).MACAddress
                            $tipconfig = "IP Address: $IPAddress`r`nMAC Address: $MacAddress`r`n"
                        }
                        else
                        {
                            $ipinfo = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $tComp
                            $IPAddress = ([System.Net.Dns]::GetHostByName("$tComp").Addresslist[0]).IpAddressToString
                            $MacAddress = ($ipinfo | where{$_.IpAddress -eq $IPAddress}).MACAddress
                            $tipconfig = "IP Address: $IPAddress`r`nMAC Address: $MacAddress`r`n"
                        }
                        output($tipconfig)
                    }

                    if($mLast5Users.Checked)
                    {
                        if(!$admin)
                        {
                            $tLast5Users = "Last 5 Users cannot run. Please run AllowAdmin, then restart DataPad as admin"
                        }
                        else
                        {
                            $last5 = dir "\\$tComp\C$\Users" | Sort-Object -Descending lastWriteTime | select -First 5
                            $names = $last5 | select -ExpandProperty "Name"
                            $dates = $last5 | select -ExpandProperty "LastAccessTime"
                            $tNames = @()
                            $tNames += "LAST 5 AUTHENTICATED USERS:"
                            $i = 0

                            foreach ($name in $names){
                                if ($name -ne "Public") {
                                    $firstName = Get-ADUser -Filter "SamAccountName -like '$name'" -Properties * | select -ExpandProperty givenName
                                    $lastName = Get-ADUser -Filter "SamAccountName -like '$name'" -Properties * | select -ExpandProperty sn
                                    $fullName = $firstName + " " + $lastName
                                    $date = $dates[$i]
                                    if ($lastName -eq $null -and $firstName -eq $null){
                                        $fullName = "No AD Entry for $name"
                                    }
                                    $tNames += "`r`n$fullName $date"
                                }
                                $i++
                                $tLast5Users = $tNames
                            }
                        }
                        output($tLast5Users)
                    }

                    if($mFCIS.Checked)
                    {
                        if($admin -ne "False")
                        {
                            try
                            {
                                try
                                {
                                    $tComp = ([System.Net.Dns]::GetHostByAddress($tComp)).HostName
                                    $tComp = $tComp -replace ".area52.afnoapps.usaf.mil"
                                }
                                catch
                                {}
                                try
                                {
                                    $remoteWMIOS = (Get-WmiObject -Class Win32_operatingsystem -ComputerName "$tComp" | select *)
                                    $remoteWMICS = (Get-WMIObject -class Win32_ComputerSystem -ComputerName "$tComp" | select *)
                                }
                                catch
                                {}
                                try{$tCompOS = ($remoteWMIOS.Name).Split("|*")[0]}catch{$tCompOS = "Not Available"}
                                try{$tCompModel = $remoteWMICS.Model}catch{$tCompModel = "NOT AVAILABLE"}   
                                try{$tCompCurrentUser = (Get-ADUser ($remoteWMICS.username -replace "$((Get-ADDomain).Name)\\", "") -Properties DisplayName).DisplayName}catch{$tCompCurrentUser = "NOT AVAILABLE"}    
                                if($tCompModel -eq "" -or $tCompModel -eq $null)
                                {
                                    $tCompModel = "NOT AVAILABLE"
                                }
                                $ADOutput = Get-ADComputer $tcomp
                                $distinguishedname = $ADOutput.DistinguishedName -replace "CN=$tcomp,"
                                $distinguishedname = $distinguishedname -replace ",","`r`n  "
                                $objectclass = $ADOutput.ObjectClass
                                $tFCIS = "`r`nFast Computer Information Script`r`nOU:`r`n  $distinguishedname`r`nName: $tComp`r`nObject Class: $objectclass`r`nOperating System: $tCompOS`r`nCurrent User: $tCompCurrentUser`r`nModel: $tCompModel"
                            }
                            catch
                            {
                                $tFCIS = "Computer $tComp not found in Active Directory!"
                            }
                            output($tFCIS)
            
                            output("`r`nEND TROUBLESHOOTING REPORT FOR $tComp`r`n==================================================`r`n")
                        }
                        else
                        {
                            output("FCIS cannot run. Please allow admin and restart as administrator")
                        }
                    }
                }
            })
        $mConfirmTroubleshoot.Size = New-Object System.Drawing.Size(203,25) 
        $MyForm.Controls.Add($mConfirmTroubleshoot) 

    ## Restart ##
        $mRestartComp = New-Object System.Windows.Forms.Button 
            $mRestartComp.Text="Restart System" 
            $mRestartComp.Top="170" 
            $mRestartComp.Left="8" 
            $mRestartComp.Anchor="Left,Top" 
            $mRestartComp.BackColor = "Gray"
            $mRestartComp.ForeColor = "Black"
            $mRestartComp.Add_Click(
            {
                $tComp = $mSystem_Name.Text
                if([System.Windows.Forms.MessageBox]::Show("Restart $($tComp)? Make sure to notify the user beforehand.","Confirm Restart",[System.Windows.Forms.MessageBoxButtons]::OKCancel,[System.Windows.Forms.MessageBoxIcon]::Exclamation) -eq "OK")
                {
                    output("Restarting $tComp...")
                    if(Test-Connection -ComputerName $tComp -Count 1)
                    {
                        Restart-Computer -ComputerName $tComp -Force
                        output("$tComp will be restarted.")
                    }
                    else
                    {
                        output("COULD NOT RESTART $tComp")
                    }
                }
                else
                {
                    output("$tComp will not be restarted.")
                }
            })
        $mRestartComp.Size = New-Object System.Drawing.Size(100,25) 
        $MyForm.Controls.Add($mRestartComp) 

    ## Message ##
        $mMessage = New-Object System.Windows.Forms.Button 
            $mMessage.Text="Send Message" 
            $mMessage.Top="170" 
            $mMessage.Left="110" 
            $mMessage.Anchor="Left,Top" 
            $mMessage.BackColor = "Gray"
            $mMessage.ForeColor = "Black"
            $mMessage.Add_Click(
            {
                output("Opening message dialog...")
                $sendMessage = New-Object System.Windows.Forms.Form 
                $sendMessage.Text="Message" 
                $sendMessage.Size = New-Object System.Drawing.Size(300,150) 
                $sendMessage.BackColor = "Gray"
                $sendMessage.WindowState = "Normal"
                $sendMessage.FormBorderStyle = "Fixed3D"
                $sendMessage.MaximizeBox = $false
                $sendMessage.MinimizeBox = $false
                $sendMessage.KeyPreview = $true
                $sendMessage.Icon = [System.Drawing.Icon](".\src\datapad.ico")
                $sendMessage.Add_Keydown({if($_.KeyCode -eq "Enter")
                {
                    $mSend.PerformClick()
                }})
                $sendMessage.Add_Keydown({if($_.KeyCode -eq "Escape"){$sendMessage.Close()}})

                ## Label ##
                    $mNameLabel = New-Object System.Windows.Forms.Label 
                        $mNameLabel.Text="Computer Name:" 
                        $mNameLabel.Top="10" 
                        $mNameLabel.Left="7" 
                        $mNameLabel.Anchor="Left,Top" 
                        $mNameLabel.BackColor = "Transparent"
                        $mNameLabel.ForeColor = "White"
                    $mNameLabel.Size = New-Object System.Drawing.Size(200,20) 
                    $sendMessage.Controls.Add($mNameLabel) 

                ## System Name ##
                    $mSystemName = New-Object System.Windows.Forms.TextBox
                        $mSystemName.Text = $mSystem_Name.Text
                        $mSystemName.Top="35" 
                        $mSystemName.Left="8" 
                        $mSystemName.Anchor="Left,Top" 
                    $mSystemName.Size = New-Object System.Drawing.Size(200,23) 
                    $sendMessage.Controls.Add($mSystemName) 

                ## Label ##
                    $mMsgLabel = New-Object System.Windows.Forms.Label 
                        $mMsgLabel.Text="Message:" 
                        $mMsgLabel.Top="60" 
                        $mMsgLabel.Left="7" 
                        $mMsgLabel.Anchor="Left,Top" 
                        $mMsgLabel.BackColor = "Transparent"
                        $mMsgLabel.ForeColor = "White"
                    $mMsgLabel.Size = New-Object System.Drawing.Size(200,20) 
                    $sendMessage.Controls.Add($mMsgLabel) 

                ## Message ##
                    $mMessage = New-Object System.Windows.Forms.TextBox
                        $mMessage.Top="85" 
                        $mMessage.Left="8" 
                        $mMessage.Anchor="Left,Top" 
                    $mMessage.Size = New-Object System.Drawing.Size(200,23) 
                    $sendMessage.Controls.Add($mMessage) 
    
                ## Send ##
                    $mSend = New-Object System.Windows.Forms.Button 
                        $mSend.Text="Send Message" 
                        $mSend.Top="77" 
                        $mSend.Left="210" 
                        $mSend.Anchor="Left,Top" 
                        $mSend.BackColor = "Black"
                        $mSend.ForeColor = "White"
                        $mSend.Add_Click(
                        {
                            if($mSystemName.Text -eq " " -or $mSystemName.Text -eq $null)
                            {
                                [System.Windows.Forms.MessageBox]::Show("Please enter a computer name","Error",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Warning)
                            }
                            elseif($mMessage.Text -eq " " -or $mMessage.Text -eq $null)
                            {
                                [System.Windows.Forms.MessageBox]::Show("Please enter a message","Error",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Warning)
                            }
                            else
                            {
                                $message = $mMessage.Text
                                try{Invoke-WmiMethod -Path Win32_Process -Name Create -ArgumentList "msg * $message" -ComputerName $mSystemName.Text}catch{output("Cannot send message, aborting...")}
                                $sendMessage.Close()
                            }
                        })
                    $mSend.Size = New-Object System.Drawing.Size(80,35) 
                    $sendMessage.Controls.Add($mSend) 
    
                $sendMessage.ShowDialog()
            })
        $mMessage.Size = New-Object System.Drawing.Size(100,25) 
        $MyForm.Controls.Add($mMessage)

    ## backdoor ##
        $mbackdoor = New-Object System.Windows.Forms.Button 
            $mbackdoor.Text="Backdoor" 
            $mbackdoor.Top="195" 
            $mbackdoor.Left="8" 
            $mbackdoor.Anchor="Left,Top" 
            $mbackdoor.BackColor = "Gray"
            $mbackdoor.ForeColor = "Black"
            $mbackdoor.Add_Click(
            {
                output("Entering C drive of $($mSystem_Name.Text)...")
                $backdoor = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = "\\$($mSystem_Name.Text)\C$" }
                $backdoor.ShowDialog()
            })
        $mbackdoor.Size = New-Object System.Drawing.Size(100,25) 
        $MyForm.Controls.Add($mbackdoor)

    ## Remote Console ##
        $mremoteConsole = New-Object System.Windows.Forms.Button 
            $mremoteConsole.Text="Remote Console" 
            $mremoteConsole.Top="195" 
            $mremoteConsole.Left="110" 
            $mremoteConsole.Anchor="Left,Top" 
            $mremoteConsole.BackColor = "Gray"
            $mremoteConsole.ForeColor = "Black"
            $mremoteConsole.Add_Click(
            {
                output("Opening remote console dialog")
                $formRemoteConsole = New-Object System.Windows.Forms.Form
                $formRemoteConsole.Text = "Remote Console"
                $formRemoteConsole.Size = New-Object System.Drawing.Size(220,120)
                $formRemoteConsole.WindowState = "Normal"
                $formRemoteConsole.FormBorderStyle = "Fixed3D"
                $formRemoteConsole.BackColor = "DarkGray"
                $formRemoteConsole.MaximizeBox = $false
                $formRemoteConsole.MinimizeBox = $false
                $formRemoteConsole.Icon = [System.Drawing.Icon](".\src\datapad.ico")

                $RCLabel = New-Object System.Windows.Forms.Label
                    $RCLabel.Text = "System Name:"
                    $RCLabel.Top = 10
                    $RCLabel.Left = 10
                    $RCLabel.Anchor = "Left,Top"
                    $RCLabel.Size = New-Object System.Drawing.Size(100,20)
                    $formRemoteConsole.Controls.Add($RCLabel)

                $RCTextBox = New-Object System.Windows.Forms.TextBox
                    $RCTextBox.Text = $mSystem_Name.Text
                    $RCTextBox.Top = 30
                    $RCTextBox.Left = 10
                    $RCTextBox.Anchor = "Left,Top"
                    $RCTextBox.Size = New-Object System.Drawing.Size(190,20)
                    $formRemoteConsole.Controls.Add($RCTextBox)

                $RCPSExec = New-Object System.Windows.Forms.Button
                    $RCPSExec.Text = "PSExec"
                    $RCPSExec.Top = 55
                    $RCPSExec.Left = 10
                    $RCPSExec.Anchor = "Left,Top"
                    $RCPSExec.Size = New-Object System.Drawing.Size(60,20)
                    $RCPSExec.ADD_CLICK({Start-Process powershell -ArgumentList "-command Psexec.exe \\$($RCTextBox.Text) powershell"})
                    $RCPSExec.ADD_CLICK({$formRemoteConsole.Close()})
                    $formRemoteConsole.Controls.Add($RCPSExec)

                $RCRDP = New-Object System.Windows.Forms.Button
                    $RCRDP.Text = "RDP"
                    $RCRDP.Top = 55
                    $RCRDP.Left = 136
                    $RCRDP.Anchor = "Left,Top"
                    $RCRDP.Size = New-Object System.Drawing.Size(60,20)
                    $RCRDP.ADD_CLICK({mstsc.exe /v:$($RCTextBox.Text) /admin /f})
                    $RCRDP.ADD_CLICK({$formRemoteConsole.Close()})
                    $formRemoteConsole.Controls.Add($RCRDP)
            

                $formRemoteConsole.ShowDialog()
            })
        $mremoteConsole.Size = New-Object System.Drawing.Size(100,25) 
        $MyForm.Controls.Add($mremoteConsole)

    ## Clear Output Box ##
        $mClear = New-Object System.Windows.Forms.Button
            $mClear.Text = "CLEAR"
            $mClear.Top = "226"
            $mClear.Left = "8"
            $mClear.Anchor = "Left,Top"
            $mClear.BackColor = "Gray"
            $mClear.ForeColor = "Black"
            $mClear.Add_Click({$mOutputBox.Text = ""})
        $mClear.Size = New-Object System.Drawing.Size(210,25)
        $MyForm.Controls.Add($mClear)

    ## Save Output Box ##
        $mSave = New-Object System.Windows.Forms.Button
            $mSave.Text = "SAVE"
            $mSave.Top = "226"
            $mSave.Left = "219"
            $mSave.Anchor = "Left,Top"
            $mSave.BackColor = "Gray"
            $mSave.ForeColor = "Black"
            $mSave.Add_Click(
            {
                $saveOutputDialog = New-Object System.Windows.Forms.SaveFileDialog
                $saveOutputDialog.InitialDirectory = "C:\"
                $saveOutputDialog.Filter = "Rich Text Document (*.rtf)|*.rtf"
                $saveOutputDialog.ShowDialog()
                $mOutputBox.Text | Out-File -FilePath $saveOutputDialog.FileName
                output("File saved at $($saveOutputDialog.FileName)")
            })
        $mSave.Size = New-Object System.Drawing.Size(210,25)
        $MyForm.Controls.Add($mSave)

    ## Output box ##
        $mOutputBox = New-Object System.Windows.Forms.RichTextBox
            $mOutputBox.Top = "250"
            $mOutputBox.Left = "8"
            $mOutputBox.Anchor = "Left,Top"
            $mOutputBox.ReadOnly = "True"
            $mOutputBox.DetectUrls = $false
        $mOutputBox.Size = New-Object System.Drawing.Size(420,225)
        $MyForm.Controls.Add($mOutputBox)

    ## Command Line ##
        $mCommandBox = New-Object System.Windows.Forms.TextBox
            $mCommandBox.Top = "480"
            $mCommandBox.Left = "8"
            $mCommandBox.Anchor = "Left,Top"
            $mCommandBox.Size = New-Object System.Drawing.Size(350,25)
            $mCommandBox.Add_Keydown(
            {
                if($_.KeyCode -eq "Enter")
                {
                    $commandOutput = Invoke-Expression $mCommandBox.Text
                    output(">Powershell: $($mCommandBox.Text)")
                    foreach($line in $commandOutput){
                        output("$line")
                    }
                    $mCommandBox.Text = ""
                }
            })
        $MyForm.Controls.Add($mCommandBox)

    ## Enter Command ##
        $mCMDEnter = New-Object System.Windows.Forms.Button
            $mCMDEnter.Text = "CMD"
            $mCMDEnter.Top = "479"
            $mCMDEnter.Left = "360"
            $mCMDEnter.Anchor = "Left,Top"
            $mCMDEnter.Size = New-Object System.Drawing.Size(68,23)
            $mCMDEnter.Add_Click(
            {
                $commandOutput = Invoke-Expression $mCommandBox.Text
                output(">Powershell: $($mCommandBox.Text)")
                foreach($line in $commandOutput){
                    output("$line")
                }
                $mCommandBox.Text = ""
            })
        $MyForm.Controls.Add($mCMDEnter)

### Admin Explorer ###

    $madminExplorer = New-Object System.Windows.Forms.Button 
        $madminExplorer.Text="Admin Explorer" 
        $madminExplorer.Top="226" 
        $madminExplorer.Left="440" 
        $madminExplorer.Anchor="Left,Top" 
        $madminExplorer.BackColor = "Gray"
        $madminExplorer.ForeColor = "Black"
        $madminExplorer.Size
        $madminExplorer.Add_Click(
        {
            output("Entering share drive...")
            $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
                InitialDirectory = $shareDrive 
                Multiselect = $true
            }
            $FileBrowser.ShowDialog()
            if($FileBrowser.FileName -ne $null -and $FileBrowser.FileName -ne "")
            {
                $openFile = [System.Windows.Forms.MessageBox]::Show("Do you want to open $($FileBrowser.SafeFileName)?","Open File?",[System.Windows.Forms.MessageBoxButtons]::YesNo,[System.Windows.Forms.MessageBoxIcon]::Question)
                if($openFile -eq "Yes")
                {
                    output("Opening $($FileBrowser.FileName)...")
                    start $FileBrowser.FileName
                }
                else
                {
                    output("Selected $($FileBrowser.FileName)")
                }
            }
        })
        $madminExplorer.Size = New-Object System.Drawing.Size(206,25) 
        $MyForm.Controls.Add($madminExplorer)

    $mButton1 = New-Object System.Windows.Forms.Button
        $mButton1.Text = $Button1Name
        $mButton1.Top = "260"
        $mButton1.Left = "440"
        $mButton1.Anchor = "Left,Top"
        $mButton1.BackColor = "Gray"
        $mButton1.ForeColor = "Black"
        $mButton1.Add_Click(
        {
            Invoke-Expression $Button1Script
            output($Button1Output)
        })
    $mButton1.Size = New-Object System.Drawing.Size(100,25)
    $MyForm.Controls.Add($mButton1)

    $mButton2 = New-Object System.Windows.Forms.Button
        $mButton2.Text = $Button2Name
        $mButton2.Top = "260"
        $mButton2.Left = "545"
        $mButton2.Anchor = "Left,Top"
        $mButton2.BackColor = "Gray"
        $mButton2.ForeColor = "Black"
        $mButton2.Add_Click(
        {
            Invoke-Expression $Button2Script
            output($Button2Output)
        })
    $mButton2.Size = New-Object System.Drawing.Size(100,25)
    $MyForm.Controls.Add($mButton2)

    $mButton3 = New-Object System.Windows.Forms.Button
        $mButton3.Text = $Button3Name
        $mButton3.Top = "290"
        $mButton3.Left = "440"
        $mButton3.Anchor = "Left,Top"
        $mButton3.BackColor = "Gray"
        $mButton3.ForeColor = "Black"
        $mButton3.Add_Click(
        {
            Invoke-Expression $Button3Script
            output($Button3Output)
        })
    $mButton3.Size = New-Object System.Drawing.Size(100,25)
    $MyForm.Controls.Add($mButton3)

    $mButton4 = New-Object System.Windows.Forms.Button
        $mButton4.Text = $Button4Name
        $mButton4.Top = "290"
        $mButton4.Left = "545"
        $mButton4.Anchor = "Left,Top"
        $mButton4.BackColor = "Gray"
        $mButton4.ForeColor = "Black"
        $mButton4.Add_Click(
        {
            Invoke-Expression $Button4Script
            output($Button4Output)
        })
    $mButton4.Size = New-Object System.Drawing.Size(100,25)
    $MyForm.Controls.Add($mButton4)

    $mButton5 = New-Object System.Windows.Forms.Button
        $mButton5.Text = $Button5Name
        $mButton5.Top = "320"
        $mButton5.Left = "440"
        $mButton5.Anchor = "Left,Top"
        $mButton5.BackColor = "Gray"
        $mButton5.ForeColor = "Black"
        $mButton5.Add_Click(
        {
            Invoke-Expression $Button5Script
            output($Button5Output)
        })
    $mButton5.Size = New-Object System.Drawing.Size(100,25)
    $MyForm.Controls.Add($mButton5)

    $mButton6 = New-Object System.Windows.Forms.Button
        $mButton6.Text = $Button6Name
        $mButton6.Top = "320"
        $mButton6.Left = "545"
        $mButton6.Anchor = "Left,Top"
        $mButton6.BackColor = "Gray"
        $mButton6.ForeColor = "Black"
        $mButton6.Add_Click(
        {
            Invoke-Expression $Button6Script
            output($Button6Output)
        })
    $mButton6.Size = New-Object System.Drawing.Size(100,25)
    $MyForm.Controls.Add($mButton6)

    $mButton7 = New-Object System.Windows.Forms.Button
        $mButton7.Text = $Button7Name
        $mButton7.Top = "350"
        $mButton7.Left = "440"
        $mButton7.Anchor = "Left,Top"
        $mButton7.BackColor = "Gray"
        $mButton7.ForeColor = "Black"
        $mButton7.Add_Click(
        {
            Invoke-Expression $Button7Script
            output($Button7Output)
        })
    $mButton7.Size = New-Object System.Drawing.Size(100,25)
    $MyForm.Controls.Add($mButton7)

    $mButton8 = New-Object System.Windows.Forms.Button
        $mButton8.Text = $Button8Name
        $mButton8.Top = "350"
        $mButton8.Left = "545"
        $mButton8.Anchor = "Left,Top"
        $mButton8.BackColor = "Gray"
        $mButton8.ForeColor = "Black"
        $mButton8.Add_Click(
        {
            Invoke-Expression $Button8Script
            output($Button8Output)
        })
    $mButton8.Size = New-Object System.Drawing.Size(100,25)
    $MyForm.Controls.Add($mButton8)

    $mButton9 = New-Object System.Windows.Forms.Button
        $mButton9.Text = $Button9Name
        $mButton9.Top = "380"
        $mButton9.Left = "440"
        $mButton9.Anchor = "Left,Top"
        $mButton9.BackColor = "Gray"
        $mButton9.ForeColor = "Black"
        $mButton9.Add_Click(
        {
            Invoke-Expression $Button9Script
            output($Button9Output)
        })
    $mButton9.Size = New-Object System.Drawing.Size(100,25)
    $MyForm.Controls.Add($mButton9)

    $mButton10 = New-Object System.Windows.Forms.Button
        $mButton10.Text = $Button10Name
        $mButton10.Top = "380"
        $mButton10.Left = "545"
        $mButton10.Anchor = "Left,Top"
        $mButton10.BackColor = "Gray"
        $mButton10.ForeColor = "Black"
        $mButton10.Add_Click(
        {
            Invoke-Expression $Button10Script
            output($Button10Output)
        })
    $mButton10.Size = New-Object System.Drawing.Size(100,25)
    $MyForm.Controls.Add($mButton10)

    $mButton11 = New-Object System.Windows.Forms.Button
        $mButton11.Text = $Button11Name
        $mButton11.Top = "410"
        $mButton11.Left = "440"
        $mButton11.Anchor = "Left,Top"
        $mButton11.BackColor = "Gray"
        $mButton11.ForeColor = "Black"
        $mButton11.Add_Click(
        {
            Invoke-Expression $Button11Script
            output($Button11Output)
        })
    $mButton11.Size = New-Object System.Drawing.Size(100,25)
    $MyForm.Controls.Add($mButton11)

    $mButton12 = New-Object System.Windows.Forms.Button
        $mButton12.Text = $Button12Name
        $mButton12.Top = "410"
        $mButton12.Left = "545"
        $mButton12.Anchor = "Left,Top"
        $mButton12.BackColor = "Gray"
        $mButton12.ForeColor = "Black"
        $mButton12.Add_Click(
        {
            Invoke-Expression $Button12Script
            output($Button12Output)
        })
    $mButton12.Size = New-Object System.Drawing.Size(100,25)
    $MyForm.Controls.Add($mButton12)

    $mButton13 = New-Object System.Windows.Forms.Button
        $mButton13.Text = $Button13Name
        $mButton13.Top = "440"
        $mButton13.Left = "440"
        $mButton13.Anchor = "Left,Top"
        $mButton13.BackColor = "Gray"
        $mButton13.ForeColor = "Black"
        $mButton13.Add_Click(
        {
            Invoke-Expression $Button13Script
            output($Button13Output)
        })
    $mButton13.Size = New-Object System.Drawing.Size(100,25)
    $MyForm.Controls.Add($mButton13)

    $mButton14 = New-Object System.Windows.Forms.Button
        $mButton14.Text = $Button14Name
        $mButton14.Top = "440"
        $mButton14.Left = "545"
        $mButton14.Anchor = "Left,Top"
        $mButton14.BackColor = "Gray"
        $mButton14.ForeColor = "Black"
        $mButton14.Add_Click(
        {
            Invoke-Expression $Button14Script
            output($Button14Output)
        })
    $mButton14.Size = New-Object System.Drawing.Size(100,25)
    $MyForm.Controls.Add($mButton14)

    $mButton15 = New-Object System.Windows.Forms.Button
        $mButton15.Text = $Button15Name
        $mButton15.Top = "260"
        $mButton15.Left = "440"
        $mButton15.Anchor = "Left,Top"
        $mButton15.BackColor = "Gray"
        $mButton15.ForeColor = "Black"
        $mButton15.Add_Click(
        {
            Invoke-Expression $Button15Script
            output($Button15Output)
        })
    $mButton15.Size = New-Object System.Drawing.Size(100,25)
    $MyForm.Controls.Add($mButton15)

    $mButton16 = New-Object System.Windows.Forms.Button
        $mButton16.Text = $Button16Name
        $mButton16.Top = "260"
        $mButton16.Left = "440"
        $mButton16.Anchor = "Left,Top"
        $mButton16.BackColor = "Gray"
        $mButton16.ForeColor = "Black"
        $mButton16.Add_Click(
        {
            Invoke-Expression $Button16Script
            output($Button16Output)
        })
    $mButton16.Size = New-Object System.Drawing.Size(100,25)
    $MyForm.Controls.Add($mButton16)

### Draw Form ###
    $mOutputBox.Text = ""
    $MyForm.ShowDialog()
