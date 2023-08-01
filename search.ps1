$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8';
function selectFromDB($loginAD)
{
    $OU = "DC=enea,DC=pl";
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
            $Enabled = "Tak";
        } elseif($Enabled -eq $False) {
            $Enabled = "Nie";
        }

    $stars = '';

    $managerLength = $manager.Length;
    if($managerLength -eq 0) {
        
        $manager = "";

    } else {

        $managerSplit = $manager.Split(',');
        $managerReplace = $managerSplit[0];
