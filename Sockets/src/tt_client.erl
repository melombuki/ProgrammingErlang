-module(tt_client).
-export([fac/1]).

fac(N) ->
    {ok, Sock} = gen_tcp:connect("localhost", 4001, [binary, {packet, 4}]),
    ok = gen_tcp:send(Sock, term_to_binary(N)),
    receive
        {tcp, Sock, Bin} ->
            io:format("client received:~p~n",[binary_to_term(Bin)]),
            gen_tcp:close(Sock)
    end.
