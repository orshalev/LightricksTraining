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
    for (NSDictionary <NSString *, NSString *> *cardAttributes in originArray) {
      NSMutableDictionary <NSString *, NSString *> *tempDict = [cardAttributes mutableCopy];
      tempDict[attribute] = attributeValue;
      [destinationArray addObject:tempDict];
    }
  }

}

+ (NSMutableArray<NSDictionary *> *) fillAttributesDictFromAttributesArray:(NSMutableArray *)attributesArray {
  NSString *currentAttribute = @"";
  NSMutableArray<NSDictionary *> *currentAttributesDicts = [[NSMutableArray alloc] init]; //of <NSString *, NSString *>
  NSMutableArray<NSDictionary *> *prevAttributesDicts; //of <NSString *, NSString *>

  while ([attributesArray count]) {
    currentAttribute = [attributesArray lastObject];
    [attributesArray removeLastObject];

    prevAttributesDicts = [currentAttribute copy];
    currentAttributesDicts = [NSMutableArray init];
    [SetCardDeck addAttribute:currentAttribute fromArray:prevAttributesDicts toArray:currentAttributesDicts];
  }
  return currentAttributesDicts;
}

+ (void) fill:(SetCardDeck *) deck {

  NSMutableArray <NSString *> *attributesStack = [[NSMutableArray alloc] initWithObjects:kCardAtrributes, nil];

  NSMutableArray<NSDictionary *> *filledAttributesDict = [SetCardDeck fillAttributesDictFromAttributesArray:attributesStack];

  for (NSDictionary <NSString *, NSString *> *cardAttributes in filledAttributesDict) {
    SetCard *newCard = [[SetCard alloc] initWithDict:cardAttributes];
    [deck addCard:newCard];
  }
}

@end
