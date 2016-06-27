//
// Author: Håvard Fossli <hfossli@agens.no>
// Author: Soroush Khanlou <soroush@khanlou.com>
//
// Copyright (c) 2013 Agens AS (http://agens.no/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

@interface LCSIndex : NSObject
@property (nonatomic, assign, readonly) NSUInteger indexInA;
@property (nonatomic, assign, readonly) NSUInteger indexInB;
@end

@interface LCS <ObjectType> : NSObject

/*
 In order to reproduce `b` array using `a`:
 1. Make a mutable copy of `a`
 2. Remove indexes
 3. Add indexes
 */
+ (void)compareArray:(NSArray <ObjectType> *)a
           withArray:(NSArray <ObjectType> *)b
       commonIndexes:(out NSArray <LCSIndex *> **)commonIndexesPointer
      removedIndexes:(out NSIndexSet **)removedIndexesPointer
        addedIndexes:(out NSIndexSet **)addedIndexesPointer
    objectComparison:(BOOL(^)(ObjectType objectA, ObjectType objectB))objectComparison;

/*
 Can be used with strings, arrays, index set and any other ordered enumeratable construct
 */
+ (void)compareListWithCount:(NSUInteger)countA
                        with:(NSUInteger)countB
               commonIndexes:(out NSArray <LCSIndex *> **)commonIndexesPointer
              removedIndexes:(out NSIndexSet **)removedIndexesPointer
                addedIndexes:(out NSIndexSet **)addedIndexesPointer
            objectComparison:(BOOL(^)(NSUInteger indexA, NSUInteger indexB))objectComparison;

@end
