-module(etude6).

-export([minimum/1, maximum/1, range/1, julian/1, alert/1, generate_teeth/2, teeth_test/0]).


%%%%%%%%%%  Etude 6-1  %%%%%%%%%%

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


%%%%%%%%%%  Etude 6-2  %%%%%%%%%%

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


%%%%%%%%%%  Etude 6-3  %%%%%%%%%%

%% Set of functions to find what day of the year a date is

%% Returns boolean notating if a given year is a leap year

-spec(is_leap_year(integer()) -> boolean()).

is_leap_year(Year) ->
    (Year rem 4 == 0 andalso Year rem 100 /= 0)
    orelse (Year rem 400 == 0).

%% Takes input and calls helper functions

-spec(julian(string()) -> integer()).

julian(Date) ->
    DaysPerMonth = [31,28,31,30,31,30,31,31,30,31,30,31],
    DateList = etude5:date_parts(Date),
    julian(lists:nth(1,DateList), lists:nth(2,DateList), 
                    lists:nth(3,DateList), DaysPerMonth, 0).

%% Helper function to sum days passed in each month

-spec(julian(integer(), integer(), integer(), list(), integer()) -> integer()).

julian(Year, Month, Day, DaysPerMonth, Total) when 14 - length(DaysPerMonth) > Month ->
    case Month > 2 andalso is_leap_year(Year) of
        true -> TotalDays = Total + 1 + Day;
        false -> TotalDays = Total + Day
    end,
    TotalDays;

julian(Year, Month, Day, DaysPerMonth, Total) ->
    NewTotal = hd(DaysPerMonth) + Total, 
    julian(Year, Month, Day, tl(DaysPerMonth), NewTotal).


%%%%%%%%%%  Etude 6-4  %%%%%%%%%%

%% Recursive Function to Alert user that input teeth pocket depths show a bad tooth

-spec(alert(list()) -> list()).

alert(TeethDepths) -> alert(TeethDepths, 1, []).

%% helper function to alert user that input teeth pocket depths show a bad tooth

-spec(alert(list(), number(), list()) -> list()).

alert([], _, Result) -> lists:reverse(Result);

alert(ListofLists, Count, TeethAlert) ->
    Tail = tl(ListofLists),
    OneTooth = hd(ListofLists),
    case maximum(OneTooth) >= 4 of
        true -> alert(Tail, Count + 1, [Count|TeethAlert]);
        false -> alert(Tail, Count + 1, TeethAlert)
    end.

%%%%%%%%%%  Etude 6-5  %%%%%%%%%%

%% Set of functions to generate random Teeth Pocket Depths

-spec(generate_teeth(string(), number()) -> list()).

generate_teeth(TFString, P) -> generate_teeth(TFString, P, []).

%% Helper function for generate_teeth/1

-spec(generate_teeth(list(), number(), list()) -> list).

generate_teeth([], _, ResultList) -> lists:reverse(ResultList);

generate_teeth([$T|Tail], P, ResultList) -> generate_teeth(Tail, P, [generate_tooth(P)|ResultList]);

generate_teeth([$F|Tail], P, ResultList) -> generate_teeth(Tail, P, [[0]|ResultList]).

%% Helper function that randomly decides if a tooth is bad

-spec(generate_tooth(number()) -> list(integer())).

generate_tooth(P) ->
    Num = rand:uniform(),
    case Num > P of 
        true -> BaseDepth = 3;
        false -> BaseDepth = 2
    end,
    generate_tooth(BaseDepth, 6, []).


%%  Helper function that randomly decides which of the six pockets are bad

-spec(generate_tooth(number(), number(), list()) -> list()).

generate_tooth(_, 0, ResultList) -> ResultList;

generate_tooth(BaseDepth, NumLeft, ResultList) ->
    Offset = rand:uniform(3),
    ToothDepth = (Offset - 2) + BaseDepth,
    generate_tooth(BaseDepth, NumLeft - 1, [ToothDepth|ResultList]).

%% Testing functions, taken from solutions of Etudes for Erlang

teeth_test()->
    TFList = "FTTTTTTTTTTTTTTFTTTTTTTTTTTTTTTT",
    N = generate_teeth(TFList, 0.75),
    print_tooth(N).

print_tooth([]) -> io:format("Finished ~n");
print_tooth([H|T]) ->
    io:format("~p~n", [H]),
    print_tooth(T).