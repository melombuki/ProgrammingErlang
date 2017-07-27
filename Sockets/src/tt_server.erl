-module(tt_server).
-export([start/0]).

start() ->
    start(4001).
		  
start(Port) ->
    {ok, LSock} = gen_tcp:listen(Port, [binary,
                                        {packet, 4},
                                        {reuseaddr, true},
                                        {active, true}]),
    spawn(fun() -> server(LSock) end).

server(LSock) ->
  {ok, Sock} = gen_tcp:accept(LSock),
  spawn(fun() -> server(LSock) end),
  loop(Sock).

loop(Sock) ->
    receive
        {tcp, Sock, Bin} ->
            Fac = fac(binary_to_term(Bin)),
            gen_tcp:send(Sock, term_to_binary(Fac));
    end,
    loop(Sock).

fac(N) when N >= 0-> fac(N, 1).

fac(0, Acc) -> Acc;
fac(N, Acc) -> fac(N-1, N * Acc).
