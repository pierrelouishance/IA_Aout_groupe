:- module(deplacement_manuel, [deplacement_manuel/6]).

:- use_module(library(lists)).
:- use_module(predicat_helper).
% immobilise_courreur(+CourreurList, -UpdatedCourreurList)
% Parcourt la liste PlayersList et modifie le champ 'immobilisé' à 1 pour chaque joueur. 
immobilise_courreur([],_).
immobilise_courreur([[NE, NJ, P, C, _]|Rest], [[NE, NJ, P, C, 1]|UpdatedRest]) :-
    immobilise_courreur(Rest, UpdatedRest). 
% courreur_position(+Position, +Player)
% Vérifie si le joueur (sous forme de liste) est à la Position spécifiée.
courreur_position(Position, [_, _, Pos, _, _]) :-
    Pos = Position.
% courreur_cote(+Cote, +Player)
% Vérifie si le joueur (sous forme de liste) est au cote spécifiée.
courreur_cote(Cot, [_, _, _, Cote, _]) :-
    Cot = Cote.

% recuperer_les_courreurs_du_plateau(+Plateau, Courreurs)
% Extrait les 12 premiers éléments du plateau qui correspand a nos courreurs.
recuperer_les_courreurs_du_plateau(Plateau, First12Courreur) :-
    length(First12Courreur, 12),  
    append(First12Courreur, _, Plateau).

% trouver_les_courreurs_qui_se_trouve_a_la_position_n(+Position, +Plateau, -CourreurPosition)
% Récupère tous les joueurs parmi les 12 premiers de la liste qui occupent la Position donnée.
trouver_les_courreurs_qui_se_trouve_a_la_position_n(Position, Plateau, CourreurPosition) :-
    recuperer_les_courreurs_du_plateau(Plateau, First12Courreur),  % Prend les 12 premiers éléments de la liste
    include(courreur_position(Position), First12Courreur, CourreurPosition).  % Filtre ceux qui sont à la position voulue

trouver_les_courreurs_qui_se_trouve_a_la_position_n_et_meme_cote(Cote,CourreursPosition,CourreursPositionCote):-
    include(courreur_cote(Cote),CourreursPosition,CourreursPositionCote).
%compter_le_nombre_courreurs_a_la_meme_case_sur_plateau(+Position, +Plateau, -NombreDeCourreurs)
%trouver le nombre de courreurs qui se trouve a une case donnée sur le plateau 
compter_le_nombre_courreurs_a_la_meme_case_sur_plateau(Position, Plateau, NombreDeCourreurs) :-
    trouver_les_courreurs_qui_se_trouve_a_la_position_n(Position, Plateau, ListeCourreurPosition ),
    length(ListeCourreurPosition,NombreDeCourreurs).
% prendre_de_la_vitesse(+vitesse,+Joueur,+CarteSecondeTire,+Plateau,+NouvellePositionApresPriseDeVitesse)
% on prend de la vitesse si on est dans un pleton
prendre_de_la_vitesse(Vitesse, POSJOUEUR, CarteSecondeTire, Plateau, NouvellePositionApresPriseDeVitesse) :-
    (  Vitesse = 1 ->
        PositionDeriereCourreur is POSJOUEUR + 1,
        PositionApresCarteSecondeCourreur1 is POSJOUEUR + CarteSecondeTire + 1,
        PositionApresCarteSecondeCourreur2 is POSJOUEUR + CarteSecondeTire + 2,
        % voir s'il y'a un courreur devanat lui 
        compter_le_nombre_courreurs_a_la_meme_case_sur_plateau(PositionDeriereCourreur, Plateau, CourreurPosition1),
        % voir s'il y'a un courreur a la position actuelle + 1 + carte seconde tiré 
        compter_le_nombre_courreurs_a_la_meme_case_sur_plateau(PositionApresCarteSecondeCourreur1, Plateau, CourreurPosition2),
        % voir s'il y'a un courreur a la position actuelle + 1 + carte seconde tiré +1
        compter_le_nombre_courreurs_a_la_meme_case_sur_plateau(PositionApresCarteSecondeCourreur2, Plateau, CourreurPosition3),
        (   (CourreurPosition1 = 1, CourreurPosition2 = 1) ; (CourreurPosition1 = 1, CourreurPosition3 = 1) ->
            NouvellePositionApresPriseDeVitesse is POSJOUEUR + 1 
        ;   NouvellePositionApresPriseDeVitesse is POSJOUEUR
        );
          Vitesse = 0 ->
        NouvellePositionApresPriseDeVitesse is POSJOUEUR
    ).

% mettre_a_jour_un_courreur(+[NUMEQUIEP, NumCourreur,Pos, Cote, Imm],+NouvellePos, +NouveauCote,+NouveauImm,+Plateau,-PlateauAjour)
mettre_a_jour_un_courreur([NUMEQUIEP, NumCourreur,_, _, _],NouvellePos, NouveauCote,NouveauImm,Plateau,PlateauAjour):-
    recuperer_les_courreurs_du_plateau(Plateau, First12Courreur),
    nth0(Index, First12Courreur, [NUMEQUIEP, NumCourreur,_, _, _]),
    remplacer_element_index_dans_plateau(Index,[NUMEQUIEP, NumCourreur,NouvellePos, NouveauCote, NouveauImm],Plateau,PlateauAjour ).

%remplacer_element_index_dans_plateau(Index, NouveauElement, Plateau,NouveauPlateau)
remplacer_element_index_dans_plateau(Index, NouveauElement, Plateau,NouveauPlateau):-
    length(Before, Index),  % Before a exactement Idx éléments
    append(Before, [_|After], Plateau),  % Ignorer l'élément actuel à l'index Idx
    append(Before, [NouveauElement|After], NouveauPlateau).  % Construire la nouvelle liste avec NewElem
%mettre_a_jour_carte_seconde( +NumEquipe, +CaretSeconde,+Plateau, NouveauPlateau):-
% upadate carte chance   
mettre_a_jour_carte_seconde( NumEquipe, CarteSeconde,Plateau, NouveauPlateau):-
    P is 11+NumEquipe,
    nth0(P, Plateau, Element),
    remove_first_occurence(CarteSeconde, Element, NouvelleCartetSeconde),
    remplacer_element_index_dans_plateau(P,NouvelleCartetSeconde,Plateau,NouveauPlateau).

%cote_libre(+Cote,+Position,+Plateau)
%retourne true si le coté est libre false sinon
cote_libre(Cote,Position,Plateau):-
    trouver_les_courreurs_qui_se_trouve_a_la_position_n(Position,Plateau,CourreurPosition),
    (length(CourreurPosition,0); \+verifier_cote_libre(CourreurPosition,Cote)).


%verifier_cote_libre(+ListCourreur, +Cote).
%renvoie true si c'est verifier sinon false
verifier_cote_libre([[_, _, _, Cote, _]|_], Cote).
verifier_cote_libre([_|T], Cote) :-
    verifier_cote_libre(T, Cote).

%mise_a_jour_des_courreur(+ListeDesCourreurAmettreAjourDansLePlateau ,-PlateauApresMiseAJour):-
% C'est un prédicat qui met a jour plusieur courreur  dans un plateau 
mise_a_jour_des_courreurs([], Plateau, Plateau).
mise_a_jour_des_courreurs([[NUMEQUIEP, NumCourreur,Pos, Cote, Imm]|RestListe], Plateau,PlateauApresMiseAJour):-
    mettre_a_jour_un_courreur([NUMEQUIEP, NumCourreur,Pos, Cote, Imm],Pos, Cote,Imm,Plateau,PlateauAjour1),
    mise_a_jour_des_courreurs(RestListe, PlateauAjour1,PlateauApresMiseAJour).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

chute([NumEquipe, NumCourreur, NouvellePosition, Cote, Imm], CarteSecondeTire, NouveauCote, Plateau, NouveauPlateau) :-
    trouver_les_courreurs_qui_se_trouve_a_la_position_n(NouvellePosition, Plateau, CourreursPosition),
    trouver_les_courreurs_qui_se_trouve_a_la_position_n_et_meme_cote(NouveauCote,CourreursPosition,CourreursPositionCote),
    length(CourreursPositionCote, Nombre),
    (
        (Nombre < 1 -> 
            mettre_a_jour_carte_seconde(NumEquipe, CarteSecondeTire, Plateau, NouveauPlateau1),
            mettre_a_jour_un_courreur([NumEquipe, NumCourreur, NouvellePosition, Cote, Imm], NouvellePosition, NouveauCote, 0, NouveauPlateau1, NouveauPlateau)
        );
        (Nombre >= 1 -> 
            immobilise_courreur(CourreursPosition, CourreursApresImmobilisation),
            
            mise_a_jour_des_courreurs(CourreursApresImmobilisation, Plateau, NouveauPlateau2),
            Pos is NouvellePosition-1,
            mettre_a_jour_un_courreur([NumEquipe, NumCourreur, Pos, Cote, Imm], NouvellePosition, NouveauCote, 1, NouveauPlateau2, NouveauPlateau3),
            mettre_a_jour_carte_seconde(NumEquipe, CarteSecondeTire, NouveauPlateau3, NouveauPlateau)
        )
    ).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%0%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deplacement_manuel([NumEquipe, NumJoueur, PosJoueur, Cote, IMMobilise], CarteSecondeTire, CoteDeplacement, PrendreVitesse, Plateau, NouveauPlateau):- 
    PosJoueur >= 0,
    PosJoueur < 127, % vérifier la position actuelle  
    % voir si ça provoque une chute 
     % calculer la nouvelle position 
    NouvellePositionJoueur is PosJoueur + CarteSecondeTire + PrendreVitesse, % calculer la nouvelle position 

    chute([NumEquipe, NumJoueur, NouvellePositionJoueur, Cote, IMMobilise], CarteSecondeTire,CoteDeplacement, Plateau, NouveauPlateau).



