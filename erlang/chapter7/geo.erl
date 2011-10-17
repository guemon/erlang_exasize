-module(geo).

-record(circle, {radius}).
-record(rectangle, {length, width}).
-record(triangle, {a,b,c}).

-export([periphery/1, area/1]).

periphery(#circle{radius = Radius}) ->
  2 * 3.14 * Radius;
periphery(#rectangle{length = Length, width = Width}) ->
  2 * (Length + Width);
periphery(#triangle{a = A,b = B,c = C}) ->
  A + B + C.

area(#circle{radius = Radius}) ->
  Radius * Radius * 3.14;
area(#rectangle{length = Length, width = Width}) ->
  Length * Width;
area(#triangle{a = A, b = B, c = C}) ->
  S = (A + B + C) / 2,
  math:sqrt(S * (S - A) * (S - B) * (S - C)).
