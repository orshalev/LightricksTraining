//
//  PlayingCard.m
//  ex1
//
//  Created by Or Shalev on 12/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

static const uint SUIT_ABS_SCORE = 1;
static const uint SUIT_REL_SCORE = 2;
static const uint RANK_ABS_SCORE = 4;
static const uint RANK_REL_SCORE = 8;
static NSArray * const kValidSuits = @[@"♥",@"♦",@"♠",@"♣"];
static NSArray * const kRankStrings = @[@"?",
  @"A", @"2", @"3", @"4", @"5",
  @"6", @"7", @"8", @"9", @"10",
  @"J", @"Q", @"K"];

@synthesize suit = _suit;

- (int)match:(NSArray<PlayingCard *> *)otherCards {
  NSInteger score = 0;
  NSUInteger cardCount = [otherCards count] + 1;

  for (PlayingCard *otherCard in otherCards) {
    if (otherCard.rank == self.rank) {
      score += RANK_ABS_SCORE + (RANK_REL_SCORE / cardCount);
    } else if ([otherCard.suit isEqualToString:self.suit]) {
      score += SUIT_ABS_SCORE + (SUIT_REL_SCORE / cardCount);
    }
  }

  return (int) score;
}

+(NSArray * const)validSuits
{
  return kValidSuits;
}

- (NSString *)contents {
  NSLog(@"rank:%lu  suit:%@  contents:%@", (unsigned long)self.rank, self.suit,
        [kRankStrings[self.rank] stringByAppendingString:self.suit]);
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
