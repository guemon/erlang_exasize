-module(echo).
-export([start/0,print/1,stop/0,loop/1]).

start() ->
  register(echo, spawn(echo, loop, [test])),
  ok.
  
print(Term) ->
  echo ! {print, Term},
  ok.

stop() ->
  echo ! stop,
  ok.

loop(Test) ->
  receive
    {print, Term} ->
      io:format("~w~n",[Term]),
      loop(test);
    stop ->
      ok;
    _ ->
      {error, unknown_message}
  end.
