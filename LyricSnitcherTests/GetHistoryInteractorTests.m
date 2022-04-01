//
//  GetHistoryInteractorTests.m
//  LyricSnitcherTests
//
//  Created by Luis Goyes Garces on 20/03/21.
//

#import <XCTest/XCTest.h>
#import "GetHistoryInteractor.h"
#import "LocalStorageRepository.h"
#import "DBLocalStorageRepository.h"
#import "SimplifiedLocalStorageRepository.h"
#import <OCMock/OCMock.h>

#pragma mark - GetHistoryInteractorTests

@interface GetHistoryInteractorTests : XCTestCase
@property (strong, nonatomic) GetHistoryInteractor* sut;
@property (strong, nonatomic) id localStorageRepository;
@end

@implementation GetHistoryInteractorTests
- (BOOL)setUpWithError:(NSError *__autoreleasing  _Nullable *)error {
    [super setUpWithError:error];
    _sut = [[GetHistoryInteractor alloc] initWithSystemConfig:SystemConfigTypeDebug];
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
    _sut = [[GetHistoryInteractor alloc] initWithSystemConfig:SystemConfigTypeDebug];
    XCTAssertTrue([_sut.localStorageRepository isKindOfClass: SimplifiedLocalStorageRepository.class]);
}
- (void) test_WhenInitWithSystemConfigRelease_InitRepositoryWithRemoteVersion {
    _sut = [[GetHistoryInteractor alloc] initWithSystemConfig:SystemConfigTypeRelease];
    XCTAssertTrue([_sut.localStorageRepository isKindOfClass: DBLocalStorageRepository.class]);
}
- (void) test_GivenTheRepositoryWithNoEntriesAndReturningNoError_WhenGetHistoryIsInvoked_ReturnAnEmptyArray {
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should be called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should not be called"];
    failureExpectation.inverted = true;
    
    [[[_localStorageRepository stub] andDo:^(NSInvocation *invocation) {
        typedef void (^SuccessHandler)(NSArray *);
        SuccessHandler onSuccess;
        [invocation getArgument:&onSuccess atIndex:2];
        onSuccess(@[]);
    }] list:OCMOCK_ANY onError:OCMOCK_ANY];
        
    [_sut getHistory:^(HistoryGetableError error) {
        [failureExpectation fulfill];
    } onSuccess:^(NSArray *history) {
        XCTAssertEqual(history.count, 0);
        [correctExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}
- (void) test_GivenTheRepositoryWithSomeEntriesAndReturningNoError_WhenGetHistoryIsInvoked_ReturnAnArray {
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should be called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should not be called"];
    failureExpectation.inverted = true;
    
    [[[_localStorageRepository stub] andDo:^(NSInvocation *invocation) {
        typedef void (^SuccessHandler)(NSArray *);
        SuccessHandler onSuccess;
        [invocation getArgument:&onSuccess atIndex:2];
        onSuccess(@[ [Lyrics new] ]);
    }] list:OCMOCK_ANY onError:OCMOCK_ANY];
    
    [_sut getHistory:^(HistoryGetableError error) {
        [failureExpectation fulfill];
    } onSuccess:^(NSArray *history) {
        XCTAssertEqual(history.count, 1);
        [correctExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}
- (void) test_GivenTheRepositoryWithSomeEntriesAndReturningError_WhenGetHistoryIsInvoked_ThrowError {
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should be called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should not be called"];
    failureExpectation.inverted = true;
    
    [[[_localStorageRepository stub] andDo:^(NSInvocation *invocation) {
        typedef void (^ErrorHandler)(LocalStorageRepositoryError);
        ErrorHandler onError;
        [invocation getArgument:&onError atIndex:3];
        onError(LocalStorageRepositoryErrorNoEntries);
    }] list:OCMOCK_ANY onError:OCMOCK_ANY];
    
    [_sut getHistory:^(HistoryGetableError error) {
        XCTAssertEqual(error, HistoryGetableErrorUnknown);
        [correctExpectation fulfill];
    } onSuccess:^(NSArray *history) {
        [failureExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}
@end
