%%%-------------------------------------------------------------------
%%% @author leonardopoggiani
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. Oct 2021 15:17
%%%-------------------------------------------------------------------
-module(pingpong).
-author("leonardopoggiani").

-export([start/0, alice/2, bob/0]).
alice(0, Other_PID) ->
  Other_PID ! finished, %terminates bob
  io:format("Alice finished~n");
alice(N, Other_PID) ->
  Other_PID ! {ping_msg, self()},
  receive
    pong_msg ->
      io:format("Alice received pong~n")
  end,
  alice(N - 1, Other_PID). %last call opt.

bob() ->
  receive
    finished ->
      io:format(" Bob finished~n");
    {ping_msg, Other_PID} -> %pttrn with Pid
      io:format(" Bob received ping~n"),
      Other_PID ! pong_msg,
      bob()
  end.

start() ->
  Pong_PID = spawn(?MODULE, bob, []),
  spawn(?MODULE, alice, [2, Pong_PID]).