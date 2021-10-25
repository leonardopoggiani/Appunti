-module(server).
-export([start/2, rpc/2]).

start(Name, Mod) ->
  register(Name, spawn(fun()-> loop(Name, Mod, Mod:init()) end)).

rpc(Name, Req) ->
  Name ! {self(), Req},
  receive {Name, Response} -> Response
  end.

loop(Name, Mod, State) ->
  receive
    {From, Req} ->
    {Response, NewState} = Mod:handle(Req, State),
    From ! {Name, Response},
    loop(Name, Mod, NewState)
  end.