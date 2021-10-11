-module(forhw).
-export([forhw/1,start/0]).

forhw(0) -> done;

forhw(N) ->
	io:fwrite("Hello~n"),
	forhw(N-1).

start() ->
	forhw(5).

