//
//  MatchismoGameViewController.h
//  ex3
//
//  Created by Or Shalev on 17/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardView.h"
#import "GameViewControllerDelegate.h"

@interface MatchismoGameViewController : UIViewController <GameViewControllerDelegate>

-(BOOL)flipCard:(UIView *)cardView;

@end
