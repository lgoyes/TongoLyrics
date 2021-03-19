//
//  RemoteLyricsRepositoryTests.m
//  LyricSnitcherTests
//
//  Created by Luis Goyes Garces on 18/03/21.
//

#import <XCTest/XCTest.h>
#import "RemoteLyricsRepository.h"
#import "APILyrics.h"

@interface RemoteLyricsRepositoryTests : XCTestCase
@property RemoteLyricsRepository* sut;
@end

@implementation RemoteLyricsRepositoryTests

- (BOOL)setUpWithError:(NSError *__autoreleasing  _Nullable *)error {
    [super setUpWithError:error];
    _sut = [[RemoteLyricsRepository alloc] init];
    return true;
}

-(BOOL)tearDownWithError:(NSError *__autoreleasing  _Nullable *)error {
    _sut = nil;
    [super tearDownWithError:error];
    return true;
}
-(void) test_WhenFormatStringURLForArtistAndSongIsCalled_ThenReturnFormattedString {
    NSString * artist = @"dummy-artist";
    NSString * song = @"dummy-song";
    NSString * urlString = [_sut formatStringURLForArtist: artist andSong: song];
    NSString * expectedURLString = [NSString stringWithFormat:@"https://api.lyrics.ovh/v1/%@/%@", artist, song];
    XCTAssertTrue([urlString isEqualToString:expectedURLString]);
}
- (void) test_GivenArtistWithSpaces_WhenFormatStringURLForArtistAndSongIsCalled_ThenReturnFormattedStringReplacingSpaces {
    NSString * artist = @"dummy artist 1";
    NSString * song = @"dummy-song";
    NSString * urlString = [_sut formatStringURLForArtist: artist andSong: song];
    NSString * expectedFormattedArtist = @"dummy%20artist%201";
    NSString * expectedURLString = [NSString stringWithFormat:@"https://api.lyrics.ovh/v1/%@/%@", expectedFormattedArtist, song];
    XCTAssertTrue([urlString isEqualToString:expectedURLString]);
}
- (void) test_GivenSongWithSpaces_WhenFormatStringURLForArtistAndSongIsCalled_ThenReturnFormattedStringReplacingSpaces {
    NSString * artist = @"dummy-artist";
    NSString * song = @"dummy song";
    NSString * urlString = [_sut formatStringURLForArtist: artist andSong: song];
    NSString * expectedFormattedSong = @"dummy%20song";
    NSString * expectedURLString = [NSString stringWithFormat:@"https://api.lyrics.ovh/v1/%@/%@", artist, expectedFormattedSong];
    XCTAssertTrue([urlString isEqualToString:expectedURLString]);
}
-(void) test_WhenGetURLForArtistAndSongIsCalled_ThenReturnURL {
    NSString * artist = @"dummy-artist";
    NSString * song = @"dummy-song";
    NSURL * url = [_sut getURLForArtist: artist andSong: song];
    XCTAssertNotNil(url);
}

// This test might take too long to run. Disable it during TDD
- (void) test_GivenValidArtistAndSong_WhenFetchLyricsForArtistAndSongIsCalled_ThenCallOnSuccessBlock {
    NSString * artist = @"Coldplay";
    NSString * song = @"Adventure of a Lifetime";
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess was called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError should not be called"];
    failureExpectation.inverted = true;
    
    [_sut fetchLyricsForArtist: artist
                       andSong: song
                       onError: ^(NSError * error) {
        [failureExpectation fulfill];
    }
                     onSuccess: ^(APILyrics* response) {
        [correctExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:20];
}

// This test might take too long to run. Disable it during TDD
- (void) test_GivenNOTValidArtistAndValidSong_WhenFetchLyricsForArtistAndSongIsCalled_ThenCallOnErrorBlock {
    NSString * artist = @"asdfasdf";
    NSString * song = @"Adventure of a Lifetime";
    XCTestExpectation * correctExpectation = [[XCTestExpectation alloc] initWithDescription:@"onError was called"];
    XCTestExpectation * failureExpectation = [[XCTestExpectation alloc] initWithDescription:@"onSuccess should not be called"];
    failureExpectation.inverted = true;
    
    [_sut fetchLyricsForArtist: artist
                       andSong: song
                       onError: ^(NSError * error) {
        XCTAssertTrue([[error localizedDescription]isEqualToString:@"The request timed out."]);
        [correctExpectation fulfill];
    }
                     onSuccess: ^(APILyrics* response) {
        [failureExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:20];
}
@end
