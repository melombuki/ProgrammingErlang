-module(jh_recs).

-export([rec_test/0, rec_test/1, map_test/0, map_search_pred/2]).

-include("../include/records.hrl").

rec_test() ->
    io:format("~w~n",[#todo{}]).

rec_test(T) ->
    io:format("~p~n", [T]).

map_test() ->
    Map = #{one => "one", two => "two"},
    io:format("~p~n", [Map]).

map_search_pred(Pred, Map) ->
    list_search_pred(Pred, maps:to_list(Map)).

list_search_pred(Pred, [{K,V}|T]) ->
    case catch Pred(V) of
	false -> list_search_pred(Pred, T);
	true  -> {ok, {K, V}}
    end;
list_search_pred(_Pred, []) ->
    {error, not_found}.
