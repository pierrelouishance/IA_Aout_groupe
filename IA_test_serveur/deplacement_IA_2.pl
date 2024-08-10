:- module(deplacement_IA_2, [deplacement_IA_2/2,toutes_les_combinaision_pour_un_joueur_une_carte/4]).

:- use_module(library(lists)).
:- use_module(predicat_helper).
:- use_module(deplacement_manuel).

%===========================================================================================================
%=======================Algorithme Min Max pour 4 joueurs===================================================
%===========================================================================================================

% fonction qui calcul le score total pour un plateau fonction utilisée par le joueur 1 
 
deplacement_IA_2(Plateau, Nouveau_plateau):-
    % write('test'),
    liste_des_nouveaux_plateau_possibles(Plateau,2,Liste_plateaux),
    % write('listes des nouveaux plateux : '),nl,
    % write(Liste_plateaux),nl,
    liste_des_vecteurs_possibles(Liste_plateaux,2,Liste_vecteurs),
    % max_joueur_list renvoie le meilleur vecteur du point de vue du coureur 2
    max_joueur_list(2,Liste_vecteurs,Vecteur),
    nth0(Index,Liste_vecteurs,Vecteur),
    nth0(Index,Liste_plateaux,Nouveau_plateau).
    % write(" l IA 2 a analyse les vecteurs suivant : "),nl,
    % write(Liste_vecteurs),nl,
    % write("il a choisi le vecteur "),nl,
    % write(Vecteur),nl,nl,
    % write("cela correspond au plateau suivant : "),
    % write(Nouveau_plateau),nl,nl,nl.

% On donne le plateau la fonction renvoie le vecteur que le joueur 4 retournera dans l'arbre,
% elle interroge pour chaque cas ce que renvoie le joueur 1
vecteur_joueur_3(Plateau,Vecteur):-
    liste_des_nouveaux_plateau_possibles(Plateau,3,Liste_plateaux),
    liste_des_vecteurs_possibles(Liste_plateaux,3,Liste_vecteurs),
    % max_joueur_list renvoie le meilleur vecteur du point de vue du coureur 1
    max_joueur_list(3,Liste_vecteurs,Vecteur).

    % write(" le joueur 3 a analyse les vecteurs suivant :"),nl,
    % write(Liste_vecteurs),nl,
    % write("il a choisi le vecteur"),nl,
    % write(Vecteur),nl,nl.


% On donne le plateau la fonction renvoie le vecteur que le joueur 4 retournera dans l'arbre,
% elle interroge pour chaque cas ce que renvoie le joueur 1
vecteur_joueur_4(Plateau,Vecteur):-
    liste_des_nouveaux_plateau_possibles(Plateau,4,Liste_plateaux),
    liste_des_vecteurs_possibles(Liste_plateaux,4,Liste_vecteurs),
    % max_joueur_list renvoie le meilleur vecteur du point de vue du coureur 1
    max_joueur_list(4,Liste_vecteurs,Vecteur).
    % write(" le joueur 4 a analyse les vecteurs suivant :"),nl,
    % write(Liste_vecteurs),nl,
    % write("il a choisi le vecteur"),nl,
    % write(Vecteur),nl,nl.

% On donne le plateau la fonction renvoie le vecteur que le joueur 1 retournera dans l'arbre
vecteur_joueur_1(Plateau,Vecteur):-
    liste_des_nouveaux_plateau_possibles(Plateau,1,Liste_plateaux),
    liste_des_vecteurs_possibles(Liste_plateaux,1,Liste_vecteurs),
    % max_joueur_list renvoie le meilleur vecteur du point de vue du coureur 1
    max_joueur_list(1,Liste_vecteurs,Vecteur).
    % write(" le joueur 1 a analyse les vecteurs suivant :"),nl,
    % write(Liste_vecteurs),nl,
    % write("il a choisi le vecteur"),nl,
    % write(Vecteur),nl,nl.


% on traite le cas ou le joueur 1 doit transformer ses plateaux en vecteurs:
liste_des_vecteurs_possibles([],1,[]).
liste_des_vecteurs_possibles([Plateau_1|Reste_plateaux],1,[Vecteur_1|Reste_vecteurs]):-
    score_total(Plateau_1,Vecteur_1),
    liste_des_vecteurs_possibles(Reste_plateaux,1,Reste_vecteurs).

% on traite le cas ou le joueur 4 doit transformer ses plateaux en vecteurs:
liste_des_vecteurs_possibles([],4,[]).
liste_des_vecteurs_possibles([Plateau_1|Reste_plateaux],4,[Vecteur_1|Reste_vecteurs]):-
    score_total(Plateau_1,Vecteur_1),
    liste_des_vecteurs_possibles(Reste_plateaux,4,Reste_vecteurs).

% on traite le cas ou le joueur 3 doit transformer ses plateaux en vecteurs:
liste_des_vecteurs_possibles([],3,[]).
liste_des_vecteurs_possibles([Plateau_1|Reste_plateaux],3,[Vecteur_1|Reste_vecteurs]):-
    score_total(Plateau_1,Vecteur_1),
    liste_des_vecteurs_possibles(Reste_plateaux,3,Reste_vecteurs).

% on traite le cas ou le joueur 2 doit transformer ses plateaux en vecteurs:
liste_des_vecteurs_possibles([],2,[]).
%si le joueur 3 n'a plus de carte on génère les score direct
liste_des_vecteurs_possibles([[E11,E12,E13,E21,E22,E23,E31,E32,E33,E41,E42,E43,C1,C2,[],C3]|Reste_plateaux],2,[Vecteur_1|Reste_vecteurs]):-
    % write('test vide'),
    score_total([E11,E12,E13,E21,E22,E23,E31,E32,E33,E41,E42,E43,C1,C2,[],C3],Vecteur_1),
    liste_des_vecteurs_possibles(Reste_plateaux,2,Reste_vecteurs).
%si le joueur 3 a encore des cartes
liste_des_vecteurs_possibles([Plateau_1|Reste_plateaux],2,[Vecteur_1|Reste_vecteurs]):-
    % write('test listes vecteurs possibles'),nl,
    vecteur_joueur_3(Plateau_1,Vecteur_1),
    % write('plateau : '),
    % write(Plateau_1),nl,
    % write('vecteur :'),
    % write(Vecteur_1),nl,
    liste_des_vecteurs_possibles(Reste_plateaux,2,Reste_vecteurs).

% PLACEHOLDER on donne le plateau et le numéro du joueur et la fonction donne la listes des nouveaux plateaux possibles
% TO DO : remplacer cette fonction par celle de Dehbia
liste_des_nouveaux_plateau_possibles(Plateau,Equipe,Listes_nouveauxplateau):-
    generer_mouvements(Equipe,Plateau,Listes_nouveauxplateau).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% partie pour calculer le score%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculer le score pour une équipe
% score_joueur(+Plateau, +Equipe, -Score)
score_joueur(Plateau, Equipe, Score) :-
    recuperer_les_coureurs_du_plateau(Plateau, First12Coureur),
    recuperer_les_coureurs_du_plateau_de_equipe_n(First12Coureur, Equipe, ListCoureursDeEquipe),
    Position_carte is 11 + Equipe,
    % on récupère les cartes secondes ici
    nth0(Position_carte, Plateau, CarteSecondeEquipe),  % Accéder à un élément spécifique du plateau
    % write("liste des cartes secondes de cette equipe : "),
    % write(CarteSecondeEquipe),nl,
    sum_list(CarteSecondeEquipe, SOMME),
    % write("somme des cartes secondes de cette equipe : "),
    % write(SOMME),nl,
    calcule_le_cout_de_la_chute(ListCoureursDeEquipe, First12Coureur, CoutChute),
    % write("cout chute pour cette equipe : "),
    % write(CoutChute),nl,
    cout_distance_parcourue(ListCoureursDeEquipe, CoutDistanceParcourue),
    % write("cout pour la distance parcourue par les joueurs : "),
    % write(CoutDistanceParcourue),nl,
    nombre_coureurs_qui_veut_prendre_de_la_vitesse(ListCoureursDeEquipe, CarteSecondeEquipe, First12Coureur, CoutVitesse),
    % write("cout vitesse pour cette equipe : "),nl,
    % write(CoutVitesse),nl,
    Score is SOMME + CoutChute + CoutDistanceParcourue + CoutVitesse.

% Fonction heuristique 
% VecteurScoreAvecLes4Equipes = [ScoreJ1, ScoreJ2, ScoreJ3, ScoreJ4]
% score_total(+Plateau, -VecteurScoreAvecLes4Equipes)
score_total(Plateau, [Score1, Score2, Score3, Score4]) :-
    score_joueur(Plateau, 1, Score1),
    score_joueur(Plateau, 2, Score2),
    score_joueur(Plateau, 3, Score3),
    score_joueur(Plateau, 4, Score4).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Les prédicats auxiliaires utilisés pour faire fonctionner nos fonctions principales de l'IA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Récupère les coureurs de l'équipe 1 ou 2 ou 3 ou 4 
% recuperer_les_coureurs_du_plateau_de_equipe_n(+ListDesCoureurs, +NumeroDeEquipe, -ListDesCoureursDeEquipeN)
recuperer_les_coureurs_du_plateau_de_equipe_n([], _, []).
recuperer_les_coureurs_du_plateau_de_equipe_n([[NE, NJ, P, C, IMM]|Rest], NumeroEquipe, [[NE, NJ, P, C, IMM]|LesCoureursDeEquipeN]) :-
    NumeroEquipe =:= NE,
    recuperer_les_coureurs_du_plateau_de_equipe_n(Rest, NumeroEquipe, LesCoureursDeEquipeN).
recuperer_les_coureurs_du_plateau_de_equipe_n([[NE, NJ, P, C, IMM]|Rest], NumeroEquipe, LesCoureursDeEquipeN) :-
    NE =\= NumeroEquipe,
    recuperer_les_coureurs_du_plateau_de_equipe_n(Rest, NumeroEquipe, LesCoureursDeEquipeN).

% Récupère les coureurs du plateau 
% recuperer_les_coureurs_du_plateau(+Plateau, -First12Coureur)
recuperer_les_coureurs_du_plateau(Plateau, First12Coureur) :-
    length(First12Coureur, 12),  % Assure que First12 a exactement 12 éléments ou moins si la liste est plus courte
    append(First12Coureur, _, Plateau).

% Calcule le coût de la chute 

calcule_le_cout_de_la_chute([], _, 0).
calcule_le_cout_de_la_chute(ListCoureursDeEquipe, First12Coureur, Cout) :-
    sum_fifth_elements(ListCoureursDeEquipe,Somme),
Cout is -(Somme * 10).

    


% Compte le nombre de coureurs à la même position
compter_le_nombre_coureurs_a_la_meme_case_sur_plateau(Position, Plateau, NombreDeCoureurs) :-
    findall(Coureur, (member(Coureur, Plateau), Coureur = [_, _, Position, _, _]), ListeCoureursPosition),
    length(ListeCoureursPosition, NombreDeCoureurs).

% Prendre de la vitesse (+POSJOUEUR, +CarteSecondeTire, +Plateau, -NouvellePositionApresPriseDeVitesse)
% On prend de la vitesse si on est dans un peloton
prendre_de_la_vitesse(POSJOUEUR, CarteSecondeTire, Plateau, CoutDeLaVitesse) :-
    PositionDerriereCoureur is POSJOUEUR + 1,
    PositionApresCarteSecondeCoureur1 is POSJOUEUR + CarteSecondeTire + 1,
    PositionApresCarteSecondeCoureur2 is POSJOUEUR + CarteSecondeTire + 2,

    compter_le_nombre_coureurs_a_la_meme_case_sur_plateau(PositionDerriereCoureur, Plateau, CoureurPosition1),
    compter_le_nombre_coureurs_a_la_meme_case_sur_plateau(PositionApresCarteSecondeCoureur1, Plateau, CoureurPosition2),
    compter_le_nombre_coureurs_a_la_meme_case_sur_plateau(PositionApresCarteSecondeCoureur2, Plateau, CoureurPosition3),
 
    ( (CoureurPosition1 > 0, CoureurPosition2 > 0) ; (CoureurPosition1 > 0, CoureurPosition3 > 0) )
    -> (CoutDeLaVitesse = 5 )
    % , write(" le joueur "), write(POSJOUEUR), write(" a pris de la vitesse grace a la carte : "),
    % write(CarteSecondeTire)
    ;  CoutDeLaVitesse = 0.

% Nombre de coureurs qui veulent prendre de la vitesse 
nombre_coureurs_qui_veut_prendre_de_la_vitesse([], _, _, 0).
nombre_coureurs_qui_veut_prendre_de_la_vitesse(_, [], _, 0).
nombre_coureurs_qui_veut_prendre_de_la_vitesse(Liste_Coureurs,Liste_Carte,Plateau,CoutTotal):-
    extract_third_elements(Liste_Coureurs,Liste_POS),
    combine_lists_as_pairs(Liste_POS,Liste_Carte,Liste_combinaisons),
    split_pairs(Liste_combinaisons,Liste_POS_combi,Liste_Carte_combi),
    % write("positions et cartes combi : "), 
    % write(Liste_combinaisons),nl,
    recuperer_les_coureurs_du_plateau(Plateau, First12Coureur),
    nombre_coureurs_qui_veut_prendre_de_la_vitesse_helper(Liste_POS_combi,Liste_Carte_combi,First12Coureur,CoutTotal).




nombre_coureurs_qui_veut_prendre_de_la_vitesse_helper([], _, _, 0).
nombre_coureurs_qui_veut_prendre_de_la_vitesse_helper(_, [], _, 0).
nombre_coureurs_qui_veut_prendre_de_la_vitesse_helper([POS|RESTCoureurs], [Carte|RESTCartes], Plateau, CoutTotal) :-
    prendre_de_la_vitesse(POS, Carte, Plateau, CoutDeLaVitesse),
    nombre_coureurs_qui_veut_prendre_de_la_vitesse_helper(RESTCoureurs, RESTCartes, Plateau, CoutRestant),
    CoutTotal is CoutDeLaVitesse + CoutRestant.

% Calcule la distance parcourue par les coureurs d'une équipe
% cout_distance_parcourue(+ListCoureursDeEquipe, -CoutDistanceParcourue)
cout_distance_parcourue([], 0).
cout_distance_parcourue([[_, _, POS, _, _]|REST], CoutDistanceParcourue) :-
    cout_distance_parcourue(REST, CoutRestant),
    CoutDistanceParcourue is CoutRestant + POS.

% Récupère les coureurs non immobilisés
recuperer_les_coureurs_equipe_n_non_mobiliser([], []).
recuperer_les_coureurs_equipe_n_non_mobiliser([[NE,NJ,POS,COTE,1]|REST], ListeCoureursNonImobiliser) :-
    recuperer_les_coureurs_equipe_n_non_mobiliser(REST, ListeCoureursNonImobiliser).
recuperer_les_coureurs_equipe_n_non_mobiliser([[NE,NJ,POS,COTE,0]|REST], [[NE,NJ,POS,COTE,0]|ListeCoureursNonImobiliser]) :-
    recuperer_les_coureurs_equipe_n_non_mobiliser(REST, ListeCoureursNonImobiliser).















%======================================================================================================================
%============================================Generation des différents plateaux possibles ============================
%======================================================================================================================


% générer tous les mouvements d'une équipe de tous les coureurs avec et sans prise de vitesse 
% ici pour l'IA 2,l'heuristique consiste à faire avancer le joueur disponible le moins avancé 
generer_mouvements(2, Plateau, NouveauListesDeTousLesPlateauPossible) :-
    % récupérer les coureurs de l'équipe N 
    recuperer_les_coureurs_du_plateau(Plateau, ListCoureurs),
    % récupérer la liste des coureurs 
    recuperer_les_coureurs_du_plateau_de_equipe_n(ListCoureurs, 2, ListCoureursDeEquipeN),
    % récupérer les coureurs de l'équipe qui ne sont pas immobilisés 
    recuperer_les_coureurs_equipe_n_non_mobiliser(ListCoureursDeEquipeN, ListeCoureursNonImobiliser),
    % récupérer la listes des joueurs non arrivés
    recuperer_les_coureurs_equipe_n_non_arrives(ListeCoureursNonImobiliser,ListeCoureursNonImobiliserNonArrives),
    % on récupère le joueut le moins avancé
    recuperer_le_coureur_le_moins_avance(ListeCoureursNonImobiliserNonArrives,Coureur_le_moins_avance),
    % récupérer les cartes secondes de l'équipe 
    INDEX is 11 + 2, 
    nth0(INDEX, Plateau, CarteSecondeEquipeN),
 
    combinaison_possible(Coureur_le_moins_avance, CarteSecondeEquipeN, Plateau, NouveauListesDeTousLesPlateauPossible).

% générer tous les mouvements d'une équipe de tous les coureurs avec et sans prise de vitesse 
% ici c'est la génération de mouvements pour les autres joueurs donc on ne se conforme pas à l'heuristique d'avancer le joueur le moins avancé
generer_mouvements(NumeroDeEquipe, Plateau, NouveauListesDeTousLesPlateauPossible) :-
    % récupérer les coureurs de l'équipe N 
    recuperer_les_coureurs_du_plateau(Plateau, ListCoureurs),
    % récupérer la liste des coureurs 
    recuperer_les_coureurs_du_plateau_de_equipe_n(ListCoureurs, NumeroDeEquipe, ListCoureursDeEquipeN),
    % récupérer les coureurs de l'équipe qui ne sont pas immobilisés 
    recuperer_les_coureurs_equipe_n_non_mobiliser(ListCoureursDeEquipeN, ListeCoureursNonImobiliser),
    % récupérer la listes des joueurs non arrivés
    recuperer_les_coureurs_equipe_n_non_arrives(ListeCoureursNonImobiliser,ListeCoureursNonImobiliserNonArrives),

    % récupérer les cartes secondes de l'équipe 
    INDEX is 11 + NumeroDeEquipe, 
    nth0(INDEX, Plateau, CarteSecondeEquipeN),

    combinaison_possible(ListeCoureursNonImobiliserNonArrives, CarteSecondeEquipeN, Plateau, NouveauListesDeTousLesPlateauPossible).

% toutes les combinaisons possibles 
combinaison_possible([], _, _, []).
combinaison_possible(_, [], _, []).
combinaison_possible([[NE, NJ, POS, COTE, IMM]|REST], ListesCarteSeconde, Plateau, Liste_Plateaux) :-
    toutes_les_combinaison_un_coureur_et_une_liste_de_carte([NE, NJ, POS, COTE, IMM], ListesCarteSeconde, Plateau, Liste_NouveauPlateau),
    combinaison_possible(REST, ListesCarteSeconde, Plateau, AutresCombinaisons),
    append(Liste_NouveauPlateau,AutresCombinaisons,Liste_Plateaux).

% mise à jour du plateau pour un coureur et une liste de carte
toutes_les_combinaison_un_coureur_et_une_liste_de_carte(_, [], _, []).
toutes_les_combinaison_un_coureur_et_une_liste_de_carte([NE, NJ, POS, COTE, IMM], [X|ListesCarteSeconde], Plateau, Listes_nouveauxplateau) :-
    toutes_les_combinaision_pour_un_joueur_une_carte([NE, NJ, POS, COTE, IMM], X, Plateau, Listes_plateau),
    toutes_les_combinaison_un_coureur_et_une_liste_de_carte([NE, NJ, POS, COTE, IMM], ListesCarteSeconde, Plateau, Listes_reste), 
    append(Listes_plateau,Listes_reste,Listes_nouveauxplateau).
  
% pour obtenir la liste des nouveaux plateaux possibles sur base d'un joueur, d'une carte, et d'un plateau  
tous_les_deplacement_manuel_pour_une_liste_de_cote_sans_aspi([NE, NJ, POS, COTE, IMM],Carte, [],Plateau, []).
tous_les_deplacement_manuel_pour_une_liste_de_cote_sans_aspi([NE, NJ, POS, COTE, IMM],Carte, [Cote_1|Reste_Cote],Plateau,[Plateau_1|RestePlateaux]):-
    deplacement_manuel([NE, NJ, POS, COTE, IMM],Carte,Cote_1,0,Plateau,Plateau_1),
    tous_les_deplacement_manuel_pour_une_liste_de_cote_sans_aspi([NE, NJ, POS, COTE, IMM],Carte, Reste_Cote,Plateau, RestePlateaux).

tous_les_deplacement_manuel_pour_une_liste_de_cote_avec_aspi([NE, NJ, POS, COTE, IMM],Carte, [],[],Plateau, []).
tous_les_deplacement_manuel_pour_une_liste_de_cote_avec_aspi([NE, NJ, POS, COTE, IMM],Carte, [Cote_1|Reste_Cote],[Cote_1_Aspi|Reste_Cote_Aspi],Plateau,[Plateau_1,Plateau_2|RestePlateaux]):-
    deplacement_manuel([NE, NJ, POS, COTE, IMM],Carte,Cote_1,0,Plateau,Plateau_1),
    deplacement_manuel([NE, NJ, POS, COTE, IMM],Carte,Cote_1_Aspi,1,Plateau,Plateau_2),
    tous_les_deplacement_manuel_pour_une_liste_de_cote_avec_aspi([NE, NJ, POS, COTE, IMM],Carte, Reste_Cote,Reste_Cote_Aspi,Plateau, RestePlateaux).
tous_les_deplacement_manuel_pour_une_liste_de_cote_avec_aspi([NE, NJ, POS, COTE, IMM],Carte, [Cote_1|Reste_Cote],[],Plateau,[Plateau_1|RestePlateaux]):-
    deplacement_manuel([NE, NJ, POS, COTE, IMM],Carte,Cote_1,0,Plateau,Plateau_1),
    tous_les_deplacement_manuel_pour_une_liste_de_cote_avec_aspi([NE, NJ, POS, COTE, IMM],Carte, Reste_Cote,[],Plateau, RestePlateaux).
tous_les_deplacement_manuel_pour_une_liste_de_cote_avec_aspi([NE, NJ, POS, COTE, IMM],Carte, [],[Cote_1_Aspi|Reste_Cote_Aspi],Plateau,[Plateau_2|RestePlateaux]):-
    deplacement_manuel([NE, NJ, POS, COTE, IMM],Carte,Cote_1_Aspi,1,Plateau,Plateau_2),
    tous_les_deplacement_manuel_pour_une_liste_de_cote_avec_aspi([NE, NJ, POS, COTE, IMM],Carte, [],Reste_Cote_Aspi,Plateau, RestePlateaux).


% combinaison pour un joueur et une carte, renvoie une liste de 1 si pas d'aspi possible et une liste de deux si aspi possible (ici cas ou aspi est possible)
toutes_les_combinaision_pour_un_joueur_une_carte([NE, NJ, POS, COTE, IMM], Carte, Plateau, Nv_Plateaux):-
    recuperer_les_coureurs_du_plateau(Plateau, First12Coureur),
    prendre_de_la_vitesse(POS,Carte,First12Coureur,5),
    Arrivee is POS + Carte,
    liste_cote_accessible(POS,COTE,Arrivee,Liste_Cote),
    liste_cote_accessible(POS,COTE,Arrivee+1,Liste_Cote_Aspi),
    tous_les_deplacement_manuel_pour_une_liste_de_cote_avec_aspi([NE, NJ, POS, COTE, IMM],Carte, Liste_Cote,Liste_Cote_Aspi,Plateau, Nv_Plateaux).

% combinaison pour un joueur et une carte, renvoie une liste de 1 si pas d'aspi possible et une liste de deux si aspi possible (ici cas ou aspi n'est pas possible)
toutes_les_combinaision_pour_un_joueur_une_carte([NE, NJ, POS, COTE, IMM], Carte, Plateau, Nv_Plateaux):-
    % write('on test joueur : '),
    % write(NJ),nl,
    % write('carte'),
    % write(Carte),nl,

    Arrivee is POS + Carte,
    liste_cote_accessible(POS,COTE,Arrivee,Liste_Cote),
    tous_les_deplacement_manuel_pour_une_liste_de_cote_sans_aspi([NE, NJ, POS, COTE, IMM],Carte, Liste_Cote,Plateau, Nv_Plateaux).
    % recuperer_les_coureurs_du_plateau(Plateau, First12Coureur),
    % prendre_de_la_vitesse(POS,Carte,First12Coureur,0),
    

% prédicat pour obtenir le coureur le moins avance parmis une liste
recuperer_le_coureur_le_moins_avance([List], [List]).

recuperer_le_coureur_le_moins_avance([List1, List2 | Rest], Max) :-
    List1 = [_, _, Third1, _, _],
    List2 = [_, _, Third2, _, _],
    (   
        Third1 =< Third2
    ->  
        recuperer_le_coureur_le_moins_avance([List1 | Rest], Max)
    ;   
        recuperer_le_coureur_le_moins_avance([List2 | Rest], Max)
    ).
