//
//  TripSpecTests.m
//  Who's Driving?!
//
//  Created by Josh Freed on 11/16/14.
//  Copyright (c) 2014 Josh Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "TripSpecification.h"
#import "Driver.h"

@interface TripSpecTests : XCTestCase
@property (nonatomic,retain) NSManagedObjectContext *moc;
@end

@implementation TripSpecTests

- (void)setUp {
    [super setUp];

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

- (void)testIsNotSatisfiedBySetWithOneDriverWhoCanNotCarryEveryone
{
    Driver *driver1 = [self buildDriver:@"Fred" withPassengerCount:@2];
    TripSpecification *tripSpec = [[TripSpecification alloc] init:@6 possibleDrivers:[NSArray array]];
    NSArray *driverSet = [NSArray arrayWithObjects:driver1, nil];
    
    XCTAssertFalse([tripSpec isSatisfiedBy:driverSet]);
}

- (void)testIsSatisfiedBySetWithOneDriverWhoCanCarryEveryone
{
    Driver *driver1 = [self buildDriver:@"Fred" withPassengerCount:@8];
    [self buildDriver:@"Larry" withPassengerCount:@2];
    [self buildDriver:@"Barry" withPassengerCount:@2];
    TripSpecification *tripSpec = [[TripSpecification alloc] init:@6 possibleDrivers:[NSArray array]];
    NSArray *driverSet = [NSArray arrayWithObjects:driver1, nil];

    XCTAssertTrue([tripSpec isSatisfiedBy:driverSet]);
}

- (void)testIsSatisfiedBySetWithTwoDriversThatCanCarryTheRequiredNumberOfPeople
{
    Driver *driver1 = [self buildDriver:@"Fred" withPassengerCount:@2];
    Driver *driver2 = [self buildDriver:@"Larry" withPassengerCount:@2];
    TripSpecification *tripSpec = [[TripSpecification alloc] init:@4 possibleDrivers:[NSArray array]];
    NSArray *driverSet = [NSArray arrayWithObjects:driver1, driver2, nil];
    
    XCTAssertTrue([tripSpec isSatisfiedBy:driverSet]);
}

- (void)testIsNotSatisfiedBySetWithTwoDriversThatCanNotCarryTheRequiredNumberOfPeople
{
    Driver *driver1 = [self buildDriver:@"Fred" withPassengerCount:@2];
    Driver *driver2 = [self buildDriver:@"Larry" withPassengerCount:@2];
    TripSpecification *tripSpec = [[TripSpecification alloc] init:@8 possibleDrivers:[NSArray array]];
    NSArray *driverSet = [NSArray arrayWithObjects:driver1, driver2, nil];
    
    XCTAssertFalse([tripSpec isSatisfiedBy:driverSet]);
}


@end
