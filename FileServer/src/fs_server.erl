-module(fs_server).

-export([start/1, loop/1]).

start(Dir) ->
  spawn(fs_server, loop, [Dir]).

loop(Dir) ->
  receive
    {Client, list_dir} ->
      Client ! {self(), file:list_dir(Dir)};
    {Client, {get_file, File}} ->
      Full = get_full_name(Dir, File),
      Client ! {self(), file:read_file(Full)};
    {Client, {put_file, FileName, Contents}} ->
      Full = get_full_name(Dir, FileName),
      Client ! {self(), file:write_file(Full, Contents)};
    {Client, {delete_file, FileName}} ->
      Full = get_full_name(Dir, FileName),
      Client ! {self(), file:delete(Full)}
  end,
  loop(Dir).

get_full_name(Dir, FileName) ->
  filename:join(Dir, FileName).