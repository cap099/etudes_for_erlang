-module(etude4).

-export([area/3, gcd/2, raise/2, raise_tail/2, raise/3, nth_root/2, nth_root/3]).

%%%%%%%%%%  Etude 4-1  %%%%%%%%%%

%% Update function from chapter 3 to use a 'case of' statement

-spec(area(atom(), number(), number()) -> number()).
area(Shape, X, Y) ->
    case Shape of
        rectangle when X >= 0 , Y >= 0 ->
            X * Y;
        triangle when X >=0, Y >= 0 ->
            (X * Y) / 2;
        ellipse when X >= 0, Y >= 0 ->
            math:pi() * X * Y;
        _ ->
            'unknown shape'
    end.

%%%%%%%%%%  Etude 4-2  %%%%%%%%%%

%% Recursive function to find Greatest Common Divisor of two integers

-spec(gcd(number(), number()) -> number()).
gcd(M,N) when M >=0, N >=0 ->
    if M =:= N -> M;
       M > N -> gcd(M-N, N);
       M < N -> gcd(M, N - M)
    end. 

%%%%%%%%%%  Etude 4-3  %%%%%%%%%%

%% Recursive function to find X to the N power

-spec(raise(number(), integer()) -> number()).
raise(X,N) ->
    if  N =:= 0 -> 1;
        N =:= 1 -> X;
        N  > 0 -> X * raise(X,N-1);
        N  < 0 -> 1 / raise(X,-N)
    end.

%%%%%%%%%%  Etude 4-4  %%%%%%%%%%

%% Tail recursive function to find X to the N power

-spec(raise_tail(number(), integer()) -> number() ).
raise_tail(X,N) ->
    if  N =:= 0 -> 1;
        N < 0 -> 1 / raise(X,-N);
        N > 0 -> raise(X,N,1)
    end.

raise(X,N,Acc) ->
    if  N =:= 0 -> Acc;
        true -> raise(X,N-1,X*Acc)
    end.


%%%%%%%%%%  Etude 4-5  %%%%%%%%%%

%% Recursive Function to find Nth root of X

-spec(nth_root(number(), integer()) -> number()).
nth_root(X, N) -> nth_root(X, N, X/2).

nth_root(X, N, A) ->
    io:format("Current guess is ~p~n", [A]),
    F = math:pow(A,N) - X,
    Fprime = N * math:pow(A, N-1),
    Next = A - F / Fprime,
    
    Change = abs(Next - A),
    if Change < 1.0e-8 -> Next;
        true -> nth_root(X,N, Next)
    end.
