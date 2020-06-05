%% Reverse Polish Notation Calculator from Chapter X in LYSE



-module(rpn).

-export([calc/1]).

calc(Input) when is_list(Input)->
   [Res] = lists:foldl(fun calc/2, [], string:tokens(Input, " ")),
   Res.

calc("+", [N1,N2|S]) -> [N2 + N1|S];
calc("-", [N1,N2|S]) -> [N2 - N1|S];
calc("*", [N1,N2|S]) -> [N2 * N1|S];
calc("/", [N1,N2|S]) -> [N2 / N1|S];

calc(X, Stack) -> [read(X)|Stack].


read(N) -> 
    case string:to_float(N) of 
        {error, no_float} -> list_to_integer(N);
        {F, _} -> F 
    end.


    