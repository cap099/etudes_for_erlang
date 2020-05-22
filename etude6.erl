-module(etude6).

-export([minimum/1, maximum/1, range/1, julian/1]).

minimum(List) ->
    minimum(List, hd(List)).

minimum([], Cur) ->  Cur;

minimum(List, Cur) ->
    if hd(List) < Cur -> 
        minimum(tl(List), hd(List));
    true -> 
        minimum(tl(List), Cur)
    end.



maximum(List) ->
    maximum(List, hd(List)).

maximum([], Cur) ->  Cur;

maximum(List, Cur) ->
    if hd(List) > Cur -> 
        maximum(tl(List), hd(List));
    true -> 
        maximum(tl(List), Cur)
    end.

range(List) ->
    Min = minimum(List),
    Max = maximum(List),
    [Min,Max].

is_leap_year(Year) ->
    (Year rem 4 == 0 andalso Year rem 100 /= 0)
    orelse (Year rem 400 == 0).

julian(Date) ->
    DaysPerMonth = [31,28,31,30,31,30,31,31,30,31,30,31],
    DateList = etude5:date_parts(Date),
    julian(lists:nth(1,DateList), lists:nth(2,DateList), 
                    lists:nth(3,DateList), DaysPerMonth, 0).

julian(Year, Month, Day, DaysPerMonth, Total) when 14 - length(DaysPerMonth) > Month ->
    case Month > 2 andalso is_leap_year(Year) of
        true -> TotalDays = Total + 1 + Day;
        false -> TotalDays = Total + Day
    end,
    TotalDays;

julian(Year, Month, Day, DaysPerMonth, Total) ->
    NewTotal = hd(DaysPerMonth) + Total, 
    julian(Year, Month, Day, tl(DaysPerMonth), NewTotal).