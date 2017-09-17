//
//  CardMatchingGame.h
//  ex2
//
//  Created by Or Shalev on 13/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

typedef NS_ENUM(NSInteger, GameMode) {
  Match2Cards,
  Match3Cards
};

@interface CardMatchingGame : NSObject
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck gameMode:(GameMode)mode;
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;
- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, strong, readonly) NSString *actionInfo;

@end
