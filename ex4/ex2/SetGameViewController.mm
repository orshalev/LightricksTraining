//
//  SetGameViewController.m
//  ex3
//
//  Created by Or Shalev on 17/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "SetGameViewController.h"

#import "Grid.h"
#import "GridView.h"
#import "SetCard.h"
#import "SetCardDeck.h"
#import "SetCardView.h"

extern const NSInteger kInitialSetCardCount = 12;
extern const NSInteger kMaxNumberOfCards = 36;


@interface SetGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UIView *gridView;

@property (strong, nonatomic) NSMutableArray<UIView *> *cardViews;

@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) Grid* grid;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;

@property (strong, nonatomic) NSLock *lock;

@property (nonatomic) BOOL stacked;

@end

@implementation SetGameViewController

+ (Deck *)createDeck {
  return [[SetCardDeck alloc] init];
}

- (void)resetGame {
  [self removeAllCards];
  [self initNewGame];
}

- (void)initNewGame {
  self.deck = [SetGameViewController createDeck];
  self.game = [[CardMatchingGame alloc] initWithCardCount:kInitialSetCardCount usingDeck:self.deck gameMode:Match3Cards];
  [self initGridView];
  [self initCardViews];
  [self updateUI];
}

- (void)initGridView {
  self.grid = [[Grid alloc] initWithSize:self.gridView.frame.size withAspectRatio:0.666 withMinNumberOfCells:kMaxNumberOfCards];
  self.grid.origin = self.gridView.frame.origin;
  if (![_grid inputsAreValid]) {
    NSLog(@"Inputs for Grid are invalid!\n");
  }
}

- (void)initCardViews {
  self.cardViews = [[NSMutableArray alloc] init];
  for (int i = 0; i < kInitialSetCardCount; i++) {
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

- (void)drawCard {
  if ([self.deck isEmpty] || [self.cardViews count] == kMaxNumberOfCards) {
    return;
  }
  NSUInteger newIndex = [self.game drawCardUsingDeckAndReturnIndex:self.deck];
  [self addCard:newIndex];
}

- (void)addCard:(NSUInteger)cardIndex {
  SetCard *card = (SetCard *)[self.game cardAtIndex:cardIndex];
  CGRect frameForCard = [self.grid frameOfCellAtPos:0];
  SetCardView *newCardView = [[SetCardView alloc] initWithFrame:frameForCard];

  newCardView.delegate = self;
  newCardView.number = card.number;
  newCardView.symbol = (SetSymbol)card.symbol;
  newCardView.striping = (SetStriping)card.striping;
  newCardView.color = card.color;
  newCardView.chosen = NO;
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

  SetCardView *cardView = (SetCardView *)view;
  [self.game chooseCardAtIndex:cardView.cardNum];
  BOOL isChosen = [self.game cardAtIndex:cardView.cardNum].chosen;
  [self updateUI];
  cardView.chosen = isChosen;
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

- (IBAction)touchDraw3Button:(id)sender {
  for (NSUInteger i = 1; i <= 3; i++) {
    [self drawCard];
  }
  [self updateCardsOnGrid];
}

#pragma mark - Animations
#define DIAGONAL_OFFSET_PERCENTAGE 0.02
- (void)updateCardsOnGrid {
  SetGameViewController __weak *weakSelf = self;
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
  SetGameViewController __weak *weakSelf = self;
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
    SetCardView *cardView = (SetCardView *)self.cardViews[i];
    SetCard *card =(SetCard *) [self.game cardAtIndex:cardView.cardNum];
    if (card.isMatched && card.isChosen) {
      [cardsForRemoval addObject:cardView];
    }
    if (cardView.chosen != card.isChosen) {
      cardView.chosen = card.isChosen;
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
