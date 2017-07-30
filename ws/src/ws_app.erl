%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(ws_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.
start(_Type, _Args) ->
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/", cowboy_static, {priv_file, ws, "index.html"}},
			{"/websocket", ws_handler, #{msg => "You rang, sir?"}},
			{"/static/[...]", cowboy_static, {priv_dir, ws, "static"}}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, [{port, 8080}], #{
		env => #{dispatch => Dispatch}
	}),
	ws_sup:start_link().

stop(_State) ->
	ok.