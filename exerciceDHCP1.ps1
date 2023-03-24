# Demander � l'utilisateur les informations n�cessaires pour cr�er l'�tendue DHCP
$nomEtendue = Read-Host "Entrez le nom de l'�tendue DHCP"
$adresseReseau = Read-Host "Entrez l'adresse r�seau de l'�tendue DHCP"
$masqueSousReseau = Read-Host "Entrez le masque sous-r�seau de l'�tendue"
$premiereAdresse = Read-Host "Entrez la premi�re adresse � distribuer"
$derniereAdresse = Read-Host "Entrez la derni�re adresse � distribuer"
$adressePasserelle = Read-Host "Entrez l'adresse de passerelle � diffuser"

# Cr�er l'�tendue DHCP en utilisant les informations fournies par l'utilisateur
Add-DhcpServerv4Scope -Name $nomEtendue -StartRange $premiereAdresse -EndRange $derniereAdresse -SubnetMask $masqueSousReseau -Description "Etendue DHCP cr��e par script PowerShell" -LeaseDuration 8.00:00:00 -State Active

Set-DhcpServerv4OptionValue -ScopeId $adresseReseau -Router $adressePasserelle

Get-DhcpServerv4Scope | Where-Object { $_.ScopeId -eq $adresseReseau } | Format-Table -AutoSize