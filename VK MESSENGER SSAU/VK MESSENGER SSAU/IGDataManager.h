//
//  IGDataManager.h
//  VK MESSENGER SSAU
//
//  Created by Ilya Glazunov on 25.12.16.
//  Copyright © 2016 Ilya Glazunov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface IGDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *mainContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *privateWriterContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
