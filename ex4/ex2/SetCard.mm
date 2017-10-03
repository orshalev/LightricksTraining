//
//  SetCard.m
//  ex3
//
//  Created by Or Shalev on 17/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (id)initWithNumber:(NSUInteger)number withSymbol:(NSUInteger)symbol withStriping:(NSUInteger)striping withColor:(UIColor *)color
{
  if (! (self = [super init])) {
    return nil;
  }

  self.number = number;
  self.symbol = symbol;
  self.striping = striping;
  self.color = color;

  return self;
}

- (NSString *)contents {
  return [NSString stringWithFormat:@"Set card:   number:%d symbol:%d striping:%d color:%@\n", (int)self.number, (int)self.symbol, (int)self.striping, self.color];
}


#pragma mark - Matching
- (int)match:(NSArray<SetCard *> *)otherCards {
  if ([self isMatchNumber:otherCards] &&
      [self isMatchSymbol:otherCards] &&
      [self isMatchStriping:otherCards] &&
      [self isMatchColor:otherCards]) {
    return 1;
  } else {
    return 0;
  }
}

- (BOOL)isMatchNumber:(NSArray<SetCard *> *)otherCards {
  NSMutableSet *attributeSet = [[NSMutableSet alloc] init];

  [attributeSet addObject:[NSNumber numberWithUnsignedInteger: self.number]];
  for (SetCard *otherCard in otherCards) {
    [attributeSet addObject:[NSNumber numberWithUnsignedInteger: otherCard.number]];
  }
  return [attributeSet count] == 1 || [attributeSet count] == SET_NUMBER_OF_ATTRIBUTE_VALUES;
}

- (BOOL)isMatchSymbol:(NSArray<SetCard *> *)otherCards {
  NSMutableSet *attributeSet = [[NSMutableSet alloc] init];

  [attributeSet addObject:[NSNumber numberWithUnsignedInteger: self.symbol]];
  for (SetCard *otherCard in otherCards) {
    [attributeSet addObject:[NSNumber numberWithUnsignedInteger: otherCard.symbol]];
  }
  return [attributeSet count] == 1 || [attributeSet count] == SET_NUMBER_OF_ATTRIBUTE_VALUES;
}

- (BOOL)isMatchStriping:(NSArray<SetCard *> *)otherCards {
  NSMutableSet *attributeSet = [[NSMutableSet alloc] init];

  [attributeSet addObject:[NSNumber numberWithUnsignedInteger: self.striping]];
  for (SetCard *otherCard in otherCards) {
    [attributeSet addObject:[NSNumber numberWithUnsignedInteger: otherCard.striping]];
  }
  return [attributeSet count] == 1 || [attributeSet count] == SET_NUMBER_OF_ATTRIBUTE_VALUES;
}

- (BOOL)isMatchColor:(NSArray<SetCard *> *)otherCards {
  NSMutableSet *attributeSet = [[NSMutableSet alloc] init];

  [attributeSet addObject:self.color];
  for (SetCard *otherCard in otherCards) {
    [attributeSet addObject:otherCard.color];
  }
  return [attributeSet count] == 1 || [attributeSet count] == SET_NUMBER_OF_ATTRIBUTE_VALUES;
}


@end
