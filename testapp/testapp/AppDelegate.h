//
//  AppDelegate.h
//  testapp
//
//  Created by Ilya Glazunov on 25.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

