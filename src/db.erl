%%  Copyright (C) 2011 - Molchanov Maxim,
%% @author Maxim Molchanov <elzor.job@gmail.com>

-module(db).

-behaviour(supervisor).

%% API
-export([squery/2, equery/3]).
-export([start_link/0]).
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, Pools} = config:get(databases),
    PoolSpecs = lists:map(
                    fun({PoolName, SizeArgs, WorkerArgs}) ->
                        Args = [{name, {local, PoolName}},
                                {worker_module, db_worker}]
                                ++ SizeArgs,
                        poolboy:child_spec(PoolName, Args, WorkerArgs)
                    end,
                    Pools
                ),
    {ok, {{one_for_one, 10, 10}, PoolSpecs}}.

squery(PoolName, Sql) ->
    poolboy:transaction(PoolName, fun(Worker) ->
        gen_server:call(Worker, {squery, Sql})
    end).

equery(PoolName, Stmt, Params) ->
    poolboy:transaction(PoolName, fun(Worker) ->
        gen_server:call(Worker, {equery, Stmt, Params})
    end).