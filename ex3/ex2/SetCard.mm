//
//  SetCard.m
//  ex3
//
//  Created by Or Shalev on 17/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard


-(id)initWithDict:(NSDictionary <NSString *, NSString *> *)attributes {
  if (! (self = [super init])) {
    return nil;
  }

  self.attributes = attributes;
  return self;
}

- (NSString *)contents {
  NSLog(@"contents:%@", self.attributes);
  NSString *contentsStr = @"";
  for (NSString *key in self.attributes) {
    contentsStr = [contentsStr stringByAppendingFormat:@"%@:%@ ", key, self.attributes[key]];
  }
  return contentsStr;
}

// Match score: number of attributes times number of possible values
- (int)match:(NSArray<SetCard *> *)otherCards {
  for (NSString *attribute in kCardAtrributes) {
    NSMutableSet <NSString *>* attributeSet = [[NSMutableSet alloc] init];

    [attributeSet addObject:self.attributes[attribute]];
    for (SetCard *otherCard in otherCards) {
      [attributeSet addObject:otherCard.attributes[attribute]];
    }
    if ([attributeSet count] != 1 && [attributeSet count] != [kSetCardValues count]) {
      return 0;
    }
  }
  return (int)([kCardAtrributes count] * [kSetCardValues count]);
}

@end
