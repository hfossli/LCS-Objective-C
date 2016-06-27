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

#import "LCS.h"

@implementation LCSIndex

- (instancetype)initWithIndex:(NSUInteger)indexInA and:(NSUInteger)indexInB
{
    self = [self init];
    if(self)
    {
        _indexInA = indexInA;
        _indexInB = indexInB;
    }
    return self;
}

@end

@implementation LCS

+ (void)compareArray:(NSArray *)a
           withArray:(NSArray *)b
       commonIndexes:(out NSArray <LCSIndex *> **)commonIndexesPointer
      removedIndexes:(out NSIndexSet **)removedIndexesPointer
        addedIndexes:(out NSIndexSet **)addedIndexesPointer
    objectComparison:(BOOL(^)(id objectA, id objectB))objectComparison
{
    [self compareListWithCount:a.count
                          with:b.count
                 commonIndexes:commonIndexesPointer
                removedIndexes:removedIndexesPointer
                  addedIndexes:addedIndexesPointer
              objectComparison:^BOOL(NSUInteger indexA, NSUInteger indexB) {
        return objectComparison(a[indexA], b[indexB]);
    }];
}

+ (void)compareListWithCount:(NSUInteger)countA
                        with:(NSUInteger)countB
               commonIndexes:(out NSArray <LCSIndex *> **)commonIndexesPointer
              removedIndexes:(out NSIndexSet **)removedIndexesPointer
                addedIndexes:(out NSIndexSet **)addedIndexesPointer
            objectComparison:(BOOL(^)(NSUInteger indexA, NSUInteger indexB))objectComparison
{
    NSInteger lengths[countA+1][countB+1];
    BOOL cache[countA+1][countB+1];
    
    for (NSInteger i = countA; i >= 0; i--) {
        for (NSInteger j = countB; j >= 0; j--) {
            if (i == countA || j == countB) {
                lengths[i][j] = 0;
            }
            else {
                BOOL equal = objectComparison(i, j);
                cache[i][j] = equal;
                if (equal) {
                    lengths[i][j] = 1 + lengths[i+1][j+1];
                } else {
                    lengths[i][j] = MAX(lengths[i+1][j], lengths[i][j+1]);
                }
            }
        }
    }
    
    NSMutableArray <LCSIndex *> *common = [NSMutableArray new];
    NSMutableIndexSet *removedIndexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(0, countA)];
    
    for (NSInteger i = 0, j = 0 ; i < countA && j < countB;) {
        BOOL equal = cache[i][j];
        if (equal) {
            [removedIndexes removeIndex:i];
            [common addObject:[[LCSIndex alloc] initWithIndex:i and:j]];
            i++; j++;
        } else if (lengths[i+1][j] >= lengths[i][j+1]) {
            i++;
        } else {
            j++;
        }
    }
    
    if (commonIndexesPointer) {
        *commonIndexesPointer = common;
    }
    
    if (removedIndexesPointer) {
        *removedIndexesPointer = removedIndexes;
    }
    
    if (addedIndexesPointer) {
        
        NSUInteger commonIndexesArray[common.count];
        for(NSUInteger i = 0; i < common.count; i++)
        {
            commonIndexesArray[i] = common[i].indexInA;
        }

        NSMutableIndexSet *addedIndexes = [NSMutableIndexSet indexSet];
        for (NSInteger i = 0, j = 0; i < common.count || j < countB;) {
            if (i < common.count && j < countB && cache[commonIndexesArray[i]][j]) {
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
