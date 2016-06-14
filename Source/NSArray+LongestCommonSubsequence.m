//
//  NSArray+LongestCommonSubsequence.m
//  LongestCommonSubsequence
//
//  Created by Soroush Khanlou on 11/6/13.
//
//

#import "NSArray+LongestCommonSubsequence.h"
#import "LCS.h"

@implementation NSArray (LongestCommonSubsequence)

- (NSIndexSet *)indexesOfCommonElementsWithArray:(NSArray *)array
{
    return [self indexesOfCommonElementsWithArray:array addedIndexes:nil removedIndexes:nil];
}

- (NSIndexSet *)indexesOfCommonElementsWithArray:(NSArray *)array
                                    addedIndexes:(NSIndexSet **)addedIndexes
                                  removedIndexes:(NSIndexSet **)removedIndexes
{
    NSIndexSet *commonIndexes = nil;
    
    [LCS compareArray:self
            withArray:array
        commonIndexes:&commonIndexes
         addedIndexes:addedIndexes
       removedIndexes:removedIndexes
     objectComparison:^BOOL(id objectA, id objectB) {
        return [objectA isEqual:objectB];
    }];
    
    return commonIndexes;
}

@end
