$voice=$true

Add-Type -AssemblyName PresentationCore,PresentationFramework

$voiceNotification=
{
    param ($type,$user,$shift,$days)
    switch ( $type )
    {
        "0"
        {
            Function Speak-Text($Text) { Add-Type -AssemblyName System.speech; $TTS = New-Object System.Speech.Synthesis.SpeechSynthesizer; $TTS.Speak($Text) }
            Speak-Text "Hello $user . Detected shift . $shift . $days days left until payday . , . , . Good luck!"
        }

        "1"
        {
            Function Speak-Text($Text) { Add-Type -AssemblyName System.speech; $TTS = New-Object System.Speech.Synthesis.SpeechSynthesizer; $TTS.Speak($Text) }
            Speak-Text "Your shift will be over soon."
        }
        Default
        {
            Function Speak-Text($Text) { Add-Type -AssemblyName System.speech; $TTS = New-Object System.Speech.Synthesis.SpeechSynthesizer; $TTS.Speak($Text) }
            Speak-Text "Error! $type,$user,$shift,$days"
        }
    }
}
function checkShift()
{
    $date = Get-Date
    if(($date.Hour -ge "5") -and ($date.Hour -le "12"))
    {
        return "morning shift"
    }
    elseif(($date.Hour -ge "13") -and ($date.Hour -le "20"))
    {
        return "afternoon shift"
    }
    elseif((($date.Hour -ge "21") -and ($date.Hour -le "23")) -or (($date.Hour -ge "0") -and ($date.Hour -le "4")))
    {
        return "night shift"
    }
    else
    {
        return "outside working hours"
    }
}
function checkDay()
{
    $date = Get-Date
    if($date.Day -ge "09")
    {
        $date = $date.AddMonths(1)
    }

    $MM = $date.Month
    $yy = $date.Year

    $day = [math]::Ceiling((([DateTime]"$mm-09-$yy")-(Get-Date)).TotalDays)
    return $day
}

function checkTime()
{
    param ($shift)

    $time = Get-Date -Format HH:mm:ss
    switch ( $shift )
    {
        "morning shift"
        {
            $alertTime = [datetime]"13:45:00"
        }
        "afternoon shift"
        {
            $alertTime = [datetime]"21:45:00"
        }
        "night shift"
        {
            $alertTime = [datetime]"5:45:00"
        }
        "outside working hours"
        {
            return 0
        }
    }
    $output = (New-TimeSpan -Start $time -End $alertTime).TotalSeconds
    if( $output -lt 0 )
    {
        $output = 86400 + $output
    }
    Write-Host "$($output)s"
    return $output
}
function alert()
{
    param ($type)
    switch ( $type )
    {
        0
        {
            $ButtonType = [System.Windows.MessageBoxButton]::YesNo
            $MessageIcon = [System.Windows.MessageBoxImage]::Information
            $MessageBody = "Do you want to open website?"
            $MessageTitle = "Open website?"
            $result = [System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
            switch ( $result )
            {
                "Yes"
                {
                    [system.Diagnostics.Process]::Start("chrome","https://example.si/te")
                }
                "No"
                {
                }
                Default
                {
                }
            }
        }
