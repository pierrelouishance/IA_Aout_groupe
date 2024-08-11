:- module(predicat_helper, [remove_first_occurence/3,max_joueur_list/3,max_joueur_list/4,element_at/3,sum_fifth_elements/2,combine_lists_as_pairs/3,extract_third_elements/2,split_pairs/3,liste_cote_accessible/4,recuperer_les_coureurs_equipe_n_non_arrives/2]).


% ===========================================================================================================================
% ===========================================================================================================================
% ======================fonctions utilitaires à mettre dans un autre fichier============================================
%=========================================================================================================================


remove_first_occurence(_,[],[]).
remove_first_occurence(Elem,[Elem|Rest],Rest).
remove_first_occurence(Elem,[Elem2|Rest],[Elem2|Rest2]):-
    remove_first_occurence(Elem,Rest,Rest2).

% Prédicat principal qui initialise la recherche de la liste avec la valeur maximale à l'index Joueur
max_joueur_list(Joueur, [H|T], MaxList) :-
    max_joueur_list(Joueur, T, H, MaxList).

% Cas de base : quand la liste est vide, la liste maximale courante est le résultat
max_joueur_list(_, [], MaxList, MaxList).

% Cas récursif : comparer la valeur de l'élément à l'index Joueur de la tête actuelle avec le maximum courant
max_joueur_list(Joueur, [Current|T], CurrentMax, MaxList) :-
    element_at(Joueur, Current, ElemCurrent),
    element_at(Joueur, CurrentMax, ElemMax),
    ElemCurrent =< ElemMax,
    max_joueur_list(Joueur, T, CurrentMax, MaxList).

max_joueur_list(Joueur, [Current|T], CurrentMax, MaxList) :-
    element_at(Joueur, Current, ElemCurrent),
    element_at(Joueur, CurrentMax, ElemMax),
    ElemCurrent > ElemMax,
    max_joueur_list(Joueur, T, Current, MaxList).

% Prédicat auxiliaire pour obtenir l'élément à l'index donné (en commençant à 1)
element_at(1, [Elem|_], Elem).
element_at(Index, [_|Tail], Elem) :-
    Index > 1,
    Index1 is Index - 1,
    element_at(Index1, Tail, Elem).




% pour sommer le 5ème élément de chaque liste
sum_fifth_elements(ListOfLists, Sum) :-
    sum_fifth_elements_helper(ListOfLists, 0, Sum).



sum_fifth_elements_helper([], Acc, Acc).  
sum_fifth_elements_helper([[_, _, _, _, FifthElement] | Rest], Acc, Sum) :-
    NewAcc is Acc + FifthElement,  
    sum_fifth_elements_helper(Rest, NewAcc, Sum).

% Combinations: List of all possible combinations of elements from List1 and List2, each represented as a list of two elements.

combine_lists_as_pairs(List1, List2, Combinations) :-
    findall([X, Y], (member(X, List1), member(Y, List2)), Combinations).

% ThirdElements: a list of the third elements of each list in ListOfLists.
extract_third_elements(ListOfLists, ThirdElements) :-
    findall(Third, (member(List, ListOfLists), nth1(3, List, Third)), ThirdElements).


% Récupère les coureurs non arrives
recuperer_les_coureurs_equipe_n_non_arrives([], []).
recuperer_les_coureurs_equipe_n_non_arrives([[_,_,POS,_,_]|REST], ListeCoureursNonImobiliser) :-
    POS>95,
    recuperer_les_coureurs_equipe_n_non_arrives(REST, ListeCoureursNonImobiliser).
recuperer_les_coureurs_equipe_n_non_arrives([[NE,NJ,POS,COTE,Im]|REST], [[NE,NJ,POS,COTE,Im]|ListeCoureursNonImobiliser]) :-
    recuperer_les_coureurs_equipe_n_non_arrives(REST, ListeCoureursNonImobiliser).


% pour split une liste de paires en deux listes
split_pairs(Pairs, FirstElements, SecondElements) :-
    split_pairs_helper(Pairs, FirstElements, SecondElements).

split_pairs_helper([], [], []).  
split_pairs_helper([[First, Second] | Rest], [First | FirstRest], [Second | SecondRest]) :-
    split_pairs_helper(Rest, FirstRest, SecondRest).  

% pour une case de départ, un cote, une case d'arrivée, renvoie la liste des cotés accessibles
liste_cote_accessible(_,_,Arrivee,[0,1,2]):-
    Arrivee < 9,
    Arrivee > 0.
liste_cote_accessible(_,_,Arrivee,[0,1,2]):-
    Arrivee < 22,
    Arrivee > 18.
liste_cote_accessible(_,_,Arrivee,[0,1,2]):-
    Arrivee > 94.

liste_cote_accessible(_,_,Arrivee,[0,1]):-
    Arrivee > 8,
    Arrivee < 19.
liste_cote_accessible(_,_,Arrivee,[0,1]):-
    Arrivee > 35,
    Arrivee < 73.
liste_cote_accessible(_,_,Arrivee,[0,1]):-
    Arrivee > 75,
    Arrivee < 84.

liste_cote_accessible(_,_,Arrivee,[0]):-
    Arrivee > 72,
    Arrivee < 76.

liste_cote_accessible(Depart,_,Arrivee,[0,1,2]):-
    Arrivee > 21,
    Arrivee < 36,
    Depart<22.
liste_cote_accessible(Depart,0,Arrivee,[0,1]):-
    Arrivee > 21,
    Arrivee < 36,
    Depart > 21.
liste_cote_accessible(Depart,1,Arrivee,[0,1]):-
    Arrivee > 21,
    Arrivee < 36,
    Depart > 21.
liste_cote_accessible(Depart,2,Arrivee,[2]):-
    Arrivee > 21,
    Arrivee < 36,
    Depart > 21.


liste_cote_accessible(_,_,Arrivee,[0]):-

    Arrivee > 72,
    Arrivee < 76.

liste_cote_accessible(Depart,_,Arrivee,[0,1]):-
    Arrivee > 83,
    Arrivee < 95,
    Depart < 84.
liste_cote_accessible(Depart,0,Arrivee,[0]):-
    Arrivee > 83,
    Arrivee < 95,
    Depart > 83.
liste_cote_accessible(Depart,1,Arrivee,[1]):-
    Arrivee > 83,
    Arrivee < 95,
    Depart > 83.