-module(etude9).

-export([mean/1, standard_dev/1, minimum/1, maximum/1, range/1]).

%% Find the mean of a list

-spec(mean(list()) -> number()).

mean(List) ->
    try List of
        _ -> lists:foldl(fun(X,Acc)-> X + Acc end, 0, List) / length(List)
    catch
        List

%% Find the standard deviation of a list

-spec(standard_dev(list()) -> number()).

standard_dev(List) ->
    Squares = [X * X || X <- List],
    Sum = lists:foldl(fun(X, Acc) -> X + Acc end, 0, List),
    SumSquares = lists:foldl(fun(X, Acc) -> X + Acc end, 0, Squares),
    N = length(List),
    math:sqrt(((N * SumSquares) - Sum * Sum)/(N*(N-1))).

%% Recursive function to find minimum in a list

-spec(minimum(list()) -> number()).

minimum(List) ->
    minimum(List, hd(List)).

minimum([], Cur) ->  Cur;

minimum(List, Cur) ->
    if hd(List) < Cur -> 
        minimum(tl(List), hd(List));
    true -> 
        minimum(tl(List), Cur)
    end.


%% Recursive function to find maximum in a list

-spec(maximum(list()) -> number()).

maximum(List) ->
    maximum(List, hd(List)).

maximum([], Cur) ->  Cur;

maximum(List, Cur) ->
    if hd(List) > Cur -> 
        maximum(tl(List), hd(List));
    true -> 
        maximum(tl(List), Cur)
    end.

%% Find range of a list using minimum/1 and maximum/1

-spec(range(list()) -> list()).
range(List) ->
    Min = minimum(List),
    Max = maximum(List),
    [Min,Max].