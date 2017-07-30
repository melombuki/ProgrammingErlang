-module(name_server).
-export([init/0, add/2, find/1, handle/2, brutal_kill/0]).
-import(jh_server2, [rpc/2]).

-define(SERVER, ?MODULE).

%% client routines
add(Name, Place) -> rpc(?SERVER, {add, Name, Place}).
find(Name) -> rpc(?SERVER, {find, Name}).
brutal_kill() -> rpc(?SERVER, {brutal_kill}).

%% callbacks
init() -> dict:new().
handle({add, Name, Place}, Dict) -> {ok, dict:store(Name, Place, Dict)};
handle({find, Name}, Dict) -> {dict:find(Name, Dict), Dict};
handle({brutal_kill}, Dict) -> {1 = 0, Dict}.