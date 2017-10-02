//
//  GameViewControllerDelegate.h
//  ex4
//
//  Created by Or Shalev on 28/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol GameViewControllerDelegate <NSObject>

-(BOOL)flipCard:(UIView *)cardView;

@end
