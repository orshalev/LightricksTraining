//
//  ViewController.m
//  ex1
//
//  Created by Or Shalev on 11/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "ViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) NSUInteger flipcount;
@property (nonatomic, strong) PlayingCardDeck *deck;
@end

@implementation ViewController

- (PlayingCardDeck *)deck
{
  if (!_deck) {
    _deck = [[PlayingCardDeck alloc] init];
  }
  return _deck;
}

- (void)setFlipcount:(NSUInteger)flipcount {
  _flipcount = flipcount;
  self.flipsLabel.text = [NSString stringWithFormat:@"Flips Count: %.5llu", (unsigned long long) self.flipcount];
}

- (IBAction)touchCardButton:(UIButton *)sender {
  if ([sender.currentTitle isEqualToString:@"~~~"]) {
    Card * card = [self.deck drawRandomCard];
    [sender setBackgroundImage:[UIImage imageNamed:@"cardfront"] forState:UIControlStateNormal];
    [sender setTitle:[card contents] forState:UIControlStateNormal];
    NSLog(@"card: %@", [card contents]);
    self.flipcount++;
  } else {
    [sender setBackgroundImage:[UIImage imageNamed:@"cardback"] forState:UIControlStateNormal];
    [sender setTitle:@"~~~" forState:UIControlStateNormal];
  }
  if ([self.deck isEmpty]) {
    NSLog(@"Refilling deck.");
    [PlayingCardDeck fill:self.deck];
  }
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
