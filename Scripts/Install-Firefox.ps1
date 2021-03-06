﻿[CmdletBinding()]
Param
    ( 
    [string]$Destination = $(Join-Path  $env:USERPROFILE "downloads\"),
    [switch] $Uninstall = $false 
    )

if (-not $Uninstall)
{
$dl=$Destination;

$ini= @'
[Install]
QuickLaunchShortcut=false
DesktopShortcut=false
'@

$prefs = @'
//comment
pref("browser.shell.checkDefaultBrowser", false); 
//defaultPref("startup.homepage_welcome_url", "");
pref("browser.startup.homepage_override.mstone","49.0.2");
pref("browser.usedOnWindows10",true);
pref("brfowser.disableResetPrompt", true);  //To remove the prompt of: "previous install detected, click here to refresh and remove addon from your profile"
defaultPref("browser.tabs.remote.force-enable", true);

defaultPref("browser.startup.homepage", "data:text/plain,browser.startup.homepage=http://www.afiexpertise.com/fr/");
//defaultPref("general.useragent.locale", "fr");
defaultPref("intl.locale.matchOS", true);
defaultPref("toolkit.telemetry.prompted", 2);
defaultPref("toolkit.telemetry.rejected", true);
defaultPref("toolkit.telemetry.enabled", false);
pref("datareporting.healthreport.service.enabled", false);
pref("datareporting.healthreport.uploadEnabled", false);
pref("datareporting.healthreport.service.firstRun", false);
defaultPref("datareporting.healthreport.logging.consoleEnabled", false);
defaultPref("datareporting.policy.dataSubmissionEnabled", false);
defaultPref("datareporting.policy.dataSubmissionPolicyResponseType", "accepted-info-bar-dismissed");
defaultPref("datareporting.policy.dataSubmissionPolicyAccepted", false);


'@


$override= @'
[XRE]
EnableProfileMigrator=false

'@


$fr="https://addons.mozilla.org/firefox/downloads/latest/417178/addon-417178-latest.xpi"
$fireLink = "https://download.mozilla.org/?product=firefox-latest&os=win&lang=en-US"

$wc = new-object System.Net.WebClient ;
$wc.DownloadFile($fr, $dl + "fr_language.xpi") ;
$wc.DownloadFile($fireLink, $dl + "firefox_Setup.exe");
$wc.Dispose();  

Set-Content (Join-Path $dl "firefox.ini") $ini

&  (Join-Path $dl "firefox_setup.exe") -ms /ini=(Join-Path $dl "firefox.ini")  | out-null


md "c:\program files (x86)\mozilla firefox\browser\defaults\preferences"

Set-Content "c:\program files (x86)\mozilla firefox\browser\defaults\preferences\all-afi.js" $prefs
Set-Content "c:\program files (x86)\mozilla firefox\browser\override.ini" $override

md "c:\program files (x86)\mozilla firefox\distribution\extensions"
copy (Join-Path $dl fr_language.xpi ) ("c:\program files (x86)\mozilla firefox\distribution\extensions\langpack-fr@firefox.mozilla.org.xpi")
}

else {  ## $Uninstall
     & "C:\Program Files (x86)\Mozilla Firefox\uninstall\helper.exe" /silent | Out-Null
    rd  (Join-Path  $env:APPDATA "\..\local\mozilla") -Recurse -Force
    rd  (Join-Path  $env:APPDATA "\mozilla") -Recurse -Force
    rd "c:\program files (x86)\mozilla firefox"  -Recurse -Force
}

 