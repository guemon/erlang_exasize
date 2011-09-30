-module(ring1).
-export([start/3,loop/1]).


start(M,N,Message) ->
  register(start, spawn(ring1, loop, [111])),
  start ! {N-1,Message}.

loop(Next_Pid) ->
  receive
    {N ,[]} when N >= 0 ->
      start ! stop,
      io:format("~w~n",[stop]);
    {N ,[]} when N < 0 ->
      Next_Pid ! stop,
      io:format("~w~n",[stop]);
    {N,[Hmessage|Tmessage]} when N == 0 ->
      io:format("~w~n",[Hmessage]),
      start ! {N-1,Tmessage},
      loop(start);
    {N,[Hmessage|Tmessage]} when (N/(erlang:length(Tmessage)+1)) > 0 ->
      io:format("~w~n",[Hmessage]),
      Create_Next_Pid =spawn(ring1, loop, [111]),
      Create_Next_Pid ! {N-1,Tmessage},
      loop(Create_Next_Pid);
    {N,[Hmessage|Tmessage]}  ->
      io:format("~w~n",[Hmessage]),
      Next_Pid ! {N-1,Tmessage},
      loop(Next_Pid); 
    stop ->
      io:format("~w~n",[stop]),
      case whereis(start) of
        undefined -> ok;
        _ ->  Next_Pid ! stop,
          ok
      end
  end.
