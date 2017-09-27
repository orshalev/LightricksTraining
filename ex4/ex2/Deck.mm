//
//  Deck.m
//  ex1
//
//  Created by Or Shalev on 12/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray *cards;
@end

@implementation Deck

- (instancetype)init
{
  self = [super init];
  if (self) {
    _cards = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
  if (atTop) {
    [self.cards insertObject:card atIndex:0];
  } else {
    [self.cards addObject:card];
  }
}

- (void)addCard:(Card *)card
{
  [self addCard:card atTop:NO];
}

- (Card *)drawRandomCard
{
  if (![self.cards count]) {
    return nil;
  }

  unsigned index = arc4random() % [self.cards count];
  Card *randomCard = self.cards[index];
  [self.cards removeObjectAtIndex:index];
  return randomCard;
}

- (BOOL)isEmpty
{
  return [self.cards count] == 0;
}

@end
