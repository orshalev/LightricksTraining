//
//  ViewController.m
//  ex2
//
//  Created by Or Shalev on 12/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "CardGameViewController.h"
#import "GameHistoryViewController.h"


@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@property (strong, nonatomic) NSAttributedString *historyData;
@end

@implementation CardGameViewController


- (CardMatchingGame *) game {
  if (!_game) {
    _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck: [self createDeck]];
  }
  return _game;
}

- (NSAttributedString *) historyData {
  if (!_historyData) {
    _historyData = [[NSAttributedString alloc] initWithString:@"Game History:\n"];
  }
  return _historyData;
}

// Abstract
- (Deck *)createDeck {
  return nil;
}

- (void)resetGame {
  self.game = nil;
  self.scoreLabel.text = @"0";
  self.infoLabel.text = @"";
  [self updateUI];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"Game History"]) {
    if ([segue.destinationViewController isKindOfClass:[GameHistoryViewController class]]) {
      NSLog(@"segueing!\n");
      GameHistoryViewController *historyController = (GameHistoryViewController *)segue.destinationViewController;
      historyController.historyData = [self historyData];

    }
  }
}


- (IBAction)touchDealButton:(id)sender {
  [self resetGame];
}

- (IBAction)touchCardButton:(UIButton *)sender {

  NSInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
  [self.game chooseCardAtIndex:chosenButtonIndex];
  [self updateUI];
}

- (void)updateUI {
  self.scoreLabel.text = [NSString stringWithFormat:@"%lld", (long long)self.game.score];
  NSLog(@"%@",self.game.actionInfo);
  self.infoLabel.text = [NSString stringWithFormat:@"info:\n%@", self.game.actionInfo];
  NSMutableAttributedString *historyMutable = [self.historyData mutableCopy];
  [historyMutable appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", self.game.actionInfo]]];
  self.historyData = historyMutable;
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
