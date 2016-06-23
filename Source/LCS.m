//
//  LCSCore.m
//  LongestCommonSubsequence
//
//  Created by Håvard Fossli on 14.06.2016.
//
//

#import "LCS.h"

@implementation LCS

+ (void)compareArray:(NSArray *)a
           withArray:(NSArray *)b
       commonIndexes:(out NSIndexSet **)commonIndexesPointer
      removedIndexes:(out NSIndexSet **)removedIndexesPointer
        addedIndexes:(out NSIndexSet **)addedIndexesPointer
    objectComparison:(BOOL(^)(id objectA, id objectB))objectComparison
{
    return [self compareArray:a withArray:b commonIndexes:commonIndexesPointer updatedIndexes:nil removedIndexes:removedIndexesPointer addedIndexes:addedIndexesPointer objectComparison:^LCSObjectEquallity(id objectA, id objectB) {
        return objectComparison(objectA, objectB) ? LCSObjectEquallityEqual : LCSObjectEquallityUnequal;
    }];
}

+ (void)compareArray:(NSArray *)a
           withArray:(NSArray *)b
       commonIndexes:(out NSIndexSet **)commonIndexesPointer
      updatedIndexes:(out NSIndexSet **)updatedIndexesPointer
      removedIndexes:(out NSIndexSet **)removedIndexesPointer
        addedIndexes:(out NSIndexSet **)addedIndexesPointer
    objectComparison:(LCSObjectEquallity(^)(id objectA, id objectB))objectComparison
{
    NSUInteger aCount = a.count;
    NSUInteger bCount = b.count;
    NSInteger lengths[aCount+1][bCount+1];
    LCSObjectEquallity cache[aCount+1][bCount+1];
    
    for (NSInteger i = aCount; i >= 0; i--) {
        for (NSInteger j = bCount; j >= 0; j--) {
            if (i == aCount || j == bCount) {
                lengths[i][j] = 0;
            }
            else {
                LCSObjectEquallity equality = objectComparison(a[i], b[j]);
                cache[i][j] = equality;
                if (equality != LCSObjectEquallityUnequal) {
                    lengths[i][j] = 1 + lengths[i+1][j+1];
                } else {
                    lengths[i][j] = MAX(lengths[i+1][j], lengths[i][j+1]);
                }
            }
        }
    }
    
    NSMutableIndexSet *commonIndexes = [NSMutableIndexSet indexSet];
    NSMutableIndexSet *updatedIndexes = [NSMutableIndexSet indexSet];
    
    for (NSInteger i = 0, j = 0 ; i < aCount && j < bCount;) {
        
        LCSObjectEquallity equality = cache[i][j];
        
        NSAssert(^{
            return equality == LCSObjectEquallityUnequal || equality == LCSObjectEquallityEqual || equality == LCSObjectEquallityEqualButUpdated;
        }(), @"The cache should be filled up and these values should be the only valid values. Received %i", (int)equality);
        
        if (equality == LCSObjectEquallityEqual) {
            [commonIndexes addIndex:i];
            i++; j++;
        }
        else if (equality == LCSObjectEquallityEqualButUpdated) {
            [commonIndexes addIndex:i];
            [updatedIndexes addIndex:i];
            i++; j++;
        } else if (lengths[i+1][j] >= lengths[i][j+1]) {
            i++;
        } else {
            j++;
        }
    }
    
    if (commonIndexesPointer) {
        *commonIndexesPointer = commonIndexes;
    }
    
    if (updatedIndexesPointer) {
        *updatedIndexesPointer = updatedIndexes;
    }
    
    if (removedIndexesPointer) {
        NSMutableIndexSet *removedIndexes = [NSMutableIndexSet indexSet];
        
        for (NSInteger i = 0; i < aCount; i++) {
            if (![commonIndexes containsIndex:i]) {
                [removedIndexes addIndex:i];
            }
        }
        *removedIndexesPointer = removedIndexes;
    }
    
    if (addedIndexesPointer) {
        
        NSUInteger commonIndexesArray[commonIndexes.count];
        [commonIndexes getIndexes:commonIndexesArray maxCount:commonIndexes.count inIndexRange:nil];

        NSMutableIndexSet *addedIndexes = [NSMutableIndexSet indexSet];
        for (NSInteger i = 0, j = 0; i < commonIndexes.count || j < bCount;) {
            if (i < commonIndexes.count && j < bCount && cache[commonIndexesArray[i]][j] != LCSObjectEquallityUnequal) {
                i++;
                j++;
            } else {
                [addedIndexes addIndex:j];
                j++;
            }
        }
        
        *addedIndexesPointer = addedIndexes;
    }
}

@end
