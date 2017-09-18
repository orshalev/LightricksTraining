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

+ (void) addAttribute:(NSString *)attribute fromArray:(NSArray *)originArray toArray:(NSMutableArray *)destinationArray {

  for (NSString *attributeValue in kSetCardValues) {
    if (!originArray.count) {
      NSMutableDictionary <NSString *, NSString *> *tempDict = [[NSMutableDictionary alloc] init];
      tempDict[attribute] = attributeValue;
      [destinationArray addObject:tempDict];
      continue;
    }
    for (NSDictionary <NSString *, NSString *> *cardAttributes in originArray) {
      NSMutableDictionary <NSString *, NSString *> *tempDict = [cardAttributes mutableCopy];
      tempDict[attribute] = attributeValue;
      [destinationArray addObject:tempDict];
    }
  }

}

+ (NSMutableArray<NSDictionary *> *)fillAttributesDict {
  NSMutableArray<NSDictionary *> *currentAttributesDicts = [[NSMutableArray alloc] initWithObjects:{}, nil]; //of <NSString *, NSString *>
  NSMutableArray<NSDictionary *> *prevAttributesDicts; //of <NSString *, NSString *>

  for(NSString *attribute in kCardAtrributes) {
    prevAttributesDicts = [currentAttributesDicts copy];
    currentAttributesDicts = [[NSMutableArray alloc] init];
    [SetCardDeck addAttribute:attribute fromArray:prevAttributesDicts toArray:currentAttributesDicts];
  }
  return currentAttributesDicts;
}

// Fill the deck using an array of dicts which will later be used by the SetCard initilizer.
+ (void) fill:(SetCardDeck *) deck {
  NSMutableArray<NSDictionary *> *filledAttributesDict = [SetCardDeck fillAttributesDict];

  for (NSDictionary <NSString *, NSString *> *cardAttributes in filledAttributesDict) {
    SetCard *newCard = [[SetCard alloc] initWithDict:cardAttributes];
    [deck addCard:newCard];
  }
}

@end
