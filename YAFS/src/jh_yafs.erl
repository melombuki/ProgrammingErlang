-module(jh_yafs).
-export([start/0, start/1, ls/0, ls/1, put_file/2, put_file/3,
        read_file/1, read_file/2, delete_file/1, delete_file/2]).

-define(SERVER, ?MODULE).

-record(state, {default_dir}).

start() ->
    {ok, Dir} = file:get_cwd(),
    register(?SERVER, Pid = spawn(fun() -> loop(#state{default_dir = Dir}) end)).

start(Dir) ->
    true = filelib:is_dir(Dir),
    register(?SERVER, Pid = spawn(fun() -> loop(#state{default_dir = Dir}) end)).

ls() ->
  rpc({list_dir}).

ls(Dir) ->
  rpc({list_dir, Dir}).

get_cwd() ->
  rpc({get_cwd}).

put_file(Filename, Contents) ->
    rpc({put_file, Filename, Contents}).

put_file(Dir, Filename, Contents) ->
    rpc({put_file, Dir, Filename, Contents}).

read_file(Filename) ->
    rpc({read_file, Filename}).

read_file(Dir, Filename) ->
    rpc({read_file, Dir, Filename}).

delete_file(Filename) ->
  rpc({delete_file, Filename}).

delete_file(Dir, Filename) ->
  rpc({delete_file, Dir, Filename}).

rpc(Q) ->
    ?SERVER ! {self(), Q},
    receive
      {?SERVER, Reply} ->
          Reply
    end.

loop(State) ->
    receive
        {From, {list_dir}} ->
            From ! {?SERVER, file:list_dir(State#state.default_dir)},
            loop(State);
        {From, {list_dir, Dir}} ->
            From ! {?SERVER, file:list_dir(Dir)},
            loop(State);
        {From, {get_cwd}} ->
            From ! {?SERVER, file:get_cwd()},
            loop(State);
        {From, {put_file, Filename, Contents}} ->
            Full = get_full_name(State#state.default_dir, Filename),
            From ! {?SERVER, file:write_file(Full, Contents)},
            loop(State);
        {From, {put_file, Dir, Filename, Contents}} ->
            true = filelib:is_dir(Dir),
            Full = get_full_name(Dir, Filename),
            From ! {?SERVER, file:write_file(Full, Contents)},
            loop(State);
        {From, {get_file, Filename}} ->
            Full = get_full_name(State#state.default_dir, Filename),
            From ! {?SERVER, file:read_file(Full)},
            loop(State);
        {From, {get_file, Dir, Filename}} ->
            true = filelib:is_dir(Dir),
            Full = get_full_name(Dir, Filename),
            From ! {?SERVER, file:read_file(Full)},
            loop(State);
        {From, {delete_file, Filename}} ->
            Full = get_full_name(State#state.default_dir, Filename),
            From ! {?SERVER, file:delete(Full)},
            loop(State);
        {From, {delete_file, Dir, Filename}} ->
            true = filelib:is_dir(Dir),
            Full = get_full_name(Dir, Filename),
            From ! {?SERVER, file:delete(Full)},
            loop(State)
    end.

get_full_name(Dir, Filename) ->
  filename:join(Dir, Filename).