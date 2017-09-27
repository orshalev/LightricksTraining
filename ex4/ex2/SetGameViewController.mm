//
//  SetGameViewController.m
//  ex3
//
//  Created by Or Shalev on 17/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "SetGameViewController.h"

#import "SetCardDeck.h"
#import "SetCard.h"


extern const NSInteger kInitialSetCardCount = 12;

@interface SetGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (nonatomic, strong) CardMatchingGame *game;
//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray<UIButton *> *cardButtons;
@property (strong, nonatomic) NSArray<SetCard *> *drawnCards;

@end

@implementation SetGameViewController


/*
+ (void)addToAttributedString:(NSMutableAttributedString *)attributedString addAttributeFromName:(NSString *)attributeName forCardValue:(NSString *)valueName {

  if ([attributeName isEqualToString:@"Symbol"]) {
    attributedString = [attributedString initWithString:[SetGameViewController symbolByValue:valueName]];
  } else if ([attributeName isEqualToString:@"Number"]) {
    [SetGameViewController addToAttributedString:attributedString numberByValue:valueName];
  } else if ([attributeName isEqualToString:@"Color"]) {
    [attributedString addAttribute:NSForegroundColorAttributeName value:[SetGameViewController colorByValue:valueName] range:NSMakeRange(0, [attributedString length])];
  } else if ([attributeName isEqualToString:@"Shading"]) {
    [SetGameViewController addToAttributedString:attributedString shadingByValue:valueName];
  }
}

+ (NSString *)symbolByValue:(NSString *)value {
  if ([value isEqualToString:@"Single"]) {
    return @"▲";
  } else if ([value isEqualToString:@"Duo"]) {
    return @"◼︎";
  } else if ([value isEqualToString:@"Triplet"]) {
    return @"●";
  }
  return @"";
}

+ (void)addToAttributedString:(NSMutableAttributedString *)attributedString numberByValue:(NSString *)value {
  // No need to handle "Single" in this case
  if ([value isEqualToString:@"Duo"]) {
    [attributedString appendAttributedString:attributedString];
  } else if ([value isEqualToString:@"Triplet"]) {
    NSMutableAttributedString *tmpAttributedString = [attributedString copy];
    [attributedString appendAttributedString:tmpAttributedString];
    [attributedString appendAttributedString:tmpAttributedString];
  }
}

+ (void)addToAttributedString:(NSMutableAttributedString *)attributedString shadingByValue:(NSString *)value {
  CGFloat alpha = 0;
  if ([value isEqualToString:@"Single"]) {
    alpha = 0.3;
  } else if ([value isEqualToString:@"Duo"]) {
    alpha = 0.6;
  } else if ([value isEqualToString:@"Triplet"]) {
    alpha = 1;
  }
  UIColor *oldColor = [attributedString attribute:NSForegroundColorAttributeName atIndex:0 longestEffectiveRange:nil inRange:NSMakeRange(0, 1)];
  oldColor = [oldColor colorWithAlphaComponent:alpha];
  [attributedString addAttribute:NSForegroundColorAttributeName value:oldColor range:NSMakeRange(0, [attributedString length])];
}

+ (UIColor *)colorByValue:(NSString *)value {
  if ([value isEqualToString:@"Single"]) {
    return [UIColor redColor];
  } else if ([value isEqualToString:@"Duo"]) {
    return [UIColor greenColor];
  } else if ([value isEqualToString:@"Triplet"]) {
    return [UIColor blueColor];
  }
  return nil;
}

+ (Deck *)createDeck {
  return [[SetCardDeck alloc] init];
}

- (CardMatchingGame *) game {
  if (!_game) {
    _game = [[CardMatchingGame alloc] initWithCardCount:kInitialCardCount usingDeck: [SetGameViewController createDeck]];
  }
  return _game;
}

- (IBAction)touchDraw3Button:(id)sender {

}

- (IBAction)touchNewGameButton:(id)sender {
  [self resetGame];
}

- (void)resetGame {
  self.game = nil;
  [self updateUI];
}

- (void)updateUI {

  for (UIButton * cardButton in [super cardButtons]) {
    NSInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
    SetCard * card = (SetCard *)[self.game cardAtIndex:cardButtonIndex];
    [cardButton setAttributedTitle:[SetGameViewController textAttributesForCard:card] forState:UIControlStateNormal];

    [cardButton setBackgroundColor:[self backgroundColorForCard:card]];
    [cardButton setBackgroundImage:nil forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
  }
}

+ (NSAttributedString *)textAttributesForCard:(SetCard *)card {
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
  [SetGameViewController addToAttributedString:attributedString addAttributeFromName:@"Symbol" forCardValue:card.attributes[@"Symbol"]];
  [SetGameViewController addToAttributedString:attributedString addAttributeFromName:@"Number" forCardValue:card.attributes[@"Number"]];
  [SetGameViewController addToAttributedString:attributedString addAttributeFromName:@"Color" forCardValue:card.attributes[@"Color"]];
  [SetGameViewController addToAttributedString:attributedString addAttributeFromName:@"Shading" forCardValue:card.attributes[@"Shading"]];
  return attributedString;
}


- (UIColor *)backgroundColorForCard:(Card *)card {
  if (card.isMatched) {
    return [UIColor grayColor];
  }
  return card.isChosen ? [UIColor whiteColor] : [UIColor lightGrayColor];
}


- (void)viewDidLoad {
  [super viewDidLoad];
  [self updateUI];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
