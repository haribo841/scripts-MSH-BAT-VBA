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
        label='Unit'
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
        label = 'Nr tel. kom.'
        expression = {$mobile}
      },@{
        label = 'Nr tel. kom. 2'
        expression = {$mobile2} 
      },@{
        label = 'Nr tel. biur.'
        expression = {$phone}
      },@{
        label = 'Nr tel. biur. 2'
        expression = {$phone2}
      },@{
        label = 'Data utworzenia konta'
        expression = {$tsADA}
      },@{
        label = 'Data utworzenia skrzynki'
        expression = {$tsPoczta}
      },@{
        label = 'Ostatnie logowanie'
        expression = {$lastLogon}
      },@{
        label = 'Ostatnie niepomyślne uwierzytelnianie'
        expression = {$lastBadPass}
      },@{
        label = 'Czy hasło wygasło?'
        expression = {$expired}
      },@{
        label = 'Ostatnia zmiana hasła'
        expression = {$lastSet}
      } | Format-List 

      #Write-Output $resultAD
}

DO {
    cls
    $loginAD = Read-Host -Prompt 'Podaj login użytkownika';
    selectFromDB -loginAD $loginAD;
    $key = Read-Host -Prompt 'Czy chcesz wyszukać ponownie użytkownika [T/N]'
} While ($key -eq 'T')
