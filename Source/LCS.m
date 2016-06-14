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
               commonIndexes:(out NSIndexSet **)commonIndexesPointer
                addedIndexes:(out NSIndexSet **)addedIndexesPointer
              removedIndexes:(out NSIndexSet **)removedIndexesPointer
            objectComparison:(BOOL(^)(id objectA, id objectB))objectComparison
{
    NSUInteger aCount = a.count;
    NSUInteger bCount = b.count;
    NSInteger lengths[aCount+1][bCount+1];
    
    for (NSInteger i = aCount; i >= 0; i--) {
        for (NSInteger j = bCount; j >= 0; j--) {
            
            if (i == aCount || j == bCount) {
                lengths[i][j] = 0;
            } else if (objectComparison(a[i], b[j])) {
                lengths[i][j] = 1 + lengths[i+1][j+1];
            } else {
                lengths[i][j] = MAX(lengths[i+1][j], lengths[i][j+1]);
            }
        }
    }
    
    NSMutableIndexSet *commonIndexes = [NSMutableIndexSet indexSet];
    
    for (NSInteger i = 0, j = 0 ; i < aCount && j < bCount; ) {
        if (objectComparison(a[i], b[j])) {
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
        for (NSInteger i = 0, j = 0; i < commonIndexes.count || j < bCount; ) {
            if (i < commonIndexes.count && j < bCount && objectComparison(a[indexes[i]], b[j])) {
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
