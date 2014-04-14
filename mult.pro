
%
% Multiplication without using the * operator
%
% X * Times = Res
%
% Sergio Salomon Garcia		<sergio.salomon at alumnos.unican.es>
%


%%%%%%%%% Recursive version
% 	multSimple/3
% 	multSimple(+X, +Times, ?Res)

% base case
multSimple(_, 0, 0).
% recursive case
multSimple(X, Times, Res) :-
	NewTimes is Times - 1,
	multSimple(X, NewTimes, NewRes),
	Res is NewRes + X. 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%% Iterative version (tail recursion)

% header with three parameters (as the previous)
multIter(X, Times, Res) :-
    multIter(X, Times, 0, Res).
    % calls the "internal" rule with the counter at zero


% internal rule with a counter between the parameters

% base case (the counter is the result)
multIter(_, 0, Count, Count).
% "recursive" case   
multIter(X, Times, Count, Res) :-
    NewTimes is Times - 1,
    Count1 is Count + X,
    multIter(X, NewTimes, Count1, Res).


% This version is much more efficient!
% Compare with big values...
% 		- multSimple(48151, 62342, Z)
%		- multIter(48151, 62342, Z)


