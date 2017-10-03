//
//  CardMatchingGame.m
//  ex2
//
//  Created by Or Shalev on 13/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong, readwrite) NSString *actionInfo;
@property (nonatomic, strong) NSMutableArray<Card *> *cards;
@property (nonatomic, readonly) NSInteger maxChosenCards;
@end

@implementation CardMatchingGame: NSObject

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck gameMode:(GameMode)mode {
  if (! (self = [super init])) {
    return nil;
  }

  switch (mode) {
    case Match2Cards:
      _maxChosenCards = 2;
      break;
    case Match3Cards:
      _maxChosenCards = 3;
      break;
    default:
      break;
  }
  _cards = [[NSMutableArray alloc] init];
  for (int i = 0; i < count; i++) {
    Card *card = [deck drawRandomCard];
    if (card) {
      [self.cards addObject:card];
    } else {
      self = nil;
      break;
    }
  }

  return self;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck {
  return [self initWithCardCount:count usingDeck:deck gameMode:Match2Cards];
}

-(NSString *)actionInfo {
  if (!_actionInfo) {
    _actionInfo = @"New game.";
  }
  return _actionInfo;
}

- (NSUInteger)drawCardUsingDeckAndReturnIndex:(Deck*)deck {
  Card *card = [deck drawRandomCard];
  if (card) {
    [self.cards addObject:card];
  }
  return [self.cards indexOfObject:card];
}

- (Card *)cardAtIndex:(NSUInteger)index {
  return (index < [self.cards count]) ? self.cards[index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;


- (void)chooseCardAtIndex:(NSUInteger)index {
  Card *card = [self cardAtIndex:index];

  if (card.isMatched) {
    return;
  }

  if (card.isChosen) {
    self.actionInfo = [NSString stringWithFormat:@"Unchose %@", [card contents]];
    card.chosen = NO;
    return;
  }

  NSMutableArray<Card *> *chosenCards = [[NSMutableArray<Card *> alloc] init];
  for (Card *otherCard in self.cards) {
    if (otherCard.isChosen && !otherCard.isMatched) {
      [chosenCards addObject:otherCard];
    }
  }

  if ([chosenCards count] == self.maxChosenCards) {
    self.actionInfo = [NSString stringWithFormat:@"Unchoose a card before choosing a new one."];
    return;
  }

  NSString *info = [NSString stringWithFormat:@"Chosen card %@ - Choice panelty of %d points.\n", [card contents], COST_TO_CHOOSE];
  self.score -= COST_TO_CHOOSE;
  
  card.chosen = YES;

  if ([chosenCards count] < self.maxChosenCards - 1) {
    self.actionInfo = info;
    return;
  }

  int matchScore = [card match:chosenCards];
  if (matchScore) {
    self.score += matchScore * MATCH_BONUS;
    card.matched = YES;

    NSString *otherCardsContents = @"";
    for (Card *otherCard in chosenCards) {
      otherCardsContents = [NSString stringWithFormat:@"%@-%@", otherCardsContents, [otherCard contents]];
      otherCard.matched = YES;
    }
    info = [NSString stringWithFormat:@"%@ Matched %@%@ for %d points.\n", info, [card contents], otherCardsContents, matchScore * MATCH_BONUS];
  } else {
    info = [NSString stringWithFormat:@"%@ Mismatch %@ for %d penalty.\n", info, [card contents], MISMATCH_PENALTY];
    self.score -= MISMATCH_PENALTY;
    card.chosen = YES;
  }
  self.actionInfo = info;
}



@end
