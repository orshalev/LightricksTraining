//
//  MatchismoGameViewController.m
//  ex3
//
//  Created by Or Shalev on 17/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "MatchismoGameViewController.h"

#import "Grid.h"
#import "GridView.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"

extern const NSInteger kInitialMatchismoCardCount = 30;

@interface MatchismoGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIView *gridView;

@property (strong, nonatomic) NSMutableArray<UIView *> *cardViews;

@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) Grid* grid;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;

@property (nonatomic) BOOL stacked;

+ (Deck *)createDeck;

@end

@implementation MatchismoGameViewController

#pragma mark - Controller Initilization
+ (Deck *)createDeck {
  return [[PlayingCardDeck alloc] init];
}

- (void)resetGame {
  [self removeAllCards];
  [self initNewGame];
}

// Call only after fully removing all existing cards.
- (void)initNewGame {
  self.game = [[CardMatchingGame alloc] initWithCardCount:kInitialMatchismoCardCount usingDeck:[MatchismoGameViewController createDeck]];
  [self initGridView];
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
    [self addCard:i];
  }
  [self updateCardsOnGrid];
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
  PlayingCard *card = (PlayingCard *)[self.game cardAtIndex:cardIndex];
  CGRect frameForCard = [self.grid frameOfCellAtPos:0];
  PlayingCardView *newCardView = [[PlayingCardView alloc] initWithFrame:frameForCard];

  newCardView.delegate = self;
  newCardView.suit = card.suit;
  newCardView.rank = card.rank;
  newCardView.faceUp = NO;
  newCardView.cardNum = cardIndex;

  [self.cardViews addObject:newCardView];
  [self.view addSubview:newCardView];
}

- (void)removeAllCards {
  [self removeCards:[self.cardViews copy]];
}

- (void)removeCards:(NSArray<UIView *> *)viewsForRemoval {
  for (UIView *view in viewsForRemoval) {
    [self.cardViews removeObject:view];
  }
  [self animateRemoveCards:viewsForRemoval];
}

- (void)animateRemoveCards:(NSArray<UIView *> *)viewsForRemoval {
  [UIView animateWithDuration:0.5
                   animations:^{
                     for (UIView *view in viewsForRemoval) {
                       view.center = CGPointMake(0, self.view.bounds.size.height);
                     }
                   }
                   completion:^(BOOL completion) {
                     for (UIView *view in viewsForRemoval) {
                       [view removeFromSuperview];
                     }
                   }];
}

- (void)tapCard:(UIView *)view {
  if ([self isStacked]) {
    [self removeAttachmentCards];
    [self updateCardsOnGrid];
    self.stacked = NO;
    return;
  }

  PlayingCardView *cardView = (PlayingCardView *)view;
  [self.game chooseCardAtIndex:cardView.cardNum];
  BOOL isChosen = [self.game cardAtIndex:cardView.cardNum].isChosen;
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
    [self attachCardsToPoint:gesturePoint];
  }
}

-(void)panCard:(UIPanGestureRecognizer *)sender {
  if (![self isStacked]) {
    return;
  }
  CGPoint gesturePoint = [sender locationInView:self.view];
  if (sender.state == UIGestureRecognizerStateBegan) {
    [self moveCardStackToPoint:gesturePoint];
  } else if (sender.state == UIGestureRecognizerStateChanged) {
    [self moveCardStackToPoint:gesturePoint];
  }
}

- (IBAction)touchNewGameButton:(id)sender {
  [self resetGame];
}


#pragma mark - Animations
#define DIAGONAL_OFFSET_PERCENTAGE 0.02
- (void)updateCardsOnGrid {
  MatchismoGameViewController __weak *weakSelf = self;
  [UIView animateWithDuration:0.5 animations: ^{
    NSUInteger cardGridPos = 0;
    for (UIView *view in weakSelf.cardViews) {
      CGRect frame = [weakSelf.grid frameOfCellAtPos:cardGridPos];
      view.frame = frame;
      cardGridPos++;
    }
  }];
}

- (void)animatePinchGroupCards:(CGPoint)point {
  MatchismoGameViewController __weak *weakSelf = self;
  [UIView animateWithDuration:0.5 animations: ^{
    CGPoint offset = point;
    for (UIView *view in weakSelf.cardViews) {
      offset.x += self.grid.cellSize.width * DIAGONAL_OFFSET_PERCENTAGE;
      offset.y += self.grid.cellSize.height * DIAGONAL_OFFSET_PERCENTAGE;

      [view setFrame:{CGPointMake(offset.x, offset.y), view.frame.size}];
    }
  }];
}

- (void)attachCardsToPoint:(CGPoint)point {
  UIDynamicItemGroup *viewsDynasmicGroup = [[UIDynamicItemGroup alloc] initWithItems:self.cardViews];
  UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:viewsDynasmicGroup attachedToAnchor:point];
  [self.animator addBehavior:attachment];
  self.attachment = attachment;
}

- (void)moveCardStackToPoint:(CGPoint)point {
  self.attachment.anchorPoint = point;
}

- (void)removeAttachmentCards {
  [self.animator removeBehavior:self.attachment];
}

#pragma mark - View initialization
- (void)updateUI {
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %.4lld", (long long)self.game.score];
  NSLog(@"%@",self.game.actionInfo);

  NSMutableArray<UIView *> *cardsForRemoval = [[NSMutableArray alloc] init];
  for (NSUInteger i = 0; i < [self.cardViews count]; i++) {
    PlayingCardView *cardView = (PlayingCardView *)self.cardViews[i];
    PlayingCard *card =(PlayingCard *) [self.game cardAtIndex:cardView.cardNum];
    if (card.isMatched && card.isChosen) {
      [cardsForRemoval addObject:self.cardViews[i]];
    }
    if (cardView.faceUp != card.isChosen) {
      cardView.faceUp = card.isChosen;
    }
  }

  if ([cardsForRemoval count]) {
    [self removeCards:cardsForRemoval];
  }
}


-(void)awakeFromNib
{
  [super awakeFromNib];
}

-(void)viewDidLayoutSubviews {
  [self initGridView];
  [self updateCardsOnGrid];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(pinch:)];
  [self.view addGestureRecognizer:pinchRecognizer];

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
