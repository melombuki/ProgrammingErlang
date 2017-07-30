-module(jh_server2).

-export([start/2, rpc/2]).

start(Name, Mod) ->
  register(Name, spawn_link(fun() -> loop(Name, Mod, Mod:init()) end)).

rpc(Name, Req) ->
  Name ! {self(), Req},
  receive
    {Name, crash} -> exit(rpc);
    {Name, ok, Res} -> Res
  end.

loop(Name, Mod, State) ->
  receive
    {From, Req} ->
      try Mod:handle(Req, State) of
        {Res, State1} ->
          From ! {Name, ok, Res},
          loop(Name, Mod, State1)
      catch
        _:Why ->
          log_the_error(Name, Req, Why),
          From ! {Name, crash},
          loop(Name, Mod, State)
      end
  end.

log_the_error(Name, Req, Why) ->
  io:format("Server ~p request ~p ~n"
            "caused exception ~p~n",
            [Name, Req, Why]).