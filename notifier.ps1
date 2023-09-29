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
