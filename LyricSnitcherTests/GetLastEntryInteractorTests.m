//
//  GetLastEntryInteractorTests.m
//  LyricSnitcherTests
//
//  Created by Luis Goyes Garces on 21/03/21.
//

#import <XCTest/XCTest.h>
#import "GetLastEntryInteractor.h"
#import "LocalStorageRepository.h"
#import "DBLocalStorageRepository.h"
#import "SimplifiedLocalStorageRepository.h"
#import <OCMock/OCMock.h>

#pragma mark - GetLastEntryInteractorTests

@interface GetLastEntryInteractorTests : XCTestCase
@property (strong, nonatomic) GetLastEntryInteractor* sut;
@property (strong, nonatomic) id localStorageRepository;
@end

@implementation GetLastEntryInteractorTests
- (BOOL)setUpWithError:(NSError *__autoreleasing  _Nullable *)error {
    [super setUpWithError:error];
    _sut = [[GetLastEntryInteractor alloc] initWithSystemConfig:SystemConfigTypeDebug];
    _localStorageRepository = OCMProtocolMock(@protocol(LocalStorageRepositoryType));
    _sut.localStorageRepository = _localStorageRepository;
    return true;
}

-(BOOL)tearDownWithError:(NSError *__autoreleasing  _Nullable *)error {
    _sut = nil;
    [super tearDownWithError:error];
    return true;
}
- (void) test_WhenInitWithSystemConfigDebug_InitRepositoryWithLocalVersion {
    _sut = [[GetLastEntryInteractor alloc] initWithSystemConfig:SystemConfigTypeDebug];
    XCTAssertTrue([_sut.localStorageRepository isKindOfClass: SimplifiedLocalStorageRepository.class]);
}
- (void) test_WhenInitWithSystemConfigRelease_InitRepositoryWithRemoteVersion {
    _sut = [[GetLastEntryInteractor alloc] initWithSystemConfig:SystemConfigTypeRelease];
    XCTAssertTrue([_sut.localStorageRepository isKindOfClass: DBLocalStorageRepository.class]);
}
- (void) test_GivenTheRepositoryWithNoEntriesAndReturningNoError_WhenGetLastEntryIsInvoked_ReturnLasEntry {
    [[[_localStorageRepository stub] andDo:^(NSInvocation *invocation) {
        typedef void (^SuccessHandler)(Lyrics *);
        SuccessHandler onSuccess;
        [invocation getArgument:&onSuccess atIndex:2];
        onSuccess([Lyrics new]);
    }] getLastRecord:OCMOCK_ANY onError:OCMOCK_ANY];
    
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should be called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should not be called"];
    failureExpectation.inverted = true;
    
    [_sut getLastEntry:^(Lyrics *entry) {
        [correctExpectation fulfill];
    } onError:^(LastEntryGetableError error) {
        [failureExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}
- (void) test_GivenTheRepositoryWithNoLastEntryAndReturningError_WhenGetLastEntryIsInvoked_ThrowError {
    [[[_localStorageRepository stub] andDo:^(NSInvocation *invocation) {
        typedef void (^ErrorHandler)(LocalStorageRepositoryError);
        ErrorHandler onError;
        [invocation getArgument:&onError atIndex:3];
        onError(LocalStorageRepositoryErrorNoEntries);
    }] getLastRecord:OCMOCK_ANY onError:OCMOCK_ANY];
    
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should be called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should not be called"];
    failureExpectation.inverted = true;

    [_sut getLastEntry:^(Lyrics *entry) {
        [failureExpectation fulfill];
    } onError:^(LastEntryGetableError error) {
        [correctExpectation fulfill];
    }];

    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}
@end
