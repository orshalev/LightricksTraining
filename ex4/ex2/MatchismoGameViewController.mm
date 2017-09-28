//
//  MatchismoGameViewController.m
//  ex3
//
//  Created by Or Shalev on 17/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "MatchismoGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"
#import "SetCardView.h"

extern const NSInteger kInitialMatchismoCardCount = 30;

@interface MatchismoGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (nonatomic, strong) CardMatchingGame *game;


@property (strong, nonatomic) IBOutlet PlayingCardView *playingCardView;
@property (strong, nonatomic) IBOutlet SetCardView *set1;
@property (strong, nonatomic) IBOutlet SetCardView *set2;
@property (strong, nonatomic) IBOutlet SetCardView *set3;


//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray<UIButton *> *cardButtons;
@property (strong, nonatomic) NSArray<PlayingCard *> *drawnCards;
//gridObj

+ (Deck *)createDeck;

@end

@implementation MatchismoGameViewController


+ (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (CardMatchingGame *) game {
  if (!_game) {
    _game = [[CardMatchingGame alloc] initWithCardCount:kInitialMatchismoCardCount usingDeck: [MatchismoGameViewController createDeck]];
  }
  return _game;
}

-(void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

}

- (IBAction)touchNewGameButton:(id)sender {
  [self resetGame];
}

- (void)resetGame {
  self.game = nil;
  [self updateUI];
}

- (void)updateUI {
  self.scoreLabel.text = [NSString stringWithFormat:@"%lld", (long long)self.game.score];
  NSLog(@"%@",self.game.actionInfo);

  /*for (UIButton * cardButton in [self drawnCards]) {
    NSInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
    
    Card * card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setTitle:[self cardAttributes:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
  }*/
  
}


- (NSString *)cardAttributes:(Card *)card {

  return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
  return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

/* TODO needed????? */
-(void)awakeFromNib
{
  [super awakeFromNib];
  [self updateUI];
}


- (void)viewDidLoad {
  [super viewDidLoad];
  self.playingCardView.suit = @"♥︎";
  self.playingCardView.rank = 13;
  self.playingCardView.faceUp = YES;

  self.set1.card = [[SetCard alloc] initWithNumber:1 withSymbol:1 withStriping:1 withColor:[UIColor redColor]];
  self.set2.card = [[SetCard alloc] initWithNumber:2 withSymbol:2 withStriping:2 withColor:[UIColor greenColor]];
  self.set3.card = [[SetCard alloc] initWithNumber:3 withSymbol:3 withStriping:3 withColor:[UIColor purpleColor]];

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
