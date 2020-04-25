# Monopoly
Probabilities for the Monopoly board game

This piece of codes determines the probability of landing on a particular square in the standard UK version of Monopoly by establishing a matrix of Markov chains and solving using eigenvector matrix algebra.  The premise of a Markov chain is that the next state is independent of all previous states it only depends on the current state.

Methodology
The probability of moving from any square on the board to any other is entirely deterministic: it is solely dependent upon the probability of rolling a particular score or receiving a particular instruction from a game card or space, all of which can be calculated. 
The probability of arriving at a particular square is the probability of being on any square multiplied by the probability of moving from that square to the particular square, summed over all possible squares.  

For example, with i = Go:
	p(Go) = p(Go)  ×  p(move from Go to Go) 
		+ p(Old Kent Rd)  ×  p(move from Old Kent Rd to Go) 
		+ p(C.Chest)  ×  p(move from C.Chest to Go)
		+ p(Whitechapel)  ×  p(move from Whitechapel to Go)
		+  (for each space)
		+ p(Mayfair)  ×  p(move from Mayfair to Go)

A corresponding set of equations may be written for every square on the board.  This forms a set of simultaneous linear equations, where the p(Go) calculated in the first equation is the same term as p(Go) that occurs in all the other formulae.  All the equations are interdependent and at first sight appear so convoluted as to be impossible to untangle and solve.  However, a method exist for evaluating such systems of equations.  

Given a  41x41 (Just Visiting and In Jail share the same square on the real board, hence there are 41 distinct sites versus 40 squares on the board) matrix of static probabilities [P] is a Markov chain of the transition probabilities from site i (say Go) to site j (Go through to Mayfair). 

    P = [ p(move from Go to Go) , p(move from Old Kent Rd to Go) ...
            p(move from Go to Old Kent Rd) , p(move from Old Kent Rd to Old Kent Rd) ...
            p(move from Go to C.Chest) , p(move from Old Kent Rd to C.Chest) ...
            ...
            p(move from Go to Mayfair) , p(move from Old Kent Rd to Mayfair) ...]

and [v] is the 41x1 vector matrix of probabilities for landing on a particular square: 

    v = [ p(Go) 
            p(Old Kent Rd) 
            p(C.Chest) 
            ...
            p(Mayfair) ]


We need to solve for the steady state vector [v] that has the probability of landing on each site such that:

[P] [v] = λ [v]

([P] – λ[I]) [v] = 0

In this case [v] is a column matrix of the eigenvectors of [P] with eigenvalue of 1 and [I] the identity matrix.  In order to establish the probabilities for each site we then normalise [v] such that its contents sum to 100%.  


Constructing the P-Matrix
For each site on a Monopoly board there is a set of probabilities for landing on the next site, the basic set of 11 possible locations (the outcome of rolling two six-side die) needs to be adjusted for the likelihood of rolling three consecutive doubles (1/216) and thereby going straight to jail before adding the possible movement impacts of Chance and Community Chest cards.

Jail Strategies
In any one turn, a player who is in jail may:
    1. Leave by rolling a double
    2. Leave by paying the fine and rolling the dice
    3. Remain in jail

Hence there is an element of player strategy which will influence any move that is made from being in Jail.  At the beginning of a game it is generally considered better to pay the fine straight away, allowing more chances to purchase available properties.  As the game progresses, and more property is developed, a longer jail term is an attractive way to avoid paying hefty rents and players are more likely to try to stay in jail for the maximum of three turns (hopefully avoiding a double to get out of jail early).  However, there is no way of predicting how a player will act and therefore no real way to model individual player strategies.  
It was decided that, since the probabilities being calculated are the long term averages, the jail strategy would match that of a player in a developed game. 
The probabilities of the site landed on after being in jail (before any adjustments for subsequent moves required by Chance or Community Chest) are shown below.  Note that sites which can be reeached by a double being thrown from Jail, are now more likely to be landed on, compared to the probabilities from Just Visiting.

Chance and Community Chest Cards 
In addition to the moves derived from rolling the dice, players can move depending on the outcome from the Chance and Community Chest cards.  In the event of the player landing on one of the card sites, the probabilities need to be adjusted to reflect the possibility that the player may eventually end up on another site (eg “Advance to Go”).  Hence if the raw probability of landing on a Chance is 16%, the probability needs to be adjusted to 9% (9/16 of the raw figure, since 9 out of the 16 Chance cards have no further movement impact) and the probability of landing on Go, Pall Mall, Marylebone Station, Trafalgar Square, Mayfair, In Jail and Go Back Three Spaces need to each be increased by 0.0625% (1/16).


After solving for the eigenvalue matrix [v] we can see the probabilities of landing on each square during the game.  In Jail, with its multiple routes (Chance, Community Chest, Go To Jail square, Three doubles) from all squares, is the most popular site.  Go To Jail (between Yellow and Green groups) is zero, since players relocated to Jail immediately.  The Chance and Community Chest squares are low probabilities since players often advanced to other squares.  Trafalgar Square is the most popular square that can be purchased, helped by an “Advance to Trafalgar Square” Chance card and benefiting from players being sent to Jail and therefore possibly having to pass Trafalgar Square a second time .  The single most likely trip from any square is the final Community Chest site (amongst the Green group) to Go – on 17.6% occasions players will land up on Go.

The group of four Stations is the most popular group,however acquiring all four stations remains a challenge.  Jail has a significant impact on popularity of sites and hence the Orange,Red and Yellow groups benefit – these groups have a strong chance of being passed twice in a player's lap of the board if he is sent back to Jail.  The two Dark Blue sites remain the least attractive, Mayfair is helped by “Advance to Mayfair” card.



