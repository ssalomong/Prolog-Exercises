% % 
% Check if a natural number is prime using mods (brute force)
%
% Author:   Sergio Salomon Garcia <sergio.salomon@alumnos.unican.es>
% %

%   is_prime/1
%   is_prime(+Num)
is_prime(X) :-
    X < 4.                      % 1, 2, 3 are primes
is_prime(X) :-
    Aux is X mod 2,
    Aux =\= 0,
    Sqrt is sqrt(X),
    Sqrt1 is floor(Sqrt),
    is_prime(X, 3, Sqrt1).      % check mod from 3 to sqrt(X)

%   is_prime/3
%   is_prime(+Num, +Aux, +Limit)
is_prime(X, N, Sqrt) :-
    N =:= Sqrt,                 % N is the Limit
    Mod is X mod N,
    Mod =\= 0.                  % X should be prime then
is_prime(X, N, Sqrt) :-
    N < Sqrt,
    Mod is X mod N,
    Mod =\= 0,                  % X could be prime, it's not sure yet
    is_prime(X,N+1,Sqrt).

