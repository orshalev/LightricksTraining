//
//  SetCard.h
//  ex3
//
//  Created by Or Shalev on 17/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "Card.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define SET_NUMBER_OF_ATTRIBUTE_VALUES 3

typedef NS_ENUM(NSUInteger, SetSymbol) {
  diamondSymbol = 1,
  squiggleSymbol,
  ovalSymbol
};

typedef NS_ENUM(NSUInteger, SetStriping) {
  solidStriping = 1,
  stripedStriping,
  openStriping
};


@interface SetCard : Card
- (id)initWithNumber:(NSUInteger)number withSymbol:(NSUInteger)symbol withStriping:(NSUInteger)striping withColor:(UIColor *)color;

@property (nonatomic) NSUInteger number;
@property (nonatomic) SetSymbol symbol;
@property (nonatomic) SetStriping striping;
@property (nonatomic) UIColor *color;

@end
