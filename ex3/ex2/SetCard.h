//
//  SetCard.h
//  ex3
//
//  Created by Or Shalev on 17/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "Card.h"

#import <Foundation/Foundation.h>

static NSSet<NSString *> *kSetCardValues = [NSSet setWithArray:@[@"Single", @"Duo", @"Triplet"]];
static NSSet<NSString *> *kCardAtrributes = [NSSet setWithArray:@[@"Number", @"Symbol", @"Shading", @"Color"]];

@interface SetCard : Card
-(id)initWithDict:(NSDictionary <NSString *, NSString *> *)attributes;

@property (nonatomic, strong) NSDictionary <NSString *, NSString *> *cardAttributes;

@end
