-module(pinpon_echo).
-export([start/0,print/1,stop/0,loop/0]).

start() ->
  register(pinpon_echo, spawn_link(pinpon_echo, loop, [])),
  ok.
  
print(Term) ->
  pinpon_echo ! {print, Term},
  ok.

stop() ->
  exit(exit_error).
loop() ->
  receive
    {print, Term} ->
      io:format("~w~n",[Term]),
      loop();
    _ ->
      {error, stopped}
  end.
