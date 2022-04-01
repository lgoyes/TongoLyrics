//
//  DBLocalStorageRepositoryTests.m
//  LyricSnitcherTests
//
//  Created by Luis David Goyes on 1/04/22.
//

#import <XCTest/XCTest.h>
#import "DBLocalStorageRepository.h"
#import <OCMock/OCMock.h>
#import <CoreData/CoreData.h>

@interface DBLocalStorageRepositoryTests : XCTestCase
@property (nonatomic, strong) DBLocalStorageRepository* sut;
@property (nonatomic, strong) id context;
@end

@implementation DBLocalStorageRepositoryTests

- (void)setUp {
    [super setUp];
    self.sut = [DBLocalStorageRepository new];
    self.context = OCMClassMock([NSManagedObjectContext class]);
    self.sut.context = self.context;
}

- (void)tearDown {
    self.sut = nil;
    self.context = nil;
    [super tearDown];
}

#pragma mark - create
- (void) test_create_successfulCreation {
    Lyrics * dbLyrics = [Lyrics new];
    id mockNSEntityDescription = OCMClassMock([NSEntityDescription class]);
    [[[mockNSEntityDescription stub] andReturn:dbLyrics] insertNewObjectForEntityForName:OCMOCK_ANY inManagedObjectContext: OCMOCK_ANY];
    
    [[[self.context stub] andReturnValue:@(YES)] save: [OCMArg anyObjectRef]];
    
    Lyrics * lyrics = [Lyrics new];
    
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"Success callback is correct"];
    XCTestExpectation * invalidExpectation = [[XCTestExpectation alloc] initWithDescription:@"Error callback is NOT correct"];
    [invalidExpectation setInverted:YES];
    [self.sut create:lyrics onSuccess:^{
        [correctExpectation fulfill];
    } onError:^(LocalStorageRepositoryError error) {
        [invalidExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, invalidExpectation] timeout:0.1];
}

- (void) test_create_errorInCreation {
    Lyrics * dbLyrics = [Lyrics new];
    id mockNSEntityDescription = OCMClassMock([NSEntityDescription class]);
    [[[mockNSEntityDescription stub] andReturn:dbLyrics] insertNewObjectForEntityForName:OCMOCK_ANY inManagedObjectContext: OCMOCK_ANY];
    
    [[[self.context stub] andReturnValue:@(NO)] save: [OCMArg anyObjectRef]];
    
    Lyrics * lyrics = [Lyrics new];
    
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"Error callback is correct"];
    XCTestExpectation * invalidExpectation = [[XCTestExpectation alloc] initWithDescription:@"Success callback is NOT correct"];
    [invalidExpectation setInverted:YES];
    [self.sut create:lyrics onSuccess:^{
        [invalidExpectation fulfill];
    } onError:^(LocalStorageRepositoryError error) {
        [correctExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, invalidExpectation] timeout:0.1];
}


#pragma mark - list
- (void) test_list {
//- (void) list: (void (^) (NSArray* entries)) onSuccess onError:(void (^) (LocalStorageRepositoryError error)) onError;
}

#pragma mark - updateBySong
- (void) test_updateBySong {
//- (void) updateBySong: (NSString*) song andArtist:(NSString*)artist item: (Lyrics*) item onSuccess:(void (^) (void)) onSuccess onError:(void (^) (LocalStorageRepositoryError error)) onError;
}

#pragma mark - deleteBySong
- (void) test_deleteBySong {
//- (void) deleteBySong: (NSString*) song andArtist:(NSString*)artist onSuccess:(void (^) (void)) onSuccess onError:(void (^) (LocalStorageRepositoryError error)) onError;
}

#pragma mark - readBySong
- (void) test_readBySong {
//- (void) readBySong: (NSString*) song andArtist:(NSString*)artist onSuccess:(void (^) (Lyrics * item)) onSuccess onError:(void (^) (LocalStorageRepositoryError error)) onError;
}

#pragma mark - getLastRecord
- (void) test_getLastRecord {
//- (void) getLastRecord:(void (^) (Lyrics * item)) onSuccess onError:(void (^) (LocalStorageRepositoryError error)) onError;
}

@end
