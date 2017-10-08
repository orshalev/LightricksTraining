//
//  SetCardView.h
//  ex4
//
//  Created by Or Shalev on 27/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewControllerDelegate.h"

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

@interface SetCardView : UIView

-(instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic) NSUInteger number;
@property (nonatomic) SetSymbol symbol;
@property (nonatomic) SetStriping striping;
@property (nonatomic) UIColor *color;
@property (nonatomic) BOOL chosen;
@property (nonatomic) NSUInteger cardNum;
@property (weak, nonatomic) id<GameViewControllerDelegate>delegate;

@end
