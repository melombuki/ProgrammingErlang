-module(fs_client).

-export([ls/1, get_file/2, put_file/3, delete_file/2]).

ls(Server) ->
  Server ! {self(), list_dir} ,
  receive
    {Server, FileList} ->
      FileList
  end.

get_file(Server, FileName) ->
  Server ! {self(), {get_file, FileName}},
  receive 
    {Server, Content} ->
      Content
  end.

put_file(Server, FileName, Contents) ->
  Server ! {self(), {put_file, FileName, Contents}},
  receive
    {Server, Message} ->
      Message
  end.

delete_file(Server, FileName) ->
  Server ! {self(), {delete_file, FileName}},
  receive
    {Server, Message} ->
      Message
  end.