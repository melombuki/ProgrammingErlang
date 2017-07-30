%%%-------------------------------------------------------------------
%%% @author Josh Hemen <melombuki@MacBookPro.local>
%%% @copyright (C) 2017, Josh Hemen
%%% @doc
%%%
%%% @end
%%% Created : 30 Jul 2017 by Josh Hemen <melombuki@MacBookPro.local>
%%%-------------------------------------------------------------------
-module(jh_bank).

-behaviour(gen_server).

%% API
-export([start_link/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
	 terminate/2, code_change/3]).

-export([new_account/1, deposit/2, withdraw/2]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API
%%%===================================================================

new_account(Who) ->
    gen_server:call(?MODULE, {new, Who}).

deposit(Who, Amount) ->
    gen_server:call(?MODULE, {add, Who, Amount}).

withdraw(Who, Amount) ->
    gen_server:call(?MODULE, {remove, Who, Amount}).

%%--------------------------------------------------------------------
%% @doc
%% Starts the server
%%
%% @spec start_link() -> {ok, Pid} | ignore | {error, Error}
%% @end
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Initializes the server
%%
%% @spec init(Args) -> {ok, State} |
%%                     {ok, State, Timeout} |
%%                     ignore |
%%                     {stop, Reason}
%% @end
%%--------------------------------------------------------------------
init([]) ->
    process_flag(trap_exit, true),
    {ok, ets:new(?MODULE, [])}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling call messages
%%
%% @spec handle_call(Request, From, State) ->
%%                                   {reply, Reply, State} |
%%                                   {reply, Reply, State, Timeout} |
%%                                   {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, Reply, State} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_call({new, Who}, _From, Tab) ->
    Reply = case ets:lookup(Tab, Who) of
		[] -> ets:insert(Tab, {Who, 0}),
		      {welcome, Who};
		[_] -> {Who, you_already_are_a_customer}
	    end,
    {reply, Reply, Tab};
handle_call({add, Who, Amount}, _From, Tab) ->
    Reply = case ets:lookup(Tab, Who) of
		[]  -> not_a_customer;
		[{Who,Balance}] ->
		    NewBalance = Balance + Amount,
		    ets:insert(Tab, {Who, NewBalance}),
		    {thanks, Who, your_balance_is,  NewBalance}	
	    end,
    {reply, Reply, Tab};
handle_call({remove, Who, Amount}, _From, Tab) ->
    Reply = case ets:lookup(Tab, Who) of
		[]  -> not_a_customer;
		[{Who,Balance}] when Amount =< Balance ->
		    NewBalance = Balance - Amount,
		    ets:insert(Tab, {Who, NewBalance}),
		    {thanks, Who, your_balance_is,  NewBalance};	
		[{Who,Balance}] ->
		    {sorry,Who,you_only_have,Balance,in_the_bank}
	    end,
    {reply, Reply, Tab};
handle_call(stop, _From, Tab) ->
    {stop, normal, stopped, Tab}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling cast messages
%%
%% @spec handle_cast(Msg, State) -> {noreply, State} |
%%                                  {noreply, State, Timeout} |
%%                                  {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%%
%% @spec terminate(Reason, State) -> void()
%% @end
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%%
%% @spec code_change(OldVsn, State, Extra) -> {ok, NewState}
%% @end
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
