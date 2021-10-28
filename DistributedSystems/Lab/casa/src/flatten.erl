%%%-------------------------------------------------------------------
%%% @author poggio
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Oct 2021 5:55 PM
%%%-------------------------------------------------------------------
-module(flatten).
-author("poggio").

%% API
-export([flatten/1, flatten/2]).

flatten(L) ->
  flatten(L, []). % trucco per definire solo flatten/1

flatten([], Result) ->
  Result.

flatten([H|T], Result) ->
  flatten(H, flatten(T, Result)).

flatten(E, Result) -> [E|Result].