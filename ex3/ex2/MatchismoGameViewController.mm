//
//  MatchismoGameViewController.m
//  ex3
//
//  Created by Or Shalev on 17/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "MatchismoGameViewController.h"
#import "PlayingCardDeck.h"
#import "SetCard.h"

@interface MatchismoGameViewController ()

@end

@implementation MatchismoGameViewController

// Abstract
- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (CardMatchingGame *) game {
  if (![super game]) {
    super.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck: [self createDeck]];
  }
  return super.game;
}

-(void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

}

- (void)updateUI {
  [super updateUI];
  for (UIButton * cardButton in [super cardButtons]) {
    NSInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
    
    Card * card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setTitle:[self cardAttributes:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
  }
}


- (NSString *)cardAttributes:(Card *)card {

  return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
  return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
