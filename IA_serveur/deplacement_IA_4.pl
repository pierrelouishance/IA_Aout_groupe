:- module(deplacement_IA_4, [deplacement_IA_4/2]).

:- use_module(library(lists)).
:- use_module(predicat_helper).
:- use_module(deplacement_manuel).
:- use_module(deplacement_IA_2).

%===========================================================================================================
%=======================Algorithme Min Max pour 4 joueurs===================================================
%===========================================================================================================
deplacement_IA_4_test(Plateau,Plateau).

% fonction qui calcul le score total pour un plateau fonction utilisée par le joueur 1 
 
deplacement_IA_4(Plateau, Nouveau_plateau):-
    liste_des_nouveaux_plateau_possibles(Plateau,4,Liste_plateaux),

    liste_des_vecteurs_possibles(Liste_plateaux,4,Liste_vecteurs),

    % max_joueur_list renvoie le meilleur vecteur du point de vue du coureur 2
    max_joueur_list(4,Liste_vecteurs,Vecteur),
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
%si le joueur 1 n'a plus de carte (pas de profondeur)
liste_des_vecteurs_possibles([[E11,E12,E13,E21,E22,E23,E31,E32,E33,E41,E42,E43,[],C1,C2,C3]|Reste_plateaux],4,[Vecteur_1|Reste_vecteurs]):-
    score_total([E11,E12,E13,E21,E22,E23,E31,E32,E33,E41,E42,E43,[],C1,C2,C3],Vecteur_1),
    liste_des_vecteurs_possibles(Reste_plateaux,4,Reste_vecteurs).
%si le joueur 1 a encore des cartes(profondeur)
liste_des_vecteurs_possibles([Plateau_1|Reste_plateaux],4,[Vecteur_1|Reste_vecteurs]):-
    vecteur_joueur_1(Plateau_1,Vecteur_1),
    liste_des_vecteurs_possibles(Reste_plateaux,4,Reste_vecteurs).

% on traite le cas ou le joueur 3 doit transformer ses plateaux en vecteurs:
liste_des_vecteurs_possibles([],3,[]).
liste_des_vecteurs_possibles([Plateau_1|Reste_plateaux],3,[Vecteur_1|Reste_vecteurs]):-
    vecteur_joueur_4(Plateau_1,Vecteur_1),
    liste_des_vecteurs_possibles(Reste_plateaux,3,Reste_vecteurs).

% on traite le cas ou le joueur 2 doit transformer ses plateaux en vecteurs:
liste_des_vecteurs_possibles([],2,[]).
liste_des_vecteurs_possibles([Plateau_1|Reste_plateaux],2,[Vecteur_1|Reste_vecteurs]):-
    vecteur_joueur_3(Plateau_1,Vecteur_1),
    liste_des_vecteurs_possibles(Reste_plateaux,2,Reste_vecteurs).

%on génères tous les plateaux possibles
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
    sum_list(CarteSecondeEquipe, SOMME),
    calcule_le_cout_de_la_chute(ListCoureursDeEquipe, First12Coureur, CoutChute),
    cout_distance_parcourue(ListCoureursDeEquipe, CoutDistanceParcourue),
    nombre_coureurs_qui_veut_prendre_de_la_vitesse(ListCoureursDeEquipe, CarteSecondeEquipe, First12Coureur, CoutVitesse),
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
    ;  CoutDeLaVitesse = 0.

% Nombre de coureurs qui veulent prendre de la vitesse 
nombre_coureurs_qui_veut_prendre_de_la_vitesse([], _, _, 0).
nombre_coureurs_qui_veut_prendre_de_la_vitesse(_, [], _, 0).
nombre_coureurs_qui_veut_prendre_de_la_vitesse(Liste_Coureurs,Liste_Carte,Plateau,CoutTotal):-
    extract_third_elements(Liste_Coureurs,Liste_POS),
    combine_lists_as_pairs(Liste_POS,Liste_Carte,Liste_combinaisons),
    split_pairs(Liste_combinaisons,Liste_POS_combi,Liste_Carte_combi),
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
generer_mouvements(4, Plateau, NouveauListesDeTousLesPlateauPossible) :-
    % récupérer les coureurs de l'équipe N 
    recuperer_les_coureurs_du_plateau(Plateau, ListCoureurs),
    % récupérer la liste des coureurs 
    recuperer_les_coureurs_du_plateau_de_equipe_n(ListCoureurs, 4, ListCoureursDeEquipeN),
    % récupérer les coureurs de l'équipe qui ne sont pas immobilisés 
    recuperer_les_coureurs_equipe_n_non_mobiliser(ListCoureursDeEquipeN, ListeCoureursNonImobiliser),
    % récupérer la listes des joueurs non arrivés
    recuperer_les_coureurs_equipe_n_non_arrives(ListeCoureursNonImobiliser,ListeCoureursNonImobiliserNonArrives),
    % récupérer les cartes secondes de l'équipe 
    INDEX is 11 + 4, 
    nth0(INDEX, Plateau, CarteSecondeEquipeN),
    % pour l'IA 4 l'heuristique consite à utiliser sa carte seconde la plus haute à chaque tour
    recuperer_carte_seconde_la_plus_haute(CarteSecondeEquipeN,Carte_haute),
    combinaison_possible(ListeCoureursNonImobiliserNonArrives, Carte_haute, Plateau, NouveauListesDeTousLesPlateauPossible).

% générer tous les mouvements d'une équipe de tous les coureurs avec et sans prise de vitesse 
% cas générale on n'impose pas de prendre la carte la plus élevé 
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
  
% Base case: If there's only one element, it is the maximum.
recuperer_carte_seconde_la_plus_haute([Max], [Max]).

% Recursive case: Compare the first two elements and keep the larger one.
recuperer_carte_seconde_la_plus_haute([H1, H2 | T], Max) :-
    H1 >= H2,
    recuperer_carte_seconde_la_plus_haute([H1 | T], Max).
recuperer_carte_seconde_la_plus_haute([H1, H2 | T], Max) :-
    H1 < H2,
    recuperer_carte_seconde_la_plus_haute([H2 | T], Max).





