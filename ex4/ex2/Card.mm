//
//  Card.m
//  ex1
//
//  Created by Or Shalev on 11/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int) match:(NSArray *)otherCards
{
  int score = 0;

  for (Card *card in otherCards) {
    if ([card.contents isEqualToString:self.contents]) {
      score = 1;
    }

  }

  return score;
}

@end
