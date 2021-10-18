%%%-------------------------------------------------------------------
%%% @author leonardopoggiani
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Oct 2021 15:30
%%%-------------------------------------------------------------------
-module(server).
-author("leonardopoggiani").
-export([start/0, loop/0]).

start() ->
  spawn(?MODULE, loop, []).

loop() ->
  receive

    {From, {plus, X, Y} } ->
      From ! {self(), X+Y},
      loop();

    {From, {minus, X, Y} } ->
      From ! {self(), X-Y},
      loop();

    stop ->
      ok;

    _Unexpected ->
      loop()

  end.

