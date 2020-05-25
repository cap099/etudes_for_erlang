-module(etude3).
-export([area/1, area/3]).



%%%%%%%%%%  Etude 3-1 to 3-4  %%%%%%%%%%

area({Shape, X, Y}) ->  area(Shape, X, Y).

area(rectangle,X,Y) when X>= 0, Y >= 0 -> 
    X * Y;
area(triangle, X,Y) when X >= 0, Y >= 0 -> 
    0.5 * X * Y;
area(ellipse, X, Y) when X >= 0, Y >= 0 -> 
    math:pi() * X* Y;
area(_, _, _) -> 
    unknown.
