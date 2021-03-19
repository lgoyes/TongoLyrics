//
//  SearchEntityTests.m
//  LyricSnitcherTests
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <XCTest/XCTest.h>
#import "SearchEntity.h"
#import "GetLyricsInteractor.h"

@interface SeamSearchEntity: SearchEntity
@property (nonatomic) BOOL validateFormWasCalled;
@end
@implementation SeamSearchEntity
- (BOOL)validateForm {
    _validateFormWasCalled = true;
    return [super validateForm];
}
@end


@interface FakeFetchInteractor : NSObject <LyricsGetable>
@property (nonatomic) bool getLyricsForArtistExpectedResultSuccess;
@end
@implementation FakeFetchInteractor
- (void)getLyricsForArtist:(NSString *)artist andSong:(NSString *)song onError:(void (^)(NSError *))onError onSuccess:(void (^)(Lyrics *))onSuccess {
    if (_getLyricsForArtistExpectedResultSuccess && onSuccess != nil) {
        Lyrics * dummyLyrics = [[Lyrics alloc] init];
        onSuccess(dummyLyrics);
    } else if (!_getLyricsForArtistExpectedResultSuccess && onError != nil) {
        NSError * error = [[NSError alloc]init];
        onError(error);
    }
}
@end

@interface FakeSearchController : NSObject <SearchControllerType>
@property (nonatomic) bool getSongWasCalled;
@property (nonatomic) NSString* song;
@property (nonatomic) bool getArtistWasCalled;
@property (nonatomic) NSString* artist;
@property (nonatomic) bool hideArtistErrorWasCalled;
@property (nonatomic) bool hideSongErrorWasCalled;
@property (nonatomic) bool showArtistErrorWasCalled;
@property (nonatomic) bool showSongErrorWasCalled;
@end

@implementation FakeSearchController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _getSongWasCalled = false;
        _getArtistWasCalled = false;
        _hideArtistErrorWasCalled = false;
        _hideSongErrorWasCalled = false;
        _showArtistErrorWasCalled = false;
        _showSongErrorWasCalled = false;
    }
    return self;
}
- (NSString *)getSong {
    _getSongWasCalled = true;
    return _song;
}

- (NSString *)getArtist {
    _getArtistWasCalled = true;
    return _artist;
}

- (void)hideArtistError {
    _hideArtistErrorWasCalled = true;
}

- (void)hideSongError {
    _hideSongErrorWasCalled = true;
}

- (void)showArtistError {
    _showArtistErrorWasCalled = true;
}

- (void)showSongError {
    _showSongErrorWasCalled = true;
}

@end


@interface SearchEntityTests : XCTestCase
@property (nonatomic) SearchEntity * sut;
@property (nonatomic) FakeFetchInteractor* fakeInteractor;
@property (nonatomic) FakeSearchController * fakeController;
@end

@implementation SearchEntityTests
- (BOOL)setUpWithError:(NSError *__autoreleasing  _Nullable *)error {
    [super setUpWithError:error];
    _sut = [[SearchEntity alloc] init];
    _fakeInteractor = [[FakeFetchInteractor alloc] init];
    _fakeController = [[FakeSearchController alloc] init];
    
    _sut.getLyricsInteractor = _fakeInteractor;
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
- (void) test_WhenInit_ThenCreateAnInstanceOfTheFetchInteractor {
    _sut = [[SearchEntity alloc] init];
    XCTAssertTrue([_sut.getLyricsInteractor isKindOfClass: GetLyricsInteractor.class]);
}
- (void) test_WhenInit_ThenControllerShouldBeNil {
    _sut = [[SearchEntity alloc] init];
    XCTAssertNil(_sut.controller);
}
- (void) test_WhenSetControllerIsInvoked_ThenSetController {
    _sut = [[SearchEntity alloc] init];
    FakeSearchController * controller = [[FakeSearchController alloc] init];
    [_sut setController:controller];
    XCTAssertTrue(_sut.controller == controller);
}
- (void) test_WhenValidateSongField_ThenGetSongFromController {
    [_sut validateSongField];
    XCTAssertTrue(_fakeController.getSongWasCalled);
}
- (void) test_GivenTheViewControllerWithAValidSong_WhenValidateSongFieldIsInvooked_ThenReturnTrue {
    _fakeController.song = @"dummy-song";
    BOOL isValid = [_sut validateSongField];
    XCTAssertTrue(isValid);
}
- (void) test_GivenTheViewControllerWithANOTValidSong_WhenValidateSongFieldIsInvooked_ThenReturnFalse {
    _fakeController.song = @"";
    BOOL isValid = [_sut validateSongField];
    XCTAssertFalse(isValid);
}
- (void) test_WhenValidateArtistField_ThenGetArtistFromController {
    [_sut validateArtistField];
    XCTAssertTrue(_fakeController.getArtistWasCalled);
}
- (void) test_GivenTheViewControllerWithAValidArtist_WhenValidateArtistFieldIsInvooked_ThenReturnFalse {
    _fakeController.artist = @"dummy-artist";
    BOOL isValid = [_sut validateArtistField];
    XCTAssertTrue(isValid);
}
- (void) test_GivenTheViewControllerWithANOTValidArtist_WhenValidateArtistFieldIsInvooked_ThenReturnFalse {
    _fakeController.artist = @"";
    BOOL isValid = [_sut validateArtistField];
    XCTAssertFalse(isValid);
}
- (void) test_GivenThatSongIsValid_WhenValidateFormIsInvoked_ThenCallHideSongErrorOnController {
    _fakeController.song = @"dummy-song";
    [_sut validateForm];
    XCTAssertTrue(_fakeController.hideSongErrorWasCalled);
}
- (void) test_GivenThatSongIsNOTValid_WhenValidateFormIsInvoked_ThenCallShowSongErrorOnController {
    _fakeController.song = @"";
    [_sut validateForm];
    XCTAssertTrue(_fakeController.showSongErrorWasCalled);
}
- (void) test_GivenThatArtistIsValid_WhenValidateFormIsInvoked_ThenCallHideArtistErrorOnController {
    _fakeController.artist = @"dummy-artist";
    [_sut validateForm];
    XCTAssertTrue(_fakeController.hideArtistErrorWasCalled);
}
- (void) test_GivenThatArtistIsNOTValid_WhenValidateFormIsInvoked_ThenCallShowArtistErrorOnController {
    _fakeController.artist = @"";
    [_sut validateForm];
    XCTAssertTrue(_fakeController.showArtistErrorWasCalled);
}
- (void) test_WhenOnGetLyricsButtonPressedIsCalled_ThenInvokeValidateForm {
    SeamSearchEntity * _sut = [[SeamSearchEntity alloc] init];
    [_sut onSearchButtonPressed];
    XCTAssertTrue(_sut.validateFormWasCalled);
}
@end
