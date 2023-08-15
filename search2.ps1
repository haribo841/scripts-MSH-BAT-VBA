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