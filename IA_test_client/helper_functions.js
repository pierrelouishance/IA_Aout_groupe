
//FONCTION qui transforme une réponse prolog en Liste de Liste
// input : un string de type "X = [[1,2,3],[1,2,3],[1,2,3]]"
// output : [[1,2,3],[1,2,3],[1,2,3]] au format liste

function stringToListOfLists(inputString) {
    // Extract the string containing the list of lists
    var str = inputString.split("=")[1].trim();
    str = str.replace(/\s/g, "");

    // Remove surrounding square brackets
    str = str.slice(2, -2);


    var rows = str.split("],[");


    var listOfLists = [];


    rows.forEach(function(row) {

        var elements = row.split(",");

        var numbers = elements.map(function(element) {
            return parseInt(element);
        });
        listOfLists.push(numbers);
    });

    return listOfLists;
}


// fonction qui vérifie dans une liste de liste si toutes les listes intérieurs sont vides
function areAllListsEmpty(listOfLists) {
    for (let i = 0; i < listOfLists.length; i++) {
        if (listOfLists[i].length !== 0) {
            return false; 
        }
    }
    return true;
}

// vérifie si l'aspiration est possible pour le cycliste et la carte donnée 
function aspiration_possible(velo,carte){
    const position_de_depart= plateau[((tour_joueur-1)*3)+velo-1][2]
    const position_de_destination= plateau[((tour_joueur-1)*3)+velo-1][2]+carte
    const liste_des_positions = []
    for (i=0;i<12;i++){
        liste_des_positions.push(plateau[i][2])
    }
    if (liste_des_positions.includes(position_de_depart+1) && (liste_des_positions.includes(position_de_destination+1) || liste_des_positions.includes(position_de_destination+2)) ){
        return true
    }else {
        return false
    }
}

// vérifie s'il y a déjà au moins un cycliste à cette place et de ce coté
function place_cote_occupee(place,cote){

    for (let i=0;i<12;i++){
        const place_test = plateau[i][2]
        const cote_test = plateau[i][3]
        if((place_test==place)&&(cote_test==cote)){
            return true
        }
    }
    return false

}

// fonction qui désimmobilise les cyclistes d'un joueur sur le plateau 
// @param : int, le numéro du joueur 
// @modif : le plateau est modif avec le 5 ème élément de la liste de chacun des 3 cycliste du joueur à 0 
function desimmobiliser(joueur){
    for (let i = (joueur-1)*3;i<((joueur-1)*3)+3;i++){
        plateau[i][4]=0
    }
}

// renvoie la liste des cyclistes disonibles pour une équipe moins ceux qui sont immobilisés
function cyclistes_non_immoblises(joueur){
    const cyclistes_dispo = cyclistes[joueur-1]
    const cyclistes_dispo_non_immob=[]
    for (velo of cyclistes_dispo){
        if(plateau[((joueur-1)*3)+(velo-1)][4]==0){
          cyclistes_dispo_non_immob.push(velo)  
        }
    }
    return cyclistes_dispo_non_immob
}

// renvoie true si la position et le coté corresponde à une carte chance 
function carte_chance(position,cote){
   

    const liste_case_chance = [ [9, 0], [10, 0], [11, 0], [12, 0],[15,1], [19, 2], [21, 2], [24, 0], [26, 0], [28, 0], [30, 0], [32, 0], [34, 0], [48, 0], [57, 0], [66, 0], [66, 1], [74, 0], [90, 1] ]
    for (element of liste_case_chance){
        if ((element[0]== position)&&(element[1]==cote)){
            return true
        }
    }
    return false

}

// cette fonction génère un nombre entre -3 et 3 (qui n'est pas 0)
function getRandomInteger() {
    let randomNumber = Math.floor(Math.random() * 7) - 3;
    while (randomNumber === 0) {
        randomNumber = Math.floor(Math.random() * 7) - 3;
    }

    return randomNumber;
}


// cette fonction return les points gagné en sprint lors de ce déplacement (0 si pas de points gagnés)
function points_sprint(joueur,velo,carte,aspiration){

    const position_apres_deplacement = plateau[((joueur-1)*3)+velo-1][2]
    const position_avant_deplacement = position_apres_deplacement - carte - aspiration
    for (sprint of sprints){
        // on vérifie que le joueur a dépassé la case sprint et qu'il reste des récompenses à attribuer
        if ((position_apres_deplacement>sprint[0])&&(position_avant_deplacement<=sprint[0])&&(sprint[1]>0)){
                const points = sprint[2][sprint[1]-1];
                sprint[1]--;
                alert("points de sprints gagnés : "+points)
                return points
        }
    }
    return 0
}

// fonction qui donne les coté accessible sur une certaine position en partant d'une autre, en prenant en compte le nombre de cotés et les terre-plein
// cette fonction ne s'occupe pas de si un coté est occupé par un autre cycliste
// param : la case de départ, le coté de départ, la case d'arrivé
// return : une liste des cotés accessibles
function cotes_accessibles(place_depart,cote_depart,place_arrivee){
    // on calcul les cotés dispo de base
    let cote_total
    if ((0<place_arrivee && place_arrivee<9) || (18<place_arrivee && place_arrivee<36) || place_arrivee>94 ){

        cote_total=[0,1,2]
    }

    else if ((8<place_arrivee && place_arrivee<19) || (35<place_arrivee && place_arrivee<73) || (75<place_arrivee && place_arrivee<95)){
        cote_total=[0,1]

    }
    else if (72<place_arrivee && place_arrivee<76 ){
        cote_total=[0]

    } 
    // on retire les coté inaccessible pour cause de terre plein 

    if (21<place_depart && place_depart<36 && 21<place_arrivee && place_arrivee<36){
        if (cote_depart==0 || cote_depart ==1){
            cote_total=[0,1]

        } else {
            cote_total=[2]

        }
    }
    if (83<place_depart && place_depart<95 && 83<place_arrivee && place_arrivee<95){
        if (cote_depart==0 ){
            cote_total=[0]

        } else {
            cote_total=[1]

        }
    }
return cote_total
}

// fonction qui sur base d'une liste de coté renvoie la meme liste de cote moins les cotés occupé
function cotes_disponibles(listes_cotes, place){
    const plateau_cycliste = plateau.slice(0,12)
    for (const cote of listes_cotes){
        for (velo of plateau_cycliste){
            if (velo[2]==place && velo[3]==cote){
                listes_cotes = listes_cotes.filter(function(element) {
                    return element !== cote;
                  });
            }
        }
    }
    return listes_cotes
}

// sur base du plateau avant et après mouvement on renvoie un objet dans les attributs sont l'index du joueur qui a bouger et le nombre de case de déplacement
function get_bike_moved_by_IA(list1, list2) {
    console.log("get bike IA")
    console.log(list1)
    console.log(list2)
    if (list1.length !== list2.length) {
        throw new Error("Both lists must have the same length");
    }

    for (let i = 0; i < 12; i++) {
        const sublist1 = list1[i];
        const sublist2 = list2[i];  
        // Check if the third element is different
        if (sublist1[2] !== sublist2[2]) {
            const difference = sublist2[2] - sublist1[2];
            return { index: i, difference: difference };
        }
        }

    return null; // No difference found
}
// fonction qui distribue des cartes au joueurs
// modifies plateaux : on push dans les listes des index 12 à 15, 5 integer allant de 1 à 12
function distribuer_cartes(){
    let liste_carte_seconde = [[8,1],[8,2],[8,3],[8,4],[8,5],[8,6],[8,7],[8,8],[8,9],[8,10],[8,11],[8,12]]
    for (let i = 0;i<5;i++){
        for (let j=0;j<4;j++){
            let carte = Math.floor(Math.random() * 12) + 1;
            while (liste_carte_seconde[carte-1][0]===0){
                let carte = Math.floor(Math.random() * 12) + 1;
            }
            plateau[12+j].push(carte)
            liste_carte_seconde[carte -1 ][0] -=1;
        }
    }
    if (tour_de_jeu===1){
        const max_carte_1 = Math.max(...plateau[12])
        const max_carte_2 = Math.max(...plateau[13])
        const max_carte_3 = Math.max(...plateau[14])
        const max_carte_4 = Math.max(...plateau[15])

        const liste_max= [max_carte_1,max_carte_2,max_carte_3,max_carte_4]
    
        let maxIndex = 0
        for (let i = 0; i <4 ; i++) {
            if (liste_max[i] > liste_max[maxIndex]) {
                maxIndex = i;
            }
        }
        tour_joueur=maxIndex+1
    }

 
    afficherPlateau();
    afficherBoutonJouer()
    

}

// fonction pour savoir si les joueurs n'ont plus carte
// return : true si les 4 dernières listes de plateau sont vide
function plus_de_carte(){
    if(plateau[12].length===0 && plateau[13].length===0 && plateau[14].length===0 && plateau[15].length===0 ){
        return true
    } else {
        return false
    }
}
// fonction qui désimmobilise les coureurs d'une équipe
// param : le numéro de l'équipe (de 1 à 4)
// modifies : plateau en mettant à 0 le 5ème élément des listes représentants les cyclistes de l'équipe ne paramètre
function desimmob_team(equipe){
    for(let i =0;i<3;i++){
        plateau[((equipe-1)*3)+i][4]=0
    }
}
// fonction qui passe le tour d'une équipe si aucun cyclistes n'est disponible (soit parce qu'immobilisé soit parce qu'arrivé)
// param : le numéro de l'équipe dont on passe le tour 
function passer_tour(equipe){
    if (tour_joueur===4){
        tour_de_jeu+=1
        tour_joueur=1
    }else{
        tour_joueur+=1
        
    }
    plateau[11+equipe].pop()
    desimmob_team(equipe)
    maj_pions()
    afficherBoutonJouer()
    afficherPlateau()

}

// gère le cas ou une carte chance est tirée par une IA
function carte_chance_tiree_pour_IA( nouvelle_position,nouveau_cote,velo_IA){
    const chance = getRandomInteger()
    alert("carte chance tirée "+chance)
    // on sélectionne les cases accessibles
    let cotes_access =  cotes_accessibles(nouvelle_position,nouveau_cote,nouvelle_position+chance)
    // on enlève les cases occupées
    let cotes_dispo = cotes_disponibles(cotes_access,nouvelle_position+chance)

    // avant le déplacement on rajoute la carte seconde qui pourrait être retirée à tord 
    if(plateau[11+4].includes(chance)){
        plateau[11+4].push(chance)
    }
    //on effectue le déplacement de la carte chance
    if (cotes_dispo.length ===0){
        deplacement_manuel(4,velo_IA,chance,0,0)
    }else{
        let cote_chance = cotes_dispo[0]
        deplacement_manuel(4,velo_IA,chance,cote_chance,0)
    }
}

// fonction qui vérifie si un cycliste a dépassé la ligne d'arrivée et qui si c'est le cas le retire de la liste des cyclistes disponibles
// et attribue les points 
// et met fin à la partie si c'était le dernier cycliste en lice 
// param : l'équipe (de 1 à 4) et le cycliste (de 1 à 3)
function cycliste_fini(equipe,cycliste){
    const case_cycliste = plateau[((equipe-1)*3)+cycliste-1][2]
    if(case_cycliste>95){
        // on retire le cycliste des cyclistes dispo
        let index = cyclistes[equipe-1].indexOf(cycliste);
        if (index !== -1) {
            cyclistes[equipe-1].splice(index, 1);
                }
        // on attribue les points
        if(tour_premier_arrive ===0 ){
            tour_premier_arrive=tour_de_jeu
            scores[equipe-1]+=(95 - case_cycliste +1 +95)
        }else {
            scores[equipe-1]=+(95 - case_cycliste +1 +95+ (10*(tour_de_jeu-tour_premier_arrive)))
        }
        // on met fin à la partie si plus de cyclistes dispo pour personnes
        if (cyclistes[0].length===0 &&cyclistes[1].length===0 &&cyclistes[2].length===0 &&cyclistes[3].length===0 ){
            console.log("fini")
            let valeurMax = Math.max(...scores);
            let indexMax = scores.indexOf(valeurMax);
            const vainqueur = nom_equipes[indexMax]
            fini = true
            $('#input_user').html('');
            const bouton_jouer= '<p> La partie est finie voici les score'+scores+'le joueur '+vainqueur +' a gagné la partie avec '+scores[indexMax]+' points </p>'
            const jouer = $(bouton_jouer)
            $("#input_user").append(jouer)
        }
    }
}

// cette fonction renvoie les données css (left et top) qui permettent de positionner un pion sur le plateau 
//param : le numéro de l'équipe et du cycliste
// return : un paire de valeur (left,top)
function get_position(equipe,velo){
    const cycliste = plateau[(equipe-1)*3+velo-1]
    const position = cycliste[2]
    const cote = cycliste[3]
    if(position==1 && cote ==0){
        return([31,44]);
    }
    else if(position==1 && cote ==1){
        return([34,44]);
    }
    else if(position==1 && cote ==2){
        return([37,44])
    }
    else if(position==2 && cote ==0){
        return([31,40])
    }
    else if(position==2 && cote ==1){
        return([34,40])
    }
    else if(position==2 && cote ==2){
        return([37,39])
    }
    else if(position==3 && cote ==0){
        return([31,35])
    }
    else if(position==3 && cote ==1){
        return([34,35])
    }
    else if(position==3 && cote ==2){
        return([36,34])
    }
    else if(position==4 && cote ==0){
        return([30,31])
    }
    else if(position==4 && cote ==1){
        return([33,30])
    }
    else if(position==4 && cote ==2){
        return([35,28])
    }
    else if(position==5 && cote ==0){
        return([29,27])
    }
    else if(position==5 && cote ==1){
        return([32,25])
    }
    else if(position==5 && cote ==2){
        return([34,22])
    }
    else if(position==6 && cote ==0){
        return([28,24])
    }
    else if(position==6 && cote ==1){
        return([30,21])
    }
    else if(position==6 && cote ==2){
        return([32,18])
    }
    else if(position==7 && cote ==0){
        return([26,20])
    }
    else if(position==7 && cote ==1){
        return([28,17])
    }
    else if(position==7 && cote ==2){
        return([30,14])
    }
    else if(position==8 && cote ==0){
        return([24,17])
    }
    else if(position==8 && cote ==1){
        return([25,14])
    }
    else if(position==8 && cote ==2){
        return([27,10])
    }
    else if(position==9 && cote ==0){
        return([20,16])
    }
    else if(position==9 && cote ==1){
        return([22,11])
    }
    else if(position==10 && cote ==0){
        return([16,15])
    }
    else if(position==10 && cote ==1){
        return([16,11])
    }
    else if(position==11 && cote ==0){
        return([12,17])
    }
    else if(position==11 && cote ==1){
        return([10,14])
    }
    else if(position==12 && cote ==0){
        return([9.5,20])
    }
    else if(position==12 && cote ==1){
        return([7.5,18])
    }
    else if(position==13 && cote ==0){
        return([9,24])
    }
    else if(position==13 && cote ==1){
        return([6,24])
    }
    else if(position==14 && cote ==0){
        return([8,28])
    }
    else if(position==14 && cote ==1){
        return([5,28])
    }
    else if(position==15 && cote ==0){
        return([8,32])
    }
    else if(position==15 && cote ==1){
        return([5,32])
    }
    else if(position==16 && cote ==0){
        return([9,35])
    }
    else if(position==16 && cote ==1){
        return([7,37])
    }
    else if(position==17 && cote ==0){
        return([10,39])
    }
    else if(position==17 && cote ==1){
        return([8,41])
    }
    else if(position==18 && cote ==0){
        return([12,42])
    }
    else if(position==18 && cote ==1){
        return([10,45])
    }
    else if(position==19 && cote ==0){
        return([17,44])
    }
    else if(position==19 && cote ==1){
        return([14,46])
    }
    else if(position==19 && cote ==2){
        return([12,49])
    }
    else if(position==20 && cote ==0){
        return([19,48])
    }
    else if(position==20 && cote ==1){
        return([16,50])
    }
    else if(position==20 && cote ==2){
        return([13,52])
    }
    else if(position==21 && cote ==0){
        return([20,52])
    }
    else if(position==21 && cote ==1){
        return([17,54])
    }
    else if(position==21 && cote ==2){
        return([14.5,56])
    }
    else if(position==22 && cote ==0){
        return([21,57])
    }
    else if(position==22 && cote ==1){
        return([18,59])
    }
    else if(position==22 && cote ==2){
        return([14,61])
    }
    else if(position==23 && cote ==0){
        return([22,61])
    }
    else if(position==23 && cote ==1){
        return([19,63])
    }
    else if(position==23 && cote ==2){
        return([14,66])
    }
    else if(position==24 && cote ==0){
        return([22.5,65])
    }
    else if(position==24 && cote ==1){
        return([20.5,67])
    }
    else if(position==24 && cote ==2){
        return([15,70])
    }
    else if(position==25 && cote ==0){
        return([24,69])
    }
    else if(position==25 && cote ==1){
        return([21,71])
    }
    else if(position==25 && cote ==2){
        return([17,75])
    }
    else if(position==26 && cote ==0){
        return([25,73])
    }
    else if(position==26 && cote ==1){
        return([23,75])
    }
    else if(position==26 && cote ==2){
        return([18,79])
    }
    else if(position==27 && cote ==0){
        return([27,76])
    }
    else if(position==27 && cote ==1){
        return([26,80])
    }
    else if(position==27 && cote ==2){
        return([22,86])
    }
    // ==========================================Position à rajouter==========================




    // =======================================================================================
    else if(position==80 && cote ==0){
        return([77,16])
    }
    else if(position==80 && cote ==1){
        return([77,11])
    }
    else if(position==81 && cote ==0){
        return([74,16])
    }
    else if(position==81 && cote ==1){
        return([74,12])
    }
    else if(position==82 && cote ==0){
        return([71,16])
    }
    else if(position==82 && cote ==1){
        return([71,12])
    }
    else if(position==83 && cote ==0){
        return([68,16])
    }
    else if(position==83 && cote ==1){
        return([69,12])
    }
    else if(position==84 && cote ==0){
        return([66,17])
    }
    else if(position==84 && cote ==1){
        return([66,10])
    }
    else if(position==85 && cote ==0){
        return([63,17])
    }
    else if(position==85 && cote ==1){
        return([64,9])
    }
    else if(position==86 && cote ==0){
        return([61,15])
    }
    else if(position==86 && cote ==1){
        return([61,8])
    }
    else if(position==87 && cote ==0){
        return([59,14])
    }
    else if(position==87 && cote ==1){
        return([59,7])
    }
    else if(position==88 && cote ==0){
        return([57,14])
    }
    else if(position==88 && cote ==1){
        return([56,7])
    }
    else if(position==89 && cote ==0){
        return([54,15])
    }
    else if(position==89 && cote ==1){
        return([53,7])
    }
    else if(position==90 && cote ==0){
        return([53,17])
    }
    else if(position==90 && cote ==1){
        return([49,11])
    }
    else if(position==91 && cote ==0){
        return([53,20])
    }
    else if(position==91 && cote ==1){
        return([49,20])
    }
    else if(position==92 && cote ==0){
        return([54,24])
    }
    else if(position==92 && cote ==1){
        return([49,24])
    }
    else if(position==93 && cote ==0){
        return([54,28])
    }
    else if(position==93 && cote ==1){
        return([49,28])
    }
    else if(position==94 && cote ==0){
        return([54,31])
    }
    else if(position==94 && cote ==1){
        return([49,31])
    }
    else if(position==95 && cote ==0){
        return([54,35])
    }
    else if(position==95 && cote ==1){
        return([52,34])
    }
    else if(position==95 && cote ==2){
        return([49,34])
    }
    else if(position==96 && cote ==0){
        return([54,40])
    }
    else if(position==96 && cote ==1){
        return([51,40])
    }
    else if(position==96 && cote ==2){
        return([48,38])
    }
    else if(position==97 && cote ==0){
        return([53,45])
    }
    else if(position==97 && cote ==1){
        return([50,43])
    }
    else if(position==97 && cote ==2){
        return([48,32])
    }
    else if(position==98 && cote ==0){
        return([50,51])
    }
    else if(position==98 && cote ==1){
        return([48,48])
    }
    else if(position==98 && cote ==2){
        return([46,46])
    }
    else if(position==99 && cote ==0){
        return([48,55])
    }
    else if(position==99 && cote ==1){
        return([46,52])
    }
    else if(position==99 && cote ==2){
        return([44,49])
    }
    else if(position==100 && cote ==0){
        return([45,52])
    }
    else if(position==100 && cote ==1){
        return([44,55])
    }
    else if(position==100 && cote ==2){
        return([42,51])
    }
    else if(position==101 && cote ==0){
        return([42,61])
    }
    else if(position==101 && cote ==1){
        return([41,57])
    }
    else if(position==101 && cote ==2){
        return([40,53])
    }
    else if(position==102 && cote ==0){
        return([39,63])
    }
    else if(position==102 && cote ==1){
        return([38,59])
    }
    else if(position==102 && cote ==2){
        return([38,54])
    }
    else if(position==103 && cote ==0){
        return([36,64])
    }
    else if(position==103 && cote ==1){
        return([36,60])
    }
    else if(position==103 && cote ==2){
        return([35,56])
    }
    else if(position==104 && cote ==0){
        return([33,65])
    }
    else if(position==104 && cote ==1){
        return([33,61])
    }
    else if(position==104 && cote ==2){
        return([33,56])
    }
    else if(position==105 && cote ==0){
        return([30,65])
    }
    else if(position==105 && cote ==1){
        return([30,61])
    }
    else if(position==105 && cote ==2){
        return([30,56])
    }

    else return([31,44])

}


