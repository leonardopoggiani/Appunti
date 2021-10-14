%%%-------------------------------------------------------------------
%%% @author leonardopoggiani
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 13. Oct 2021 16:21
%%%-------------------------------------------------------------------
-module(lab_01).
-author("leonardopoggiani").

%% API
-export([hello/0, hello/1, hello/2, rsum/1, take/2, reverse/1]).

hello() ->
  io:format("Hello world!~n").

hello(Name) ->
  io:format("Hello ~s ~n", [Name]).

hello(_, 0) ->
  done;

hello(Name, Iterations) ->
  hello(Name),
  hello(Name,Iterations - 1).

%%%% STANDARD TRICK %%%%

rsum(L) -> rsum(L, 0).

rsum([H | T], Acc) ->
  rsum(T, Acc + H);

rsum([], Acc) -> Acc.

%%%% ESERCIZIO NUMERO 5 %%%%

take(_, []) -> indexerror;

take(Index, _) when Index < 0 -> indexerror;

take(1, [H | _]) -> H;

take(Index, [_ | T]) -> take(Index - 1, T).

%%%% ESERCIZIO 6 %%%%

% implement the function reverse that bring a list and print it reversed

reverse([H | T]) ->
