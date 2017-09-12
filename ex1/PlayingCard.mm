//
//  PlayingCard.m
//  ex1
//
//  Created by Or Shalev on 12/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

static NSArray * const kValidSuits = @[@"♥",@"♦",@"♠",@"♣"];

+(NSArray * const)validSuits
{
  return kValidSuits;
}

- (NSString *)contents {
  NSLog(@"rank:%lu  suit:%@  contents:%@", (unsigned long)self.rank, self.suit, [kRankStrings[self.rank] stringByAppendingString:self.suit]);
  return [kRankStrings[self.rank] stringByAppendingString:self.suit];
}

- (void)setSuit:(NSString *)suit {
  if ([kValidSuits containsObject:suit]) {
    _suit = suit;
  }
}

-(NSString *)suit {
  return _suit ? _suit : @"?";
}

static NSArray * const kRankStrings = @[@"?",@"A",
                                        @"2",@"3",@"4",@"5",@"6",
                                        @"7",@"8",@"9",@"10",
                                        @"J",@"Q",@"K"];



+(NSArray * const)rankStrings
{
  return kRankStrings;
}

+(NSUInteger)maxRank
{
  return [kRankStrings count] - 1;
}

-(void)setRank:(NSUInteger)rank
{
  if(rank <= [PlayingCard maxRank]) {
    _rank = rank;
  }
}

@end
