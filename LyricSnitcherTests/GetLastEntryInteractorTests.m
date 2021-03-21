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

#pragma mark - FakeLocalStorageRepository

@interface FakeLocalStorageRepositoryForLastEntry : NSObject <LocalStorageRepositoryType>
@property (strong, nonatomic) Lyrics * lastEntry;
@end

@implementation FakeLocalStorageRepositoryForLastEntry
- (instancetype)init
{
    self = [super init];
    if (self) {
        _lastEntry = nil;
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
    [NSException raise:@"Invalid method call" format:@"This method should not be called"];
}

- (void)readBySong:(NSString *)song andArtist:(NSString *)artist onSuccess:(void (^)(Lyrics *))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    [NSException raise:@"Invalid method call" format:@"This method should not be called"];
}

- (void)updateBySong:(NSString *)song andArtist:(NSString *)artist item:(Lyrics *)item onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    [NSException raise:@"Invalid method call" format:@"This method should not be called"];
}

- (void)getLastRecord:(void (^)(Lyrics *))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    if (_lastEntry != nil) {
        onSuccess(_lastEntry);
    } else {
        onError(LocalStorageRepositoryErrorNoEntries);
    }
}

@end

#pragma mark - GetLastEntryInteractorTests

@interface GetLastEntryInteractorTests : XCTestCase
@property (strong, nonatomic) GetLastEntryInteractor* sut;
@property (strong, nonatomic) FakeLocalStorageRepositoryForLastEntry* localStorageRepository;
@end

@implementation GetLastEntryInteractorTests
- (BOOL)setUpWithError:(NSError *__autoreleasing  _Nullable *)error {
    [super setUpWithError:error];
    _sut = [[GetLastEntryInteractor alloc] initWithSystemConfig:SystemConfigTypeDebug];
    _localStorageRepository = [[FakeLocalStorageRepositoryForLastEntry alloc] init];
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
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should be called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should not be called"];
    failureExpectation.inverted = true;
    
    _localStorageRepository.lastEntry = [[Lyrics alloc] init];
    
    [_sut getLastEntry:^(Lyrics *entry) {
        [correctExpectation fulfill];
    } onError:^(LastEntryGetableError error) {
        [failureExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}
- (void) test_GivenTheRepositoryWithNoLastEntryAndReturningError_WhenGetLastEntryIsInvoked_ThrowError {
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
