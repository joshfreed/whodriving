//
//  whodrivingTests.m
//  whodrivingTests
//
//  Created by Josh Freed on 9/19/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TripSpecification.h"
#import "TripService.h"
#import "Driver.h"
#import "DriverResult.h"

@interface TripServiceTests : XCTestCase
@property (nonatomic,retain) NSManagedObjectContext *moc;
@property (nonatomic,retain) TripService *tripService;
@end

@implementation TripServiceTests

- (void)setUp {
    [super setUp];

    self.tripService = [[TripService alloc] init];
    
    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle mainBundle]]];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    XCTAssert([psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");
    self.moc = [[NSManagedObjectContext alloc] init];
    self.moc.persistentStoreCoordinator = psc;
}

- (void)tearDown {
    self.moc = nil;
    [super tearDown];
}

- (Driver*)buildDriver:(NSString*)name withPassengerCount:(NSNumber*)passengerCount {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Driver" inManagedObjectContext:self.moc];
    Driver *driver = [[Driver alloc] initWithEntity:entity insertIntoManagedObjectContext:self.moc];
    driver.driverName = name;
    driver.numPassengers = passengerCount;
    [driver enable];
    return driver;
}

- (void)assertResults:(NSArray*)actualResults containsSet:(NSArray*)expectedDriverSet
{
    for (NSArray *actualDriverSet in actualResults) {
        int found = 0;
        for (Driver *expectedDriver in expectedDriverSet) {
            if ([actualDriverSet containsObject:expectedDriver]) {
                found++;
            }
        }
        if (found == expectedDriverSet.count) {
            return;
        }
    }

    XCTFail(@"Missing some expected drivers");
}

- (void)testOneDriverCanDriveEveryone
{
    Driver *driver1 = [self buildDriver:@"Fred" withPassengerCount:@2];
    Driver *driver2 = [self buildDriver:@"Larry" withPassengerCount:@8];
    Driver *driver3 = [self buildDriver:@"Barry" withPassengerCount:@2];
    
    NSMutableArray *drivers = [[NSMutableArray alloc] init];
    [drivers addObject:driver1];
    [drivers addObject:driver2];
    [drivers addObject:driver3];
    TripSpecification *tripSpec = [TripSpecification new];
    tripSpec.passengerCount = 7;
    tripSpec.possibleDrivers = drivers;
    
    NSArray *allResultSets = [self.tripService getAllPossibleResults:tripSpec];
    
    XCTAssertEqual(1, allResultSets.count);
    [self assertResults:allResultSets containsSet:[NSArray arrayWithObjects:driver2, nil]];
}

- (void)testTwoDriversCanDriveEveryone
{
    Driver *driver1 = [self buildDriver:@"Fred" withPassengerCount:@2];
    Driver *driver2 = [self buildDriver:@"Larry" withPassengerCount:@0];
    Driver *driver3 = [self buildDriver:@"Barry" withPassengerCount:@2];
    
    NSMutableArray *drivers = [[NSMutableArray alloc] init];
    [drivers addObject:driver1];
    [drivers addObject:driver2];
    [drivers addObject:driver3];
    TripSpecification *tripSpec = [TripSpecification new];
    tripSpec.passengerCount = 6;
    tripSpec.possibleDrivers = drivers;
    
    NSArray *allResultSets = [self.tripService getAllPossibleResults:tripSpec];
    
    XCTAssertEqual(1, allResultSets.count);
    [self assertResults:allResultSets containsSet:[NSArray arrayWithObjects:driver1, driver3, nil]];
}

- (void)testThreeSetsOfDriversAreCapableOfDriving
{
    Driver *driver1 = [self buildDriver:@"Fred" withPassengerCount:@2];
    Driver *driver2 = [self buildDriver:@"Larry" withPassengerCount:@2];
    Driver *driver3 = [self buildDriver:@"Barry" withPassengerCount:@2];
    
    NSMutableArray *drivers = [[NSMutableArray alloc] init];
    [drivers addObject:driver1];
    [drivers addObject:driver2];
    [drivers addObject:driver3];
    
    TripSpecification *tripSpec = [TripSpecification new];
    tripSpec.passengerCount = 6;
    tripSpec.possibleDrivers = drivers;
    
    // SUT
    NSArray *allResultSets = [self.tripService getAllPossibleResults:tripSpec];
    
    // VERIFY
    XCTAssertEqual(3, allResultSets.count);
    [self assertResults:allResultSets containsSet:[NSArray arrayWithObjects:driver1, driver2, nil]];
    [self assertResults:allResultSets containsSet:[NSArray arrayWithObjects:driver1, driver3, nil]];
    [self assertResults:allResultSets containsSet:[NSArray arrayWithObjects:driver2, driver3, nil]];
}

- (void)testComplicatedScenario
{
    Driver *driver1 = [self buildDriver:@"Fred" withPassengerCount:@1];
    Driver *driver2 = [self buildDriver:@"Larry" withPassengerCount:@2];
    Driver *driver3 = [self buildDriver:@"Barry" withPassengerCount:@3];
    Driver *driver4 = [self buildDriver:@"Sarry" withPassengerCount:@2];
    Driver *driver5 = [self buildDriver:@"Rarry" withPassengerCount:@1];
    
    NSMutableArray *drivers = [[NSMutableArray alloc] init];
    [drivers addObject:driver1];
    [drivers addObject:driver2];
    [drivers addObject:driver3];
    [drivers addObject:driver4];
    [drivers addObject:driver5];
    TripSpecification *tripSpec = [TripSpecification new];
    tripSpec.passengerCount = 7;
    tripSpec.possibleDrivers = drivers;
    
    // SUT
    NSArray *allResultSets = [self.tripService getAllPossibleResults:tripSpec];
    
    // VERIFY
    XCTAssertEqual(7, allResultSets.count);
    [self assertResults:allResultSets containsSet:[NSArray arrayWithObjects:driver3, driver2, nil]];
    [self assertResults:allResultSets containsSet:[NSArray arrayWithObjects:driver3, driver4, nil]];
    [self assertResults:allResultSets containsSet:[NSArray arrayWithObjects:driver3, driver1, driver5, nil]];
    [self assertResults:allResultSets containsSet:[NSArray arrayWithObjects:driver2, driver4, driver1, nil]];
    [self assertResults:allResultSets containsSet:[NSArray arrayWithObjects:driver2, driver4, driver5, nil]];
    [self assertResults:allResultSets containsSet:[NSArray arrayWithObjects:driver2, driver1, driver5, nil]];
    [self assertResults:allResultSets containsSet:[NSArray arrayWithObjects:driver4, driver1, driver5, nil]];
}

@end
