[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')


# Demander � l'utilisateur le nombre d'�tendues DHCP qu'il veut cr�er
$nombreEtendues = [Microsoft.VisualBasic.Interaction]::InputBox("Nombre d'�tendues DHCP � cr�er","Entrez le nombre d'�tendues DHCP � cr�er","")

# V�rifier que l'utilisateur a entr� un nombre valide
if (-not [int]::TryParse($nombreEtendues, [ref]$null)) {
    Write-Host "Erreur : vous devez entrer un nombre valide."
    exit
}

# Boucle pour cr�er chaque �tendue DHCP
for ($i = 1; $i -le $nombreEtendues; $i++) {
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
    

    $confirmationReservation = [System.Windows.Forms.MessageBox]::Show($messageConfirmation, "Voulez-vous faire une r�servation d'adresses pour cette �tendue", [System.Windows.Forms.MessageBoxButtons]::YesNo)


    if ($confirmationReservation -eq "Yes") {
        $NombreReservation = [Microsoft.VisualBasic.Interaction]::InputBox("Nombre de r�servation � cr�er","")

        # V�rifier que l'utilisateur a entr� un nombre valide
        if (-not [int]::TryParse($NombreReservation, [ref]$null)) {
            Write-Host "Erreur : vous devez entrer un nombre valide."
            exit
        }

        for ($i = 1; $i -le $NombreReservation; $i++) {
        $adresseIpReservation = [Microsoft.VisualBasic.Interaction]::InputBox("adresse IP","Entrez l'adresse IP a r�server","")
        $adresseMacReservation = [Microsoft.VisualBasic.Interaction]::InputBox("adresse MAC","Entrez l'adresse MAC a r�server avec cette adresse IP : $adresseIpReservation ","")
        $descriptionReservation = [Microsoft.VisualBasic.Interaction]::InputBox("description de la r�servation","Entrez la description pour la r�servation avec cette adresse IP : $adresseIpReservation ","")
        Add-DhcpServerv4Reservation -ScopeId $adresseReseau -IPAddress $adresseIpReservation -ClientId $adresseMacReservation -Description $descriptionReservation

        }
    }
    
}
