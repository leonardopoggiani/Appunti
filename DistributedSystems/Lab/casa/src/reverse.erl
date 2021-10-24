%%%-------------------------------------------------------------------
%%% @author leonardopoggiani
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Oct 2021 15:50
%%%-------------------------------------------------------------------
-module(reverse).
-author("leonardopoggiani").

%% API
-export([reverse/1]).

%%%% ESERCIZIO 6 %%%%

% implement the function reverse that bring a list and print it reversed.

reverse(L) ->
  reverse(L,[]).

reverse([],Acc) ->
  Acc;

reverse([H|T],Acc) ->
  reverse(T, [H|Acc]).
