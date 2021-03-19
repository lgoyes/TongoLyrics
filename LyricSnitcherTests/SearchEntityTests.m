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
@property (nonatomic) BOOL startLoadingUIWasCalled;
@property (nonatomic) BOOL stopLoadingUIWasCalled;
@property (nonatomic) BOOL searchLyricsWasCalled;
@property (nonatomic) BOOL handleLyricsSearchErrorWasCalled;
@property (nonatomic) BOOL handleLyricsSearchSuccessWasCalled;
@property (nonatomic) BOOL getErrorMessageWasCalled;
@end
@implementation SeamSearchEntity
- (BOOL)validateForm {
    _validateFormWasCalled = true;
    return [super validateForm];
}
- (void)startLoadingUI {
    _startLoadingUIWasCalled = true;
    [super startLoadingUI];
}
- (void)stopLoadingUI {
    _stopLoadingUIWasCalled = true;
    [super stopLoadingUI];
}
- (void)searchLyrics {
    _searchLyricsWasCalled = true;
    [super searchLyrics];
}
- (void)handleLyricsSearchError: (LyricsGetableError) error {
    _handleLyricsSearchErrorWasCalled = true;
    [super handleLyricsSearchError:error];
}
- (void)handleLyricsSearchSuccess: (Lyrics*) response {
    _handleLyricsSearchSuccessWasCalled = true;
    [super handleLyricsSearchSuccess: response];
}
- (NSString *)getErrorMessageFor:(LyricsGetableError)error {
    _getErrorMessageWasCalled = true;
    return [super getErrorMessageFor:error];
}
@end


@interface FakeFetchInteractor : NSObject <LyricsGetable>
@property (nonatomic) bool getLyricsForArtistExpectedResultSuccess;
@property (nonatomic) bool getLyricsForArtistWasCalled;
@end
@implementation FakeFetchInteractor
- (void)getLyricsForArtist:(NSString *)artist andSong:(NSString *)song onError:(void (^)(LyricsGetableError))onError onSuccess:(void (^)(Lyrics *))onSuccess {
    _getLyricsForArtistWasCalled = true;
    if (_getLyricsForArtistExpectedResultSuccess && onSuccess != nil) {
        Lyrics * dummyLyrics = [[Lyrics alloc] init];
        onSuccess(dummyLyrics);
    } else if (!_getLyricsForArtistExpectedResultSuccess && onError != nil) {
        onError(LyricsGetableErrorUnknown);
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
@property (nonatomic) bool setLoadingStateWasCalled;
@property (nonatomic) bool setSteadyStateWasCalled;
@property (nonatomic) bool showErrorWasCalled;
@property (nonatomic) bool navigateToReaderWasCalled;
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
        _setLoadingStateWasCalled = false;
        _showErrorWasCalled = false;
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

- (void)setLoadingState {
    _setLoadingStateWasCalled = true;
}

- (void)setSteadyState {
    _setSteadyStateWasCalled = true;
}

- (void)showError:(NSString *)message {
    _showErrorWasCalled = true;
}

- (void)navigateToReader:(Lyrics *)lyrics {
    _navigateToReaderWasCalled = true;
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
- (void) test_WhenOnGetLyricsButtonPressedIsCalled_ThenInvokeStartLoadingUI {
    SeamSearchEntity * _sut = [[SeamSearchEntity alloc] init];
    [_sut onSearchButtonPressed];
    XCTAssertTrue(_sut.startLoadingUIWasCalled);
}
- (void) test_GivenNotValidForm_WhenOnGetLyricsButtonPressedIsCalled_ThenInvokeStopLoadingUI {
    SeamSearchEntity * _sut = [[SeamSearchEntity alloc] init];
    [_sut onSearchButtonPressed];
    XCTAssertTrue(_sut.stopLoadingUIWasCalled);
}
- (void) test_WhenStartLoadingUIIsCalled_ThenInvokeSetLoadingStateOnController {
    _fakeController.artist = @"dummy-artist";
    _fakeController.song = @"dummy-song";
    [_sut startLoadingUI];
    XCTAssertTrue(_fakeController.setLoadingStateWasCalled);
}
- (void) test_WhenStopLoadingUIIsCalled_ThenInvokeSetSteadyStateOnController {
    _fakeController.artist = @"dummy-artist";
    _fakeController.song = @"dummy-song";
    [_sut stopLoadingUI];
    XCTAssertTrue(_fakeController.setSteadyStateWasCalled);
}
- (void) test_GivenValidForm_WhenOnGetLyricsButtonPressedIsCalled_ThenSearchLyricsShouldBeInvoked {
    SeamSearchEntity * _sut = [[SeamSearchEntity alloc] init];
    _sut.controller = _fakeController;
    _fakeController.artist = @"dummy-artist";
    _fakeController.song = @"dummy-song";
    [_sut onSearchButtonPressed];
    XCTAssertTrue(_sut.searchLyricsWasCalled);
}
- (void) test_WhenSearchLyricsIsCalled_GetSongFromController {
    [_sut searchLyrics];
    XCTAssertTrue(_fakeController.getSongWasCalled);
}
- (void) test_WhenSearchLyricsIsCalled_GetArtistFromController {
    [_sut searchLyrics];
    XCTAssertTrue(_fakeController.getArtistWasCalled);
}
- (void) test_WhenSeachLyricsIsCalled_CallInteractor {
    [_sut searchLyrics];
    XCTAssertTrue(_fakeInteractor.getLyricsForArtistWasCalled);
}
- (void) test_GivenBadResponseFromInteractor_WhenSearchLyricsIsCalled_ThenInvokeHandleSearchLyricsError {
    SeamSearchEntity * _sut = [[SeamSearchEntity alloc] init];
    _sut.getLyricsInteractor = _fakeInteractor;
    _fakeInteractor.getLyricsForArtistExpectedResultSuccess = false;
    [_sut searchLyrics];
    XCTAssertTrue(_sut.handleLyricsSearchErrorWasCalled);
}
- (void) test_GivenSuccessResponseFromInteractor_WhenSearchLyricsIsCalled_ThenInvokeHandleSearchLyricsSuccess {
    SeamSearchEntity * _sut = [[SeamSearchEntity alloc] init];
    _sut.getLyricsInteractor = _fakeInteractor;
    _fakeInteractor.getLyricsForArtistExpectedResultSuccess = true;
    [_sut searchLyrics];
    XCTAssertTrue(_sut.handleLyricsSearchSuccessWasCalled);
}
- (void) test_WhenHandleSearchLyricsError_ThenInvokeStopLoadingUI {
    SeamSearchEntity * _sut = [[SeamSearchEntity alloc] init];
    [_sut handleLyricsSearchError:LyricsGetableErrorUnknown];
    XCTAssertTrue(_sut.stopLoadingUIWasCalled);
}
- (void) test_WhenHandleSearchLyricsSuccess_ThenInvokeStopLoadingUI {
    SeamSearchEntity * _sut = [[SeamSearchEntity alloc] init];
    Lyrics * response = [[Lyrics alloc]init];
    [_sut handleLyricsSearchSuccess:response];
    XCTAssertTrue(_sut.stopLoadingUIWasCalled);
}
- (void) test_WhenHandleSearchLyricsError_ThenInvokeShowErrorOnController {
    [_sut handleLyricsSearchError:LyricsGetableErrorUnknown];
    XCTAssertTrue(_fakeController.showErrorWasCalled);
}
- (void) test_GivenNoResultError_WhenGetErrorMessageForErrorIsInvoked_ThenReturnAString {
    NSString * errorMessage = [_sut getErrorMessageFor: LyricsGetableErrorNoResult];
    XCTAssertTrue([errorMessage isEqualToString:@"No lyrics found"]);
}
- (void) test_GivenUnknownError_WhenGetErrorMessageForErrorIsInvoked_ThenReturnAString {
    NSString * errorMessage = [_sut getErrorMessageFor: LyricsGetableErrorUnknown];
    XCTAssertTrue([errorMessage isEqualToString:@"Unknown error"]);
}
- (void) test_WhenHandleSearchLyricsError_ThenInvokeGetErrorMessageForError {
    SeamSearchEntity * _sut = [[SeamSearchEntity alloc] init];
    [_sut handleLyricsSearchError:LyricsGetableErrorUnknown];
    XCTAssertTrue(_sut.getErrorMessageWasCalled);
}
- (void) test_WhenHandleSearchLyricsSuccess_ThenInvokeNavigateToReaderOnController {
    Lyrics * lyrics = [[Lyrics alloc] init];
    [_sut handleLyricsSearchSuccess:lyrics];
    XCTAssertTrue(_fakeController.navigateToReaderWasCalled);
}
@end
