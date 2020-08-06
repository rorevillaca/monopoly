### What are the best places to buy in Monopoly?

I recently played Monopoly with my friends. I had not played in a very long time and ended up devising a strategy on the go, which lead me to loose after three pretty frustrating hours. I decided to make an analysis in order to deterime what properties provide their owner the best revenue.

#### Landing Probabilities

The first step in my approach was to determine the landing probabilities for each tile in the game. For this, I took into consideration several factors: 
* Landing on spaces as a product of dice rolls
* Landing on spaces due to the instructions on Community Chest and Chance cards
* Going to jail for landing on the "Go to Jail" space
* Going to jail for rolling three doubles in a row

I integrated the board, dice and special rules in an OOP Python script that generates random games. The simulator obtains all the spaces where a player lands on on a game, including when he is rerouted. For example, if he lands on the "Go To Jail" tile, both the landing tile and the "Jail" tile are added to the list. I ran the simulation 500,000 times and visualized the results on R:

<p align="center">
  <img src="monopoly_probabilities.png" />
</p>

The results are pretty interesting. The two most landed spaces on the board are "Go" and "Jail". This makes sense, as there are several events that lead to being redirected to these spaces. If landing on the "Jail" space is so common, it is logical that the following spaces are also visited a lot. In particular, Illinois Avenue is the most visited property on the board, followed by New York Avenue, Tennessee Avenue and the B. & O. Railroad. Great! The high probability associated with the Orange and Red groups make them the best investment in the game, right?

Well, yes and no. As a rough first answer, they are a good investment. Having these properties means that players getting out of jail will very likely fall on them. However, adding other variables to the analysis will provide a more accurate answer...

---

#### Property Payback

Let´s now dive into the world of finance. I obtained the costs and rents associated to each one of the properties on board from [this](https://monopoly.fandom.com/wiki/Property)  Wiki. In the following plot, I present the net amount of money produced by each property when someone lands on it, without buildings. This provides us with a general grasp of the properties and their groups:
* The brown group has the cheapest properties, but with the lowest long-term payback.
* The blue group has the most expensive properties, and the highest payback. Note that this properties are also the ones that most rapidly pay themselves back.
* The rest of the colors (green, yellow, red, orange, pink and blue) fall in between, in that particular order.

<p align="center">
  <img src="payback_no_buidlings.png" />
</p>

---

<p align="center">
  <img src="payback_w_prob_no_b.png" />
</p>

---

<p align="center">
  <img src="payback_w_prob_1_hotel.png" />
</p>

---

<p align="center">
  <img src="rolls_color_group_1_hotel.png" />
</p>
