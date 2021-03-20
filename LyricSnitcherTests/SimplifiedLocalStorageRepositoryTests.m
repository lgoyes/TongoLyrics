//
//  SimplifiedLocalStorageRepositoryTests.m
//  LyricSnitcherTests
//
//  Created by Luis Goyes Garces on 20/03/21.
//

#import <XCTest/XCTest.h>
#import "SimplifiedLocalStorageRepository.h"

#pragma mark - SimplifiedLocalStorageRepositoryTests

@interface SimplifiedLocalStorageRepositoryTests : XCTestCase
@property (nonatomic) SimplifiedLocalStorageRepository * sut;
@end

@implementation SimplifiedLocalStorageRepositoryTests
- (BOOL)setUpWithError:(NSError *__autoreleasing  _Nullable *)error {
    [super setUpWithError:error];
    _sut = [[SimplifiedLocalStorageRepository alloc] init];
    return true;
}

-(BOOL)tearDownWithError:(NSError *__autoreleasing  _Nullable *)error {
    _sut = nil;
    [super tearDownWithError:error];
    return true;
}
- (void) test_WhenInit_SetOneDefaultEntryToDatabase {
    NSArray * entries = [_sut getEntries];
    XCTAssertEqual(entries.count, 1);
}
- (void) test_GivenCreateWillSucceed_WhenCreateEntry_AddNewEntryToDatabase {
    _sut.shouldSuccessfullyStoreEntry = true;
    
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should be called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should not be called"];
    failureExpectation.inverted = true;
    
    Lyrics * newEntry = [[Lyrics alloc] initWithLyrics:@"new-dummy-string-for-lyrics" artist:@"new-dummy-string-for-artist" song:@"new-dummy-string-for-song" andDate:[NSDate now]];
    
    SimplifiedLocalStorageRepositoryTests * __weak weakSelf = self;
    [_sut create:newEntry onSuccess:^{
        NSArray * entries = [weakSelf.sut getEntries];
        Lyrics * insertedEntry = (Lyrics*) entries[1];
        XCTAssertTrue([insertedEntry.artist isEqualToString:newEntry.artist]);
        XCTAssertTrue([insertedEntry.song isEqualToString:newEntry.song]);
        XCTAssertTrue([insertedEntry.lyrics isEqualToString:newEntry.lyrics]);
        XCTAssertTrue([insertedEntry.date isEqualToDate:newEntry.date]);
        [correctExpectation fulfill];
    } onError:^(LocalStorageRepositoryError error) {
        [failureExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}

- (void) test_GivenCreateWillFail_WhenCreateEntry_ThrowError {
    _sut.shouldSuccessfullyStoreEntry = false;
    
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should be called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should not be called"];
    failureExpectation.inverted = true;
    
    Lyrics * newEntry = [[Lyrics alloc] initWithLyrics:@"new-dummy-string-for-lyrics" artist:@"new-dummy-string-for-artist" song:@"new-dummy-string-for-song" andDate:[NSDate now]];
    
    [_sut create:newEntry onSuccess:^{
        [failureExpectation fulfill];
    } onError:^(LocalStorageRepositoryError error) {
        XCTAssertEqual(error, LocalStorageRepositoryErrorCreate);
        [correctExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}

- (void) test_GivenSomeValidSongAndArtist_WhenReadEntry_ReturnEntry {
    NSString * song = @"dummy-string-for-song";
    NSString * artist = @"dummy-string-for-artist";
    
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should be called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should not be called"];
    failureExpectation.inverted = true;
    
    [_sut readBySong:song andArtist:artist onSuccess:^(Lyrics * entry) {
        [correctExpectation fulfill];
    } onError:^(LocalStorageRepositoryError error) {
        [failureExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}

- (void) test_GivenNOTValidSongAndArtist_WhenReadEntry_ThrowError {
    NSString * song = @"dummy-string-for-song-invalid";
    NSString * artist = @"dummy-string-for-artist";
    
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should be called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should not be called"];
    failureExpectation.inverted = true;
    
    [_sut readBySong:song andArtist:artist onSuccess:^(Lyrics * entry) {
        [failureExpectation fulfill];
    } onError:^(LocalStorageRepositoryError error) {
        XCTAssertEqual(error, LocalStorageRepositoryErrorEntryDoesNotExist);
        [correctExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}

- (void) test_GivenValidSongAndArtist_WhenDeleteEntry_ReturnSuccess {
    NSString * song = @"dummy-string-for-song";
    NSString * artist = @"dummy-string-for-artist";
    
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should be called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should not be called"];
    failureExpectation.inverted = true;
    
    [_sut deleteBySong:song andArtist:artist onSuccess:^() {
        [correctExpectation fulfill];
    } onError:^(LocalStorageRepositoryError error) {
        [failureExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}

- (void) test_GivenNOTValidSongAndArtist_WhenDeleteEntry_ThrowError {
    NSString * song = @"dummy-string-for-song-not-valid";
    NSString * artist = @"dummy-string-for-artist";
    
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should be called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should not be called"];
    failureExpectation.inverted = true;
    
    [_sut deleteBySong:song andArtist:artist onSuccess:^() {
        [failureExpectation fulfill];
    } onError:^(LocalStorageRepositoryError error) {
        XCTAssertEqual(error, LocalStorageRepositoryErrorEntryDoesNotExist);
        [correctExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}

- (void) test_GivenValidSongAndArtist_WhenUpdateEntry_ReturnSuccess {
    NSString * song = @"dummy-string-for-song";
    NSString * artist = @"dummy-string-for-artist";
    
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should be called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should not be called"];
    failureExpectation.inverted = true;
    
    Lyrics * newEntry = [[Lyrics alloc] initWithLyrics:@"new-dummy-string-for-lyrics" artist:@"new-dummy-string-for-artist" song:@"new-dummy-string-for-song" andDate:[NSDate now]];
    
    [_sut updateBySong:song andArtist:artist item:newEntry onSuccess:^{
        [correctExpectation fulfill];
    } onError:^(LocalStorageRepositoryError error) {
        [failureExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}

- (void) test_GivenNOTValidSongAndArtist_WhenUpdateEntry_ThrowError {
    NSString * song = @"dummy-string-for-song-not-valid";
    NSString * artist = @"dummy-string-for-artist";
    
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should be called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should not be called"];
    failureExpectation.inverted = true;
    
    Lyrics * newEntry = [[Lyrics alloc] initWithLyrics:@"new-dummy-string-for-lyrics" artist:@"new-dummy-string-for-artist" song:@"new-dummy-string-for-song" andDate:[NSDate now]];
    
    [_sut updateBySong:song andArtist:artist item:newEntry onSuccess:^{
        [failureExpectation fulfill];
    } onError:^(LocalStorageRepositoryError error) {
        [correctExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}

- (void) test_WhenListEntries_ReturnSuccess {
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should be called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should not be called"];
    failureExpectation.inverted = true;
    
    [_sut list:^(NSArray * entries) {
        [correctExpectation fulfill];
    } onError:^(LocalStorageRepositoryError error) {
        [failureExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}
@end
