# Demander à l'utilisateur les informations nécessaires pour créer l'étendue DHCP
$nomEtendue = Read-Host "Entrez le nom de l'étendue DHCP"
$adresseReseau = Read-Host "Entrez l'adresse réseau de l'étendue DHCP"
$masqueSousReseau = Read-Host "Entrez le masque sous-réseau de l'étendue"
$premiereAdresse = Read-Host "Entrez la première adresse à distribuer"
$derniereAdresse = Read-Host "Entrez la dernière adresse à distribuer"
$adressePasserelle = Read-Host "Entrez l'adresse de passerelle à diffuser"

# Créer l'étendue DHCP en utilisant les informations fournies par l'utilisateur
Add-DhcpServerv4Scope -Name $nomEtendue -StartRange $premiereAdresse -EndRange $derniereAdresse -SubnetMask $masqueSousReseau -Description "Etendue DHCP créée par script PowerShell" -LeaseDuration 8.00:00:00 -State Active

Set-DhcpServerv4OptionValue -ScopeId $adresseReseau -Router $adressePasserelle

Get-DhcpServerv4Scope | Where-Object { $_.ScopeId -eq $adresseReseau } | Format-Table -AutoSize