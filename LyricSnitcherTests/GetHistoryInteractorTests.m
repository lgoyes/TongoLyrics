//
//  GetHistoryInteractorTests.m
//  LyricSnitcherTests
//
//  Created by Luis Goyes Garces on 20/03/21.
//

#import <XCTest/XCTest.h>
#import "GetHistoryInteractor.h"
#import "LocalStorageRepository.h"

#pragma mark - FakeNetworkRepository

@interface FakeLocalStorageRepository : NSObject <LocalStorageRepositoryType>

@end
@implementation FakeLocalStorageRepository
- (void)create:(Lyrics *)item onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    
}

- (void)deleteBySong:(NSString *)song andArtist:(NSString *)artist onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    
}

- (void)list:(void (^)(NSArray *))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    
}

- (void)readBySong:(NSString *)song andArtist:(NSString *)artist onSuccess:(void (^)(Lyrics *))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    
}

- (void)updateBySong:(NSString *)song andArtist:(NSString *)artist item:(Lyrics *)item onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    
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
    return true;
}

-(BOOL)tearDownWithError:(NSError *__autoreleasing  _Nullable *)error {
    _sut = nil;
    [super tearDownWithError:error];
    return true;
}
@end
