//
//  SetCardView.m
//  ex4
//
//  Created by Or Shalev on 27/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "SetCardView.h"
#import "Grid.h"


static const float kWidthPipFrameRatio = 0.7;
static const float kHeightPipFrameRatio = 0.24;
static const float kHeightPipDistanceRatio = 0.04;
static const float k2PipsHeightStartsRatio = 0.22;
static const float k3PipsHeightStartsRatio = 0.08;

static const float kStrokeWidth = 0.15;

extern const float kSetCornerFontStandardHeight = 180.0;
extern const float kSetCornerRadius = 12.0;

@interface SetCardView()


@end

@implementation SetCardView


#pragma mark - Properties

-(void)setCard:(SetCard *)card {
  _card = card;
  [self setNeedsDisplay];
}
/*
-(Grid *)grid {
  if (!_grid) {
    _grid = [[Grid alloc] initWithSize:self.frame.size
                  withAspectRatio:self.frame.size.height / self.frame.size.width
                  withMinNumberOfCells:self.card.number];
  }
  return _grid;
}*/

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                         cornerRadius:[self cornerRadius]];
  [roundedRect addClip];

  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);

  [[UIColor blackColor] setStroke];
  [roundedRect stroke];

  [self drawPips];
}



- (void)drawPips {
  for (NSUInteger i = 0; i < [self.card number]; i++) {
    CGRect pipRect = [self rectForPip:i];
    [self drawPipAtRect:pipRect];
  }
}

- (CGRect)rectForPip:(NSUInteger)pos {
  CGFloat x,y;

  x = self.bounds.size.width * ((1 - kWidthPipFrameRatio) / 2);

  switch ([self.card number]) {
    case 1:
      y = self.bounds.size.height * ((1 - kHeightPipFrameRatio) / 2);
      break;
    case 2:
      y = self.bounds.size.height * ((k2PipsHeightStartsRatio + (kHeightPipDistanceRatio + kHeightPipFrameRatio) * (pos / ([self.card number] - 1))));
      break;
    case 3:
      y = self.bounds.size.height * ((k3PipsHeightStartsRatio + (kHeightPipDistanceRatio + kHeightPipFrameRatio) * pos));
      break;
    default:
      return self.bounds;
  }

  return CGRectMake(x, y, self.bounds.size.width * kWidthPipFrameRatio, self.bounds.size.height * kHeightPipFrameRatio);
}

- (void)drawPipAtRect:(CGRect)rect {
  switch ([self.card symbol]) {
    case diamondSymbol:
      [self drawDiamondAtRect:rect];
      break;
    case squiggleSymbol:
      [self drawSquiggleAtRect:rect];
      break;
    case ovalSymbol:
      [self drawOvalAtRect:rect];
      break;
    default:
      break;
  }
}

- (void)drawDiamondAtRect:(CGRect)rect {
  UIBezierPath *path = [[UIBezierPath alloc] init];
  [path moveToPoint:CGPointMake(rect.origin.x,
                                rect.origin.y + rect.size.height/2)];
  [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2,
                                   rect.origin.y + rect.size.height)];
  [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width,
                                   rect.origin.y + rect.size.height/2)];
  [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2,
                                   rect.origin.y)];
  [path addLineToPoint:CGPointMake(rect.origin.x,
                                   rect.origin.y + rect.size.height/2)];

  path.lineWidth = rect.size.height * kStrokeWidth;
  [[self.card color] setStroke];
  [path stroke];
  [self fillPath:path inRect:rect];
}

// Code adapted from: cs193p.m2m.at
#define SQUIGGLE_WIDTH 0.25
#define SQUIGGLE_HEIGHT 0.35
#define SQUIGGLE_FACTOR 0.8
- (void)drawSquiggleAtRect:(CGRect)rect {
  UIBezierPath *path = [[UIBezierPath alloc] init];
  CGPoint point = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height/2);

  CGFloat dx = self.bounds.size.width * SQUIGGLE_WIDTH / 2.0;
  CGFloat dy = self.bounds.size.height * SQUIGGLE_HEIGHT / 2.0;
  CGFloat dsqx = dx * SQUIGGLE_FACTOR;
  CGFloat dsqy = dy * SQUIGGLE_FACTOR;

  [path moveToPoint:CGPointMake(point.x - dx, point.y - dy)];
  [path addQuadCurveToPoint:CGPointMake(point.x + dx, point.y - dy)
               controlPoint:CGPointMake(point.x - dsqx, point.y - dy - dsqy)];
  [path addCurveToPoint:CGPointMake(point.x + dx, point.y + dy)
          controlPoint1:CGPointMake(point.x + dx + dsqx, point.y - dy + dsqy)
          controlPoint2:CGPointMake(point.x + dx - dsqx, point.y + dy - dsqy)];
  [path addQuadCurveToPoint:CGPointMake(point.x - dx, point.y + dy)
               controlPoint:CGPointMake(point.x + dsqx, point.y + dy + dsqy)];
  [path addCurveToPoint:CGPointMake(point.x - dx, point.y - dy)
          controlPoint1:CGPointMake(point.x - dx - dsqx, point.y + dy - dsqy)
          controlPoint2:CGPointMake(point.x - dx + dsqx, point.y - dy + dsqy)];

  CGAffineTransform transform = CGAffineTransformIdentity;
  transform = CGAffineTransformTranslate(transform, point.x, point.y);
  transform = CGAffineTransformRotate(transform, M_PI/2);
  transform = CGAffineTransformTranslate(transform, -point.x, -point.y);

  [path applyTransform:transform];

  path.lineWidth = rect.size.height * kStrokeWidth;
  [[self.card color] setStroke];
  [path stroke];
  [self fillPath:path inRect:rect];
}

- (void)drawOvalAtRect:(CGRect)rect {
  UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.height/2];
  path.lineWidth = rect.size.height * kStrokeWidth;
  [[self.card color] setStroke];
  [path stroke];
  [self fillPath:path inRect:rect];
}

- (void)fillPath:(UIBezierPath *)path inRect:(CGRect)rect {
  switch ([self.card striping]) {
    case solidStriping:
      [[self.card color] setFill];
      [path fill];
      break;
    case stripedStriping:
      [self fillWithStripesPath:path inRect:rect];
      break;
    case openStriping:
      [[UIColor clearColor] setFill];
      [path fill];
      break;
    default:
      break;
  }
}

- (void)fillWithStripesPath:(UIBezierPath *)path inRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  [path addClip];

  UIBezierPath *pathStripes = [[UIBezierPath alloc] init];
  for (int i = 0; i < 5 ;i++) {
    [pathStripes moveToPoint:CGPointMake(rect.origin.x + i*rect.size.width/5,
                                         rect.origin.y)];
    [pathStripes addLineToPoint:CGPointMake(rect.origin.x + (i+1)*rect.size.width/5,
                                         rect.origin.y + rect.size.height)];

  }

  pathStripes.lineWidth = self.bounds.size.width * kWidthPipFrameRatio / 10;
  [[self.card color] setStroke];
  [pathStripes stroke];

  CGContextRestoreGState(context);
}


-(CGFloat)cornerOffset {
  return [self cornerRadius] / 3.0;
}

-(CGFloat)cornerRadius {
  return kSetCornerRadius * [self cornerScaleFactor];
}

-(CGFloat)cornerScaleFactor {
  return self.bounds.size.height / kSetCornerFontStandardHeight;
}



#pragma mark - Initialization
-(void)awakeFromNib {
  [super awakeFromNib];
  [self setup];
}

-(void)setup {
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}


-(instancetype)initWithFrame:(CGRect)frame {
  if (! (self = [super init])) {
    return nil;
  }

  /**/

  return self;
}


@end
