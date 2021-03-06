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
@property (nonatomic) BOOL mode3MatchEnabled;
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
    self.actionInfo = [NSString stringWithFormat:@"unchose %@", [card contents]];
    card.chosen = NO;
    return;
  }

  NSString *info = [NSString stringWithFormat:@"Chosen card %@ - Choice panelty of %d points.\n", [card contents], COST_TO_CHOOSE];
  self.score -= COST_TO_CHOOSE;

  NSMutableArray<Card *> *chosenCards = [[NSMutableArray<Card *> alloc] init];
  for (Card * otherCard in self.cards) {
    if (!otherCard.isChosen || otherCard.isMatched) {
      continue;
    }
    [chosenCards addObject:otherCard];
  }
  card.chosen = YES;

  if ([chosenCards count] < self.maxChosenCards - 1) {
    return;
  }

  int matchScore = [card match:chosenCards];
  if (matchScore) {
    self.score += matchScore * MATCH_BONUS;
    card.matched = YES;
    //card.chosen = NO;

    NSString *otherCardsContents = @"";
    for (Card *otherCard in chosenCards) {
      otherCardsContents = [NSString stringWithFormat:@"%@-%@", otherCardsContents, [otherCard contents]];
      //otherCard.chosen = NO;
      otherCard.matched = YES;
    }
    info = [NSString stringWithFormat:@"%@ Matched %@%@ for %d points.\n", info, [card contents], otherCardsContents, matchScore * MATCH_BONUS];
    card.matched = YES;
  } else {
    info = [NSString stringWithFormat:@"%@ Mismatch %@ for %d panelty.\n", info, [card contents], MISMATCH_PENALTY];
    self.score -= MISMATCH_PENALTY;
    // Unchoose random card.
    chosenCards[arc4random() % [chosenCards count]].chosen = NO;
    card.chosen = YES;
  }
  self.actionInfo = info;
}



@end
