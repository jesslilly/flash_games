// Include the Math.as file on whose methods this recipe relies
#include "com/sparkyland/flash/Math.as"

// When a new card player is created by way of its constructor, pass it
// a reference to the card deck, and give it a unique player ID.
function CardPlayer (deck, id) {
  this.hand = null;
  this.deck = deck;
  this.id = id;
}

// The setHand() method sets the cards in a player's hand.
CardPlayer.prototype.setHand = function (hand) {
  this.hand = hand;
};

// The getHand() method returns the cards in a player's hand.
CardPlayer.prototype.getHand = function () {
  return this.hand;
};

// The draw() method deals the specified number of cards to the player.
CardPlayer.prototype.draw = function (num) {
  this.deck.draw(this.id, num);
};

// The discard() method discards the cards specified by their
// indices in the player's hand.
CardPlayer.prototype.discard = function (cardsArIds) {
  cardsArIds.sort();
  for (var i = 0; i < cardsArIds.length; i++) {
    this.hand.splice(cardsArIds[i] - i, 1);
  }
};

// The Cards constructor creates a deck of cards.
function Cards () {

  // Create a local array that contains the names of the four suits.
  var suits = ["Hearts", "Diamonds", "Spades", "Clubs"];

  // The cards property is an array that is populated with all the cards.
  this.cards = new Array();

  // Specify the names of the cards for stuffing into the cards array later.
  var cardNames = ["2", "3", "4", "5", "6", "7", "8", "9", "10",
                    "J", "Q", "K", "A"];

  // Create a 52-card array. Each element is an object that contains
  // properties for: the card's integer value (for sorting purposes), card name, 
  // suit name, and display name. The display name combines the card's name
  // and suit in a single string for display to the user.
  for (var i = 0; i < suits.length; i++) {
    // For each suit, add thirteen cards
    for (var j = 0; j < 13; j++) {
      this.cards.push(
                      {val: j, 
                       name: cardNames[j], 
                       suit: suits[i],
                       display: cardNames[j] + " " + suits[i]});
    }
  }
}

// The deal() method needs to know the number of players in the game 
// and the number of cards to deal per player. If the cardsPerPlayer 
// parameter is undefined, then it deals all the cards.
Cards.prototype.deal = function (numOfPlayers, cardsPerPlayer) {

  // Create an array, players, that holds the cards dealt to each player.
  var players = new Array();

  // The players array contains CardPlayer objects. Each card player is given a
  // reference to this deck of cards, as well as a unique player id.
  for (var i = 0; i < numOfPlayers; i++) {
    players.push(new CardPlayer(this, i));
  }

  // Make a copy of the deck of cards from which we'll deal. This way, we
  // can always recreate a fresh deck from the original cards property.
  this.cardsToDeal = this.cards.concat();

  // If a cardsPerPlayer value was passed in, deal that number of cards.
  // Otherwise, divide the number of cards (52) by the number of players.
  var cardsEach = cardsPerPlayer;
  if (cardsPerPlayer == undefined) {
    cardsEach = Math.floor(this.cards.length / numOfPlayers);
  }

  // Deal out the specified number of cards to each player.
  var rand, hand;
  for (var i = 0; i < numOfPlayers; i++) {

    hand = new Array();

    // Deal a random card to each player. Remove that card from the 
    // tempCards array so that it cannot be dealt again.
    for (var j = 0; j < cardsEach; j++) {
      rand = Math.randRange(0, this.cardsToDeal.length - 1);
      hand.push(this.cardsToDeal[rand]);
      this.cardsToDeal.splice(rand, 1);
    }

    // Use Cards.orderHand() to sort a player's hand, and use setHand() 
    // to assign it to the card player object.
    players[i].setHand(Cards.orderHand(hand.concat()));
  }

  // Return the players array.
  return players;
};

// The Cards.draw() method is called from CardPlayer.draw() to draw the
// specified number of cards from the deck and add them to the player's hand.
Cards.prototype.draw = function (player, numToDraw) {

  // Get the player's current hand.
  var hand = players[player].getHand();

  // Add the specified number of cards to the hand.
  for (var i = 0; i < numToDraw; i++) {
    rand = Math.randRange(0, this.cardsToDeal.length - 1);
    hand.push(this.cardsToDeal[rand]);
    this.cardsToDeal.splice(rand, 1);
  }

  // Sort the hand and reassign it to the player object.
  var orderedHand = Cards.orderHand(hand);
  players[player].setHand(orderedHand);
};

// Used by sort() in the orderHand() method to sort the cards by suit and rank.
Cards.sorter = function(a, b) {
  if (a.suit > b.suit) {
    return 1;
  } else if (a.suit < b.suit) {
    return -1;
  } else {
    return (Number(a.val) > Number(b.val));
  }
};

// This method sorts an array of cards by calling the sort() method on that
// array with a sorter method of Cards.sorter().
Cards.orderHand = function(hand) {
  hand.sort(Cards.sorter);
  return hand;
};
