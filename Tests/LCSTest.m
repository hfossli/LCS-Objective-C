//
//  LCSTest.m
//  LCS-Objective-C
//
//  Created by Håvard Fossli on 23.06.2016.
//
//

#import <XCTest/XCTest.h>
#import "LCS.h"

@interface DataObject : NSObject

@property (nonatomic, assign) NSUInteger uniqueId;
@property (nonatomic, strong) NSString *value;

+ (instancetype)newWithId:(NSUInteger)uniqueId value:(NSString *)value;

@end

@implementation DataObject

+ (instancetype)newWithId:(NSUInteger)uniqueId value:(NSString *)value
{
    DataObject *instance = [self new];
    instance.uniqueId = uniqueId;
    instance.value = value;
    return instance;
}

- (LCSObjectEquallity)compareWith:(DataObject *)objectB
{
    if(self.uniqueId == objectB.uniqueId)
    {
        if([self.value isEqualToString:objectB.value])
        {
            return LCSObjectEquallityEqual;
        }
        return LCSObjectEquallityEqualButUpdated;
    }
    return LCSObjectEquallityUnequal;
}

@end

@interface LCSTest : XCTestCase

@end

@implementation LCSTest

- (void)testNoUpdate
{
    NSArray *a = @[[DataObject newWithId:1000 value:@"aaa"],
                   [DataObject newWithId:1001 value:@"aaa"],
                   [DataObject newWithId:1002 value:@"aaa"]
                   ];
    NSArray *b = @[[DataObject newWithId:1000 value:@"aaa"],
                   [DataObject newWithId:1001 value:@"aaa"],
                   [DataObject newWithId:1002 value:@"aaa"]
                   ];
    
    NSIndexSet *common, *removed, *added, *updated;
    [LCS <DataObject *> compareArray:a withArray:b commonIndexes:&common updatedIndexes:&updated removedIndexes:&removed addedIndexes:&added objectComparison:^LCSObjectEquallity(DataObject *objectA, DataObject *objectB) {
        return [objectA compareWith:objectB];
    }];
    
    NSMutableIndexSet *expectedCommon = [NSMutableIndexSet new];
    [expectedCommon addIndex:0];
    [expectedCommon addIndex:1];
    [expectedCommon addIndex:2];
    XCTAssertEqualObjects(common, expectedCommon, @"Not as expected");
    
    NSMutableIndexSet *expectedRemoved = [NSMutableIndexSet new];
    XCTAssertEqualObjects(removed, expectedRemoved, @"Not as expected");
    
    NSMutableIndexSet *expectedAdded = [NSMutableIndexSet new];
    XCTAssertEqualObjects(added, expectedAdded, @"Not as expected");
    
    NSMutableIndexSet *expectedUpdated = [NSMutableIndexSet new];
    XCTAssertEqualObjects(updated, expectedUpdated, @"Not as expected");
}

- (void)testUpdated
{
    NSArray *a = @[[DataObject newWithId:1000 value:@"aaa"],
                   [DataObject newWithId:1001 value:@"aaa"],
                   [DataObject newWithId:1002 value:@"aaa"]
                   ];
    NSArray *b = @[[DataObject newWithId:1000 value:@"bbb"],
                   [DataObject newWithId:1001 value:@"aaa"],
                   [DataObject newWithId:1002 value:@"ccc"]
                   ];
    
    NSIndexSet *common, *removed, *added, *updated;
    [LCS <DataObject *> compareArray:a withArray:b commonIndexes:&common updatedIndexes:&updated removedIndexes:&removed addedIndexes:&added objectComparison:^LCSObjectEquallity(DataObject *objectA, DataObject *objectB) {
        return [objectA compareWith:objectB];
    }];
    
    NSMutableIndexSet *expectedCommon = [NSMutableIndexSet new];
    [expectedCommon addIndex:0];
    [expectedCommon addIndex:1];
    [expectedCommon addIndex:2];
    XCTAssertEqualObjects(common, expectedCommon, @"Not as expected");
    
    NSMutableIndexSet *expectedUpdated = [NSMutableIndexSet new];
    [expectedUpdated addIndex:0];
    [expectedUpdated addIndex:2];
    XCTAssertEqualObjects(updated, expectedUpdated, @"Not as expected");
    
    NSMutableIndexSet *expectedRemoved = [NSMutableIndexSet new];
    XCTAssertEqualObjects(removed, expectedRemoved, @"Not as expected");
    
    NSMutableIndexSet *expectedAdded = [NSMutableIndexSet new];
    XCTAssertEqualObjects(added, expectedAdded, @"Not as expected");
}

- (void)testUpdatedFirstAndAddedAfter
{
    NSArray *a = @[
                   [DataObject newWithId:1000 value:@"aaa"]
                   ];
    NSArray *b = @[[DataObject newWithId:1000 value:@"bbb"],
                   [DataObject newWithId:1001 value:@"aaa"],
                   [DataObject newWithId:1002 value:@"ccc"]
                   ];
    
    NSIndexSet *common, *removed, *added, *updated;
    [LCS <DataObject *> compareArray:a withArray:b commonIndexes:&common updatedIndexes:&updated removedIndexes:&removed addedIndexes:&added objectComparison:^LCSObjectEquallity(DataObject *objectA, DataObject *objectB) {
        return [objectA compareWith:objectB];
    }];
    
    NSMutableIndexSet *expectedCommon = [NSMutableIndexSet new];
    [expectedCommon addIndex:0];
    XCTAssertEqualObjects(common, expectedCommon, @"Not as expected");
    
    NSMutableIndexSet *expectedUpdated = [NSMutableIndexSet new];
    [expectedUpdated addIndex:0];
    XCTAssertEqualObjects(updated, expectedUpdated, @"Not as expected");
    
    NSMutableIndexSet *expectedRemoved = [NSMutableIndexSet new];
    XCTAssertEqualObjects(removed, expectedRemoved, @"Not as expected");
    
    NSMutableIndexSet *expectedAdded = [NSMutableIndexSet new];
    [expectedAdded addIndex:1];
    [expectedAdded addIndex:2];
    XCTAssertEqualObjects(added, expectedAdded, @"Not as expected");
}

- (void)testAddedBefore
{
    NSArray *a = @[
                   [DataObject newWithId:1002 value:@"aaa"]
                   ];
    NSArray *b = @[[DataObject newWithId:1000 value:@"aaa"],
                   [DataObject newWithId:1001 value:@"aaa"],
                   [DataObject newWithId:1002 value:@"aaa"]
                   ];
    
    NSIndexSet *common, *removed, *added, *updated;
    [LCS <DataObject *> compareArray:a withArray:b commonIndexes:&common updatedIndexes:&updated removedIndexes:&removed addedIndexes:&added objectComparison:^LCSObjectEquallity(DataObject *objectA, DataObject *objectB) {
        return [objectA compareWith:objectB];
    }];
    
    NSMutableIndexSet *expectedCommon = [NSMutableIndexSet new];
    [expectedCommon addIndex:0];
    XCTAssertEqualObjects(common, expectedCommon, @"Not as expected");
    
    NSMutableIndexSet *expectedUpdated = [NSMutableIndexSet new];
    XCTAssertEqualObjects(updated, expectedUpdated, @"Not as expected");
    
    NSMutableIndexSet *expectedRemoved = [NSMutableIndexSet new];
    XCTAssertEqualObjects(removed, expectedRemoved, @"Not as expected");
    
    NSMutableIndexSet *expectedAdded = [NSMutableIndexSet new];
    [expectedAdded addIndex:0];
    [expectedAdded addIndex:1];
    XCTAssertEqualObjects(added, expectedAdded, @"Not as expected");
}

- (void)testUpdatedFirstAddedBefore
{
    NSArray *a = @[
                   [DataObject newWithId:1002 value:@"aaa"]
                   ];
    NSArray *b = @[[DataObject newWithId:1000 value:@"aaa"],
                   [DataObject newWithId:1001 value:@"aaa"],
                   [DataObject newWithId:1002 value:@"bbb"]
                   ];
    
    NSIndexSet *common, *removed, *added, *updated;
    [LCS <DataObject *> compareArray:a withArray:b commonIndexes:&common updatedIndexes:&updated removedIndexes:&removed addedIndexes:&added objectComparison:^LCSObjectEquallity(DataObject *objectA, DataObject *objectB) {
        return [objectA compareWith:objectB];
    }];
    
    NSMutableIndexSet *expectedCommon = [NSMutableIndexSet new];
    [expectedCommon addIndex:0];
    XCTAssertEqualObjects(common, expectedCommon, @"Not as expected");
    
    NSMutableIndexSet *expectedUpdated = [NSMutableIndexSet new];
    [expectedUpdated addIndex:0];
    XCTAssertEqualObjects(updated, expectedUpdated, @"Not as expected");
    
    NSMutableIndexSet *expectedRemoved = [NSMutableIndexSet new];
    XCTAssertEqualObjects(removed, expectedRemoved, @"Not as expected");
    
    NSMutableIndexSet *expectedAdded = [NSMutableIndexSet new];
    [expectedAdded addIndex:0];
    [expectedAdded addIndex:1];
    XCTAssertEqualObjects(added, expectedAdded, @"Not as expected");
}

@end
