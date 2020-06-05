%%%-------------------------------------------------------------------
%% @doc echo_server public API
%% @end
%%%-------------------------------------------------------------------

-module(echo_server_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    echo_server_sup:start_link(),

    {ok, Env} = file:consult("rebar.config"),

    {port, Port} = hd(Env),

    echo_server:start_server(Port).

stop(_State) ->
    ok.

%% internal functions
