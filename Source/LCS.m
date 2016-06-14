//
//  LCSCore.m
//  LongestCommonSubsequence
//
//  Created by Håvard Fossli on 14.06.2016.
//
//

#import "LCS.h"

@implementation LCS

+ (NSIndexSet *)compareArray:(NSArray *)a
                    andArray:(NSArray *)b
               commonIndexes:(NSIndexSet **)commonIndexesPointer
                addedIndexes:(NSIndexSet **)addedIndexesPointer
              removedIndexes:(NSIndexSet **)removedIndexesPointer
            objectComparison:(BOOL(^)(id objectA, id objectB))objectComparison
{
    NSUInteger aCount = a.count;
    NSUInteger bCount = b.count;
    NSInteger lengths[aCount+1][bCount+1];
    
    BOOL (^compare)(NSUInteger indexA, NSUInteger indexB) = ^BOOL (NSUInteger indexA, NSUInteger indexB) {
        return objectComparison(a[indexA], b[indexB]);
    };
    
    for (NSInteger i = aCount; i >= 0; i--) {
        for (NSInteger j = bCount; j >= 0; j--) {
            
            if (i == aCount || j == bCount) {
                lengths[i][j] = 0;
            } else if (compare(i, j)) {
                lengths[i][j] = 1 + lengths[i+1][j+1];
            } else {
                lengths[i][j] = MAX(lengths[i+1][j], lengths[i][j+1]);
            }
        }
    }
    
    NSMutableIndexSet *commonIndexes = [NSMutableIndexSet indexSet];
    
    for (NSInteger i = 0, j = 0 ; i < aCount && j < bCount; ) {
        if (compare(i, j)) {
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
        NSArray *commonObjects = [a objectsAtIndexes:commonIndexes];
        
        NSMutableIndexSet *addedIndexes = [NSMutableIndexSet indexSet];
        for (NSInteger i = 0, j = 0; i < commonObjects.count || j < bCount; ) {
            if (i < commonObjects.count && j < bCount && [commonObjects[i] isEqual:b[j]]) {
                i++;
                j++;
            } else {
                [addedIndexes addIndex:j];
                j++;
            }
        }
        
        *addedIndexesPointer = addedIndexes;
    }
    
    return commonIndexes;
}

@end
