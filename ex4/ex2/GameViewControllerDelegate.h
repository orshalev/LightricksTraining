//
//  GameViewControllerDelegate.h
//  ex4
//
//  Created by Or Shalev on 28/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GameViewControllerDelegate <NSObject>

-(void)tapCard:(UIView *)cardView;
-(void)panCard:(UIPanGestureRecognizer *)sender;

@end
