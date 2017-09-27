//
//  CardGridHandler.m
//  ex4
//
//  Created by Or Shalev on 26/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import "CardGridHandler.h"
#import "Grid.h"

@interface CardGridHandler ()

@property (strong, nonatomic) Grid *grid;

@end


@implementation CardGridHandler

/*
 @property (nonatomic) CGSize size;                      // overall available space to put grid into
 @property (nonatomic) CGFloat cellAspectRatio;          // width divided by height (of each cell)
 @property (nonatomic) NSUInteger minimumNumberOfCells;*/
- (id)initWithSize:(CGSize *)size withAspectRatio:(CGFloat)cellAspectRatio withMinNumberOfCells:(NSUInteger)minimumNumberOfCells {
  if (! (self = [super init])) {
    return nil;
  }

  self.grid = [[Grid alloc] init];


  return self;
}

/*
@property (nonatomic) CGSize size;                      // overall available space to put grid into
@property (nonatomic) CGFloat cellAspectRatio;          // width divided by height (of each cell)
@property (nonatomic) NSUInteger minimumNumberOfCells;

- (CGPoint)centerOfCellAtRow:(NSUInteger)row inColumn:(NSUInteger)column;
- (CGRect)frameOfCellAtRow:(NSUInteger)row inColumn:(NSUInteger)column;
*/

@end
