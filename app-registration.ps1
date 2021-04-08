$org = "brk"
$env = "dev"
$appDisplayName = "chbot-$($org)-$($env)"

# Generate a new client secret
$password = (head /dev/urandom | tr -dc [:alnum:] | fold -w 30 | head -n 1)

$appId = ( 
  az ad app create --display-name $appDisplayName `
  --password $password  `
  --available-to-other-tenants `
  --query 'appId' -o tsv
)

Write-Output $appId
Write-Output $password
Write-Output $appDisplayName+$org
Write-Output '{ "chatbotWebAppSecret": { "value": "$($password)" } }'
Write-Output "{ \"appId\": { \"value\": \"$($appId)\" } }" 
Write-Output "{ \"org\": { \"value\": \"$($org)\" } }" 
Write-Output "{ \"enviorment\": { \"value\": \"$($env)\" } }"
  
# az deployment group create --resource-group chbot-intevolution-test --name deploy-de-infraestructura `
#   --template-file template.json  `
#   --parameters parameters.json `
#   --parameters "{ \"chatbotWebAppSecret\": { \"value\": \"$($password)\" } }" `
#   --parameters "{ \"appId\": { \"value\": \"$($appId)\" } }" `
#   --parameters "{ \"org\": { \"value\": \"$($org)\" } }" `
#   --parameters "{ \"enviorment\": { \"value\": \"$($env)\" } }"