//
//  RemoteLyricsRepositoryTests.m
//  LyricSnitcherTests
//
//  Created by Luis Goyes Garces on 18/03/21.
//

#import <XCTest/XCTest.h>
#import "RemoteLyricsRepository.h"
#import "APILyrics.h"
#import <OCMock/OCMock.h>

@interface RemoteLyricsRepositoryTests : XCTestCase
@property (strong, nonatomic) RemoteLyricsRepository* sut;
@property (strong, nonatomic) id webClient;
@end

@implementation RemoteLyricsRepositoryTests

- (void)setUp {
    [super setUp];
    _sut = [[RemoteLyricsRepository alloc] init];
    self.webClient = OCMProtocolMock(@protocol(WebClient));
    self.sut.webClient = self.webClient;
}

- (void)tearDown {
    _sut = nil;
    self.webClient = nil;
    [super tearDown];
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

- (void) test_GivenValidArtistAndSong_WhenPrivateFetchLyricsForArtistAndSongIsCalled_ThenCallOnSuccessBlock {
    [[[self.webClient stub] andDo:^(NSInvocation *invocation) {
        typedef void (^SuccessHandler)(NSDictionary *);
        SuccessHandler onSuccess;
        [invocation getArgument:&onSuccess atIndex:3];
        onSuccess(@{@"lyrics": @"any-lyrics"});
    }] performRequestWithEndpoint:OCMOCK_ANY onSuccess:OCMOCK_ANY onError:OCMOCK_ANY];
    
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

- (void) test_GivenNOTValidArtistAndValidSong_WhenPrivateFetchLyricsForArtistAndSongIsCalled_ThenCallOnErrorBlock {
    [[[self.webClient stub] andDo:^(NSInvocation *invocation) {
        typedef void (^ErrorHandler)(NSError *);
        ErrorHandler onError;
        [invocation getArgument:&onError atIndex:4];
        NSError * error = [NSError errorWithDomain:NSURLErrorDomain code:1 userInfo:@{NSLocalizedDescriptionKey: @"The request timed out."}];
        onError(error);
    }] performRequestWithEndpoint:OCMOCK_ANY onSuccess:OCMOCK_ANY onError:OCMOCK_ANY];
    
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
                     onSuccess: ^(Lyrics* response) {
        [failureExpectation fulfill];
    }];
    
    [self waitForExpectations:@[correctExpectation, failureExpectation] timeout:0.1];
}
-(void) test_WhenMapAPIResponseIsCalled_ThenMapProperties {
    NSString * artist = @"dummy-artist";
    NSString * song = @"dummy-song";
    NSString * lyrics = @"dummy-lyrics";
    NSDate * date = [NSDate now];
    APILyrics * apiResponse = [[APILyrics alloc] initWithLyrics:lyrics];
    
    Lyrics * mappedResponse = [_sut mapAPIResponse:apiResponse withArtist:artist song:song andDate:date];
    XCTAssertEqual(mappedResponse.artist, artist);
    XCTAssertEqual(mappedResponse.song, song);
    XCTAssertEqual(mappedResponse.lyrics, lyrics);
    XCTAssertEqual(mappedResponse.date, date);
}
@end
