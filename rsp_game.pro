% % 
% Rock-Paper-Scissors Game in Prolog --
%	Rock, Paper, Scissors... Lizard, Spock
%
% Sergio Salomon Garcia <sergio.salomon at alumnos.unican.es>
% %

%%  FACTS:  %%

weapon(rock).
weapon(paper).
weapon(scissors).
weapon(lizard).
weapon(spock).


over(scissors, paper).	% Scissors cuts paper,
over(paper, rock).		% paper covers rock,
over(rock, lizard).		% rock crushes lizard,
over(lizard, spock).	% lizard poisons Spock,
over(spock, scissors).	% Spock smashes scissors,
over(scissors, lizard).	% scissors decapitates lizard,
over(lizard, paper).	% lizzard eats paper,
over(paper, spock).		% paper disproves Spock,
over(spock, rock).		% Spock vaporizes rock,
over(rock, scissors).	% and, as it always has, rock crushes scissors.


%%  RULES:  %%

%	isOver/2
%	isOver(?WeaponOver,?OtherWeapon)
isOver(X, Y) :-
	weapon(X), 
	weapon(Y),
	over(X,Y).

%	wins/3
%	wins(?Weapon1, ?Weapon2, ?Solution)
wins(X, X, draw) :-	weapon(X).
wins(X, Y, X) :- isOver(X, Y).
wins(X, Y, Y) :- isOver(Y, X).


%	game/2
%	game(?Weapon1, ?Weapon2)
game(X, Y) :-
	wins(X,Y,Sol), 
	Sol \= draw,
	nl, write(Sol), write(' wins'), nl, !.
game(X, Y) :-
	wins(X,Y,draw), 
	nl, write('There is a draw!'), nl, !.




% Could 3 people play ? ... Of course!
%
%	game/3
%	game(?Weapon1, ?Weapon2, ?Weapon3)
game(X, Y, Z) :-
	isOver(X,Y),
	isOver(Y,Z),
	isOver(Z,X),
	nl, write('There is a draw!'), nl   %;
;	isOver(X,Z),
	isOver(Z,Y),
	isOver(Y,X),
	nl, write('There is a draw!'), nl   %;
;	X = Y, Y = Z,
	weapon(X),
	nl, write('There is a draw!'), nl   %;
;	isOver(X,Z),
	X = Y,
	nl, write('There is a draw!'), nl   %;
;	isOver(X,Y),
	X = Z,
	nl, write('There is a draw!'), nl   %;
;	isOver(Y,X),
	Y = Z,
	nl, write('There is a draw!'), nl   %;
;	isOver(X,Y),
	isOver(X,Z),
	nl, write(X), write(' wins'), nl    %;
;	isOver(Y,X),
	isOver(Y,Z),
	nl, write(Y), write(' wins'), nl    %;
;	isOver(Z,X),
	isOver(Z,Y),
	nl, write(Z), write(' wins'), nl.
% WTF! This should be improved...


