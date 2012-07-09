%
% English parser in Prolog
%
% ( http://www.amzi.com/AdventureInProlog/a15nlang.php )
%
% Sergio Salomon Garcia		<sergio.salomon@alumnos.unican.es>
%


%%%%%%%%%
% Grammar Rules
%
%	The dog ate the bone.
%	The big brown mouse chases a lazy cat.
%
%	[the,dog,ate,the,bone]
%	[the,big,brown,mouse,chases,a,lazy,cat]
%
% sentence :
%	nounphrase, verbphrase.
% nounphrase :
% 	determiner, nounexpression.
% nounphrase :
%	nounexpression.
% nounexpression :
%	noun.
% nounexpression :
%	adjective, nounexpression.
% verbphrase :
%	verb, nounphrase.
%
% determiner :
%	the | a.
% noun :
%	dog | bone | mouse | cat.
% verb :
%	ate | chases.
% adjective :
%	big | brown | lazy.
%
%%%%%%%%%

% The '-->' (DCG) syntax would be a cleaner way


%	noun/1
%	noun(+[Noun|L] - ?L)
noun([mouse|X]-X).
noun([cat|X]-X).
noun([dog|X]-X).
noun([bone|X]-X).
noun([sheep|X]-X).
noun([velociraptor|X]-X).
noun([snake|X]-X).
noun([robot|X]-X).


%	verb/1
%	verb(+[Verb|L] - ?L)
verb([ate|X]-X).
verb([chases|X]-X).
verb([runs|X]-X).
verb([looks|X]-X).
verb([bites|X]-X).
verb([growls|X]-X).


%	adjective/1
%	adjective(+[Adjective|L] - ?L)
adjective([big|X]-X).
adjective([small|X]-X).
adjective([brown|X]-X).
adjective([blue|X]-X).
adjective([lazy|X]-X).
adjective([fast|X]-X).
adjective([strange|X]-X).


%	determiner/1
%	determiner(+[Determiner|L] - ?L)
determiner([the|X]-X).
determiner([a|X]-X).
determiner([an|X]-X).
determiner([this|X]-X).
determiner([that|X]-X).



%	sentence/1
%	sentence(?List)
sentence(L) :-
	nounphrase(L-S1),
	verbphrase(S1-[]), !.


%	nounphrase/1
%	nounphrase(+[NP|L] - ?L)
nounphrase(NP-X) :-
	determiner(NP-S1), nounexpression(S1-X).
nounphrase(NP-X) :-
	nounexpression(NP-X).


%	nounexpression/1
%	nounexpression(+[NE|L] - ?L)
nounexpression(NE-X) :-
	noun(NE-X).
nounexpression(NE-X) :-
	adjective(NE-S1), nounexpression(S1-X).


%	verbphrase/1
%	verbphrase(+[VP|L] - ?L)
verbphrase(VP-X) :-
	verb(VP-S1), nounphrase(S1-X).
verbphrase(VP-[]) :-
	verb(VP-[]).



