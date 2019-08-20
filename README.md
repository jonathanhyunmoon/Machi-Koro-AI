# Machi-Koro-AI

Authors: Winice Hui (wh394), Jonathan Hyun Moon (hm447), Jason Jung (jj634)

I. Intended Projects and Results

The aim of this project was to implement an AI program for the card game Machi Koro. Machi Koro is a city-building card
game about buying property, creating an income, and ultimately purchasing four landmarks (seven total landmarks in the
Harbor expansion pack) to win the game. The number of players for this game ranges from 2-4 players.

To give a sense of the decisions a player faces, we will briefly discuss strategy. While the search space only includes
the bank of unowned properties, the player must consider how the possible purchases align with its already owned property.
The relative value of each card changes throughout the game and may be dependent on other cards. Additionally, the benefits
of certain purchases might not be clear or profitable until many turns down the game. Overall, considering the 276 total
cards, the delayed reward of purchases, and the multitude of strategies and build orders a player may employ, Machi Koro
presented an interesting challenge. 

II. Implementation

The user-interface and game-play implementation of Machi Koro were coded in OCaml previously by a team member. An AI
decision-making process in Java was added to function in conjunction with this. This is done using a single JSON file
containing either the initial state given by OCaml or the modified state given by Java, as well as a control bit signifying
which of these states the file is in.
The agent’s main role in our game was to decide for a player which establishment or landmark card to purchase or whether to
purchase no card at all. This decision-making process was approached using a Monte Carlo Tree Search (MCTS). We decided to
use a MCTS for our decision-making process specifically because (1) Machi Koro has a large search space (2) the most optimal
move at one node, does not necessarily mean it is the most optimal later on and therefore a good AI would consider not just
the perceived optimal strategy (exploitation), but also continually evaluate other alternate strategies by executing them
(exploration) as well and (3) we wanted to be able to give our AI a state, and have it select the next best move. This
heuristic search algorithm played a major role in our AI decision process.


III. Tweaks to MCTS

1. Expected value function
While implementing a game and its rules in its entirety (for the simulation phase) is what is typically done in Monte Carlo
Tree Search, Machi Koro differs for a few reasons. Machi Koro is a non-deterministic game, and the first few rolls often have
a compounding effect, allowing the player to continuously capitalize on their income advantage. Additionally, there exist a
few moves beyond the purchase decision, such as those required by certain major establishments and landmarks. Having to
consider these would significantly increase the branching factor and require longer simulations to acquire a similar level of
confidence in a decision.

The solution used is an expected value function, which returns the expected income per turn for any given Landmark or
Establishment. These would be summed, added to the player, and subtracted from the bank to represent the income phase.

Creating this was tricky, as most cards have some sort of nuance to them. Each card color is activated depending on whether
the owner is the current player, and restaurants steal from the current player only. Cards activated on rolls of 7 or more
are useless unless the Train Station has been constructed. There are many “multiplying” type cards, whose value depends on
the number of another card or cards owned (such as the Furniture Factory). Certain Harbor establishments provide value only
if the Harbor landmark is owned. Most difficult to approximate, however, were the cards involving some sort of decision. In
some cases, parameters were used representing the frequency of one decision versus another, as in the Train Station. In
others, their probabilities of activation were calculated. For example, the Amusement Park allows the player to take
another turn if a double is rolled, so the original income is multiplied by (1 + ⅙), ⅙ being the probability of landing
doubles. While there were many more approximations made, these were a few highlights of the major ones; please refer to
classes “State” under package Components and “Heuristics” under package AI for the full implementation.

2. Eliminating unrealistic playouts
During the simulation phase, there were often unrealistic situations by the random playout. While exploring every possible
option is a critical part of Monte Carlo Tree Search, it was decided that some situations would never occur in a real
game. The anomalous situations arose when a player would own hundreds of coins and have only a couple remaining landmarks to
purchase. This happens when a simulated player with a high income repeatedly opts to purchase nothing, amassing a huge bank.
The child states function was altered such that if the player has more coins than the cost of the most expensive card in the
game (Airport: 30), meaning that they can buy any card, only return the purchasable landmarks.

3. Scaled UCT values
The max depth parameter serves to scale the propagated win value. Wins at nodes with high depths are valued less over wins at
nodes with low depths; lower-depth wins are more likely to occur, and should be further explored by the UCT function. This
was implemented by scaling the win_value by the reciprocal of the depth.

4. Landmark buff
Our UCT function was slightly modified with the addition of a landmark buff factor of 1.05, to account for the fact that
landmarks are relatively better for purchase, as their construction make up a player’s win. This may seem somewhat arbitrary
and against the ideals of a Monte Carlo simulation. In practice, however, this buff makes no difference when comparing a
landmark with a few visits to another option with far more visits; it is only relevant when weighing a landmark and an
apparently equal option.
