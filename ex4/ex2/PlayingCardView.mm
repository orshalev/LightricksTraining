//
//  SuperCard.m
//  ex4
//
//  Created by Or Shalev on 27/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "PlayingCardView.h"

@implementation PlayingCardView


#pragma mark - Properties
- (void)setSuit:(NSString *)suit {
  _suit = suit;
  [self setNeedsDisplay];
}

- (void)setRank:(NSUInteger)rank {
  _rank = rank;
  [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp {
  _faceUp = faceUp;
  [self setNeedsDisplay];
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                         cornerRadius:[self cornerRadius]];
  [roundedRect addClip];

  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);

  [[UIColor blackColor] setStroke];
  [roundedRect stroke];

  if (self.faceUp) {
    [self drawCorners];
  } else {
    [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
  }
}

- (void)drawCorners {
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;

  UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];

  NSString *cornerNonattributedText = [NSString stringWithFormat:@"%@\n%@",
                                       [self rankAsString], self.suit];
  NSAttributedString *cornerAttributedText = [[NSAttributedString alloc]
                                              initWithString:cornerNonattributedText
                                              attributes:@{NSFontAttributeName:cornerFont,
                                                           NSParagraphStyleAttributeName:paragraphStyle}];

  CGRect textBounds;
  textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
  textBounds.size = [cornerAttributedText size];
  [cornerAttributedText drawInRect:textBounds];

  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
  CGContextRotateCTM(context, M_PI);
  [cornerAttributedText drawInRect:textBounds];

}

- (NSString *) rankAsString {
  return @[@"?",
           @"A", @"2", @"3", @"4", @"5",
           @"6", @"7", @"8", @"9", @"10",
           @"J", @"Q", @"K"][self.rank];
}


extern const float kCornerFontStandardHeight = 180.0;
extern const float kCornerRadius = 12.0;

-(CGFloat)cornerOffset {
  return [self cornerRadius] / 3.0;
}

-(CGFloat)cornerRadius {
  return kCornerRadius * [self cornerScaleFactor];
}

-(CGFloat)cornerScaleFactor {
  return self.bounds.size.height / kCornerFontStandardHeight;
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
