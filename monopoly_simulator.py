import random
import string
import csv

class Player(object):
    def __init__(self):
        '''
        Initializes a Player object
        Has no inputs and five attributes:
            landed spaces: List containing all landed-on spaces for player
            turns: Int with the total number of turns taken 
            doubles_count: Temporal count for the number of doubles
            current_position: Position after taking a turn
            chance_cards: list representing 16 cards
            community_chest_cards: list representing 17 cards
            end_game: boolean to control when game ends (when there are no cards left)
        '''
        self.landed_spaces = [0]
        self.turns = 0       
        self.doubles_count = 0
        self.current_position = 0
        self.chance_cards = list(string.ascii_uppercase[0:16])
        random.shuffle(self.chance_cards)
        self.community_chest_cards = list(string.ascii_lowercase[0:17])
        random.shuffle(self.community_chest_cards)
        self.end_game = False

    def take_turn(self):
        '''
        Used to simulate taking a turn
        '''
        special_condition = False
        self.turns += 1 #Increases turn count
        die_one = random.randint(1, 6) #Rolls die
        die_two = random.randint(1, 6) #Rolls die
        roll_total = die_one + die_two #Adds up both dice
        last_position = self.landed_spaces[-1] #Recovers position before rolling dice
        self.current_position = (last_position + roll_total)%40 #Calculates position after rolling dice, considering the board "loop"

        #Checks wether doubles were rolled
        if die_one == die_two: 
            self.doubles_count +=1
            #print("doubles! "+str(die_one)+", "+str(die_two))
        else:
            self.doubles_count = 0 

        if self.current_position in [2,7,17,22,30,33,36]: #Special positions
            special_condition =True
            new_position = 0
            if self.current_position in [7,22,36]: #Chance card
                drawn_card = self.chance_cards.pop(0)
                if drawn_card == "A":
                    new_position = 0
                elif drawn_card == "B":
                    new_position = 24
                elif drawn_card == "C":
                    new_position = 11
                elif drawn_card == "D":
                    if self.current_position == 22:
                        new_position = 28
                    else:
                        new_position = 12
                elif drawn_card == "E":
                    if self.current_position == 7:
                        new_position = 15
                    elif self.current_position == 22:
                        new_position = 25
                    else:
                        new_position = 5
                elif drawn_card == "H":
                    new_position = self.current_position -3
                elif drawn_card == "I":
                    new_position = 10
                elif drawn_card == "L":
                    new_position = 5
                elif drawn_card == "M":
                    new_position = 39
                else: 
                    special_condition = False
                #print("drew chance card:"+drawn_card)
            elif self.current_position in [2,17,33]: #Community chest card
                drawn_card = self.community_chest_cards.pop(0)
                if drawn_card == "a":
                    new_position = 0
                elif drawn_card == "f":
                    new_position = 10
                else:
                    special_condition = False
                #print("drew chance card:"+drawn_card)
            elif self.current_position == 30:
                new_position = 10

            
        #Checks for three doubles in a row or landing in a "special condition" space
        if self.doubles_count == 3 or special_condition:
            self.doubles_count = 0
            if special_condition:
                #print("Landed on special space "+str(self.current_position)+" and redirected to space "+str(new_position))
                self.landed_spaces.append(self.current_position)
                self.landed_spaces.append(new_position)
                
            else:
                #Takes player to jail
                self.landed_spaces.append(10)

        else: #Updates position if player not taken to jail
            self.landed_spaces.append(self.current_position)

        #print("Position: "+str(self.landed_spaces[-1]))

        if len(self.chance_cards) == 0 or len(self.community_chest_cards) == 0:
                    self.end_game = True
        #Returns flag to indicate wether another turn should be played
        return self.end_game
        

#Initialize information lists
game_index = []
total_landed_spaces = []

#Generate one million games
for i in range(1,1000001):
    rodrigo = Player()
    game=False
    while not game:
        game = rodrigo.take_turn()
    print(i)
    game_index += [i]*len(rodrigo.landed_spaces)
    total_landed_spaces += rodrigo.landed_spaces

#Save to csv file
with open(r'C:\Users\rodrigo.revilla\Documents\simulation_results.csv', 'w',newline='') as f:
    writer = csv.writer(f)
    writer.writerows(zip(game_index, total_landed_spaces))
#print(game_index)
#print(total_landed_spaces)


#CHANCE CARDS REFERENCE (SPACES 7,22,36)
#ID CONTENT                             GO TO SPACE(S) __ 
#A  "Advance to Go"                     0
#B  "Advance to Illinois Ave."          24
#C  "Advance to St. Charles Place"      11
#D  "Advance to nearest Utility"        12,28 
#E  "Advance to nearest Railroad"       5,15,25,35
#F  "Bank pays you..."                  -
#G  "Get out of Jail free"              -
#H  "Go back three spaces"              -3
#I  "Go to Jail"                        10
#J  "Make general repairs..."           -
#K  "Pay poor tax..."                   -
#L  "Take a trip to Reading Railroad"   5
#M  "Take a walk on the Boardwalk"      39
#N  "You have been elected..."          -
#O  "Your building matures..."          -
#P  "You have won a..."                 -

#COMMUNITY CHEST CARDS REFERENCE (SPACES 2,17,33)
#ID CONTENT                             GO TO SPACE(S) __ 
#a  "Advance to "Go""                   0
#b  "Bank error..."                     -
#c  "Doctor´s fee..."                   -
#d  "From sale of stock..."             -
#e  "Get Out of Jail Free"              -
#f  "Go to Jail"                        10
#g  "Grand Opera Night..."              -
#h  "Holiday Fund Matures"              -
#i  "Income tax refund"                 -
#j  "It is your birthday"               -
#k  "Life insurance matures"            -
#l  "Hospital Fees"                     -
#m  "School Fees"                       -
#n  "Receive $25 consultancy fee"       -
#o  "You are assessed for street..."    -
#p  "You have won second prize..."      -
#q  "You inherit $100"                  -
