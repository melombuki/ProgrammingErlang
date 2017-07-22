-module(jh_lists).

-export([sum/1,
	 fib/1,
	 map/2,
	 pmap/2,
	 pmap1/2,
	 my_tuple_to_list/1,
	 my_time_func/1]).

sum(X) ->
  sum(X, 0).

sum([H|T], Acc) ->
  sum(T, Acc + H);
sum([], Acc) ->
  Acc.

map(F, [H|T]) ->
  [F(H)|map(F, T)];
map(_, []) ->
  [].

fib(X) ->
  tail_fib(X, 0, 0, 0).

tail_fib(End, N, N0, N1) ->
  case N of
    End -> N0 + N1;
    0 -> tail_fib(End, 1, 0, 0);
    1 -> tail_fib(End, 2, 1, 0);
    _ -> tail_fib(End, N+1, N1 + N0, N0)
  end.

pmap(F, L) ->
  S = self(),
  Ref = erlang:make_ref(),
  Pids = map(fun(I) ->
      spawn(fun() -> do_f(S, Ref, F, I) end)
    end, L),
  gather(Pids, Ref).

do_f(Parent, Ref, F, I) ->
  Parent ! {self(), Ref, (catch F(I))}.
  
gather([Pid|T], Ref) ->
  receive
    {Pid, Ref, Ret} -> [Ret| gather(T, Ref)]
  end;
gather([], _) ->
  [].
   	
pmap1(F, L) ->
  S = self(),
  Ref = erlang:make_ref(),
  lists:foreach(fun(I) ->
    spawn(fun() -> do_f1(S, Ref, F, I) end)
  end, L),
  %% gather the results
  gather1(length(L), Ref, []).
 	
do_f1(Parent, Ref, F, I) ->
  Parent ! {Ref, (catch F(I))}.
 	
gather1(0, _, L) -> L;
gather1(N, Ref, L) ->
  receive
    {Ref, Ret} -> gather1(N-1, Ref, [Ret|L])
  end.

my_tuple_to_list(T) ->
  my_tuple_to_list(T, 1, tuple_size(T)).
  
my_tuple_to_list(T, Pos, Size) when Pos =< Size ->
    [element(Pos, T) | my_tuple_to_list(T, Pos + 1, Size)];
my_tuple_to_list(_T, _Pos, _Size) ->
  [].

my_time_func(F) ->
  Start = erlang:system_time(millisecond),
  F(),
  erlang:system_time(millisecond) - Start.
