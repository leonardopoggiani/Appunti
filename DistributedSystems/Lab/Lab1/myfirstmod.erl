-module(myfirstmod).

%% API for the module, quali funzioni sono chiamabili al di fuori del modulo
-export([sayhello/0,addinc/2]). 

add(X,Y) ->
	X+Y.

addinc(X) ->
	X+1.

addinc(X,Y) ->
	add(addinc(X), Y).

sayhello() ->
	io:format("Hello World!~n").

