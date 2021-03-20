//
//  GetLyricsInteractorTests.m
//  LyricSnitcherTests
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <XCTest/XCTest.h>
#import "GetLyricsInteractor.h"
#import "LocalLyricsRepository.h"
#import "RemoteLyricsRepository.h"
#import "LyricsRepositoryProtocol.h"
#import "LocalStorageRepository.h"
#import "DBLocalStorageRepository.h"
#import "SimplifiedLocalStorageRepository.h"

#pragma mark - FakeNetworkRepository

@interface FakeLocalStorageRepositoryForGetLyricsInteractor : NSObject <LocalStorageRepositoryType>
@property (strong, nonatomic) NSMutableArray * entries;
@property (nonatomic) BOOL createShouldSucceed;
@end

@implementation FakeLocalStorageRepositoryForGetLyricsInteractor
- (instancetype)init
{
    self = [super init];
    if (self) {
        _entries = [@[] mutableCopy];
        _createShouldSucceed = false;
    }
    return self;
}

- (void)create:(Lyrics *)item onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    if (_createShouldSucceed) {
        onSuccess();
    } else {
        onError(LocalStorageRepositoryErrorCreate);
    }
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
@end

#pragma mark - FakeNetworkRepository

@interface FakeNetworkRepository : NSObject <LyricsRepositoryProtocol>
@property (nonatomic) bool fetchLyricsForArtistWasCalled;
@property (nonatomic) bool fetchLyricsForArtistExpectedResultSuccess;
@end
@implementation FakeNetworkRepository
- (instancetype)init
{
    self = [super init];
    if (self) {
        _fetchLyricsForArtistWasCalled = false;
        _fetchLyricsForArtistExpectedResultSuccess = false;
    }
    return self;
}
- (void)fetchLyricsForArtist:(NSString *)artist andSong:(NSString *)song onError:(void (^)(NSError *))onError onSuccess:(void (^)(Lyrics *))onSuccess {
    _fetchLyricsForArtistWasCalled = true;
    if (_fetchLyricsForArtistExpectedResultSuccess && onSuccess != nil) {
        Lyrics * dummyLyrics = [[Lyrics alloc] init];
        onSuccess(dummyLyrics);
    } else if (!_fetchLyricsForArtistExpectedResultSuccess && onError != nil) {
        NSError * error = [NSError errorWithDomain:NSURLErrorDomain code:-1001 userInfo:@{ @"NSLocalizedDescription": @"The request timed out."}];
        onError(error);
    }
}
@end

#pragma mark - GetLyricsInteractorTests

@interface GetLyricsInteractorTests : XCTestCase
@property (strong, nonatomic) GetLyricsInteractor* sut;
@property (strong, nonatomic) FakeNetworkRepository* networkRepository;
@property (strong, nonatomic) FakeLocalStorageRepositoryForGetLyricsInteractor* localStorageRepository;
@end

@implementation GetLyricsInteractorTests
- (BOOL)setUpWithError:(NSError *__autoreleasing  _Nullable *)error {
    [super setUpWithError:error];
    _sut = [[GetLyricsInteractor alloc] initWithSystemConfig:SystemConfigTypeDebug];
    _networkRepository = [[FakeNetworkRepository alloc] init];
    _localStorageRepository = [[FakeLocalStorageRepositoryForGetLyricsInteractor alloc] init];
    _sut.networkRepository = _networkRepository;
    _sut.localStorageRepository = _localStorageRepository;
    return true;
}

-(BOOL)tearDownWithError:(NSError *__autoreleasing  _Nullable *)error {
    _networkRepository = nil;
    _localStorageRepository = nil;
    _sut = nil;
    [super tearDownWithError:error];
    return true;
}
- (void) test_WhenInitWithSystemConfigDebug_InitNetworkRepositoryWithLocalVersion {
    _sut = [[GetLyricsInteractor alloc] initWithSystemConfig:SystemConfigTypeDebug];
    XCTAssertTrue([_sut.networkRepository isKindOfClass: LocalLyricsRepository.class]);
}
- (void) test_WhenInitWithSystemConfigRelease_InitNetworkRepositoryWithRemoteeVersion {
    _sut = [[GetLyricsInteractor alloc] initWithSystemConfig:SystemConfigTypeRelease];
    XCTAssertTrue([_sut.networkRepository isKindOfClass: RemoteLyricsRepository.class]);
}
- (void) test_WhenInitWithSystemConfigDebug_InitLocalStorageRepositoryWithSimplifiedVersion {
    _sut = [[GetLyricsInteractor alloc] initWithSystemConfig:SystemConfigTypeDebug];
    XCTAssertTrue([_sut.localStorageRepository isKindOfClass: SimplifiedLocalStorageRepository.class]);
}
- (void) test_WhenInitWithSystemConfigRelease_InitLocalStorageRepositoryWithDBVersion {
    _sut = [[GetLyricsInteractor alloc] initWithSystemConfig:SystemConfigTypeRelease];
    XCTAssertTrue([_sut.localStorageRepository isKindOfClass: DBLocalStorageRepository.class]);
}
- (void) test_GivenValidArguments_WhenGetLyricsForArtistAndSong_ThenInvokeFetchLyricsForArtistInRepository {
    NSString * artist = @"dummy-artist";
    NSString * song = @"dummy-song";
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"Any callback is correct"];
    GetLyricsInteractorTests * __weak weakSelf = self;
    [_sut getLyricsForArtist:artist andSong:song onError:^(LyricsGetableError error) {
        XCTAssertTrue(weakSelf.networkRepository.fetchLyricsForArtistWasCalled);
        [correctExpectation fulfill];
    } onSuccess:^(Lyrics * _Nonnull response) {
        XCTAssertTrue(weakSelf.networkRepository.fetchLyricsForArtistWasCalled);
        [correctExpectation fulfill];
    }];
    [self waitForExpectations:@[correctExpectation] timeout:0.1];
}
- (void) test_GivenOnErrorResponseFromTheNetworkRepository_WhenGetLyricsForArtistAndSong_ThenCallOnErrorCallback {
    NSString * artist = @"dummy-artist";
    NSString * song = @"dummy-song";
    _networkRepository.fetchLyricsForArtistExpectedResultSuccess = false;
    
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError is correct"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess is not correct"];
    failureExpectation.inverted = true;
    
    [_sut getLyricsForArtist:artist andSong:song onError:^(LyricsGetableError error) {
        [correctExpectation fulfill];
    } onSuccess:^(Lyrics * _Nonnull response) {
        [failureExpectation fulfill];
    }];
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}
- (void) test_GivenOnSuccessResponseFromTheNetworkRepository_WhenGetLyricsForArtistAndSong_ThenCallOnSuccessCallback {
    NSString * artist = @"dummy-artist";
    NSString * song = @"dummy-song";
    _networkRepository.fetchLyricsForArtistExpectedResultSuccess = true;
    
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess is correct"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError is not correct"];
    failureExpectation.inverted = true;
    [_sut getLyricsForArtist:artist andSong:song onError:^(LyricsGetableError error) {
        [failureExpectation fulfill];
    } onSuccess:^(Lyrics * _Nonnull response) {
        [correctExpectation fulfill];
    }];
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}
//- (void) test_GivenOnSuccessResponseFromTheNetworkRepository_WhenGetLyricsForArtistAndSong_ThenCallCreateEntryOnLocalStorageRepository {
//    NSString * artist = @"dummy-artist";
//    NSString * song = @"dummy-song";
//
//    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess is correct"];
//    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError is not correct"];
//    failureExpectation.inverted = true;
//
//    [_sut getLyricsForArtist:artist andSong:song onError:^(LyricsGetableError error) {
//        [failureExpectation fulfill];
//    } onSuccess:^(Lyrics * _Nonnull response) {
//        [correctExpectation fulfill];
//    }];
//    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
//}
@end
