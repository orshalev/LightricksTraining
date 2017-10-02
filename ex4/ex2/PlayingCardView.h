//
//  SuperCard.h
//  ex4
//
//  Created by Or Shalev on 27/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCard.h"
#import "MatchismoGameViewController.h"
#import "GameViewControllerDelegate.h"

@interface PlayingCardView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic) BOOL faceUp;
@property (nonatomic) NSUInteger cardNum;
@property (weak, nonatomic) id<GameViewControllerDelegate>delegate;

@end
