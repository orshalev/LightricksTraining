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

@interface SetCard : Card
- (id)initWithNumber:(NSUInteger)number withSymbol:(NSUInteger)symbol withStriping:(NSUInteger)striping withColor:(UIColor *)color;

@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger striping;
@property (nonatomic) UIColor *color;

@end
