-module(btree).

-export([sum/1, max/1, min/1, is_ordered/1, insert/2]).
-record(bt, {numver, lesser, greater}).

init(Number) ->
		spawn(?MODULE, loop, [#bt{number = Number}]).

loop(#bt{number = Number, lesser = Lesser, greater = Greater} = E) ->
		receive
      {add , AddNumber} when Number < AddNumber ->
						E#bt{greater = AddNumber}.
