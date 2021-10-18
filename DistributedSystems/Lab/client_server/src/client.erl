%%%-------------------------------------------------------------------
%%% @author leonardopoggiani
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Oct 2021 15:30
%%%-------------------------------------------------------------------
-module(client).
-author("leonardopoggiani").
-export([start/4, body/4]).

start(ServID, OpID, X, Y) ->
  spawn(?MODULE, body, [ServID, OpID, X, Y]).

% remote procedure call
rpc(ServID, Msg) ->
  ServID ! {self(), Msg},
  receive

    {ServID, Result} -> Result

  end.

body(ServID, OpID, X, Y) ->
  Result = rpc(ServID, {OpID, X, Y} ) ,
  io:format("Result: ~p~n", [Result]).