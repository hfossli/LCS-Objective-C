//
//  LCSCore.m
//  LongestCommonSubsequence
//
//  Created by Håvard Fossli on 14.06.2016.
//
//

#import "LCS.h"

typedef NS_ENUM(NSUInteger, _LCSObjectEquallity)
{
    _LCSObjectEquallityUnknown,
    _LCSObjectEquallityEqual,
    _LCSObjectEquallityUnequal,
};

@implementation LCS

+ (NSIndexSet *)compareArray:(NSArray *)a
                    andArray:(NSArray *)b
               commonIndexes:(out NSIndexSet **)commonIndexesPointer
                addedIndexes:(out NSIndexSet **)addedIndexesPointer
              removedIndexes:(out NSIndexSet **)removedIndexesPointer
            objectComparison:(BOOL(^)(id objectA, id objectB))objectComparison
{
    NSUInteger aCount = a.count;
    NSUInteger bCount = b.count;
    NSInteger lengths[aCount+1][bCount+1];
    _LCSObjectEquallity cache[aCount+1][bCount+1];
    
    for (NSInteger i = aCount; i >= 0; i--) {
        for (NSInteger j = bCount; j >= 0; j--) {
            
            if (i == aCount || j == bCount) {
                lengths[i][j] = 0;
            } else if (objectComparison(a[i], b[j])) {
                cache[i][j] = _LCSObjectEquallityEqual;
                lengths[i][j] = 1 + lengths[i+1][j+1];
            } else {
                cache[i][j] = _LCSObjectEquallityUnequal;
                lengths[i][j] = MAX(lengths[i+1][j], lengths[i][j+1]);
            }
        }
    }
    
    NSMutableIndexSet *commonIndexes = [NSMutableIndexSet indexSet];
    
    for (NSInteger i = 0, j = 0 ; i < aCount && j < bCount;) {
        _LCSObjectEquallity equality = cache[i][j];
        NSAssert(equality == _LCSObjectEquallityUnequal || equality == _LCSObjectEquallityEqual, @"The cache should be filled up and these values should be the only valid values. Received %i", (int)equality);
        if (equality == _LCSObjectEquallityEqual) {
            [commonIndexes addIndex:i];
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

        NSUInteger indexes[commonIndexes.count];
        [commonIndexes getIndexes:indexes maxCount:commonIndexes.count inIndexRange:nil];
        
        NSMutableIndexSet *addedIndexes = [NSMutableIndexSet indexSet];
        for (NSInteger i = 0, j = 0; i < commonIndexes.count || j < bCount;) {
            if (i < commonIndexes.count && j < bCount && cache[indexes[i]][j] == _LCSObjectEquallityEqual) {
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
