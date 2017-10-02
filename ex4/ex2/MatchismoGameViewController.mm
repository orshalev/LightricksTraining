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
#import "Grid.h"
#import "GridView.h"

extern const NSInteger kInitialMatchismoCardCount = 30;

@interface MatchismoGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIView *gridView;

@property (strong, nonatomic) NSMutableIndexSet *activeCardsIndexes;
@property (strong, nonatomic) NSMutableArray<PlayingCardView *> *cardViews;

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) Grid* grid;

@property (strong, nonatomic) UIDynamicAnimator *animator;

@property (nonatomic) BOOL stacked;

+ (Deck *)createDeck;

@end

@implementation MatchismoGameViewController


+ (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (void)resetGame {
  NSMutableIndexSet *cardsPosForRemoval = self.activeCardsIndexes;
  MatchismoGameViewController __weak *weakSelf = self;
  [self removeCards:cardsPosForRemoval withCompletionTask:@selector(initNewGame) fromObject:weakSelf];
}

// Call only after fully removing all existing cards.
- (void)initNewGame {
  self.game = [[CardMatchingGame alloc] initWithCardCount:kInitialMatchismoCardCount usingDeck:[MatchismoGameViewController createDeck]];
  [self initGridView];
  [self initCards];
  [self initCardViews];
  [self updateUI];
}

- (void)initGridView {
  self.grid = [[Grid alloc] initWithSize:self.gridView.frame.size withAspectRatio:0.666 withMinNumberOfCells:kInitialMatchismoCardCount];
  self.grid.origin = self.gridView.frame.origin;
  if (![_grid inputsAreValid]) {
    NSLog(@"Inputs for Grid are invalid!\n");
  }
}

- (void)initCardViews {
  self.cardViews = [[NSMutableArray alloc] init];
  for (int i = 0; i < kInitialMatchismoCardCount; i++) {
    PlayingCardView *cardView = [self addViewForCard:i];
    [self.cardViews addObject:cardView];
    [self.view addSubview:cardView];
  }
  [self updateCardsOnGrid];
}

-(void)initCards {
  self.activeCardsIndexes = [[NSMutableIndexSet alloc] init];
  [self.activeCardsIndexes addIndexesInRange:NSMakeRange(0, kInitialMatchismoCardCount)];
}

- (UIDynamicAnimator *)animator {
  if (!_animator) {
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
  }
  return _animator;
}

-(BOOL)isStacked {
  if (!_stacked) {
    _stacked = NO;
  }
  return _stacked;
}

- (void)addCard:(NSUInteger)cardIndex {
  [self.activeCardsIndexes addIndex:cardIndex];
  PlayingCardView *cardView = [self addViewForCard:cardIndex];
  [self.view addSubview:cardView];
  [self.cardViews addObject:cardView];
}

- (PlayingCardView *)addViewForCard:(NSUInteger)cardIndex{

  PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:cardIndex];
  CGRect frameForCard = [self.grid frameOfCellAtPos:0];
  PlayingCardView *newCardView = [[PlayingCardView alloc] initWithFrame:frameForCard];

  newCardView.delegate = self;
  newCardView.suit = card.suit;
  newCardView.rank = card.rank;
  newCardView.faceUp = NO;
  newCardView.cardNum = cardIndex;

  return newCardView;
}


- (void)handleSingleTapStack:(UITapGestureRecognizer *)recognizer
{
  PlayingCardView *cardView = (PlayingCardView *)recognizer.view;
  cardView.faceUp = !cardView.faceUp;
}

- (void)removeCards:(NSIndexSet *)cardsPosForRemoval {
  [self removeCards:cardsPosForRemoval withCompletionTask:nil fromObject:nil];
}

- (void)removeCards:(NSIndexSet *)cardsPosForRemoval withCompletionTask:(SEL)func fromObject:(id)object {
  MatchismoGameViewController __weak *weakSelf = self;
  [UIView animateWithDuration:0.5
                   animations:^{
                     NSUInteger idx = cardsPosForRemoval.firstIndex;
                     while (idx != NSNotFound) {
                       PlayingCardView *view = [weakSelf.cardViews objectAtIndex:idx];
                       view.center = CGPointMake(0, self.view.bounds.size.height);
                       idx = [cardsPosForRemoval indexGreaterThanIndex:idx];
                     }
                   }
                   completion:^(BOOL finished) {
                     NSUInteger idx = cardsPosForRemoval.firstIndex;
                     while (idx != NSNotFound) {
                       PlayingCardView *view = [weakSelf.cardViews objectAtIndex:idx];
                       [view removeFromSuperview];
                       idx = [cardsPosForRemoval indexGreaterThanIndex:idx];
                     }
                     //[weakSelf.cardViews removeObjectsAtIndexes:cardsPosForRemoval];
                     [weakSelf.activeCardsIndexes removeIndexes:cardsPosForRemoval];
                     [weakSelf updateCardsOnGrid];
                     if (func) {
                       [object performSelector:func];
                     }
                   }];
}

- (void)updateCardsOnGrid {
  MatchismoGameViewController __weak *weakSelf = self;
  [UIView animateWithDuration:0.5 animations: ^{
    NSUInteger idx = weakSelf.activeCardsIndexes.firstIndex;
    NSUInteger cardGridPos = 0;
    while (idx != NSNotFound) {
      CGRect frame = [weakSelf.grid frameOfCellAtPos:cardGridPos];
      weakSelf.cardViews[idx].frame = frame;
      cardGridPos++;
      idx = [weakSelf.activeCardsIndexes indexGreaterThanIndex:idx];
    }
  }];
}

- (BOOL)flipCard:(UIView *)cardView {
  NSInteger chosenButtonIndex = [self.cardViews indexOfObject:(PlayingCardView *)cardView];
  [self.game chooseCardAtIndex:chosenButtonIndex];
  BOOL shouldFaceUpAfterAction = [self.game cardAtIndex:chosenButtonIndex].isChosen;
  [self updateUI];
  return shouldFaceUpAfterAction;
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender {
  self.stacked = YES;
  CGPoint gesturePoint = [sender locationInView:self.view];
  if (sender.state == UIGestureRecognizerStateBegan) {
    [self animatePinchGroupCards];
    [self attachCardsToPoint:gesturePoint];
  } else if (sender.state == UIGestureRecognizerStateChanged) {
    [self attachCardsToPoint:gesturePoint];
  } else if (sender.state == UIGestureRecognizerStateEnded) {
    //[self removeAttachmentCards];
  }
}

- (IBAction)tapStack:(UITapGestureRecognizer *)sender {
  if ([self isStacked]) {
    self.stacked = NO;
  }
}


- (IBAction)touchNewGameButton:(id)sender {
  [self resetGame];
}


#pragma mark - Animations
- (void)animatePinchGroupCards {

}

- (void)attachCardsToPoint:(CGPoint)point {

}

- (void)removeAttachmentCards {

}



- (void)updateUI {
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %.4lld", (long long)self.game.score];
  NSLog(@"%@",self.game.actionInfo);

  NSMutableIndexSet *cardsForRemoval = [[NSMutableIndexSet alloc] init];

  NSUInteger idx = self.activeCardsIndexes.firstIndex;
  while (idx != NSNotFound) {
    PlayingCard * card =(PlayingCard *) [self.game cardAtIndex:idx];
    if (card.isMatched && card.isChosen) {
      [cardsForRemoval addIndex:idx];
    }
    if (self.cardViews[idx].faceUp != card.isChosen) {
      self.cardViews[idx].faceUp = card.isChosen;
    }
    idx = [self.activeCardsIndexes indexGreaterThanIndex:idx];
  }

  if ([cardsForRemoval count]) {
    [self removeCards:cardsForRemoval];
  }
}


-(void)awakeFromNib
{
  [super awakeFromNib];
  //[self resetGame];
}


- (void)viewDidLoad {
  [super viewDidLoad];
  UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
  [self.view addGestureRecognizer:pinchRecognizer];

  UITapGestureRecognizer *tapStackRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStack:)];
  [self.view addGestureRecognizer:tapStackRecognizer];

  [self initNewGame];
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
