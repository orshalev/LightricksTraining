//
//  SetCardDeck.m
//  ex3
//
//  Created by Or Shalev on 17/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype)init
{
  if (! (self = [super init])) {
    return nil;
  }

  [SetCardDeck fill:self];
  return self;
}

+ (void) fill:(SetCardDeck *) deck {
  for (NSUInteger number = 1; number <= SET_NUMBER_OF_ATTRIBUTE_VALUES; number ++){
    for (NSUInteger symbol = 1; symbol <= SET_NUMBER_OF_ATTRIBUTE_VALUES; symbol ++){
      for (NSUInteger striping = 1; striping <= SET_NUMBER_OF_ATTRIBUTE_VALUES; striping ++) {
        for (UIColor *color in @[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor]]) {
          SetCard *newCard = [[SetCard alloc] initWithNumber:number withSymbol:symbol withStriping:striping withColor:color];
          [deck addCard:newCard];
        }
      }
    }
  }
}

@end
