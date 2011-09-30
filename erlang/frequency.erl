%% Code from 
%%   Erlang Programming
%%   Francecso Cesarini and Simon Thompson
%%   O'Reilly, 2008
%%   http://oreilly.com/catalog/9780596518189/
%%   http://www.erlangprogramming.org/
%%   (c) Francesco Cesarini and Simon Thompson

-module(frequency).
-export([start/0, stop/0, allocate/0, deallocate/1]).
-export([init/0]).

%% These are the start functions used to create and
%% initialize the server.

start() ->
  register(frequency, spawn(frequency, init, [])).

init() ->
  Frequencies = {get_frequencies(), []},
  loop(Frequencies).

% Hard Coded
get_frequencies() -> [10,11,12,13,14,15].

%%  The client Functions

stop()           -> call(stop).
allocate()       -> call(allocate).
deallocate(Freq) -> call({deallocate, Freq}).

%% We hide all message passing and the message
%% protocol in a functional interface.

call(Message) ->
  frequency ! {request, self(), Message},
  receive
    {reply, Reply} -> Reply
  end.

%% The Main Loop

loop(Frequencies) ->
  receive
    {request, Pid, allocate} ->
      {NewFrequencies, Reply} = allocate(Frequencies, Pid),
      reply(Pid, Reply),
      loop(NewFrequencies);
    {request, Pid , {deallocate, Freq}} ->
      NewFrequencies = deallocate(Frequencies, Freq, Pid),
      reply(Pid, ok),
      loop(NewFrequencies);
    {request, Pid, stop} ->
      reply(Pid, ok)
  end.

reply(Pid, Reply) ->
  Pid ! {reply, Reply}.

%% The Internal Help Functions used to allocate and
%% deallocate frequencies.

allocate({[], Allocated}, _Pid) ->
  {{[], Allocated}, {error, no_frequency}};

allocate({[Freq|Free], Allocated}, Pid) ->
  case lists:filter( fun({_,AllocatedPid}) -> AllocatedPid == Pid end, Allocated) of
    [_,_,_|_] ->
      {{[Freq|Free], Allocated}, error_over_three};
    _ ->
      {{Free, [{Freq, Pid}|Allocated]}, {ok, Freq}}
   end.


deallocate({Free, Allocated}, Freq, Pid) ->
  A =  lists:member({Freq,Pid},Allocated),
  case (A)  of
    true ->
      io:format("~w~n",[sucsess]),
      NewAllocated=lists:keydelete(Freq, 1, Allocated),
      {[Freq|Free],  NewAllocated};
    false ->
      io:format("~w~n",[error]),
		  error_not_allocated
  end.
