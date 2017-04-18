$AppToken= 'yourToken'            
$Challenge = (Invoke-RestMethod -Uri "$BaseURL/login").result.challenge            
            
# password = hmac-sha1(app_token, challenge)            
# http://leftshore.wordpress.com/2010/10/04/hmac-sha1-using-powershell/            
$hmacsha = New-Object System.Security.Cryptography.HMACSHA1            
$hmacsha.key = [Text.Encoding]::ASCII.GetBytes($AppToken)            
$signature = $hmacsha.ComputeHash([Text.Encoding]::ASCII.GetBytes($Challenge))            
$password = [string]::join("", ($signature | % {([int]$_).toString('x2')}))            
            
$SessionJson = @"
{
   `"app_id`": `"fr.freebox.testapp`",
   `"password`": `"$($password)`"
}
"@            
            
$session = Invoke-RestMethod -Uri "$BaseURL/login/session/" -Method Post -Body $SessionJson            
            
'ouverture de la session avec succes: {0}' -f $session.success             
#'le session_token est: {0}' -f $session.result.session_token            
## Afficher les permissions            
#$session.result.permissions

$Header = @{'X-Fbx-App-Auth' = $($session.result.session_token)}            
# Afficher le journal d'appel            
#(Invoke-RestMethod -Uri "$BaseURL/call/log/" -Headers $Header).result | ft -AutoSize
$FreeboxVideao = (Invoke-RestMethod -Uri "$BaseURL/fs/ls/L0Rpc3F1ZSBkdXIvVmlkw6lvcw==" -Headers $Header).result.Name | ft -AutoSize

$telechargementItems = Get-ChildItem C:\Users\isabe\Downloads -Recurse | Select-Object Name

ForEach($item in $telechargementItems)  {
    if ($FreeboxVideao -contains $item) {
        ($item.Name)
    }
}