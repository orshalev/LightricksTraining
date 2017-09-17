//
//  PlayingCardDeck.m
//  ex1
//
//  Created by Or Shalev on 12/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

- (instancetype)init
{
  self = [super init];

  if (self) {
    [PlayingCardDeck fill:self];
  }

  return self;
}

+ (void) fill:(PlayingCardDeck *) deck
{
  for (NSString *suit in PlayingCard.validSuits) {
    for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
      PlayingCard *card = [[PlayingCard alloc] init];
      card.rank = rank;
      card.suit = suit;
      [deck addCard:card];
    }
  }
}

@end
