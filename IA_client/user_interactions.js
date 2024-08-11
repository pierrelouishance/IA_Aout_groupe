function jouer_tour(){
    if (fini){
        console.log("c'est fini")
    }
    else{
    console.log("plateau avant le tour du joueur "+ tour_joueur+ " : " + plateau)
    if(cyclistes_non_immoblises(tour_joueur).length===0){
        // si aucun coureur disponible on propose de passer son tour 
            $('#input_user').html('');
            const message_choix_cycliste= '<button onclick="passer_tour('+tour_joueur+')" class="btn btn-primary">'+'Passer le tour du joueur  '+tour_joueur+ '(pas de coureur disponibles)'+'</button>'
            const mess_choix_cycliste = $(message_choix_cycliste)
            $("#input_user").append(mess_choix_cycliste)
    }else{
    switch(tour_joueur){
        case 1:
            choix_cycliste()
            break;
        case 2: 
            deplacement_IA_2()
         break;
        case 3: 
            choix_cycliste()
         break;
        case 4: 
            deplacement_IA_4()
         break;
    }  
}
}
}


// fonction qui place sur le doc html les boutons de choix des velo
// quand le user clique sur un des boutons cela active la fonction choix carte avec le bon parametre
function choix_cycliste(){

    // on affiche le message
    $('#input_user').html('');
    const message_choix_cycliste= "<p>joueur " + JSON.stringify(tour_joueur)+ "choisissez un cycliste</p>"
    const mess_choix_cycliste = $(message_choix_cycliste)
    $("#input_user").append(mess_choix_cycliste)
    // on affiche les boutons de choix
    const cyclistes_non_immob = cyclistes_non_immoblises(tour_joueur)
    for (cycliste of cyclistes_non_immob){  
        const bouton_choix_cycliste= '<button onclick="choix_carte('+cycliste+')" class="btn btn-primary">'+cycliste+ '</button>'
        const choix_cycliste = $(bouton_choix_cycliste)
        $("#input_user").append(choix_cycliste)
    }
}

// fonction qui place sur le doc html les boutons de choix des cartes
// quand le user clique sur un des boutons cela active la fonction choix aspiration avec les bons parametres
function choix_carte(velo){
    $('#input_user').html('');
    const message_choix_carte= "<p>joueur " + JSON.stringify(tour_joueur)+ "choisissez une carte seconde </p>"
    const mess_choix_carte = $(message_choix_carte)
    $("#input_user").append(mess_choix_carte)
    // on sélectionne dans plateau les cartes de cette utilisateur
    for (carte of plateau[11+tour_joueur]){
    const bouton_choix_cycliste= '<button onclick="choix_aspiration('+velo+','+carte+')" class="btn btn-primary">'+carte+ '</button>'
    const choix_cycliste = $(bouton_choix_cycliste)
    $("#input_user").append(choix_cycliste)
    }
}

// fonction qui place sur le doc html les boutons de choix de l'aspiration
// quand le user clique sur un des boutons cela active la fonction choix cote avec les bons parametres
function choix_aspiration(velo,carte){
    if (aspiration_possible(velo,carte)){
        // on ajoute le message pour le choix de l'aspiration dans l'html
        $('#input_user').html('');
        const message_choix_aspi= "<p>joueur " + JSON.stringify(tour_joueur)+ "l'aspiration est possible, souhaitez-vous en bénéficier ? </p>"
        const mess_choix_aspi = $(message_choix_aspi)
        $("#input_user").append(mess_choix_aspi)
        // on rajoute les boutons du choix dans l'html
        const bouton_aspi_oui= '<button onclick="choix_cote('+velo+','+carte+','+'1)" class="btn btn-primary"> OUI </button>'
        const aspi_oui = $(bouton_aspi_oui)
        $("#input_user").append(aspi_oui)
        const bouton_aspi_non= '<button onclick="choix_cote('+velo+','+carte+','+'0)" class="btn btn-primary"> NON </button>'
        const aspi_non = $(bouton_aspi_non)
        $("#input_user").append(aspi_non)

    } else {
        choix_cote(velo,carte,0)
    }
}




// fonction qui place sur le doc html les boutons de choix du cote
// quand le user clique sur un des boutons cela active la fonction udpate plateau qui interragit avec prolog pour update le plateau
async function choix_cote(velo,carte,aspiration){

    // cote_0_occupe est un booléen qui représente si un cycliste se trouve sur le cote 0 (idem pour cote_1_occupe)
    const place_depart = plateau[((tour_joueur-1)*3)+velo-1][2]
    const place_destination = place_depart+carte+aspiration
    const cote_depart = plateau[((tour_joueur-1)*3)+velo-1][3]
    // on sélectionne les cases accessibles
    let cotes_access =  cotes_accessibles(place_depart,cote_depart,place_destination)
    // on enlève les cases occupées
    let cotes_dispo = cotes_disponibles(cotes_access,place_destination)
    $('#input_user').html('');
    const message_choix_cote= "<p>joueur " + JSON.stringify(tour_joueur)+ "sur quel coté souhaitez-vous positionner le cycliste ? </p>"
    const mess_choix_cote = $(message_choix_cote)
    $("#input_user").append(mess_choix_cote)
    if (cotes_dispo.length===0){
        for (const cote of cotes_access){
            const bouton_cote= '<button onclick="deplacement_manuel('+tour_joueur+','+velo+','+carte +','+cote+','+aspiration+')" class="btn btn-primary"> Cote'+cote+'  </button>'
            const elem_cote = $(bouton_cote)
            $("#input_user").append(elem_cote)
        }
    } else {
    for (const cote of cotes_dispo){
        const bouton_cote= '<button onclick="deplacement_manuel('+tour_joueur+','+velo+','+carte +','+cote+','+aspiration+')" class="btn btn-primary"> Cote'+cote+'  </button>'
        const elem_cote = $(bouton_cote)
        $("#input_user").append(elem_cote)
    }
}


}