//
//  AppDelegate.h
//  ex2
//
//  Created by Or Shalev on 12/09/2017.
//  Copyright © 2017 Or Shalev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

