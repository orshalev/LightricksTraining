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
@property (strong, nonatomic) NSMutableArray<UIAttachmentBehavior *> *attachments;

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

-(NSMutableArray<UIAttachmentBehavior *> *)attachments {
  if (!_attachments) {
    _attachments = [[NSMutableArray alloc] init];
  }
  return _attachments;
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

- (void)tapCard:(PlayingCardView *)cardView {
  if ([self isStacked]) {
    [self removeAttachmentCards];
    [self updateCardsOnGrid];
    self.stacked = NO;
    return;
  }

  NSInteger chosenButtonIndex = [self.cardViews indexOfObject:cardView];
  [self.game chooseCardAtIndex:chosenButtonIndex];
  BOOL isChosen = [self.game cardAtIndex:chosenButtonIndex].isChosen;
  [self updateUI];

  [UIView transitionWithView:cardView duration:0.5 options:(UIViewAnimationOptionTransitionFlipFromBottom) animations:^{
  } completion:^(BOOL finished) {
    cardView.faceUp = isChosen;
  }];
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender {
  self.stacked = YES;
  CGPoint gesturePoint = [sender locationInView:self.view];
  if (sender.state == UIGestureRecognizerStateBegan) {
    [self animatePinchGroupCards:gesturePoint];
    //[self attachCardsToPoint:gesturePoint];
  } else if (sender.state == UIGestureRecognizerStateChanged) {
    //[self attachCardsToPoint:gesturePoint];
  } else if (sender.state == UIGestureRecognizerStateEnded) {
    //[self removeAttachmentCards];
  }
}

-(void)panCard:(UIPanGestureRecognizer *)sender {
  if (![self isStacked]) {
    return;
  }
  CGPoint gesturePoint = [sender locationInView:self.view];
  if (sender.state == UIGestureRecognizerStateBegan) {
    [self attachCardsToPoint:gesturePoint];
  } else if (sender.state == UIGestureRecognizerStateChanged) {
    [self attachCardsToPoint:gesturePoint];
  } else if (sender.state == UIGestureRecognizerStateEnded) {
    [self removeAttachmentCards];
  }
}

- (IBAction)panStack:(UIPanGestureRecognizer *)sender {
  CGPoint gesturePoint = [sender locationInView:self.view];
  if (sender.state == UIGestureRecognizerStateBegan) {
    [self attachCardsToPoint:gesturePoint];
  } else if (sender.state == UIGestureRecognizerStateChanged) {
    [self attachCardsToPoint:gesturePoint];
  } else if (sender.state == UIGestureRecognizerStateEnded) {
    [self removeAttachmentCards];
  }
}

- (IBAction)touchNewGameButton:(id)sender {
  [self resetGame];
}


#pragma mark - Animations
#define DIAGONAL_OFFSET_PERCENTAGE 0.02

- (void)animatePinchGroupCards:(CGPoint)point {
  MatchismoGameViewController __weak *weakSelf = self;
  [UIView animateWithDuration:0.5 animations: ^{
    NSUInteger idx = weakSelf.activeCardsIndexes.firstIndex;
    CGPoint offset = point;
    while (idx != NSNotFound) {
      PlayingCardView *view = self.cardViews[idx];
      offset.x += self.grid.cellSize.width * DIAGONAL_OFFSET_PERCENTAGE;
      offset.y += self.grid.cellSize.height * DIAGONAL_OFFSET_PERCENTAGE;

      [view setFrame:{CGPointMake(offset.x, offset.y), view.frame.size}];

      idx = [weakSelf.activeCardsIndexes indexGreaterThanIndex:idx];
    }
  }];
}


- (void)attachCardsToPoint:(CGPoint)point {
  [self removeAttachmentCards];
  NSUInteger idx = self.activeCardsIndexes.firstIndex;
  CGPoint offset = point;
  while (idx != NSNotFound) {
    PlayingCardView *view = self.cardViews[idx];
    offset.x += self.grid.cellSize.width * DIAGONAL_OFFSET_PERCENTAGE;
    offset.y += self.grid.cellSize.height * DIAGONAL_OFFSET_PERCENTAGE;

    UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:view attachedToAnchor:offset];
    [self.animator addBehavior:attachment];
    [self.attachments addObject:attachment];

    idx = [self.activeCardsIndexes indexGreaterThanIndex:idx];
  }
}

- (void)removeAttachmentCards {
  for (UIAttachmentBehavior *attachment in self.attachments) {
    [self.animator removeBehavior:attachment];
  }
  self.attachments = nil;
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

/*-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
}*/

-(void)viewDidLayoutSubviews {
  [self initGridView];
  [self updateCardsOnGrid];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(pinch:)];
  [self.view addGestureRecognizer:pinchRecognizer];

  UIPanGestureRecognizer *panStackRecognizer = [[UIPanGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(panStack:)];
  [self.view addGestureRecognizer:panStackRecognizer];

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
