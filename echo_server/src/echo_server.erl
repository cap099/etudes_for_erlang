%% This code was mostly taken from the book 'Learn You Some Erlang For Great Good!' 
%% This is an implementation of a TCP echo server that also uses rebar3


-module(echo_server).
-export([start_server/1]).

start_server(Port) ->
    Pid = spawn_link(
        fun() -> 
            {ok, Listen} = gen_tcp:listen(Port, [binary, {active, false}]),
            spawn(fun() -> acceptor(Listen) end),
            timer:sleep(infinity)
            end
    ),
    {ok, Pid}.
 
acceptor(ListenSocket) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    spawn(fun() -> acceptor(ListenSocket) end),
    handle(Socket).
 
%% Echoing back whatever was obtained
handle(Socket) ->
    inet:setopts(Socket, [{active, once}]),
    receive
        {tcp, Socket, <<"quit", _/binary>>} ->
            gen_tcp:close(Socket);
        {tcp, Socket, Msg} ->
            gen_tcp:send(Socket, Msg),
        handle(Socket)
    end.