
# Delete multiple spaces from Confluence Cloud
# The deletion takes time, so you won't see the effect right away. Be patient
# ACTION: set the $limit to restrict how many Spaces the script deletes per run
# ACTION: set the 'if conditions' on ine 37 to determine which spaces to delete
# ACTION: uncomment line 35 to export the space details to a CSV

##############################
# Limit nr of spaces         #
##############################
$limit = 10

##############################
#  Authentication settings   #
##############################

$pair = "john.smith@domain.com:y0urt0k3n"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"
$header = @{
        "authorization" = $basicAuthValue;
        "X-Atlassian-Token" = "nocheck"
    }
$baseURL = "https://yourdomain.atlassian.net"

##############################
#  Delete function           #
##############################

function Delete-Spaces {
    $url = "$baseURL/wiki/rest/api/space?limit=$limit"
    $json = Invoke-RestMethod -Uri $url -Headers $header 
    $spaces = $json.results 
    #$spaces | Export-csv "cloud-spaces.csv" -encoding "UTF8" -NoTypeInformation  
    Foreach($i in $spaces) {
        if($i.type -eq "personal") {
            $spaceKey = $i.key
            $spaceName = $i.name
            $deleteUrl = "$baseURL/wiki/rest/api/space/$spaceKey"
            Write-Host("Deleting space $spaceName")
            Invoke-RestMethod -Uri $deleteUrl -Headers $header -Method 'DELETE'
        }  
    }
}

Delete-Spaces
