%%%-------------------------------------------------------------------
%%% @author poggio
%%% @copyright (C) 2021, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Nov 2021 4:38 PM
%%%-------------------------------------------------------------------

%%% Write an Erlang process - the "coordinator" - able to spawn N processes and to communicate with each of them
%%% (thus, according to a STAR topology). Any process at a star end must be able to echo back to the coordinator
%%% one specially-structured message ("baton"). The coordinator receives commands on what to do by means of dedicated
%%% incoming messages. In particular, the coordinator can be asked to perform B bounces of batons on the star:
%%% a bounce corresponds to sending a baton to all the "end" processes and getting all the replies back from them.
%%% Possibly, add the ability to terminate the processes at the star ends (w/o being killed!).
-module(star_topology).
-author("poggio").

%% API
-export([]).

% functions to test the ring system; test_ring/0 for the test requested in the text

test_ring() -> test_ring(5,3).
test_ring(NNodes, NRounds) ->  %% NNodes: # of nodes in the ring; NRounds: # or ring rounds to do
  Coordinator = start_ring(NNodes),
  io:format("\n~w-nodes ring creation issued to Coordinator ~w \n\n",[NNodes, Coordinator]),
  Coordinator ! {command, rounds, NRounds},
  io:format("\nRounds ~w command issued\n\n", [NRounds]),
  Coordinator ! {command, stop},
  io:format("\nStop command issued\n\n").


%start a ring with N nodes, returning the Pid of the coordinator node

start_ring(N) ->
  Coordinator = spawn( fun() -> coord_loop() end ),
  Coordinator ! {command, setupring, N},
  Coordinator.


%loop for any node in the ring except the coordinator

link_loop(Next) ->
  receive
    {From, token} ->
      io:format("    ~w -- token --> ~w ~n",[From, self()]),
      Next ! {self(), token},
      link_loop(Next);
    stop ->
      Next ! stop;  %no more actions, stop
    _ -> link_loop(Next)  %any other message is skipped
  end.


%loop for the coordinator node

coord_loop() -> coord_loop(nonext).
coord_loop(Next) ->  %%Next is the Pid of the next node in the ring (or 'nonext' at spawning)
  receive
    {command, setupring, N}  when not is_pid(Next) ->
      coord_loop( create_ring(N) );
    {command, rounds, N} when is_pid(Next) ->
      run_rounds(Next, N),
      coord_loop(Next);
    {command, stop} ->
      Next ! stop,
      ring_removed;
    _ ->
      coord_loop(Next)
  end.


%funct to create the line of processes that composes the ring. Executed by the Coordinator

create_ring(N) ->
  create_ring(self(), N-1). %returns the Pid of the process the coordinator must sent messages to

create_ring(Pid, 0) -> Pid;
create_ring(Next_Pid, N) ->
  Curr_Pid = spawn(fun() -> link_loop(Next_Pid) end),
  io:format("  Coordinator created node ~p~n",[Curr_Pid]),
  create_ring(Curr_Pid, N-1).


%funct to run N rounds of token messages along the ring

run_rounds(Next, N) -> run_rounds(Next, 0, N).
run_rounds(_, X, X) ->
  io:format("  === NO MORE ROUNDS ===\n\n"),
  rounds_over;
run_rounds(Next, Count, N) ->
  Next ! {self(), token},
  receive
    {From, token} ->
      io:format("  ~w -- token --> ~w (coordinator)~n",[From, self()]),
      io:format("  Round ~w completed~n",[Count+1]),
      run_rounds(Next, Count+1, N)
  end.