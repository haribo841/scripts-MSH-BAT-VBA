$SaveSearchHistory=$true #$true or $false
$file="SearchHistory.txt" #file name
$debug=$false

[console]::WindowWidth=100; 
[console]::WindowHeight=40;
[console]::BufferWidth=[console]::WindowWidth

$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8';
$option = 'b'

function chceckLastSearch()
{
    param ($option)
    if($option -eq "init")
    {
        $returnArray = @()
        if([System.IO.File]::Exists($file))
        {
            $returnArray += (Get-Content -Path $file -Tail 1).substring(17) 
            $returnArray += (Get-Content -Path $file -Tail 2 | Select -First 1).substring(17) 
            return ,$returnArray
        }
        else
        {
            $loginAD = [Environment]::UserName
            $returnArray += $loginAD
            $returnArray += "empty search"
            return ,$returnArray
        }
    }
    else
    {
        if([System.IO.File]::Exists($file))
        {
            $lastSearch = (Get-Content -Path $file -Tail 2 | Select -First 1).substring(17) 
            return $lastSearch
        }
        else
        {
            $lastSearch="empty search"
            return $lastSearch
        }
    }
}
function selectFromDB()
{
    param ($loginAD)
    $loginAD = $loginAD.ToString()
    $resultAD = Get-ADUser -Properties * -Filter {SAMAccountName -eq $loginAD} | 
        select cn,sAMAccountName, mail, enabled, company, personalTitle, department,manager,extensionAttribute6, mobile, MobilePhone, 
            msExchWhenMailboxCreated, City, createTimeStamp, LastLogonDate, LastBadPasswordAttempt, Office, OfficePhone, telephoneNumber, 
            PasswordExpired, PasswordLastSet, msExchMailboxAuditEnable, msExchMailboxAuditLastAdminAccess, msExchMailboxAuditLastDelegateAccess

    $cn = $resultAD.cn;
    $sAMAccountName = $resultAD.sAMAccountName;
    $mail = $resultAD.mail;
    $enabled = $resultAD.Enabled;
    $company = $resultAD.company;
    $personalTitle = $resultAD.personalTitle;
    $department = $resultAD.department;
    $manager = $resultAD.manager;
    $extensionAttribute6 = $resultAD.extensionAttribute6;
    $mobile = $resultAD.mobile;
    $mobile2 = $resultAD.MobilePhone;
    $tsPoczta = $resultAD.msExchWhenMailboxCreated;
    $city = $resultAD.City;
    $tsADA = $resultAD.createTimeStamp;
    $lastLogon = $resultAD.LastLogonDate;
    $lastBadPass = $resultAD.LastBadPasswordAttempt;
    $office = $resultAD.Office;
    $phone = $resultAD.OfficePhone;
    $phone2 = $resultAD.telephoneNumber;
    $expired = $resultAD.PasswordExpired;
    $lastSet = $resultAD.PasswordLastSet;
    $msexchaudit = $resultAD.msExchMailboxAuditEnable
    $msexchauditAccAdmi = $resultAD.msExchMailboxAuditLastAdminAccess
    $msexchauditAccDele = $resultAD.msExchMailboxAuditLastDelegateAccess

     if($Enabled -eq $True) {
        $Enabled = "Yes";
        $Alert1 = "";
    } elseif($Enabled -eq $False) {
        $Enabled = "No";
        $Alert1 = "                                                [!]";
    }

    if($expired -eq $True) {
        $expired = "Yes";
        $Alert2 = "                                                [!]";
    } elseif($expired -eq $False) {
        $expired = "No";
        $Alert2 = "";
    }

    if($msexchaudit -eq $True) {
        $msexchaudit = "Yes";
    } elseif($msexchaudit -eq $False) {
        $msexchaudit = "No";
    }

    $stars = '';
    $managerLength = $manager.Length;
    
    if($managerLength -eq 0) {
        $manager = "";
    } else {
        $managerSplit = $manager.Split(',');
        $managerReplace = $managerSplit[0];
        $manager = $managerReplace -replace "CN=","";
    }

    $lengthExtensionAttribute6 = $extensionAttribute6.Length;

    if($lengthExtensionAttribute6 -eq 0) {
        $extensionAttribute6 = '';
    } else {
        $countStars = 11 - $lengthExtensionAttribute6
        for($i = 0; $i -lt $countStars; $i++) {
            $stars = $stars+'*';
        }
        $extensionAttribute6 = $stars+$extensionAttribute6;
    }

    write-output * | Select-Object -Property @{ #THERE IS SOMETHING BREAKING THE FORMATTING, MAYBE WRITE_OUTS
        label='Name displayed'
        expression={$cn}
      },@{
        label='Login'
        expression={$sAMAccountName}
      },@{
        label='E-mail adress'
        expression={$mail}
      },@{
        label='Company'
        expression={$company}
      },@{
        label='Department'
        expression={$department}
      },@{
        label='Position'
        expression={$personalTitle}
      },@{
        label='Supervisor'
        expression={$manager}
      },@{
        label='PESEL'
        expression={$extensionAttribute6}
      },@{
        label='City'
        expression={$city}
      },@{
        label = 'Location'
        expression = {$office}
      },@{
        label = 'Mobile no.'
        expression = {$mobile}
      },@{
        label = 'Mobile no. 2'
        expression = {$mobile2} 
      },@{
        label = 'Offices no.'
        expression = {$phone}
      },@{
        label = 'Offices no. 2'
        expression = {$phone2}
      },@{
        label='Account active?'
        expression={$enabled+$Alert1}
      },@{
        label = 'Has password expired?'
        expression = {$expired+$Alert2}
      },@{        
        label = 'Account creation date'
        expression = {$tsADA}
      },@{
        label = 'Mailbox creation date'
        expression = {$tsPoczta}
	  },@{
        label = 'Last Logon'
        expression = {$lastLogon}
      },@{
        label = 'Last failed authentication'
        expression = {$lastBadPass}
      },@{
        label = 'Last password change'
        expression = {$lastSet}
      },@{
        label = 'MS Exch Audit?'
        expression = {$msexchaudit}
      },@{
        label = 'Administrators last access to mail'
        expression = {$msexchauditAccAdmi}
      },@{
        label = 'Proxys last access to mail'
        expression = {$msexchauditAccDele}
      }
}

function isUserExist
{
    param ($loginAD)
    try
    {
        Get-ADUser -Identity $loginAD -ErrorAction Stop | Out-Null
        return $true;
    }
    catch 
    {
        return $false;
    }
}

function checkUserExist #total spghetti 
{
    param ($loginAD)

    if(isUserExist $loginAD)
    {
        return $loginAD
    }
    else
    {
        if($loginAD -like '*?.?*')
        {   
            if ($loginAD.Length -gt 2)
            {
                $loginTemp = $loginAD.Split(".")
                $newLoginToChck = $loginTemp[1] + '.' + $loginTemp[0]
                $didyou = Read-Host -Prompt "`nCannot find user. Did you mean '$($newLoginToChck)'? [Y/n] (default=Y)"; 
                $didyou = ('y',$didyou)[[bool]$didyou]
                if($didyou -eq 'y')
                {
                    #check the reversed order
                    if(isUserExist $newLoginToChck)
                    {
                        return $newLoginToChck;
                    }
                    else
                    {
                        $loginTemp=$newLoginToChck.Split(".")
                    }
                }
                else #do not check the reversed order
                {
                    $loginTemp=$loginAD.Split(".")
                }
            }
            else
            {
                $loginTemp=$loginAD.Split(".")
            }
        }
        else
        {
            $loginTemp=$loginAD
        }

        function isUserExist
{
    param ($loginAD)
    try
    {
        Get-ADUser -Identity $loginAD -ErrorAction Stop | Out-Null
        return $true;
    }
    catch 
    {
        return $false;
    }
}

function checkUserExist #total spghetti 
{
    param ($loginAD)

    if(isUserExist $loginAD)
    {
        return $loginAD
    }
    else
    {
        if($loginAD -like '*?.?*')
        {   
            if ($loginAD.Length -gt 2)
            {
                $loginTemp = $loginAD.Split(".")
                $newLoginToChck = $loginTemp[1] + '.' + $loginTemp[0]
                $didyou = Read-Host -Prompt "`nCannot find user. Did you mean '$($newLoginToChck)'? [Y/n] (default=Y)"; 
                $didyou = ('y',$didyou)[[bool]$didyou]
                if($didyou -eq 'y')
                {
                    # Check the reversed order
                    if(isUserExist $newLoginToChck)
                    {
                        return $newLoginToChck;
                    }
                    else
                    {
                        $loginTemp=$newLoginToChck.Split(".")
                    }
                }
                else # Do not check the reversed order
                {
                    $loginTemp=$loginAD.Split(".")
                }
            }
            else
            {
                $loginTemp=$loginAD.Split(".")
            }
        }
        else
        {
            $loginTemp=$loginAD
        }

##### D E B U G #####
        if($debug){ Write-Host "" }
        if($debug){ Write-Host "[DEBUG] loginTemp::$loginTemp" }
        if($debug){ Write-Host "[DEBUG] loginTemp.GetType::$($loginTemp.GetType())" }

        # Searching for similar
        while($true)
        {  
            # Query with a space
            if($loginAD -like '*? ?*')
            {   
                if ($loginAD.Length -gt 2)
                {
                    $loginTemp = $loginAD.Split(" ")
                    $printLoginTemp=$loginAD
                }
            }

            if( -not $debug){ cls }
            if($loginAD -like '*? ?*')
            {   
                if ($loginAD.Length -gt 2)
                {
                    $loginTemp = $loginAD.Split(" ")
                    $printLoginTemp=$loginAD
                }
            }
            elseif($loginTemp.GetType() -eq [string[]])
            {
                $printLoginTemp = "$($loginTemp[0]).$($loginTemp[1])"
            }
            else
            {
                $printLoginTemp = "$loginTemp"
            }
            
            Write-Host "`nUser '$printLoginTemp' cannot be found, below users with similar names:`n`n----------------------------------------------------------------------------------------------------"
            Write-Host "`nThe database processes the query..."

              #looking for similar ones
            try
            {    
                #e.g. john doe
                if ($loginTemp.GetType() -eq [string[]])
                {            
                    $searchResult = Get-ADUser -Properties SamAccountName -Filter "SAMAccountName -like '*$($loginTemp[1])*' -or SAMAccountName -like '*$($loginTemp[0])*'" | sort SamAccountName
                }
                elseif ($loginTemp.GetType() -eq [string])
                {
                    $searchResult = Get-ADUser -Properties SamAccountName -Filter "SAMAccountName -like '*$($loginTemp)*'" | sort SamAccountName
                }

            }
            catch
            {

                $searchResult=$null

            }

            #listing similar
            if( -not $debug){ cls }
            Write-Host "`nUser '$printLoginTemp' cannot be found, below users with similar names:`n`n----------------------------------------------------------------------------------------------------"
            try
            {
       #         if (!($searchResult.SAMAccountName.GetType() -eq [System.Object[]]))
       #         {
       #             Write-Host "`n$($searchResult.SamAccountName)"
       #         }
       #         else
       #         {
                     #$size = $searchResult.Length
                
                # A faster printing version 
                $toDisplay=$searchResult.SAMAccountName | Format-Wide -force -prop {$_} -Column 4 | Out-String # | % {Write-Host $_};
                $toDisplay=$toDisplay.substring(2)
                $toDisplay=$toDisplay.substring(0,$toDisplay.Length-3)
                Write-Host $toDisplay