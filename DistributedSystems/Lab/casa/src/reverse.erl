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
-export([tail_reverse/1]).

%%%% ESERCIZIO 6 %%%%

% implement the function reverse that bring a list and print it reversed.

tail_reverse(L) ->
  tail_reverse(L,[]).

tail_reverse([],Acc) ->
  Acc;

tail_reverse([H|T],Acc) ->
  tail_reverse(T, [H|Acc]).
