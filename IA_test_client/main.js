//==================LISTES DES VARIABLES===========================================================================
/*
les 12 premières liste de la variable plateau contient les informations sur la position des cyclistes, leur coté et s'ils sont immobilisés (0 pour non, 1 pour oui)
Le format de ces listes est [numéro_équipe, numéro_cycliste, position, coté, immobilisé]
les 4 dernières listes contiennent les informations sur les cartes disponibles pour chaque joueur
Ce format nous permet de communiquer avec prolog en envoyant une seule variable
*/
let plateau = [[1,1,0,0,0],[1,2,0,0,0],[1,3,0,0,0],[2,1,0,0,0],[2,2,0,0,0],[2,3,0,0,1],[3,1,0,0,0],[3,2,0,0,0],[3,3,0,0,0],[4,1,0,0,0],[4,2,0,0,0],[4,3,0,0,0],[],[],[],[]]
// les cyclistes encore en jeu (qui n'ont pas déjà passé la lignes d'arrivées)
let cyclistes = [[1,2,3],[1,2,3],[1,2,3],[1,2,3]]
// // la listes des cyclistes arrives
// let cyclistes_arrives=[[],[],[],[]]

let nom_equipes = ["Italie","Hollande","Belgique","Allemagne"]
//vaut true si la partie est finie 
let fini = false
// le score de chaque équipe 
let scores = [0,0,0,0]
// le joueur dont c'est le tour 
let tour_joueur = 1 
//le tour de jeu 
let tour_de_jeu=1
// le tour du premier arrivé
let tour_premier_arrive=0
// les informations sur les sprints , 1 : la case du sprint, 2 : de récompense encore disponible à ce sprint, 3 : la liste des points disponibles
let sprints= [[21,1,[2]],[35,2,[2,7]],[75,1,[6]]]
// la listes des cases chances
let casesChance = [ [9, 0], [10, 0], [11, 0], [12, 0],[15,1], [19, 2], [21, 2], [24, 0], [26, 0], [28, 0], [30, 0], [32, 0], [34, 0], [48, 0], [57, 0], [66, 0], [66, 1], [74, 0], [90, 1] ]; 


// on affiche les info sur la page html 
function afficherPlateau() {
    // on affiche la variable plateau
    $('#topdiv').html('');
    const plateau_string= "<p>" + JSON.stringify(plateau)+ "</p>"
    const paragraph_plateau = $(plateau_string)
    $("#topdiv").append(paragraph_plateau)
    // on affiche le tour de jeu
    const tour_string= "<p> tour de jeu " + tour_de_jeu+" tour du joueur "+ tour_joueur+ "</p>"
    const paragraph_tour = $(tour_string)
    $("#topdiv").append(paragraph_tour)

    // on affiche les infos des équipes
    for (let joueur = 1;joueur<5;joueur++){
        $("#info"+joueur).html('');
        const nom_string ="<p>Equipe : "+joueur +" : "+nom_equipes[joueur-1]+"</p> "
        const parag_nom=$(nom_string)
        $("#info"+joueur).append(parag_nom)
        for(let velo = 0;velo<3;velo++){
            let immob = ""
            if(plateau[((joueur-1)*3)+velo][4]==1){
                immob="immob"
            }
            const velo_string ="<p>cycliste "+(velo+1)+" : "+plateau[((joueur-1)*3)+velo][2]+" "+immob+"</p> "
            const parag_velo=$(velo_string)
            $("#info"+joueur).append(parag_velo)
        }
    const carte_string = "<p> cartes : "+plateau[11+joueur]+"</p>"
    const parag_carte=$(carte_string)
    $("#info"+joueur).append(parag_carte)

    const score_string = "<p> score : "+scores[joueur-1]+"</p>"
    const parag_score=$(score_string)
    $("#info"+joueur).append(parag_score)
    }
   
}

function afficherBoutonDistribuer(){
    $('#input_user').html('');
    const bouton_jouer= '<button onclick="distribuer_cartes()" class="btn btn-primary"> Distribuer les cartes secondes </button>'
    const jouer = $(bouton_jouer)
    $("#input_user").append(jouer)

}



function afficherBoutonJouer(){
    if(fini){
        console.log("c'est finiii")
    }else{
    if(plus_de_carte()){
        afficherBoutonDistribuer()
    }else{
    $('#input_user').html('');
    const bouton_jouer= '<button onclick="jouer_tour()" class="btn btn-primary"> Effectuer le tour du joueur'+tour_joueur+' </button>'
    const jouer = $(bouton_jouer)
    $("#input_user").append(jouer)
    }
}
}

afficherBoutonDistribuer()
afficherPlateau()
maj_pions()




