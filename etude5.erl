-module(etude5).


-export([char_to_shape/1, get_number/1, get_dimensions/2, area/0, date_parts/1]).


%%%%%%%%%%  Etude 5-1  %%%%%%%%%%


area() ->
    Char = io:get_line("R)ectangle, T)riangle, E)llipse >"),
    Shape = char_to_shape(hd(Char)),
    case Shape of
        rectangle -> Dimensions = get_dimensions("height","width");
        triangle -> Dimensions = get_dimensions("base", "height");
        ellipse -> Dimensions = get_dimensions("major axis","minor axis")
    end,
    {X,Y} = Dimensions,
    area(Shape, X, Y).
    
    
char_to_shape(Char) ->
    case Char of 
        $r -> rectangle;
        $R -> rectangle;
        $t -> triangle;
        $T -> triangle;
        $e -> ellipse;
        $E -> ellipse;
         _  -> unknown_shape
    end.

get_number(Prompt) ->
    Num = io:get_line("Enter " ++ Prompt ++ " > "),
    {Test, _ } = string:to_float(Num),
        case Test of
            error -> {N, _} = string:to_integer(Num);
            _ -> N = Test
        end,
        N.


get_dimensions(Prompt1, Prompt2) ->
    N1 = get_number(Prompt1),
    N2 = get_number(Prompt2),
    {N1, N2}.

area(rectangle,X,Y) when X>= 0, Y >= 0 -> 
    X * Y;
area(triangle, X,Y) when X >= 0, Y >= 0 -> 
    0.5 * X * Y;
area(ellipse, X, Y) when X >= 0, Y >= 0 -> 
    math:pi() * X* Y;
area(_, _, _) -> 
    unknown.

%%%%%%%%%%  Etude 5-2  %%%%%%%%%%


date_parts(Date) ->
 [Y, M, D] = re:split(Date, "-", [{return, list}]),
 [element(1, string:to_integer(Y)),
 element(1, string:to_integer(M)),
 element(1, string:to_integer(D))].
