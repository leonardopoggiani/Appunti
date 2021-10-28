%%%-------------------------------------------------------------------
%%% @author poggio
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Oct 2021 11:54 AM
%%%-------------------------------------------------------------------
-module(lab_casa).
-author("poggio").

%% API
-export([flatten/2]).

flatten([],Acc) -> Acc;
flatten([H|T],Acc) when is_list(H) -> flatten(T, flatten(H,Acc));
flatten([H|T],Acc) -> flatten(T,[H|Acc]).