
$FbxApi = Invoke-RestMethod -Uri http://mafreebox.freebox.fr/api_version

# Déclarer l'application            
$AuthJson = @'
{
   "app_id": "fr.freebox.testapp",
   "app_name": "Test App",
   "app_version": "1.0.0",
   "device_name": "Mon PC"
}
'@            
            
$BaseURL = "http://mafreebox.freebox.fr$($FbxApi.api_base_url)v$([int]$FbxApi.api_version)"            
            
# Demander l'autorisation            
$post = Invoke-RestMethod -Uri "$BaseURL/login/authorize" -Method Post -Body $AuthJson

$statusToken = Invoke-RestMethod -Uri "$BaseURL/login/authorize/$($post.result.track_id)"            
# Requete GET pour interroger le statut            
while ($statusToken.result.status -eq "pending") {            
 $statusToken = Invoke-RestMethod -Uri "$BaseURL/login/authorize/$($post.result.track_id)"            
 Start-Sleep -Seconds 1            
}            
            
if ($statusToken.result.status -eq "granted") {            
    "Bravo, application autorisée"            
    "le app_token secret à conserver est: {0}" -f $post.result.app_token            
} else {            
    "Echec: résultat du processus d'autorisation: {0}" -f $statusToken.result.status            
}   