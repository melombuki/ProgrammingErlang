-module(new_name_server).
-export([init/0, all_names/0, delete/1, add/2, find/1, handle/2, brutal_kill/0]).
-import(jh_server3, [rpc/2]).

-define(SERVER, ?MODULE).

%% client routines
all_names() -> rpc(name_server, allNames).
add(Name, Place) -> rpc(?SERVER, {add, Name, Place}).
delete(Name) -> rpc(name_server, {delete, Name}).
find(Name) -> rpc(?SERVER, {find, Name}).
brutal_kill() -> rpc(?SERVER, brutal_kill).

%% callbacks
init() -> dict:new().
handle({add, Name, Place}, Dict) -> {ok, dict:store(Name, Place, Dict)};
handle({delete, Name}, Dict) -> {ok, dict:erase(Name, Dict)};
handle({find, Name}, Dict) -> {dict:find(Name, Dict), Dict};
handle(allNames, Dict) -> {dict:fetch_keys(Dict), Dict};
handle(brutal_kill, Dict) -> {1 = 0, Dict}.