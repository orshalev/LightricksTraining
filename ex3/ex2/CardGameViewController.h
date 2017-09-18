//
//  ViewController.h
//  ex3
//
//  Created by Or Shalev on 12/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray<UIButton *> *cardButtons;
@property (nonatomic, strong) CardMatchingGame *game;

// Abstract
- (Deck *)createDeck;

- (void)updateUI;


@end

