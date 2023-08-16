$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8';
function selectFromDB($loginAD)
{
    $OU = "DC=DOMAIN_NAME,DC=en";
    $resultAD = Get-ADUser -Properties * -Filter {SAMAccountName -eq $loginAD} -SearchBase $OU | 
        select cn,sAMAccountName, mail, enabled, company, personalTitle, department,manager,extensionAttribute6, mobile, MobilePhone, 
            msExchWhenMailboxCreated, City, createTimeStamp, LastLogonDate, LastBadPasswordAttempt, Office, OfficePhone, telephoneNumber, 
            PasswordExpired, PasswordLastSet

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
    $tsMailbox = $resultAD.msExchWhenMailboxCreated;
    $city = $resultAD.City;
    $tsADA = $resultAD.createTimeStamp;
    $lastLogon = $resultAD.LastLogonDate;
    $lastBadPass = $resultAD.LastBadPasswordAttempt;
    $office = $resultAD.Office;
    $phone = $resultAD.OfficePhone;
    $phone2 = $resultAD.telephoneNumber;
    $expired = $resultAD.PasswordExpired;
    $lastSet = $resultAD.PasswordLastSet;

    if($Enabled -eq $True) {
            $Enabled = "Yes";
        } elseif($Enabled -eq $False) {
            $Enabled = "No";
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
    for($i = 0; $i -lt $countStars; $i++)
    {
        $stars = $stars+'*';
    }

    $extensionAttribute6 = $stars+$extensionAttribute6;
    }

    write-output * | Select-Object -Property @{
        label='Name displayed'
        expression={$cn}
      },@{
        label='Login'
        expression={$sAMAccountName}
      },@{
        label='E-mail adress'
        expression={$mail}
      },@{
        label='Account active'
        expression={$enabled}
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
        label = 'Account creation date'
        expression = {$tsADA}
      },@{
        label = 'Mailbox creation date'
        expression = {$tsMailbox}
      },@{
        label = 'Last Logon'
        expression = {$lastLogon}
      },@{
        label = 'Last failed authentication'
        expression = {$lastBadPass}
      },@{
        label = 'Has password expired?'
        expression = {$expired}
      },@{
        label = 'Last password change'
        expression = {$lastSet}
      } | Format-List 

      #Write-Output $resultAD
}

DO {
    cls
    $loginAD = Read-Host -Prompt 'Enter the user login';
    selectFromDB -loginAD $loginAD;
    $key = Read-Host -Prompt 'Do you want to search for the user again [Y/N]'
} While ($key -eq 'Y')
