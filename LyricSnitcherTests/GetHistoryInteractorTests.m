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

#pragma mark - FakeNetworkRepository

@interface FakeLocalStorageRepository : NSObject <LocalStorageRepositoryType>
@property (strong, nonatomic) NSMutableArray * entries;
@property (nonatomic) BOOL listShouldSucceed;
@end

@implementation FakeLocalStorageRepository
- (instancetype)init
{
    self = [super init];
    if (self) {
        _entries = [@[] mutableCopy];
        _listShouldSucceed = false;
    }
    return self;
}

- (void)create:(Lyrics *)item onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    [NSException raise:@"Invalid method call" format:@"This method should not be called"];
}

- (void)deleteBySong:(NSString *)song andArtist:(NSString *)artist onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    [NSException raise:@"Invalid method call" format:@"This method should not be called"];
}

- (void)list:(void (^)(NSArray *))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    if (_listShouldSucceed) {
        onSuccess([_entries copy]);
    } else {
        onError(LocalStorageRepositoryErrorList);
    }
}

- (void)readBySong:(NSString *)song andArtist:(NSString *)artist onSuccess:(void (^)(Lyrics *))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    [NSException raise:@"Invalid method call" format:@"This method should not be called"];
}

- (void)updateBySong:(NSString *)song andArtist:(NSString *)artist item:(Lyrics *)item onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    [NSException raise:@"Invalid method call" format:@"This method should not be called"];
}

- (void)getLastRecord:(void (^)(Lyrics *))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    [NSException raise:@"Invalid method call" format:@"This method should not be called"];
}

@end

#pragma mark - GetLyricsInteractorTests

@interface GetHistoryInteractorTests : XCTestCase
@property (strong, nonatomic) GetHistoryInteractor* sut;
@property (strong, nonatomic) FakeLocalStorageRepository* localStorageRepository;
@end

@implementation GetHistoryInteractorTests
- (BOOL)setUpWithError:(NSError *__autoreleasing  _Nullable *)error {
    [super setUpWithError:error];
    _sut = [[GetHistoryInteractor alloc] initWithSystemConfig:SystemConfigTypeDebug];
    _localStorageRepository = [[FakeLocalStorageRepository alloc] init];
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
    
    _localStorageRepository.listShouldSucceed = true;
    
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
    
    _localStorageRepository.listShouldSucceed = true;
    [_localStorageRepository.entries addObject:[[Lyrics alloc] init]];
    
    [_sut getHistory:^(HistoryGetableError error) {
        [failureExpectation fulfill];
    } onSuccess:^(NSArray *history) {
        XCTAssertEqual(history.count, 1);
        [correctExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}
- (void) test_GivenTheRepositoryWithSomeEntriesAndReturningError_WhenGetHistoryIsInvoked_ThrowError {
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should be called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should not be called"];
    failureExpectation.inverted = true;
    
    _localStorageRepository.listShouldSucceed = false;
    [_localStorageRepository.entries addObject:[[Lyrics alloc] init]];
    
    [_sut getHistory:^(HistoryGetableError error) {
        XCTAssertEqual(error, HistoryGetableErrorUnknown);
        [correctExpectation fulfill];
    } onSuccess:^(NSArray *history) {
        [failureExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}
@end
