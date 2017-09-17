//
//  GameHistoryViewController.m
//  ex3
//
//  Created by Or Shalev on 17/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "GameHistoryViewController.h"

@interface GameHistoryViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textViewOutlet;

@end


@implementation GameHistoryViewController

- (NSAttributedString *)historyData {
  if (!_historyData) {
    _historyData = [[NSAttributedString alloc] initWithString:@"No history"];
  }
  return _historyData;
}

- (void)setHistory:(NSAttributedString *)historyData {
  _historyData = historyData;
  if (self.view.window) {
    [self updateUI];
  }
}

- (void)updateUI {
  self.textViewOutlet.attributedText = [self historyData];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self updateUI];
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
