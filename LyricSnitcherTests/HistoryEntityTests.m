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

#pragma mark - SeamHistoryEntity

@interface SeamHistoryEntity : HistoryEntity
@property (nonatomic) BOOL getHistoryWasCalled;
@property (nonatomic) BOOL startWasCalled;
@property (nonatomic) BOOL handleHistoryErrorWasCalled;
@property (nonatomic) BOOL handleHistorySuccessWasCalled;
@property (nonatomic) BOOL startLoadingWasCalled;
@end
@implementation SeamHistoryEntity
-(void)start {
    _startWasCalled = true;
    [super start];
}
- (void)getHistory {
    _getHistoryWasCalled = true;
    [super getHistory];
}
- (void)startLoading {
    _startLoadingWasCalled = true;
    [super startLoading];
}
- (void)handleHistoryError:(HistoryGetableError)error {
    _handleHistoryErrorWasCalled = true;
    [super handleHistoryError:error];
}
- (void)handleHistorySuccess:(NSArray *)history {
    _handleHistorySuccessWasCalled = true;
    [super handleHistorySuccess:history];
}
@end

#pragma mark - FakeGetHistoryInteractor

@interface FakeGetHistoryInteractor : NSObject <HistoryGetable>
@property (nonatomic) BOOL getHistoryWasCalled;
@property (nonatomic) BOOL successIsExpected;
@end
@implementation FakeGetHistoryInteractor
- (void)getHistory:(void (^)(HistoryGetableError))onError onSuccess:(void (^)(NSArray *))onSuccess {
    _getHistoryWasCalled = true;
    if (_successIsExpected) {
        onSuccess(@[]);
    } else {
        onError(HistoryGetableErrorUnknown);
    }
}
@end

#pragma mark - FakeHistoryController

@interface FakeHistoryController : NSObject <HistoryControllerType>
@property (nonatomic) BOOL showErrorWasCalled;
@property (nonatomic) BOOL showHistoryWasCalled;
@property (nonatomic) BOOL setEmptyStateWasCalled;
@property (nonatomic) BOOL setLoadingStateWasCalled;
@end
@implementation FakeHistoryController
- (void)showError:(NSString *)message {
    _showErrorWasCalled = true;
}
- (void)showHistory:(NSArray *)history {
    _showHistoryWasCalled = true;
}
- (void)setEmptyState {
    _setEmptyStateWasCalled = true;
}
- (void)setLoadingState {
    _setLoadingStateWasCalled = true;
}
@end

#pragma mark - HistoryEntityTests

@interface HistoryEntityTests : XCTestCase
@property (strong, nonatomic) HistoryEntity* sut;
@property (strong, nonatomic) FakeGetHistoryInteractor* fakeInteractor;
@property (strong, nonatomic) FakeHistoryController* fakeController;
@end

@implementation HistoryEntityTests
- (BOOL)setUpWithError:(NSError *__autoreleasing  _Nullable *)error {
    [super setUpWithError:error];
    _sut = [[HistoryEntity alloc] init];
    _fakeInteractor = [[FakeGetHistoryInteractor alloc] init];
    _fakeController = [[FakeHistoryController alloc] init];
    
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
    FakeHistoryController * controller = [[FakeHistoryController alloc] init];
    [_sut setController:controller];
    XCTAssertTrue(_sut.controller == controller);
}
- (void) test_WhenStartIsInvoked_ThenExecuteStartLoading {
    SeamHistoryEntity * _sut = [[SeamHistoryEntity alloc] init];
    [_sut start];
    XCTAssertTrue(_sut.startLoadingWasCalled);
}
- (void) test_WhenStartIsInvoked_ThenExecuteGetHistory {
    SeamHistoryEntity * _sut = [[SeamHistoryEntity alloc] init];
    [_sut start];
    XCTAssertTrue(_sut.getHistoryWasCalled);
}
- (void) test_GivenBadResponseFromInteractor_WhenGetHistoryIsCalled_ThenInvokeHandleHistoryError {
    SeamHistoryEntity * _sut = [[SeamHistoryEntity alloc] init];
    _sut.getHistoryInteractor = _fakeInteractor;
    _fakeInteractor.successIsExpected = false;
    [_sut getHistory];
    XCTAssertTrue(_sut.handleHistoryErrorWasCalled);
}
- (void) test_GivenSuccessResponseFromInteractor_WhenGetHistoryIsCalled_ThenInvokeHandleHistorySuccess {
    SeamHistoryEntity * _sut = [[SeamHistoryEntity alloc] init];
    _sut.getHistoryInteractor = _fakeInteractor;
    _fakeInteractor.successIsExpected = true;
    [_sut getHistory];
    XCTAssertTrue(_sut.handleHistorySuccessWasCalled);
}
- (void) test_WhenHandleHistoryErrorIsInvoked_ThenCallShowErrorMessageOnController {
    HistoryGetableError error = HistoryGetableErrorUnknown;
    [_sut handleHistoryError:error];
    XCTAssertTrue(_fakeController.showErrorWasCalled);
}
- (void) test_GivenAtLeastOneEntryInTheHistory_WhenHandleHistorySuccessIsInvoked_ThenCallShowHistoryOnController {
    NSArray * history = @[[[NSObject alloc] init]];
    [_sut handleHistorySuccess:history];
    XCTAssertTrue(_fakeController.showHistoryWasCalled);
}
- (void) test_GivenNoEntriesInTheHistory_WhenHandleHistorySuccessIsInvoked_ThenCallSetEmptyStateOnController {
    NSArray * history = @[];
    [_sut handleHistorySuccess:history];
    XCTAssertTrue(_fakeController.setEmptyStateWasCalled);
}
- (void) test_WhenStartLoadingIsInvoked_ThenCallSetLoadingStateOnController {
    [_sut startLoading];
    XCTAssertTrue(_fakeController.setLoadingStateWasCalled);
}
@end
