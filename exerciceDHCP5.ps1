[void][System.Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')


# Demander à l'utilisateur le nombre d'étendues DHCP qu'il veut créer
$nombreEtendues = [Microsoft.VisualBasic.Interaction]::InputBox("Nombre d'étendues DHCP à créer","Entrez le nombre d'étendues DHCP à créer","")

# Vérifier que l'utilisateur a entré un nombre valide
if (-not [int]::TryParse($nombreEtendues, [ref]$null)) {
    Write-Host "Erreur : vous devez entrer un nombre valide."
    exit
}

# Boucle pour créer chaque étendue DHCP
for ($i = 1; $i -le $nombreEtendues; $i++) {
    # Demander à l'utilisateur les informations nécessaires pour créer l'étendue DHCP
    $nomEtendue = [Microsoft.VisualBasic.Interaction]::InputBox("nom de l'étendue DHCP","Entrez le nom de l'étendue DHCP","")
    $adresseReseau = [Microsoft.VisualBasic.Interaction]::InputBox("Adresse réseau de l'étendue DHCP","Entrez l'adresse réseau de l'étendue DHCP","")
    $masqueSousReseau = [Microsoft.VisualBasic.Interaction]::InputBox("Masque de sous-réseau de l'étendue DHCP","Entrez le masque de sous-réseau de l'étendue DHCP","")
    $premiereAdresse = [Microsoft.VisualBasic.Interaction]::InputBox("Première adresse à attribuer","Entrez la première adresse à attribuer","")
    $derniereAdresse = [Microsoft.VisualBasic.Interaction]::InputBox("Dernière adresse à attribuer","Entrez la dernière adresse à attribuer","")
    $adressePasserelle = [Microsoft.VisualBasic.Interaction]::InputBox("Adresse de passerelle à diffuser","Entrez l'adresse de passerelle à diffuser","")
    $adresseDNS = [Microsoft.VisualBasic.Interaction]::InputBox("Adresse du domaine","Entrez l'adresse du domaine","")
    $nomDomaine = [Microsoft.VisualBasic.Interaction]::InputBox("Nom du domaine","Entrez le nom du domaine","")


    $messageConfirmation = "Êtes-vous sûr de vouloir créer l'étendue DHCP suivante ?`n`n" +
                          "Nom de l'étendue DHCP : $nomEtendue`n" +
                          "Adresse réseau : $adresseReseau`n" +
                          "Masque de sous-réseau : $masqueSousReseau`n" +
                          "Première adresse à attribuer : $premiereAdresse`n" +
                          "Dernière adresse à attribuer : $derniereAdresse`n" +
                          "Adresse de passerelle à diffuser : $adressePasserelle`n" +
                          "Nom du domaine : $nomDomaine`n" +
                          "Adresse du domaine : $adresseDNS"


    $confirmation = [System.Windows.Forms.MessageBox]::Show($messageConfirmation, "Voulez-vous vraiment créer cette étendue DHCP", [System.Windows.Forms.MessageBoxButtons]::YesNo)

    if ($confirmation -ne "Yes") {
        Write-Host "Opération annulée."
        exit
    }

    # Créer l'étendue DHCP en utilisant les informations fournies par l'utilisateur
    Add-DhcpServerv4Scope -Name $nomEtendue -StartRange $premiereAdresse -EndRange $derniereAdresse -SubnetMask $masqueSousReseau -Description "Etendue DHCP créée par script PowerShell" -LeaseDuration 8.00:00:00 -State Active

    Set-DhcpServerv4OptionValue -ScopeId $adresseReseau -Router $adressePasserelle -DnsServer $adresseDNS -DnsDomain $nomDomaine

    Get-DhcpServerv4Scope | Where-Object { $_.ScopeId -eq $adresseReseau } | Format-Table -AutoSize 
    

    $confirmationReservation = [System.Windows.Forms.MessageBox]::Show($messageConfirmation, "Voulez-vous faire une réservation d'adresses pour cette étendue", [System.Windows.Forms.MessageBoxButtons]::YesNo)


    if ($confirmationReservation -eq "Yes") {
        $NombreReservation = [Microsoft.VisualBasic.Interaction]::InputBox("Nombre de réservation à créer","")

        # Vérifier que l'utilisateur a entré un nombre valide
        if (-not [int]::TryParse($NombreReservation, [ref]$null)) {
            Write-Host "Erreur : vous devez entrer un nombre valide."
            exit
        }

        for ($i = 1; $i -le $NombreReservation; $i++) {
        $adresseIpReservation = [Microsoft.VisualBasic.Interaction]::InputBox("adresse IP","Entrez l'adresse IP a réserver","")
        $adresseMacReservation = [Microsoft.VisualBasic.Interaction]::InputBox("adresse MAC","Entrez l'adresse MAC a réserver avec cette adresse IP : $adresseIpReservation ","")
        $descriptionReservation = [Microsoft.VisualBasic.Interaction]::InputBox("description de la réservation","Entrez la description pour la réservation avec cette adresse IP : $adresseIpReservation ","")
        Add-DhcpServerv4Reservation -ScopeId $adresseReseau -IPAddress $adresseIpReservation -ClientId $adresseMacReservation -Description $descriptionReservation

        }
    }
    
}
