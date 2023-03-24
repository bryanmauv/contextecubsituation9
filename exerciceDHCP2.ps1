# Demander à l'utilisateur les informations nécessaires pour créer l'étendue DHCP
$nomEtendue = Read-Host "Entrez le nom de l'étendue DHCP"
$adresseReseau = Read-Host "Entrez l'adresse réseau de l'étendue DHCP"
$masqueSousReseau = Read-Host "Entrez le masque sous-réseau de l'étendue"
$premiereAdresse = Read-Host "Entrez la première adresse à distribuer"
$derniereAdresse = Read-Host "Entrez la dernière adresse à distribuer"
$adressePasserelle = Read-Host "Entrez l'adresse de passerelle à diffuser"
$adresseDNS = Read-Host "Entrez l'adresse du serveur de domaine"
$nomDomaine = Read-Host "Enter le nom du domaine"

# Afficher les informations de l'étendue DHCP à créer
Write-Host "Vous êtes sur le point de créer l'étendue DHCP suivante :"
Write-Host "Nom : $nomEtendue"
Write-Host "Adresse réseau : $adresseReseau"
Write-Host "Masque sous-réseau : $masqueSousReseau"
Write-Host "Première adresse à distribuer : $premiereAdresse"
Write-Host "Dernière adresse à distribuer : $derniereAdresse"
Write-Host "Adresse de passerelle : $adressePasserelle"
Write-Host "le Nom de Domaine : $adresseDNS"
Write-Host "l'adresse IP du serveur de domaine : $nomDomaine"

# Demander à l'utilisateur de confirmer la création de l'étendue DHCP
$confirmation = Read-Host "Voulez-vous vraiment créer cette étendue DHCP ? (Oui/Non)"
if ($confirmation -ne "Oui") {
    Write-Host "Opération annulée."
    exit
}

# Créer l'étendue DHCP en utilisant les informations fournies par l'utilisateur
Add-DhcpServerv4Scope -Name $nomEtendue -StartRange $premiereAdresse -EndRange $derniereAdresse -SubnetMask $masqueSousReseau -Description "Etendue DHCP créée par script PowerShell" -LeaseDuration 8.00:00:00 -State Active

Set-DhcpServerv4OptionValue -ScopeId $adresseReseau -Router $adressePasserelle -DnsServer $adresseDNS -DnsDomain $nomDomaine

Get-DhcpServerv4Scope | Where-Object { $_.ScopeId -eq $adresseReseau } | Format-Table -AutoSize
