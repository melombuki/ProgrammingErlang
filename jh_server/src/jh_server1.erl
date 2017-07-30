-module(jh_server1).

-export([start/2, rpc/2]).

start(Name, Mod) ->
  register(Name, spawn_link(fun() -> loop(Name, Mod, Mod:init()) end)).

rpc(Name, Req) ->
  Name ! {self(), Req},
  receive
    {Name, Res} -> Res
  end.

loop(Name, Mod, State) ->
  receive
    {From, Req} ->
      {Res, State1} = Mod:handle(Req, State),
      From ! {Name, Res},
      loop(Name, Mod, State1)
  end.