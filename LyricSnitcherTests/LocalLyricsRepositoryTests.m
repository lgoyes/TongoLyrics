//
//  LocalLyricsRepositoryTests.m
//  LyricSnitcherTests
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <XCTest/XCTest.h>
#import "LocalLyricsRepository.h"
#import "Lyrics.h"

@interface LocalLyricsRepositoryTests : XCTestCase
@property (strong, nonatomic) LocalLyricsRepository* sut;
@end

@implementation LocalLyricsRepositoryTests

- (void)setUp {
    [super setUp];
    _sut = [[LocalLyricsRepository alloc] init];
}

- (void)tearDown {
    _sut = nil;
    [super tearDown];
}

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
                     onSuccess: ^(Lyrics* response) {
        [correctExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}

- (void) test_GivenNOTValidArtistAndValidSong_WhenFetchLyricsForArtistAndSongIsCalled_ThenCallOnErrorBlock {
    NSString * artist = @"error";
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
                     onSuccess: ^(Lyrics* response) {
        [failureExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}
@end
