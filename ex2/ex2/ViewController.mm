//
//  ViewController.m
//  ex2
//
//  Created by Or Shalev on 12/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "ViewController.h"

#import "CardMatchingGame.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSegControl;
@property (nonatomic) GameMode mode;
@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray<UIButton *> *cardButtons;
@end

@implementation ViewController

- (GameMode)mode {
  if (!_mode) {
    _mode = Match2Cards;
  }
  return _mode;
}

- (CardMatchingGame *) game {
  if (!_game) {
    _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck: [self createDeck] gameMode:self.mode];
  }
  return _game;
}

- (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (void)resetGame {
  self.game = nil;
  self.scoreLabel.text = @"0";
  self.infoLabel.text = @"";
  [self updateUI];
}

- (IBAction)touchGameModeSegControl:(id)sender {

  UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
  NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;

  self.mode = (GameMode)selectedSegment;
  [self resetGame];
}


- (IBAction)touchDealButton:(id)sender {
  [self resetGame];
  self.gameModeSegControl.enabled = YES;
}

- (IBAction)touchCardButton:(UIButton *)sender {

  NSInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
  [self.game chooseCardAtIndex:chosenButtonIndex];
  [self updateUI];
}

- (void)updateUI {
  for (UIButton * cardButton in self.cardButtons) {
    NSInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
    Card * card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
    [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
    self.scoreLabel.text = [NSString stringWithFormat:@"%lld", (long long)self.game.score];
    NSLog(self.game.actionInfo);
    self.infoLabel.text = [NSString stringWithFormat:@"info:\n%@", self.game.actionInfo];
  }
}

- (NSString *)titleForCard:(Card *)card {
  return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card {
  return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
