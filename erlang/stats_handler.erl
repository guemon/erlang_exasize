-module(stats_handler).
-export([init/1, terminate/1, handle_event/2]).

init(_) ->
  [].

terminate(Stats) ->
  Stats.

handle_event({Type, _, Description}, Stats) ->
  case lists:keyfind({Type,Description}, 1, Stats) of
    {Key, Count} ->
      lists:keyreplace(Key, 1, Stats, {Key, Count+1});
    false ->
      [{{Type,Description},1} | Stats]
  end;
handle_event(Event, Stats) ->
  Stats.
