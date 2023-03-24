# Demander � l'utilisateur les informations n�cessaires pour cr�er l'�tendue DHCP
$nomEtendue = Read-Host "Entrez le nom de l'�tendue DHCP"
$adresseReseau = Read-Host "Entrez l'adresse r�seau de l'�tendue DHCP"
$masqueSousReseau = Read-Host "Entrez le masque sous-r�seau de l'�tendue"
$premiereAdresse = Read-Host "Entrez la premi�re adresse � distribuer"
$derniereAdresse = Read-Host "Entrez la derni�re adresse � distribuer"
$adressePasserelle = Read-Host "Entrez l'adresse de passerelle � diffuser"
$adresseDNS = Read-Host "Entrez l'adresse du serveur de domaine"
$nomDomaine = Read-Host "Enter le nom du domaine"

# Afficher les informations de l'�tendue DHCP � cr�er
Write-Host "Vous �tes sur le point de cr�er l'�tendue DHCP suivante :"
Write-Host "Nom : $nomEtendue"
Write-Host "Adresse r�seau : $adresseReseau"
Write-Host "Masque sous-r�seau : $masqueSousReseau"
Write-Host "Premi�re adresse � distribuer : $premiereAdresse"
Write-Host "Derni�re adresse � distribuer : $derniereAdresse"
Write-Host "Adresse de passerelle : $adressePasserelle"
Write-Host "le Nom de Domaine : $adresseDNS"
Write-Host "l'adresse IP du serveur de domaine : $nomDomaine"

# Demander � l'utilisateur de confirmer la cr�ation de l'�tendue DHCP
$confirmation = Read-Host "Voulez-vous vraiment cr�er cette �tendue DHCP ? (Oui/Non)"
if ($confirmation -ne "Oui") {
    Write-Host "Op�ration annul�e."
    exit
}

# Cr�er l'�tendue DHCP en utilisant les informations fournies par l'utilisateur
Add-DhcpServerv4Scope -Name $nomEtendue -StartRange $premiereAdresse -EndRange $derniereAdresse -SubnetMask $masqueSousReseau -Description "Etendue DHCP cr��e par script PowerShell" -LeaseDuration 8.00:00:00 -State Active

Set-DhcpServerv4OptionValue -ScopeId $adresseReseau -Router $adressePasserelle -DnsServer $adresseDNS -DnsDomain $nomDomaine

Get-DhcpServerv4Scope | Where-Object { $_.ScopeId -eq $adresseReseau } | Format-Table -AutoSize
