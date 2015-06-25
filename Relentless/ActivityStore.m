//
//  ActivityEventStore.m
//  Relentless
//
//  Created by pixable on 6/24/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import "ActivityStore.h"
#import "Relentless-Swift.h"

@import CoreData;

@interface ActivityStore()

@property (nonatomic, strong) NSMutableArray *privateActivityEvents;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation ActivityStore

//- (Activity *)createActivity {
//    Activity *activity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity"
//                                                       inManagedObjectContext:self.context];
//    [self.privateActivities addObject:activity];
//    return activity;
//}

- (ActivityEvent *)activityEventForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    for (ActivityEvent *activityEvent in self.privateActivityEvents) {
        if ([calendar isDate:date inSameDayAsDate:activityEvent.date]) {
            return activityEvent;
        }
    }
    return [self createActivityEventForDate:date];
}

- (ActivityEvent *)createActivityEventForDate:(NSDate *)date {
    ActivityEvent *activityEvent = [NSEntityDescription insertNewObjectForEntityForName:@"ActivityEvent"
                                                                 inManagedObjectContext:self.context];
    activityEvent.date = date;
    [self.privateActivityEvents addObject:activityEvent];
    return activityEvent;
}

- (Activity *)createActivity {
    Activity *activity = [NSEntityDescription insertNewObjectForEntityForName:@"Activity"
                                                       inManagedObjectContext:self.context];
    return activity;
}

- (void)deleteActivity:(Activity *)activity {
    NSLog(@"Attempting deletion of: %@", activity.name);
    activity.activityEvent = nil;
    [self.context deleteObject:activity];
}

#pragma mark - CoreData and Init Junk
+ (instancetype)sharedStore {
    static ActivityStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedStore = [[self alloc] initPrivate];
    });
    
    return sharedStore;
}

- (BOOL)saveCoreDataChanges {
    
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (instancetype)initPrivate {
    
    self = [super init];
    
    if (self) {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        NSString *path = [self itemArchivePath];
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        NSError *error = nil;
        
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES,
                                  NSInferMappingModelAutomaticallyOption: @YES
                                  };
        BOOL successOfAdding = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:storeURL
                                                       options:options
                                                         error:&error] != nil;
        if (successOfAdding == NO)
        {
            // Check if the database is there.
            // If it is there, it most likely means that model has changed significantly.
            if ([[NSFileManager defaultManager] fileExistsAtPath:storeURL.path])
            {
                // Delete the database
                [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
                // Trying to add a database to the coordinator again
                successOfAdding = [psc addPersistentStoreWithType: NSSQLiteStoreType
                                                    configuration:nil
                                                              URL:storeURL
                                                          options:nil
                                                            error:&error] != nil;
                if (successOfAdding == NO)
                {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    abort();
                }
            }
        }
        
        [self loadAllItems];
    }
    return self;
}

- (NSString *)itemArchivePath {
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask,
                                                                       YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (void)loadAllItems {
    
    if (!self.privateActivityEvents) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"ActivityEvent"
                                             inManagedObjectContext:self.context];
        
        request.entity = e;
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateActivityEvents = [[NSMutableArray alloc] initWithArray:result];
    }
    for (ActivityEvent *event in self.privateActivityEvents) {
        NSLog(@"Have event for date: %@", [event.date string]);
    }
}

@end
