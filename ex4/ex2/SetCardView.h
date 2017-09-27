//
//  SetCardView.h
//  ex4
//
//  Created by Or Shalev on 27/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetCard.h"

@interface SetCardView : UIView

-(instancetype)initWithFrame:(CGRect)frame;

@property (weak, nonatomic) SetCard *card;

@end
