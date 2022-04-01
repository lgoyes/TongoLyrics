//
//  HistoryEntityTests.m
//  LyricSnitcherTests
//
//  Created by Luis Goyes Garces on 20/03/21.
//

#import <XCTest/XCTest.h>
#import "HistoryEntity.h"
#import "HistoryGetable.h"
#import "HistoryPresentationContract.h"
#import "GetHistoryInteractor.h"
#import <OCMock/OCMock.h>

#pragma mark - HistoryEntityTests

@interface HistoryEntityTests : XCTestCase
@property (strong, nonatomic) HistoryEntity* sut;
@property (strong, nonatomic) id fakeInteractor;
@property (strong, nonatomic) id fakeController;
@end

@implementation HistoryEntityTests
- (BOOL)setUpWithError:(NSError *__autoreleasing  _Nullable *)error {
    [super setUpWithError:error];
    _sut = [[HistoryEntity alloc] init];
    _fakeInteractor = OCMProtocolMock(@protocol(HistoryGetable));
    _fakeController = OCMProtocolMock(@protocol(HistoryControllerType));
    
    _sut.getHistoryInteractor = _fakeInteractor;
    _sut.controller = _fakeController;
    return true;
}
-(BOOL)tearDownWithError:(NSError *__autoreleasing  _Nullable *)error {
    _fakeInteractor = nil;
    _fakeController = nil;
    _sut = nil;
    [super tearDownWithError:error];
    return true;
}
- (void) test_WhenInit_ThenControllerShouldBeNil {
    _sut = [[HistoryEntity alloc] init];
    XCTAssertNil(_sut.controller);
}
- (void) test_WhenInit_ThenCreateAnInstanceOfTheGetHistoryInteractor {
    _sut = [[HistoryEntity alloc] init];
    XCTAssertTrue([_sut.getHistoryInteractor isKindOfClass: GetHistoryInteractor.class]);
}
- (void) test_WhenSetControllerIsInvoked_ThenSetController {
    _sut = [[HistoryEntity alloc] init];
    id controller = OCMProtocolMock(@protocol(HistoryControllerType));
    [_sut setController:controller];
    XCTAssertTrue(_sut.controller == controller);
}
- (void) test_WhenStartIsInvoked_ThenExecuteStartLoading {
    id testingSut = OCMPartialMock(_sut);
    [_sut start];
    OCMVerify([testingSut startLoading]);
}
- (void) test_WhenStartIsInvoked_ThenExecuteGetHistory {
    id testingSut = OCMPartialMock(_sut);
    [_sut start];
    OCMVerify([testingSut getHistory]);
}
- (void) test_GivenBadResponseFromInteractor_WhenGetHistoryIsCalled_ThenInvokeHandleHistoryError {
    id testingSut = OCMPartialMock(_sut);

    [[[_fakeInteractor stub] andDo:^(NSInvocation *invocation) {
        typedef void (^ErrorHandler)(HistoryGetableError);
        ErrorHandler onError;
        [invocation getArgument:&onError atIndex:2];
        onError(HistoryGetableErrorUnknown);
    }] getHistory:OCMOCK_ANY onSuccess:OCMOCK_ANY];
    
    [_sut getHistory];
    
    OCMVerify([testingSut handleHistoryError:HistoryGetableErrorUnknown]);
}
- (void) test_GivenSuccessResponseFromInteractor_WhenGetHistoryIsCalled_ThenInvokeHandleHistorySuccess {
    id testingSut = OCMPartialMock(_sut);
    
    [[[_fakeInteractor stub] andDo:^(NSInvocation *invocation) {
        typedef void (^SuccessHandler)(NSArray*);
        SuccessHandler onSuccess;
        [invocation getArgument:&onSuccess atIndex:3];
        onSuccess(@[]);
    }] getHistory:OCMOCK_ANY onSuccess:OCMOCK_ANY];
    
    [_sut getHistory];
    
    OCMVerify([testingSut handleHistorySuccess:OCMOCK_ANY]);
}
- (void) test_WhenHandleHistoryErrorIsInvoked_ThenCallShowErrorMessageOnController {
    HistoryGetableError error = HistoryGetableErrorUnknown;
    [_sut handleHistoryError:error];
    OCMVerify([_fakeController showError:OCMOCK_ANY]);
}
- (void) test_GivenAtLeastOneEntryInTheHistory_WhenHandleHistorySuccessIsInvoked_ThenCallShowHistoryOnController {
    NSArray * history = @[[[NSObject alloc] init]];
    [_sut handleHistorySuccess:history];
    OCMVerify([_fakeController showHistory:OCMOCK_ANY]);
}
- (void) test_GivenNoEntriesInTheHistory_WhenHandleHistorySuccessIsInvoked_ThenCallSetEmptyStateOnController {
    NSArray * history = @[];
    [_sut handleHistorySuccess:history];
    OCMVerify([_fakeController setEmptyState]);
}
- (void) test_WhenStartLoadingIsInvoked_ThenCallSetLoadingStateOnController {
    [_sut startLoading];
    OCMVerify([_fakeController setLoadingState]);
}
- (void) test_WhenOnItemSelected_ThenInvokeLaunchReaderWithLyricsOnController {
    int selectedItemIndex = 0;
    [_sut onItemSelected: selectedItemIndex];
    OCMVerify([_fakeController launchReaderWithLyrics:OCMOCK_ANY]);
}
@end
