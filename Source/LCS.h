//
//  LCSCore.h
//  LongestCommonSubsequence
//
//  Created by Håvard Fossli on 14.06.2016.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, LCSObjectEquallity)
{
    LCSObjectEquallityUnequal,
    LCSObjectEquallityEqual,
    LCSObjectEquallityEqualButUpdated,
};

@interface LCS <ObjectType> : NSObject

/*
 In order to reproduce `b` array using `a`:
 1. Make a mutable copy of `a`
 2. Remove indexes
 3. Add indexes
 */
+ (void)compareArray:(NSArray <ObjectType> *)a
           withArray:(NSArray <ObjectType> *)b
       commonIndexes:(out NSIndexSet **)commonIndexesPointer
      removedIndexes:(out NSIndexSet **)removedIndexesPointer
        addedIndexes:(out NSIndexSet **)addedIndexesPointer
    objectComparison:(BOOL(^)(ObjectType objectA, ObjectType objectB))objectComparison;

/*
 In order to reproduce `b` array using `a`:
 1. Make a mutable copy of `a`
 2. Update indexes
 3. Remove indexes
 4. Add indexes
 */
+ (void)compareArray:(NSArray <ObjectType> *)a
           withArray:(NSArray <ObjectType> *)b
       commonIndexes:(out NSIndexSet **)commonIndexesPointer
      updatedIndexes:(out NSIndexSet **)updatedIndexesPointer
      removedIndexes:(out NSIndexSet **)removedIndexesPointer
        addedIndexes:(out NSIndexSet **)addedIndexesPointer
    objectComparison:(LCSObjectEquallity(^)(ObjectType objectA, ObjectType objectB))objectComparison;

/*
 Can be used with strings, arrays, index set and any other ordered enumeratable construct
 */
+ (void)compareListWithCount:(NSUInteger)countA
                        with:(NSUInteger)countB
               commonIndexes:(out NSIndexSet **)commonIndexesPointer
              updatedIndexes:(out NSIndexSet **)updatedIndexesPointer
              removedIndexes:(out NSIndexSet **)removedIndexesPointer
                addedIndexes:(out NSIndexSet **)addedIndexesPointer
            objectComparison:(LCSObjectEquallity(^)(NSUInteger indexA, NSUInteger indexB))objectComparison;

@end
