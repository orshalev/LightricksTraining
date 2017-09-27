//
//  PlayingCard.h
//  ex1
//
//  Created by Or Shalev on 12/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray * const)validSuits;
+ (NSArray * const)rankStrings;
+ (NSUInteger)maxRank;

@end
