//
//  Card.h
//  ex1
//
//  Created by Or Shalev on 11/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;

- (int) match:(NSArray *)otherCards;
@end
