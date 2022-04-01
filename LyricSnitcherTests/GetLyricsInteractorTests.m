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
#import <OCMock/OCMock.h>

#pragma mark - GetLyricsInteractorTests

@interface GetLyricsInteractorTests : XCTestCase
@property (strong, nonatomic) GetLyricsInteractor* sut;
@property (strong, nonatomic) id networkRepository;
@property (strong, nonatomic) id localStorageRepository;
@end

@implementation GetLyricsInteractorTests
- (BOOL)setUpWithError:(NSError *__autoreleasing  _Nullable *)error {
    [super setUpWithError:error];
    _sut = [[GetLyricsInteractor alloc] initWithSystemConfig:SystemConfigTypeDebug];
    _networkRepository = OCMProtocolMock(@protocol(LyricsRepositoryProtocol));
    _localStorageRepository = OCMProtocolMock(@protocol(LocalStorageRepositoryType));
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
    
    [[[_networkRepository stub] andDo:^(NSInvocation *invocation) {
        typedef void (^ErrorHandler)(NSError *);
        ErrorHandler onError;
        [invocation getArgument:&onError atIndex:4];
        NSError * error = [NSError errorWithDomain:NSCocoaErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: @"The request timed out."}];
        onError(error);
    }] fetchLyricsForArtist:OCMOCK_ANY andSong:OCMOCK_ANY onError:OCMOCK_ANY onSuccess:OCMOCK_ANY];
    
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"Any callback is correct"];
    NSString * artist = @"dummy-artist";
    NSString * song = @"dummy-song";
    GetLyricsInteractorTests * __weak weakSelf = self;
    [_sut getLyricsForArtist:artist andSong:song onError:^(LyricsGetableError error) {
        [correctExpectation fulfill];
    } onSuccess:^(Lyrics * _Nonnull response) {
        [correctExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation] timeout:0.1];
    
    OCMVerify([weakSelf.networkRepository fetchLyricsForArtist:OCMOCK_ANY andSong:OCMOCK_ANY onError:OCMOCK_ANY onSuccess:OCMOCK_ANY]);
}

- (void) test_GivenOnErrorResponseFromTheNetworkRepository_WhenGetLyricsForArtistAndSong_ThenCallOnErrorCallback {
    NSString * artist = @"dummy-artist";
    NSString * song = @"dummy-song";

    [[[_networkRepository stub] andDo:^(NSInvocation *invocation) {
        typedef void (^ErrorHandler)(NSError *);
        ErrorHandler onError;
        [invocation getArgument:&onError atIndex:4];
        NSError * error = [NSError errorWithDomain:NSCocoaErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: @"The request timed out."}];
        onError(error);
    }] fetchLyricsForArtist:OCMOCK_ANY andSong:OCMOCK_ANY onError:OCMOCK_ANY onSuccess:OCMOCK_ANY];
    
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
    [[[_localStorageRepository stub] andDo:^(NSInvocation *invocation) {
        typedef void (^SuccessHandler)(void);
        SuccessHandler onSuccess;
        [invocation getArgument:&onSuccess atIndex:3];
        onSuccess();
    }] create:OCMOCK_ANY onSuccess:OCMOCK_ANY onError:OCMOCK_ANY];
    
    [[[_networkRepository stub] andDo:^(NSInvocation *invocation) {
        typedef void (^SuccessHandler)(Lyrics *);
        SuccessHandler onSuccess;
        [invocation getArgument:&onSuccess atIndex:5];
        Lyrics * lyrics = [Lyrics new];
        onSuccess(lyrics);
    }] fetchLyricsForArtist:OCMOCK_ANY andSong:OCMOCK_ANY onError:OCMOCK_ANY onSuccess:OCMOCK_ANY];
    
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
- (void) test_GivenOnSuccessResponseFromTheNetworkRepository_WhenGetLyricsForArtistAndSong_ThenCallCreateEntryOnLocalStorageRepository {

    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess is correct"];
    XCTestExpectation * failureExpectationNetworkError = [[XCTestExpectation alloc] initWithDescription:@"onError is not correct"];
    failureExpectationNetworkError.inverted = true;
    XCTestExpectation * failureExpectationDatabaseError = [[XCTestExpectation alloc] initWithDescription:@"LocalStorageRepository should've stored the new entry"];
    failureExpectationDatabaseError.inverted = true;

    [[[_localStorageRepository stub] andDo:^(NSInvocation *invocation) {
        typedef void (^SuccessHandler)(void);
        SuccessHandler onSuccess;
        [invocation getArgument:&onSuccess atIndex:3];
        onSuccess();
    }] create:OCMOCK_ANY onSuccess:OCMOCK_ANY onError:OCMOCK_ANY];
    
    [[[_networkRepository stub] andDo:^(NSInvocation *invocation) {
        typedef void (^SuccessHandler)(Lyrics *);
        SuccessHandler onSuccess;
        [invocation getArgument:&onSuccess atIndex:5];
        Lyrics * lyrics = [Lyrics new];
        onSuccess(lyrics);
    }] fetchLyricsForArtist:OCMOCK_ANY andSong:OCMOCK_ANY onError:OCMOCK_ANY onSuccess:OCMOCK_ANY];
    
    NSString * artist = @"dummy-artist";
    NSString * song = @"dummy-song";
    [_sut getLyricsForArtist:artist andSong:song onError:^(LyricsGetableError error) {
        [failureExpectationNetworkError fulfill];
    } onSuccess:^(Lyrics * _Nonnull response) {
        [correctExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectationNetworkError, failureExpectationDatabaseError] timeout:0.1];
}
- (void) test_GivenOnSuccessResponseFromTheNetworkRepositoryAndErrorFromTheDatabase_WhenGetLyricsForArtistAndSong_ThenThrowError {
    NSString * artist = @"dummy-artist";
    NSString * song = @"dummy-song";

    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError is expected"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should not be reached"];
    failureExpectation.inverted = true;
        
    [[[_localStorageRepository stub] andDo:^(NSInvocation *invocation) {
        typedef void (^ErrorHandler)(NSError*);
        ErrorHandler onError;
        [invocation getArgument:&onError atIndex:4];
        onError([NSError new]);
    }] create:OCMOCK_ANY onSuccess:OCMOCK_ANY onError:OCMOCK_ANY];
    
    [[[_networkRepository stub] andDo:^(NSInvocation *invocation) {
        typedef void (^SuccessHandler)(Lyrics *);
        SuccessHandler onSuccess;
        [invocation getArgument:&onSuccess atIndex:5];
        Lyrics * lyrics = [Lyrics new];
        onSuccess(lyrics);
    }] fetchLyricsForArtist:OCMOCK_ANY andSong:OCMOCK_ANY onError:OCMOCK_ANY onSuccess:OCMOCK_ANY];
    
    [_sut getLyricsForArtist:artist andSong:song onError:^(LyricsGetableError error) {
        XCTAssertEqual(error, LyricsGetableErrorUnableToStoreInDB);
        [correctExpectation fulfill];
    } onSuccess:^(Lyrics * _Nonnull response) {
        [failureExpectation fulfill];
    }];
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}
@end
