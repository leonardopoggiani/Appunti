-module(shapes).
-export([area/1]).

area({square,Side}) ->
	Side*Side;

area({circle,Radius}) ->
	Radius*Radius*3.1415;

area({triangle,B,H}) ->
	B*H/2.
