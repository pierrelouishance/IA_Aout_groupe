:- use_module(library(http/http_cors)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_header)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_header)).
:- use_module(library(http/json)).
:- use_module(deplacement_manuel).
:- use_module(deplacement_IA_2).
:- use_module(deplacement_IA_4).


:- http_handler(root(.),handle,[]).

server(Port) :-
   http_server(http_dispatch,[port(Port)]).




handle(Request) :-
   format(user_output,"I m here~n",[]),
   http_read_json(Request, DictIn,[json_object(term)]),
   %format(user_output,"Request is: ~p~n",[Request]),
   format(user_output,"DictIn is: ~p~n",[DictIn]),
   DictOut=DictIn,
   get_predicate(DictIn,X),
   format(user_output,"X ~p~n",[X]),
   reponse(X,DictIn,Y),

   reply_json(Y).

% pour obtenir le prédicat que l'on veut utiliser, le premier argument est la requête et X vaut le vauleur de la clé "predicate" de l'objet json de la requete
get_predicate(json([predicat=X,_,_,_,_,_]),X).
get_predicate(json([predicat=X,_]),X).

reponse(deplacement_IA_2,json([_,plateau=Plateau]),json([plateau=Nouveau_Plateau])):-
   deplacement_IA_2(Plateau,Nouveau_Plateau). 

reponse(deplacement_IA_4,json([_,plateau=Plateau]),json([plateau=Nouveau_Plateau])):-
   deplacement_IA_4(Plateau,Nouveau_Plateau). 

reponse(deplacement_manuel,json([_,plateau=Plateau,etat_cycliste=Etat_cycliste,carte=Carte,cote=Cote,vitesse=Vitesse]),json([ plateau=Nouveau_Plateau])):-
   deplacement_manuel(Etat_cycliste,Carte,Cote,Vitesse,Plateau,Nouveau_Plateau).

reponse(_,_,json([plateau="predicat non reconnu"])).



reponse(example2,json([ name='Demo termm2'])).



