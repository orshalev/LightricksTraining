//
//  CardGridHandler.h
//  ex4
//
//  Created by Or Shalev on 26/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Grid.h"

@interface CardGridHandler : NSObject

- (id)initWithSize:(CGSize *)size withAspectRatio:(CGFloat)cellAspectRatio withMinNumberOfCells:(NSUInteger)minimumNumberOfCells;

@property (strong, nonatomic) Grid *grid;

- (CGPoint)centerOfCellAtPos:(NSUInteger)column;
- (CGRect)frameOfCellAtpos:(NSUInteger)row;

@end
