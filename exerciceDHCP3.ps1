[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')


# Demander � l'utilisateur les informations n�cessaires pour cr�er l'�tendue DHCP
$nomEtendue = [Microsoft.VisualBasic.Interaction]::InputBox("nom de l'�tendue DHCP","Entrez le nom de l'�tendue DHCP","")
$adresseReseau = [Microsoft.VisualBasic.Interaction]::InputBox("Adresse r�seau de l'�tendue DHCP","Entrez l'adresse r�seau de l'�tendue DHCP","")
$masqueSousReseau = [Microsoft.VisualBasic.Interaction]::InputBox("Masque de sous-r�seau de l'�tendue DHCP","Entrez le masque de sous-r�seau de l'�tendue DHCP","")
$premiereAdresse = [Microsoft.VisualBasic.Interaction]::InputBox("Premi�re adresse � attribuer","Entrez la premi�re adresse � attribuer","")
$derniereAdresse = [Microsoft.VisualBasic.Interaction]::InputBox("Derni�re adresse � attribuer","Entrez la derni�re adresse � attribuer","")
$adressePasserelle = [Microsoft.VisualBasic.Interaction]::InputBox("Adresse de passerelle � diffuser","Entrez l'adresse de passerelle � diffuser","")
$adresseDNS = [Microsoft.VisualBasic.Interaction]::InputBox("Adresse du domaine","Entrez l'adresse du domaine","")
$nomDomaine = [Microsoft.VisualBasic.Interaction]::InputBox("Nom du domaine","Entrez le nom du domaine","")


$messageConfirmation = "�tes-vous s�r de vouloir cr�er l'�tendue DHCP suivante ?`n`n" +
                      "Nom de l'�tendue DHCP : $nomEtendue`n" +
                      "Adresse r�seau : $adresseReseau`n" +
                      "Masque de sous-r�seau : $masqueSousReseau`n" +
                      "Premi�re adresse � attribuer : $premiereAdresse`n" +
                      "Derni�re adresse � attribuer : $derniereAdresse`n" +
                      "Adresse de passerelle � diffuser : $adressePasserelle`n" +
                      "Nom du domaine : $nomDomaine`n" +
                      "Adresse du domaine : $adresseDNS"


$confirmation = [System.Windows.Forms.MessageBox]::Show($messageConfirmation, "Voulez-vous vraiment cr�er cette �tendue DHCP", [System.Windows.Forms.MessageBoxButtons]::YesNo)

if ($confirmation -ne "Yes") {
    Write-Host "Op�ration annul�e."
    exit
}

# Cr�er l'�tendue DHCP en utilisant les informations fournies par l'utilisateur
Add-DhcpServerv4Scope -Name $nomEtendue -StartRange $premiereAdresse -EndRange $derniereAdresse -SubnetMask $masqueSousReseau -Description "Etendue DHCP cr��e par script PowerShell" -LeaseDuration 8.00:00:00 -State Active

Set-DhcpServerv4OptionValue -ScopeId $adresseReseau -Router $adressePasserelle -DnsServer $adresseDNS -DnsDomain $nomDomaine

Get-DhcpServerv4Scope | Where-Object { $_.ScopeId -eq $adresseReseau } | Format-Table -AutoSize
