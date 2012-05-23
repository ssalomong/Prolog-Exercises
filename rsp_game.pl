% % 
% Rock-Paper-Scissors Game in Prolog --
%	Rock, Paper, Scissors... Lizard, Spock
%
% Author:   Sergio Salomon Garcia <sergio.salomon@alumnos.unican.es>
% %

%%  FACTS:  %%

weapon(rock).
weapon(paper).
weapon(scissors).
weapon(lizard).
weapon(spock).

over(rock, scissors).
over(rock, lizard).

over(paper, rock).
over(paper, spock).

over(scissors, paper).
over(scissors, lizard).

over(lizard, paper).
over(lizard, spock).

over(spock, rock).
over(spock, scissors).


%%  RULES:  %%

%	isOver/2
%	isOver(?WeaponOver,?OtherWeapon)
isOver(X, Y) :-
	weapon(X), 
	weapon(Y),
	over(X,Y).

%	wins/3
%	wins(?Weapon1, ?Weapon2, ?Solution)
wins(X, Y, Sol) :-
	isOver(Sol, Y),
	Sol = X     %;
;	isOver(Sol, X),
	Sol = Y     %;
;	X = Y, weapon(X),
	Sol = draw.

%	game/2
%	game(?Weapon1, ?Weapon2)
game(X, Y) :-
	isOver(X,Y),
	nl, write(X), write(' wins'), nl    %;
;	isOver(Y,X),
	nl, write(Y), write(' wins'), nl    %;
;	X = Y, 
	weapon(X), 
	nl, write('There is a draw!'), nl.


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


