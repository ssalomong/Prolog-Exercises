%
%   Amzi -- Adventure in Prolog
%   Nani Search
%	http://www.amzi.com/AdventureInProlog/index.php
%
% Author:	Sergio Salomon Garcia <sergio.salomon@alumnos.unican.es>
%

%%%% RULES %%%%

% Declares a room in the house
%	room/1
%	room(?NameOfRoom)
room(office).
room(hall).
room(kitchen).
room('dining room').
room(cellar).

:- op(33, fx, room).	%% for op precedence


% Connection between two rooms
%	door/2
%	door(?RoomA, ?RoomB)
door(office, hall).
door(hall, 'dining room').
door('dining room', kitchen).
door(kitchen, office).
door(cellar, kitchen).


% Properties of the doors
%	isopen/1
%	isopen(?Door(X,Y))
:- dynamic isopen/1.

%	isclosed/1
%	isclosed(?Door(X,Y))
:- dynamic isclosed/1.
isclosed(door(office, hall)).
isclosed(door(hall, 'dining room')).
isclosed(door('dining room', kitchen)).
isclosed(door(kitchen, office)).
isclosed(door(cellar, kitchen)).


% Location of an object in a place
%	location/2
%	location(?Object, ?Place)
:- dynamic location/2.
location(desk, office).
location(computer, office).
location(flashlight, desk).
location(envelope, desk).
location(stamp, envelope).
location(key, envelope).
location(apple, kitchen).
location(broccoli, kitchen).
location(crackers, kitchen).
location('washing machine', cellar).
location(nani, 'washing machine').		% There it is!!

% With lists version of locaion
location(X,Y) :-
	loc_list(L, Y),
	member(X, L).

:- dynamic loc_list/2.
loc_list([apple, broccoli, apple, crackers, candle, table], kitchen).
loc_list([desk, computer], office).
loc_list([flashlight, envelope], desk).
loc_list([key, stamp], envelope).
loc_list(['washing machine'], cellar).
loc_list([nani], 'washing machine').
% TODO ...


% Structured version of location
location_s(object(candle, red, small, 1), kitchen).
location_s(object(apple, red, small, 1), kitchen).
location_s(object(apple, green, small, 1), kitchen).
location_s(object(table, white, big, 50), kitchen).
location_s(object(desk, brown, big, _), office).
location_s(object(computer, gray, large, _), office).
location_s(object(flashlight, black, small, _), desk).
location_s(object(envelope, white, small, _), desk).
location_s(object(stamp, red, tiny, _), envelope).
location_s(object(key, golden, tiny, _), envelope).
location_s(object(broccoli, green, small, _), kitchen).
location_s(object(crackers, brown, small, _), kitchen).
location_s(object('washing machine', white, big, _), cellar).
location_s(object(nani, blue, small, _), 'washing machine').
% TODO ...


% Operator is_in for check location
is_in(Thing, room(X)) :-
	location(Thing, X).
:- op(35, yfx, is_in).
%:- op(35, xfy, is_in).
banana is_in room(kitchen).
pear is_in room kitchen.


%	is_contained/2
%	is_contained(?Thing, ?Container)
is_contained(Thing, Container) :-
	location(Thing, Container).
is_contained(Thing, Container) :-
	location(X, Container),
	is_contained(Thing, X).
%is_contained(Thing, Container) :-
%	location(Thing, X),		% unbound !
%	is_contained(X, Container).


% Some properties of the objects in the house

%	edible/1
%	edible(?Thing)
edible(apple).
edible(crackers).

%	tastes_yucky/1
%	tastes_yucky(?Stuff)
tastes_yucky(broccoli).

%	turned_off/1
%	turned_off(?SomeLight)
:- dynamic turned_off/1.
turned_off(flashlight).
%	turned_on/1
%	turned_on(?SomeLight)
:- dynamic turned_on/1.

:- op(33, xf, turned_on).
:- op(33, xf, turned_off).


% The location of the player
%	here/1
%	here(?PresentRoom)
:- dynamic here/1.
here(kitchen).	
% here begins the player


% The objects that have the player
% 	have/1
%	have(?Object)
:- dynamic have/1.





%%%% RULES %%%%


%	puzzle
puzzle(goto(cellar)) :-
	have(flashlight), turned_on(flashlight), !.
puzzle(goto(cellar)) :-
	write('It''s dark and you are afraid of the dark.'), !, fail.
puzzle(_).


%	where_food/2
%	where_food(?Food, ?Place)
where_food(X, Y) :-
	location(X, Y),
	edible(X).
where_food(X, Y) :-
	location(X, Y),
	tastes_yucky(X).


% Connection between rooms (in two way)
%	connect/2
%	connect(?RoomA, ?RoomB)
connect(X,Y) :- door(X,Y).
connect(X,Y) :- door(Y,X).


% List the thing in the location
%	list_things/1
%	list_things(+Place)
list_things(Place) :-
	location(Thing, Place),
	tab(2),
	write(Thing),
	nl,
	fail.
list_things(_).

% Structured version of list_things
list_things_s(Place) :-
	location_s(object(Thing,Color,Size,Weight), Place),
	write('A '), write(Size), tab(1), write(Color), 
	tab(1), write(Thing), write(', weighing '),
	write_weight(Weight), nl, fail.
list_things_s(_).

write_weight(1) :- write('1 pound.').
write_weight(X) :- X > 1, write(X), write(' pounds.').
% TODO ...


% List the connections of a room
%	list_connections/1
%	list_connections(+Place)
list_connections(Place) :-
	connect(Place, OtherPlace),
	tab(2), write(OtherPlace), nl,
	fail.
list_connections(_).


% Actions of the player

%	look/0
%	look()
look :-
	here(Place),
	write('You are in the '), write(Place), nl,
	write('You can see:'), nl,
	list_things(Place),
	write('You can go to:'), nl,
	list_connections(Place).

%	look_in/1
%	look_in(+Location)
look_in(X) :-
	location(_, X),
	write('Looking in the '), write(X),
	write(' you found:'), nl,
	list_things(X).


%	goto/1
%	goto(+Place)
goto(Place) :-
	puzzle(goto(Place)),
	can_go(Place),
	move(Place),
	look.

:- op(37, fx, goto).


%	can_go/1
%	can_go(?Place)
can_go(Place) :-
	here(X),
%	connect(X, Place),
	connection_open(X, Place).
can_go(Place) :-
	here(X),
	connect(X, Place),
	write('The door is closed.'), nl, 
	!, fail.
can_go(_) :-
	write('You can''t get there from here.'), nl,
	fail.

%	connection_open/2
%	connection_open(?X, ?Y)
connection_open(X, Y) :-
	door(X, Y),
	isopen(door(X,Y)).
connection_open(X, Y) :-
	door(Y, X),
	isopen(door(Y,X)).


%	move/1
%	move(+Place)
move(Place) :-
	retract(here(_)),
	asserta(here(Place)).


%	take/1
%	take(+Object)
take(X) :-
%	not(have(X)),
	can_take(X),
	take_object(X).
% TODO ?

:- op(37, fx, take).


%	can_take/1
%	can_take(?Object)
can_take(Object) :-
	here(Place),
%	location(Object, Place).
	is_contained(Object, Place).
can_take(Object) :-
	write('There is no '), 
	write(Object), write(' here.'),
	nl, fail.

% Structured version of can_take
can_take_s(Object) :-
	here(Place),
	location_s(object(Object,_,small,_), Place).
can_take_s(Object) :-
	here(Place),
	location_s(object(Object,_,big,_), Place),
	write('The '), write(Object),
	write(' is too big to carry.'), nl, fail.
can_take_s(Object) :-
	here(Place),
	not(location_s(object(Object,_,_,_), Place)),
	write('There is no '), write(Object),
	write(' here.'), nl, fail.
% TODO ...


%	take_object/1
%	take_object(+Object)
take_object(Object) :-
	retract(location(Object, _)),
	asserta(have(Object)),
	write('taken'), nl.


%	put/1
%	put(+Object)
put(Object) :-
	have(Object),
	here(Place),
	retract(have(Object)),
	asserta(location(Object, Place)),
	write('left'), nl.




% List the objects in the player's inventory
%	inventory/0
%	inventory()
inventory :-
	write('Objects in your inventory:'), nl,
	have(X),
	tab(2), write(X), nl,
	fail.
inventory.	% TODO necesario ?


% Blah blah
%	respond/1
%	respond(+ListTerms)
respond([]) :- nl.
respond([T|Terms]) :-
	write(T), write(' '), respond(Terms).
% TODO ...



%	turn_on/1
%	turn_on(+Stuff)
turn_on(flashlight) :-
	have(flashlight), turned_off(flashlight),
	retract(turned_off(flashlight)),
	asserta(turned_on(flashlight)),
	write('turned on'), nl.

turn_off(flashlight) :-
	have(flashlight), turned_on(flashlight),
	retract(turned_on(flashlight)),
	asserta(turned_off(flashlight)),
	write('turned off'), nl.

:- op(37, fx, turn_on).
:- op(37, fx, turn_off).


%	open_door/1
%	open_door(+ToPlace)
open_door(X) :-
	here(P),
%	connect(X, P),	% TODO necessary ?
	isclosed(door(X, P)),
	retract(isclosed(door(X, P))),
	asserta(isopen(door(X, P))),
	write('now is open'), nl.
open_door(X) :-
	here(P),
%	connect(X, P),	% TODO
	isclosed(door(P, X)),
	retract(isclosed(door(P, X))),
	asserta(isopen(door(P, X))),
	write('now is open'), nl.


%	close_door/1
%	close_door(+DoorToPlace)
close_door(X) :-
	here(P),
%	connect(X, P),	% TODO necessary ?
	isopen(door(X, P)),
	retract(isopen(door(X, P))),
	asserta(isclosed(door(X, P))),
	write('now is closed'), nl.
close_door(X) :-
	here(P),
%	connect(X, P),	% TODO
	isopen(door(P, X)),
	retract(isopen(door(P, X))),
	asserta(isclosed(door(P, X))),
	write('now is closed'), nl.


% With lists
add_thing(NewThing, Container, [NewThing|OldL]) :-
	loc_list(OldL, Container).
%	append([NewThing], OldL, NewL).
%	NewL = [NewThing, OldL].

put_thing(X, Container) :-
	retract(loc_list(OldL, Container)),
	asserta(loc_list([X|OldL], Container)).
% TODO ...


%3- Add the remaining command predicates to do/1 so the game 
% can be fully played.

%4- Add the concept of time to the game by putting a counter 
% in the command loop. Use an out-of-time condition as one way 
% to end the game. Also add a 'wait' command, which just waits 
% for one time increment.

%5- Add other individuals or creatures that move automatically 
% through the game rooms. Each cycle of the command loop will
% update their locations based on whatever algorithm you choose.



%%%% USER INTERFACE %%%%

%	command_loop/0
command_loop :-
	write('-- Welcome to Nani Seach Game --'), nl,
	repeat,
	write('Enter a command (end to exit): '),
	read(X),
	puzzle(X),
	do(X), nl,
	end_condition(X).


do(goto(X)) :- goto(X), !.
do(go(X)) :- goto(X), !.
do(inventory) :- inventory, !.
do(take(X)) :- take(X), !.
do(put(X)) :- put(X), !.
do(look) :- look, !.
do(end).
do(_) :- write('Invalid command').


end_condition(end).
end_condition(_) :-
	have(nani),
	write('Congratulations!').




	



