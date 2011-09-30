-module(my_db).
-export([start/0,stop/0,write/2,read/1,delete/1,match/1,return/2,loop/1,request_and_return/1]).

start() ->
  register(my_db, spawn(my_db, loop, [db:new()])),
  ok.

stop() ->
  request_and_return({stop, self()}).

write(Key,Element) ->
 request_and_return({write, self(), {Key,Element}}).

read(Key) ->
  request_and_return({read, self(), Key}).

delete(Key) ->
   request_and_return({delete, self(), Key}).

match(Element) ->
  request_and_return({match, self(), Element}). 

request_and_return(Request) ->
	my_db ! Request,
	receive
    {return,Return} -> Return
  end.

loop(Data) ->
  receive
    {stop, Pid} ->
      return(Pid,ok);
    {write, Pid,{Key,Element}} ->
      DB = db:write(Key,Element,Data),
      return(Pid,ok),
      loop(DB);
    {read, Pid, Key} ->
      Value = db:read(Key,Data),
      return(Pid,Value),
      loop(Data);
    {delete ,Pid ,Key} ->
      DB = db:delete(Key,Data),
      return(Pid,ok),
      loop(DB);
    {match,Pid,Element} ->
      Elements = db:match(Element,Data),
      return(Pid,Elements),
      loop(Data);
    stop ->
      ok
end.

return(Pid,Return) ->
  Pid ! {return,Return}.
