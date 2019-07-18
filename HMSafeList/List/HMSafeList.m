//
//  HMSafeList.m
//  HMSafeList
//
//  Created by humiao on 2019/7/18.
//  Copyright © 2019 humiao. All rights reserved.
//

#import "HMSafeList.h"

@implementation HMSafeList

- (void)dealloc
{
    //    pthread_mutex_destroy(&_mutex);
}

- (instancetype)init
{
    if (self = [super init])
    {
        //        pthread_mutex_init(&_mutex, NULL);
        _safeArray = [NSMutableArray array];
        _lock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)lock
{
    //    pthread_mutex_lock(&_mutex);
    OSSpinLockLock(&_lock);
}

- (void)unlock
{
    //    pthread_mutex_unlock(&_mutex);
    OSSpinLockUnlock(&_lock);
}

- (void)addObject:(id)anObject
{
    [self lock];
    [_safeArray addObject:anObject];
    [self unlock];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    [self lock];
    [_safeArray insertObject:anObject atIndex:index];
    [self unlock];
    
}

@end
