//
//  HMMutableArray.m
//  HMSafeList
//
//  Created by humiao on 2020/1/15.
//  Copyright © 2020 humiao. All rights reserved.
//

#import "HMMutableArray.h"

@interface HMMutableArray ()

@property (nonatomic, strong) dispatch_queue_t parallelQueue;
@property (nonatomic, strong) NSMutableArray *hm_array;

@end


@implementation HMMutableArray

- (void)dealloc{
    if (_parallelQueue) {
        _parallelQueue = NULL;
    }
}

- (instancetype)initHMMutableArray {
    self = [super init];
    if (self) {
        NSString *uuid = [NSString stringWithFormat:@"com.hm.www.HMMutableArray_%p",self];
        _parallelQueue = dispatch_queue_create([uuid UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (instancetype)init {
    self = [self initHMMutableArray];
    if (self) {
        _hm_array = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 数据操作方法 (凡涉及更改数组中元素的操作，使用异步派发+栅栏块；读取数据使用 同步派发+并行队列)
- (NSUInteger)count{
    __weak __typeof(&*self) weakSelf = self;
    __block NSUInteger count;
    dispatch_sync(_parallelQueue, ^{
        count = weakSelf.hm_array.count;
    });
    return count;
}

- (id)objectAtIndex:(NSUInteger)index{
    __weak __typeof(&*self) weakSelf = self;
    __block id obj;
    dispatch_sync(_parallelQueue, ^{
        if (index < [weakSelf.hm_array count]) {
            obj = weakSelf.hm_array[index];
        }
    });
    return obj;
}

- (NSEnumerator *)objectEnumerator{
    __weak __typeof(&*self) weakSelf = self;
    __block NSEnumerator *enu;
    dispatch_sync(_parallelQueue, ^{
        enu = [weakSelf.hm_array objectEnumerator];
    });
    return enu;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    __weak __typeof(&*self) weakSelf = self;
    dispatch_barrier_async(_parallelQueue, ^{
        if (anObject && index < [weakSelf.hm_array count]) {
            [weakSelf.hm_array insertObject:anObject atIndex:index];
        }
    });
}

- (void)addObject:(id)anObject{
    __weak __typeof(&*self) weakSelf = self;
    dispatch_barrier_async(_parallelQueue, ^{
        if (anObject) {
            [weakSelf.hm_array addObject:anObject];
        }
    });
}

- (void)removeObjectAtIndex:(NSUInteger)index{
    __weak __typeof(&*self) weakSelf = self;
    dispatch_barrier_async(_parallelQueue, ^{
        if (index < [weakSelf.hm_array count]) {
            [weakSelf.hm_array removeObjectAtIndex:index];
        }
    });
}

- (void)removeLastObject{
    __weak __typeof(&*self) weakSelf = self;
    dispatch_barrier_async(_parallelQueue, ^{
        [weakSelf.hm_array removeLastObject];
    });
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    __weak __typeof(&*self) weakSelf = self;
    dispatch_barrier_async(_parallelQueue, ^{
        if (anObject && index < [weakSelf.hm_array count]){
            [weakSelf.hm_array replaceObjectAtIndex:index withObject:anObject];
        }
    });
}

- (NSUInteger)indexOfObject:(id)anObject{
    __weak __typeof(&*self) weakSelf = self;
    __block NSUInteger index = NSNotFound;
    dispatch_sync(_parallelQueue, ^{
        for (int i = 0; i < [weakSelf.hm_array count]; i++){
            if ([weakSelf.hm_array objectAtIndex:i] == anObject) {
                index = i;
                break;
            }
        }
    });
    return index;
}



@end
