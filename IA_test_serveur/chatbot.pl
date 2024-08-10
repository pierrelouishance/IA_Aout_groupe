:- module(chatbot, [tourdefrance/2]).

:- use_module(library(lists)).
:- dynamic reponse/2.
% :- discontiguous ecrire_reponse/1.


/* --------------------------------------------------------------------- */
/*                                                                       */
/*        PRODUIRE_REPONSE(L_Mots,L_Lignes_reponse) :                    */
/*                                                                       */
/*        Input : une liste de mots L_Mots representant la question      */
/*                de l'utilisateur                                       */
/*        Output : une liste de liste de mots correspondant a la         */
/*                 reponse fournie par le bot                            */
/*                                                                       */
/* --------------------------------------------------------------------- */

% Liste des mots-clés
liste_mot_cle([commence, jeu, coureurs, coureur , classement ,equipes, equipe, tirage, sprint , intermediaire, carte, aspiration , vitesse ,secondes, bascote, depasser, chute, vainqueur, score, total, italie, belgique, hollande, allemagne,case ,chance, robot, gagne, gagner, aleatoire, combien, existe, groupe, groupes ]).

% Calculer la distance de Levenshtein
levenshtein(A, B, D) :-
    length(A, N),
    length(B, M),
    ( N == 0 ->
        D = M
    ; M == 0 ->
        D = N
    ; A = [H1|T1],
      B = [H2|T2],
      ( H1 == H2 ->
          levenshtein(T1, T2, D)
      ;
          levenshtein(T1, [H2|T2], D1),
          levenshtein([H1|T1], T2, D2),
          levenshtein(T1, T2, D3),
          min_list([D1, D2, D3], MinD),
          D is MinD + 1
      )
    ).

% Vérifier les mots avec tolérance
mots_cle_trouves([], _, []).
mots_cle_trouves([Mot|Reste], Mots, [Mot|MotsClesTrouves]) :-
    member(Mot, Mots),
    !,
    mots_cle_trouves(Reste, Mots, MotsClesTrouves).
mots_cle_trouves([Mot|Reste], Mots, [MotCle|MotsClesTrouves]) :-
    atom_chars(Mot, MotChars),  % Convertir l'atome en liste de caractères
    findall(D, (member(M, Mots), atom_chars(M, MChars), levenshtein(MotChars, MChars, D)), Distances),
    min_list(Distances, MinDistance),
    MinDistance =< 2,  % Tolérance pour une erreur mineure
    nth0(Index, Distances, MinDistance),
    nth0(Index, Mots, MotCle),
    !,
    mots_cle_trouves(Reste, Mots, MotsClesTrouves).
mots_cle_trouves([_|Reste], Mots, MotsClesTrouves) :-
    mots_cle_trouves(Reste, Mots, MotsClesTrouves).

% Sélectionner la réponse basée sur les mots-clés trouvés
select_answer(MotsClesTrouves, Answer) :-
    (member(commence, MotsClesTrouves), member(jeu, MotsClesTrouves) ->
        Answer = [cest, au, joueur, ayant, la, plus, haute, carte, secondes, de, commencer];
    member(combien, MotsClesTrouves), (member(coureurs, MotsClesTrouves); member(equipe, MotsClesTrouves); member(equipes, MotsClesTrouves)) ->
        Answer = [chaque, equipe, compte, trois, coureurs, et, il, y, a, quatre, equipes, italie, hollande, belgique, et, allemagne];
    member(gagne, MotsClesTrouves); member(gagner, MotsClesTrouves); member(vainqueur, MotsClesTrouves) ->
        Answer = [le, vainqueur, est, le ,joueur, qui ,dont ,les, temps, cumules, des, trois, cyclistes, est, le, plus, faible, deduction ,faite ,des, points, de ,sprints];
    member(ordre, MotsClesTrouves), member(tirage, MotsClesTrouves) ->
        Answer = [les, joueurs, tirent, cinq, cartes, au, hasard, dans, lordre, suivant, italie, hollande, belgique, allemagne];
    member(deplacer, MotsClesTrouves), member(coureur, MotsClesTrouves), member(case, MotsClesTrouves) ->
        Answer = [non, il, nest, pas, permis, de, deplacer, un, coureur, sur, une, case, occupee];
    member(depasser, MotsClesTrouves), member(groupe, MotsClesTrouves) ->
        Answer = [oui, il, est, permis, de, depasser, par, le, bas-cote, de, la, route, pour, autant, que, le, coureur, arrive, sur, une, case, non, occupee];
    member(carte, MotsClesTrouves), member(secondes, MotsClesTrouves) ->
        Answer = [les, cartes, secondes, prennent, une, valeur, entre, un, et, douze];
    member(cartes, MotsClesTrouves), member(secondes, MotsClesTrouves) ->
        Answer = [il, y, a, quatre_vingt_seize, cartes, secondes, au, total];
    member(aspiration, MotsClesTrouves), member(vitesse, MotsClesTrouves) ->
        Answer = [un, coureur, dans, un, peloton, ou, derriere, un, autre, coureur, profite, de, l, aspiration, et, avance, dune, seconde, et, dune, case, supplementaires, la, prise, de, vitesse, est, facultative, pour, le, coureur, de, tete];      
    member(case, MotsClesTrouves), member(chance, MotsClesTrouves) ->
        Answer = [une, case, chance, permet, de, tirer, aleatoirement, un, nombre, entre, moins, trois, et, trois];
    member(tirage, MotsClesTrouves) ->
        Answer = [chaque, carte, ou, case, a, une, chance, egale, detre, tiree, en, fonction, du, nombre, de, cartes, ou, cases, restant];
    member(qui, MotsClesTrouves), member(robot, MotsClesTrouves) ->
        Answer = [les, equipes, de, hollande, et, d, allemagne, sont, jouees, par, des, robots];
    member(gagne, MotsClesTrouves), member(jeu, MotsClesTrouves) ->
        Answer = [le, joueur, gagne, si, le, temps, total, de, son, equipe, est, le, plus, faible];
    member(sprint, MotsClesTrouves), member(intermediaire, MotsClesTrouves) ->
        Answer = [en, passant, un, sprint, intermediaire, un, ou, plusieurs, coureurs, peuvent, gagner, des, secondes, de, bonification, et, des, points, de, bonification, ces, secondes, et, points, sont, indiques, au, niveau, des, sprints, intermediaires, et, sont, directement, notes, sur, le, classement];    
    member(chute, MotsClesTrouves) ->
        Answer = [le, coureur, chute, et, entraine, dans, sa, chute, le, groupe, de, coureurs, quil, voulait, depasser];
    member(bascote, MotsClesTrouves) ->
        Answer = [oui, mais, si, vous, ne, pouvez, pas, completement, depasser, le, groupe, vous, risquez, de, faire, chuter, tout, le, monde];
    member(classement, MotsClesTrouves), member(equipe, MotsClesTrouves) ->
        Answer = [classement, des, equipes, quarante, points, pour, lequipe, ayant, realise, le, meilleur, temps, total, quinze, points, pour, lequipe, en, deuxieme, place, cinq, points, pour, lequipe, en, troisieme, place];
    member(classement, MotsClesTrouves), member(coureur, MotsClesTrouves) ->
        Answer = [classement, des, coureurs, quinze, points, pour, le, coureur, ayant, realise, le, meilleur, temps, total, maillot, jaune, dix, points, pour, le, coureur, en, deuxieme, place, cinq, points, pour, le, coureur, en, troisieme, place];
           
    Answer = [je, ne, suis, pas, sur, de, comprendre, la, question, pouvez, vous, la, reformuler]).

% Prédicat pour produire une réponse
produire_reponse(ListeMots, Reponse) :-
    % Convertir tous les mots en minuscules
    maplist(downcase_atom, ListeMots, ListeMotsMinuscules),
    % Filtrer les mots-clés trouvés dans la liste des mots avec tolérance
    liste_mot_cle(Keywords),
    mots_cle_trouves(ListeMotsMinuscules, Keywords, MotsClesTrouves),
    % Sélectionner la réponse appropriée basée sur les mots-clés trouvés
    select_answer(MotsClesTrouves, Reponse).

% Prédicat pour lire la question de l'utilisateur
lire_question(Question, ListeMots) :-
    downcase_atom(Question, QuestionMinuscule),
    split_string(QuestionMinuscule, " ", "", ListeMots).

% Prédicat pour écrire la réponse
ecrire_reponse(Reponse, ReponseSentence) :-
    convert_sentence(Reponse, ReponseSentence).

% Prédicat pour convertir une liste de mots en une phrase
convert_sentence(Words, Sentence) :- 
    atomic_list_concat(Words, ' ', Sentence).

/* --------------------------------------------------------------------- */
/*                            TEST DE FIN                                */
/* --------------------------------------------------------------------- */

fin(L) :- member(fin,L).

/* --------------------------------------------------------------------- */
/*                         BOUCLE PRINCIPALE                             */
/* --------------------------------------------------------------------- */

% Nouveau prédicat principal pour répondre aux questions
tourdefrance(Question, ReponseSentence) :-
    lire_question(Question, L_Mots),
    produire_reponse(L_Mots, L_ligne_reponse),
    ecrire_reponse(L_ligne_reponse, ReponseSentence).

