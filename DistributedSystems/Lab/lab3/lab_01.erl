%% @doc This is the module to be developed in lab session 1 for the course
%% "Distributed Systems and Middleware Technologies."
%% @reference See the <a href="http://www.iet.unipi.it/a.bechini/distr/"> course webpage</a>.


-module(lab_01).

-export([hello/0, hello/1, hello/2, take/2, reverse/1, reverse2/1, maxelem/1, rsum/1,
  splitter/1, splitter/2, splitterg/1, halve_them1/1, halve_them/1, halve_them2/1,
  halve_them3/1, deriv/1, deriv/2]).




%% Exercise #1

%% Write an Erlang module named "lab_01" with function hello/0 that prints
%% on the screen the sentence "Hello World!"using the function io:format/1.

%% @doc It prints out "Hello World!"
hello() ->
  io:format("Hello World!~n").






%% Exercise #2

%% In the developed module, insert another function hello/1 that takes a
%% string as argument and prints on the screen "Hello", followed by the
%% passed string. Use the function for formatted print io:format/2;
%% the placeholder for strings in the template string is "~s".
%% Test it from the shell.

hello(Name) ->
  io:format("Hello ~s~n", [Name]).






%% Exercise #3

%% Add another function hello/2 that behaves like the previous one, but prints
%% the sentence on the screen as many times as indicated by the last argument.

hello(_, 0) ->
  ok;
hello(Name, Howmany) ->
  hello(Name),
  hello(Name, Howmany - 1).






%% Exercise #4  trick: ACCUMULATOR

%% Write the function rsum/1 that, given a list of numbers, returns their sum,
%% computed recursively.
%% For the sake of performance, it must be implemented using tail recursion.

%% @doc For a list of numbers, it calculates their sum recursively.
rsum(L) -> rsum(L, 0).
rsum([H | T], Acc) -> rsum(T, Acc + H);
rsum([], Acc) -> Acc.






%% Exercise #5

%% Write a function take/2 that, given an integer and a list, returns
%% the list element at the position indicated by the first parameter.
%% The corresponding library function is lists:nth/2

take(_, []) -> indexerror;
take(Index, _) when Index <0 -> indexError;
take(1, [H | _]) -> H;
take(Index, [_ | T]) -> take(Index - 1, T).






%% Exercise #6

%% Implement the function reverse/1 that takes a list and returns it reversed:
%% e.g.reverse([1,2,3]) gives [3,2,1].
%% Note: the concatenation of two lists can be obtained by the operator "++".

reverse([]) ->
  [];
reverse([H | T]) ->
  reverse(T) ++ [H].  %problem: no tail recursion here. Let's find a more efficient solution.

reverse2([]) -> [];
reverse2(L) -> reverse2(L, []).


reverse2([], R) -> R;
reverse2([H|T], R) -> reverse2(T, [H|R]).






%% Exercise #7

%% Implement a function that returns the maximum element of a list of numbers
%% passed as argument.
%% Develop one version using "case" and another using "if".

maxelem([]) -> null;
maxelem([X]) -> X;
maxelem([H | T]) ->
  MT = maxelem(T),
  %%case H > MT of
  %%   true -> H;
  %%   false -> MT
  %% end.
  if H > MT -> H;
    true -> MT
  end.






%% Exercise #8  trick: ACCUMULATOR

%% Implement the function splitter/1 that takes a list of integers and
%% separates its elements in two lists, one with its even elements,
%% and the other with the odd elements.
%% It must return a tuple with both the calculated lists.

splitter(L) -> splitter(L, [], []).
splitter([], Odds, Evens) -> {lists:reverse(Odds), lists:reverse(Evens)};
splitter([H | T], Odds, Evens) ->
  Reminder = H rem 2,
  if Reminder =:= 0 -> splitter(T, Odds, [H | Evens]);
    true -> splitter(T, [H | Odds], Evens)
  end.

% with guards:
splitterg(L) -> splitterg(L, [], []).
splitterg([], Odds, Evens) -> {lists:reverse(Odds), lists:reverse(Evens)};
splitterg([H | T], Odds, Evens) when H rem 2 =:= 0 ->
  splitter(T, Odds, [H | Evens]);
splitterg([H | T], Odds, Evens) -> splitter(T, [H | Odds], Evens).


splitter(L, Pred) -> splitter(L, Pred, [], []).
splitter([], _, Ok, Ko) -> {lists:reverse(Ok), lists:reverse(Ko)};
splitter([H | T], Pred, Ok, Ko) ->
  case Pred(H) of
    true -> splitter(T, Pred, [H | Ok], Ko);
    _ -> splitter(T, Pred, Ok, [H | Ko])
  end.






%% Exercise #9

%% Write a function that, given a list of numbers, returns a list with values
%% that correspond to half of values in the input list.
%% Develop a plain recursive solution, then a solution based on a
%% list comprehension.
%% Possibly, develop yet another one that makes use of lists:map/2.

halve_them1([]) -> [];
halve_them1([H | T]) -> [H / 2 | halve_them1(T)].

halve_them(L) -> halve_them(L, []).
halve_them([], R) -> lists:reverse(R);
halve_them([H|T], R) -> halve_them(T, [H/2|R]).

halve_them2(L) -> [E / 2 || E <- L].

halve_them3(L) -> lists:map(fun(N) -> N / 2 end, L).






%% Exercise #10

%% Write a function that, given a mathematical function R -> R, returns
%% a function that approximates its derivative.

deriv(F,H) -> fun(X) -> (F(X+H)-F(X))/H  end.
deriv(F) -> deriv(F, 0.0001). %%default value for epsilon: 0.0001

% example
%%Mycos = lab_01:deriv(fun math:sin/1).
%%Mycos(math:pi()/2).

