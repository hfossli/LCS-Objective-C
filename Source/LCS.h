//
//  LCSCore.h
//  LongestCommonSubsequence
//
//  Created by Håvard Fossli on 14.06.2016.
//
//

#import <Foundation/Foundation.h>

@interface LCS : NSObject

+ (NSIndexSet *)compareArray:(NSArray *)a
                    andArray:(NSArray *)b
               commonIndexes:(out NSIndexSet **)common
                addedIndexes:(out NSIndexSet **)added
              removedIndexes:(out NSIndexSet **)removed
            objectComparison:(BOOL(^)(id objectA, id objectB))objectComparison;

@end
