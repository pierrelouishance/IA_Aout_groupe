
// fonction pour déplacer un coureur sur le plateau
// param : le num d'équipe (de 1 à 4), du cycliste(de 1 à 3),la carte seconde, le coté et l'aspiration
// modifies : la variable globale plateau est modifiée sur base du résultat prolog du predicat deplacement manuel pour les paramètres 
async function deplacement_manuel(equipe,cycliste,carte,cote,vitesse) {
    etat_cycliste= plateau[((equipe-1)*3)+cycliste-1]
    // on exécute la modification de plateau selon prolog
  
    try {
        const response = await fetch("http://localhost:8080/http://localhost:8000", {
            method: "POST",
            body: JSON.stringify({ "predicat": "deplacement_manuel",plateau:plateau,etat_cycliste:etat_cycliste,carte:carte,cote:cote,vitesse:vitesse
             }),
            headers:  {
                "Content-Type": "application/json",
              },
            
          });
        if (!response.ok) {
        throw new Error(`Response status: ${response.status}`);
        }
    
        const json = await response.json();
 
        plateau=json.plateau

        // SPRINT : on vérifie les points sprint
        scores [equipe -1] = scores[equipe-1]- points_sprint(equipe,cycliste,carte,vitesse)

        // CHANCE : on vérifie si le cycliste est tombé sur une carte chance
        const nouvelle_position =  plateau[((equipe-1)*3)+cycliste-1][2]
        const cycliste_non_immobilisé = (plateau[((equipe-1)*3)+cycliste-1][4]==0)

        if (carte_chance(nouvelle_position,cote)&& cycliste_non_immobilisé  ){
          
            //si c'est un joueur humain qui joue
            if (equipe === 1 || equipe ===3){
                    // on tire une carte chance et on redonne la possibilité au joueur de choisir le coté si possible 
                    // si pas de choix de coté le mouvement est effecuté automatiquement
                    const chance = getRandomInteger()
                    alert("carte chance tirée "+chance)

                    // avant le déplacement on rajoute la carte seconde qui pourrait être retirée à tord 
                    if(plateau[11+equipe].includes(chance)){
                        plateau[11+equipe].push(chance)
                    }
                    choix_cote(cycliste, chance, 0)
            }else{
            // si c'est une IA 
                    const nouveau_cote_chance =  plateau[((equipe-1)*3)+cycliste-1][3]
                    carte_chance_tiree_pour_IA(nouvelle_position,nouveau_cote_chance,cycliste)
            }
           
        }
        else {
        // on lance le tour du joueur suivant
        cycliste_fini(equipe,cycliste)
        desimmob_team(equipe)
        if(tour_joueur==1){
            tour_joueur=2
            maj_pions()
            afficherBoutonJouer()
            afficherPlateau()
        }else if(tour_joueur==3){
            tour_joueur=4
            maj_pions()
            afficherBoutonJouer()
            afficherPlateau()
        }else if(tour_joueur==2){
            tour_joueur=3
            maj_pions()
            afficherBoutonJouer()
            afficherPlateau()
        }else if(tour_joueur==4){
            tour_joueur=1
            tour_de_jeu=tour_de_jeu+1
            maj_pions()
            afficherBoutonJouer()
            afficherPlateau()
        }


        }
        
    } catch (error) {
        console.error(error.message);
    }


    }


// fonction pour que l'IA 2 déplace un de ses coureurs 
// modifies : la variable globale plateau est modifiée sur base du résultat prolog du prédicat deplacement_IA_2
async function deplacement_IA_2() {

        try {
            const response = await fetch("http://localhost:8080/http://localhost:8000", {
                method: "POST",
                body: JSON.stringify({ "predicat": "deplacement_IA_2",plateau:plateau
                 }),
                headers:  {
                    "Content-Type": "application/json",
                  },
                
              });
            if (!response.ok) {
            throw new Error(`Response status: ${response.status}`);
            }
        
            const json = await response.json();
            
            // on modifie le plateau et on déduit de la différence, quel joueur a été déplacé par l'IA et de combien
            const plateau_avant = plateau
            plateau=json.plateau
            const plateau_apres = plateau
            const changement = get_bike_moved_by_IA(plateau_avant,plateau_apres)
            velo_IA = changement.index-2
          
            // SPRINT : on vérifie les points sprint
            scores [1] = scores[1]- points_sprint(2,velo_IA,changement.difference,0)

            // CHANCE : on vérifie si le cycliste est tombé sur une carte chance
            const nouvelle_position =  plateau[3+velo_IA-1][2]
            const nouveau_cote =  plateau[3+velo_IA-1][3]
            const cycliste_non_immobilisé = (plateau[3+velo_IA-1][4]==0)
            if (carte_chance(nouvelle_position,nouveau_cote)&& cycliste_non_immobilisé  ){
                // on tire une carte chance et on redonne la possibilité au joueur de choisir le coté si possible 
                // si pas de choix de coté le mouvement est effecuté automatiquement
                const chance = getRandomInteger()
                alert("carte chance tirée "+chance)
                // on sélectionne les cases accessibles
                let cotes_access =  cotes_accessibles(nouvelle_position,nouveau_cote,nouvelle_position+chance)
                // on enlève les cases occupées
                let cotes_dispo = cotes_disponibles(cotes_access,nouvelle_position+chance)
                // avant le déplacement on rajoute la carte seconde qui pourrait être retirée à tord 
                if(plateau[11+2].includes(chance)){
                    plateau[11+2].push(chance)
                }
                //on effectue le déplacement de la carte chance
                if (cotes_dispo.length ===0){
                    deplacement_manuel(2,velo_IA,chance,0,0)
                }else{
                    let cote_chance = cotes_dispo[0]
                    deplacement_manuel(2,velo_IA,chance,cote_chance,0)
                }

            }else{
        // on lance le tour suivant
                cycliste_fini(2,velo_IA)
                desimmob_team(2)
                tour_joueur=3
                maj_pions()
                afficherPlateau()

                afficherBoutonJouer()

            }


        } catch (error) {
            console.error(error.message);
            console.error("Error stack trace:", error.stack);
        }


        }

async function deplacement_IA_4() {

    try {
        const response = await fetch("http://localhost:8080/http://localhost:8000", {
            method: "POST",
            body: JSON.stringify({ "predicat": "deplacement_IA_4",plateau:plateau
                }),
            headers:  {
                "Content-Type": "application/json",
                },
            
            });
        if (!response.ok) {
        throw new Error(`Response status: ${response.status}`);
        }
    
        const json = await response.json();
        
        // on modifie le plateau et on déduit de la différence, quel joueur a été déplacé par l'IA et de combien
        const plateau_avant = plateau
        plateau=json.plateau
        const plateau_apres = plateau
        const changement = get_bike_moved_by_IA(plateau_avant,plateau_apres)
        const velo_IA = changement.index-8
        // on vérifie les points sprint
        scores [3] = scores[3]- points_sprint(4,velo_IA,changement.difference,0)

        // CHANCE : on vérifie si le cycliste est tombé sur une carte chance
        const nouvelle_position =  plateau[9+velo_IA-1][2]
        const nouveau_cote =  plateau[9+velo_IA-1][3]
        const cycliste_non_immobilisé = (plateau[9+velo_IA-1][4]==0)
        if (carte_chance(nouvelle_position,nouveau_cote)&& cycliste_non_immobilisé  ){
            carte_chance_tiree_pour_IA(nouvelle_position,nouveau_cote,velo_IA)
            // on tire une carte chance et on redonne la possibilité au joueur de choisir le coté si possible 
            // si pas de choix de coté le mouvement est effecuté automatiquement
            // const chance = getRandomInteger()
            // alert("carte chance tirée "+chance)
            // // on sélectionne les cases accessibles
            // let cotes_access =  cotes_accessibles(nouvelle_position,nouveau_cote,nouvelle_position+chance)
            // // on enlève les cases occupées
            // let cotes_dispo = cotes_disponibles(cotes_access,nouvelle_position+chance)

            // // avant le déplacement on rajoute la carte seconde qui pourrait être retirée à tord 
            // if(plateau[11+4].includes(chance)){
            //     plateau[11+4].push(chance)
            // }
            // //on effectue le déplacement de la carte chance
            // if (cotes_dispo.length ===0){
            //     deplacement_manuel(4,velo_IA,chance,0,0)
            // }else{
            //     let cote_chance = cotes_dispo[0]
            //     deplacement_manuel(4,velo_IA,chance,cote_chance,0)
            // }

        }else{
            // on lance le tour suivant
            cycliste_fini(4,velo_IA)
            desimmob_team(4)
            tour_joueur=1
            tour_de_jeu+=1
            maj_pions()
            afficherPlateau()
            afficherBoutonJouer()

        }
        
    } catch (error) {
        console.error(error.message);
        console.error("Error stack trace:", error.stack);
    }

    }



// fonction pour interragir avec le chat_bot
// param : la question envoyée au chatbot
// effect : la réponse est affichée à l'écran
async function chatbot(question) {


  
    try {
        const response = await fetch("http://localhost:8080/http://localhost:8000", {
            method: "POST",
            body: JSON.stringify({ "predicat": "chat",question:question
             }),
            headers:  {
                "Content-Type": "application/json",
              },
            
          });
        if (!response.ok) {
        throw new Error(`Response status: ${response.status}`);
        }
    
        const json = await response.json();
        console.log(json)

        displayResponse(json);           
    } catch (error) {
        console.error(error.message);
    }


    }

