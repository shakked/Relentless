//
//  ExerciseStore.h
//  Relentless
//
//  Created by pixable on 6/24/15.
//  Copyright (c) 2015 Zachary Shakked. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Activity;
@class ActivityEvent;
@interface ActivityStore : NSObject

+ (instancetype)sharedStore;
- (BOOL)saveCoreDataChanges;

- (ActivityEvent *)activityEventForDate:(NSDate *)date;
- (void)deleteActivity:(Activity *)activity;
- (Activity *)createActivity;

@end
