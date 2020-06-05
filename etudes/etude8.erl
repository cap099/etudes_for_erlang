-module(etude8).
-export([war/0, dealer/0, dealer/6, player/2, compare/2, convert/1]).

%% Player process - sends cards when asked, picks up cards, tracks which cards are held
%% Dealer process - asks and is sent correct number of cards, creates deck, shuffles, checks for winner, tells correct player to pick up cards
                %% - tracks which cards are in the Pile, spawns players and does all initialization

%% value function - 2 inputs, notates which input is greater

%% how many function - if pile is empty send 1 card, if not send 3

%% Phases:
    % ask for cards
    % wait for cards
    % battle (compare cards)
    % return cards


war() -> spawn(etude8, dealer, []).


dealer() -> 
    %%rand:seed(now()),
    Deck = etude7:shuffle(etude7:make_deck()),   % initialize 2 randomized decks of 26 cards
    {P1_cards, P2_cards} = lists:split(26, Deck),

    P1 = spawn(etude8, player, [self(), P1_cards]),
    P2 = spawn(etude8, player, [self(), P2_cards]),  %% spawn players and send decks


    io:format("Spawned players ~p and ~p with 26 cards each~n~n",[P1,P2]),

    dealer([],[], [P1, P2], ask_for_cards, [], 0).  % await cards




dealer(P1_hand, P2_hand, PlayerPids, Phase, Pile, Count) ->
    [P1, P2] = PlayerPids,
    case Phase of 
        ask_for_cards -> 
            io:format("Asking players for ~p card(s) for battle ~n~n", [num_cards(Pile)]),
            timer:sleep(3000),
            lists:map(fun(X) -> X ! {send_cards, num_cards(Pile)} end, PlayerPids),
            dealer(P1_hand,P2_hand, PlayerPids, receive_cards, Pile, 0);
        
        receive_cards ->
            io:format("Waiting for cards from players ~n~n"),
            timer:sleep(3000),
            receive 
                {Pid, Card} -> 
                    case Pid of
                        P1 -> P1_new_hand = Card, P2_new_hand = P2_hand,
                        io:format("Received a ~p from P1~n~n", [Card]),
                        timer:sleep(3000);
                        P2 -> P1_new_hand = P1_hand, P2_new_hand = Card,
                        io:format("Received a ~p from P2~n~n", [Card]),
                        timer:sleep(3000)
                    end
            end,
            if
                Count + 1 =:= 2 ->  NextPhase = battle;
                Count + 1 /= 2 -> NextPhase = receive_cards
            end,
            dealer(P1_new_hand, P2_new_hand, PlayerPids, NextPhase, Pile, Count + 1);


        battle ->
            io:format("Begin battle! ~n~n"),
            timer:sleep(3000),
            Result = compare(P1_hand, P2_hand),
            Newpile = Pile ++ P1_hand ++ P2_hand,
            case Result of
                player1_win ->
                    P1 ! {take_cards, Newpile},
                    io:format("Player 1 wins the battle~n~n"),
                    io:format("P1 winnings: ~p~n~n", [Newpile]),
                    timer:sleep(5000),
                    dealer(P1_hand, P2_hand, PlayerPids, confirm, [], 0);

                player2_win ->
                    P2 ! {take_cards, Newpile},
                    io:format("Player 2 wins the battle~n~n"),
                    io:format("P2 winnings: ~p~n~n", [Newpile]),
                    timer:sleep(5000),
                    dealer(P1_hand, P2_hand, PlayerPids, confirm, [], 0);

                war -> 
                    io:format("DON'T YOU KNOW WE'RE AT WAAAAR~n~n"),
                    dealer([], [], PlayerPids, ask_for_cards, Newpile, 0)
            end;

    confirm ->
        io:format("Awaiting confirmation of player receiving cards~n~n"),
        timer:sleep(3000),
        receive
            {confirmed, _Pid, _Data} ->
            io:format("Confirmation received! ~n~n"),
            io:format("%%%%%%%%%%%%%%% NEXT ROUND %%%%%%%%%%%%%%% ~n~n"),
            dealer([], [], PlayerPids, ask_for_cards,[], 0)
        end
end.





player(DealerPid, Hand) ->
    receive
        {Command, Data}  ->    
            case Command of 
                send_cards ->  {ToSend, _} = lists:split(Data, Hand),
                DealerPid ! {self(), ToSend}, io:format("~p Sending cards~n~n", [self()]),
                NewHand = Hand;

                take_cards ->  
                    io:format("~p now has ~p cards~n", [self(),length(Data) + length(Hand)]),
                    NewHand = Hand ++ Data,
                    DealerPid ! {confirmed, self(), []}
            end
    end,
    player(DealerPid, NewHand).




num_cards([]) -> 1;
num_cards(_) -> 3.

compare(P1_hand, P2_hand) ->
    P1_card = convert(hd(P1_hand)),
    P2_card = convert(hd(P2_hand)),
    if 
        P1_card > P2_card -> io:format("Player 1 has a ~p and Player 2 has a ~p ~n~n", [P1_card, P2_card]), player1_win;
        P2_card > P1_card -> io:format("Player 1 has a ~p and Player 2 has a ~p ~n~n", [P1_card, P2_card]), player2_win;
        P1_card == P2_card -> io:format("Player 1 has a ~p and Player 2 has a ~p ~n~n", [P1_card, P2_card]), war
    end.

convert({Card, _}) ->
    case Card of 
        $A -> 14;
        $K -> 13;
        $Q -> 12;
        $J -> 11;
        _ -> Card
    end.

    
