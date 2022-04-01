//
//  SearchEntityTests.m
//  LyricSnitcherTests
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <XCTest/XCTest.h>
#import "SearchEntity.h"
#import "GetLyricsInteractor.h"
#import "GetLastEntryInteractor.h"
#import <OCMock/OCMock.h>

#pragma mark - SearchEntityTests

@interface SearchEntityTests : XCTestCase
@property (strong, nonatomic) SearchEntity * sut;
@property (strong, nonatomic) id fakeGetLyricsInteractor;
@property (strong, nonatomic) id fakeGetLastEntryInteractor;
@property (strong, nonatomic) id fakeController;
@end

@implementation SearchEntityTests
- (void)setUp {
    [super setUp];
    _sut = [[SearchEntity alloc] init];
    _fakeGetLyricsInteractor = OCMProtocolMock(@protocol(LyricsGetable));
    _fakeController = OCMProtocolMock(@protocol(SearchControllerType));
    _fakeGetLastEntryInteractor = OCMProtocolMock(@protocol(LastEntryGetable));
    
    _sut.getLyricsInteractor = _fakeGetLyricsInteractor;
    _sut.getLastEntryInteractor = _fakeGetLastEntryInteractor;
    _sut.controller = _fakeController;
}

-(void)tearDown {
    _fakeGetLastEntryInteractor = nil;
    _fakeGetLyricsInteractor = nil;
    _fakeController = nil;
    _sut = nil;
    [super tearDown];
}
- (void) test_WhenInit_ThenCreateAnInstanceOfTheFetchInteractor {
    _sut = [[SearchEntity alloc] init];
    XCTAssertTrue([_sut.getLyricsInteractor isKindOfClass: GetLyricsInteractor.class]);
}
- (void) test_WhenInit_ThenCreateAnInstanceOfTheGetLastEntryInteractor {
    _sut = [[SearchEntity alloc] init];
    XCTAssertTrue([_sut.getLastEntryInteractor isKindOfClass: GetLastEntryInteractor.class]);
}
- (void) test_WhenInit_ThenControllerShouldBeNil {
    _sut = [[SearchEntity alloc] init];
    XCTAssertNil(_sut.controller);
}
- (void) test_WhenSetControllerIsInvoked_ThenSetController {
    _sut = [[SearchEntity alloc] init];
    id controller = OCMProtocolMock(@protocol(SearchControllerType));
    [_sut setController:controller];
    XCTAssertTrue(_sut.controller == controller);
}
- (void) test_WhenValidateSongField_ThenGetSongFromController {
    [_sut validateSongField];
    OCMVerify([_fakeController getSong]);
}
- (void) test_GivenTheViewControllerWithAValidSong_WhenValidateSongFieldIsInvooked_ThenReturnTrue {
    [[[_fakeController stub] andReturn:@"dummy-song"] getSong];
    BOOL isValid = [_sut validateSongField];
    XCTAssertTrue(isValid);
}
- (void) test_GivenTheViewControllerWithANOTValidSong_WhenValidateSongFieldIsInvooked_ThenReturnFalse {
    [[[_fakeController stub] andReturn:@""] getSong];
    BOOL isValid = [_sut validateSongField];
    XCTAssertFalse(isValid);
}
- (void) test_WhenValidateArtistField_ThenGetArtistFromController {
    [_sut validateArtistField];
    OCMVerify([_fakeController getArtist]);
    OCMVerify(never(), [_fakeController getSong]);
}

- (void) test_GivenTheViewControllerWithAValidArtist_WhenValidateArtistFieldIsInvooked_ThenReturnFalse {
    [[[_fakeController stub] andReturn:@"dummy-artist"] getArtist];
    BOOL isValid = [_sut validateArtistField];
    XCTAssertTrue(isValid);
}
- (void) test_GivenTheViewControllerWithANOTValidArtist_WhenValidateArtistFieldIsInvooked_ThenReturnFalse {
    [[[_fakeController stub] andReturn:@""] getArtist];
    BOOL isValid = [_sut validateArtistField];
    XCTAssertFalse(isValid);
}
- (void) test_GivenThatSongIsValid_WhenValidateFormIsInvoked_ThenCallHideSongErrorOnController {
    [[[_fakeController stub] andReturn:@"dummy-song"] getSong];
    [_sut validateForm];
    OCMVerify([_fakeController hideSongError]);
}
- (void) test_GivenThatSongIsNOTValid_WhenValidateFormIsInvoked_ThenCallShowSongErrorOnController {
    [[[_fakeController stub] andReturn:@""] getSong];
    [_sut validateForm];
    OCMVerify([_fakeController showSongError]);
}
- (void) test_GivenThatArtistIsValid_WhenValidateFormIsInvoked_ThenCallHideArtistErrorOnController {
    [[[_fakeController stub] andReturn:@"dummy-artist"] getArtist];
    [_sut validateForm];
    OCMVerify([_fakeController hideArtistError]);
}
- (void) test_GivenThatArtistIsNOTValid_WhenValidateFormIsInvoked_ThenCallShowArtistErrorOnController {
    [[[_fakeController stub] andReturn:@""] getArtist];
    [_sut validateForm];
    OCMVerify([_fakeController showArtistError]);
}
- (void) test_WhenOnGetLyricsButtonPressedIsCalled_ThenInvokeValidateForm {
    id testingSut = OCMPartialMock(_sut);
    [_sut onSearchButtonPressed];
    OCMVerify([testingSut validateForm]);
}
- (void) test_WhenOnGetLyricsButtonPressedIsCalled_ThenInvokeStartLoadingUI {
    id testingSut = OCMPartialMock(_sut);
    [_sut onSearchButtonPressed];
    OCMVerify([testingSut startLoadingUI]);
}
- (void) test_GivenNotValidForm_WhenOnGetLyricsButtonPressedIsCalled_ThenInvokeStopLoadingUI {
    id testingSut = OCMPartialMock(_sut);
    [[[testingSut stub] andReturnValue:@(NO)] validateForm];
    [_sut onSearchButtonPressed];
    OCMVerify([testingSut stopLoadingUI]);
    OCMVerify(never(), [testingSut searchLyrics]);
}
- (void) test_WhenStartLoadingUIIsCalled_ThenInvokeSetLoadingStateOnController {
    [[[_fakeController stub] andReturn:@"dummy-artist"] getArtist];
    [[[_fakeController stub] andReturn:@"dummy-song"] getSong];
    [_sut startLoadingUI];
    OCMVerify([_fakeController setLoadingState]);
}
- (void) test_WhenStopLoadingUIIsCalled_ThenInvokeSetSteadyStateOnController {
    [[[_fakeController stub] andReturn:@"dummy-artist"] getArtist];
    [[[_fakeController stub] andReturn:@"dummy-song"] getSong];
    [_sut stopLoadingUI];
    OCMVerify([_fakeController setSteadyState]);
}
- (void) test_GivenValidForm_WhenOnGetLyricsButtonPressedIsCalled_ThenSearchLyricsShouldBeInvoked {
    id testingSut = OCMPartialMock(_sut);
    [[[testingSut stub] andReturnValue:@(YES)] validateForm];
    [_sut onSearchButtonPressed];
    OCMVerify(never(),[testingSut stopLoadingUI]);
    OCMVerify([testingSut searchLyrics]);
}
- (void) test_WhenSearchLyricsIsCalled_GetSongFromController {
    [_sut searchLyrics];
    OCMVerify([_fakeController getSong]);
}
- (void) test_WhenSearchLyricsIsCalled_GetArtistFromController {
    [_sut searchLyrics];
    OCMVerify([_fakeController getArtist]);
}
- (void) test_WhenSeachLyricsIsCalled_CallInteractor {
    [_sut searchLyrics];
    OCMVerify([_fakeGetLyricsInteractor getLyricsForArtist:OCMOCK_ANY andSong:OCMOCK_ANY onError:OCMOCK_ANY onSuccess:OCMOCK_ANY]);
}
- (void) test_GivenBadResponseFromInteractor_WhenSearchLyricsIsCalled_ThenInvokeHandleSearchLyricsError {
    id testingSut = OCMPartialMock(_sut);
    [[[_fakeGetLyricsInteractor stub] andDo:^(NSInvocation *invocation) {
        typedef void (^ErrorHandler)(LyricsGetableError);
        ErrorHandler onError;
        [invocation getArgument:&onError atIndex:4];
        onError(LyricsGetableErrorUnknown);
    }] getLyricsForArtist:OCMOCK_ANY andSong:OCMOCK_ANY onError:OCMOCK_ANY onSuccess:OCMOCK_ANY];
    
    [_sut searchLyrics];
    
    OCMVerify([testingSut handleLyricsSearchError:LyricsGetableErrorUnknown]);
    OCMVerify(never(), [testingSut handleLyricsSearchSuccess:OCMOCK_ANY]);
}
- (void) test_GivenSuccessResponseFromInteractor_WhenSearchLyricsIsCalled_ThenInvokeHandleSearchLyricsSuccess {
    id testingSut = OCMPartialMock(_sut);

    [[[_fakeGetLyricsInteractor stub] andDo:^(NSInvocation *invocation) {
        typedef void (^SuccessHandler)(Lyrics*);
        SuccessHandler onSuccess;
        [invocation getArgument:&onSuccess atIndex:5];
        onSuccess([Lyrics new]);
    }] getLyricsForArtist:OCMOCK_ANY andSong:OCMOCK_ANY onError:OCMOCK_ANY onSuccess:OCMOCK_ANY];
    
    [_sut searchLyrics];
    
    OCMVerify(never(), [testingSut handleLyricsSearchError:LyricsGetableErrorUnknown]);
    OCMVerify([testingSut handleLyricsSearchSuccess:OCMOCK_ANY]);
}
- (void) test_WhenHandleSearchLyricsError_ThenInvokeStopLoadingUI {
    id testingSut = OCMPartialMock(_sut);
    [_sut handleLyricsSearchError:LyricsGetableErrorUnknown];
    OCMVerify([testingSut stopLoadingUI]);
}
- (void) test_WhenHandleSearchLyricsSuccess_ThenInvokeStopLoadingUI {
    id testingSut = OCMPartialMock(_sut);
    Lyrics * response = [[Lyrics alloc]init];
    [_sut handleLyricsSearchSuccess:response];
    OCMVerify([testingSut stopLoadingUI]);
}
- (void) test_WhenHandleSearchLyricsSuccess_ThenInvokeShowLastEntryOnController {
    Lyrics * response = [[Lyrics alloc]init];
    [_sut handleLyricsSearchSuccess:response];
    OCMVerify([_fakeController showLastEntry:OCMOCK_ANY]);
}
- (void) test_WhenHandleSearchLyricsError_ThenInvokeShowErrorOnController {
    [_sut handleLyricsSearchError:LyricsGetableErrorUnknown];
    OCMVerify([_fakeController showError:OCMOCK_ANY]);
}
- (void) test_GivenNoResultError_WhenGetErrorMessageForErrorIsInvoked_ThenReturnAString {
    NSString * errorMessage = [_sut getErrorMessageFor: LyricsGetableErrorNoResult];
    XCTAssertTrue([errorMessage isEqualToString:@"No lyrics found."]);
}
- (void) test_GivenUnknownError_WhenGetErrorMessageForErrorIsInvoked_ThenReturnAString {
    NSString * errorMessage = [_sut getErrorMessageFor: LyricsGetableErrorUnknown];
    XCTAssertTrue([errorMessage isEqualToString:@"Please check your network connection."]);
}
- (void) test_GivenDBError_WhenGetErrorMessageForErrorIsInvoked_ThenReturnAString {
    NSString * errorMessage = [_sut getErrorMessageFor: LyricsGetableErrorUnableToStoreInDB];
    XCTAssertTrue([errorMessage isEqualToString:@"There is an error with the history. Please re-install the app."]);
}
- (void) test_WhenHandleSearchLyricsError_ThenInvokeGetErrorMessageForError {
    id testingSut = OCMPartialMock(_sut);
    [_sut handleLyricsSearchError:LyricsGetableErrorUnknown];
    OCMVerify([testingSut getErrorMessageFor:LyricsGetableErrorUnknown]);
}
- (void) test_WhenHandleSearchLyricsSuccess_ThenInvokeNavigateToReaderOnController {
    Lyrics * lyrics = [[Lyrics alloc] init];
    [_sut handleLyricsSearchSuccess:lyrics];
    OCMVerify([_fakeController navigateToReader:OCMOCK_ANY]);
}
- (void) test_WhenStartIsInvoked_ThenExecuteGetLastEntry {
    id testingSut = OCMPartialMock(_sut);
    [_sut start];
    OCMVerify([testingSut getLastEntry]);
}
- (void) test_WhenGetLastEntryIsCalled_InvokeGetLastEntryInteractor {
    [_sut getLastEntry];
    OCMVerify([_fakeGetLastEntryInteractor getLastEntry:OCMOCK_ANY onError:OCMOCK_ANY]);
}
- (void) test_GivenOnSuccessFromGetLastEntryInteractor_WhenGetLastEntryIsCalled_ThenInvokeHandleOnGetLastEntrySuccess {
    id testingSut = OCMPartialMock(_sut);
    
    [[[_fakeGetLastEntryInteractor stub] andDo:^(NSInvocation *invocation) {
        typedef void (^SuccessHandler)(Lyrics*);
        SuccessHandler onSuccess;
        [invocation getArgument:&onSuccess atIndex:2];
        onSuccess([Lyrics new]);
    }] getLastEntry:OCMOCK_ANY onError:OCMOCK_ANY];
    
    [_sut getLastEntry];
    
    OCMVerify([testingSut handleOnGetLastEntrySuccess:OCMOCK_ANY]);
}
- (void) test_GivenOnErrorFromGetLastEntryInteractor_WhenGetLastEntryIsCalled_ThenInvokeHandleOnGetLastEntryError {
    id testingSut = OCMPartialMock(_sut);

    [[[_fakeGetLastEntryInteractor stub] andDo:^(NSInvocation *invocation) {
        typedef void (^ErrorHandler)(LastEntryGetableError);
        ErrorHandler onError;
        [invocation getArgument:&onError atIndex:3];
        onError(LastEntryGetableErrorNoEntries);
    }] getLastEntry:OCMOCK_ANY onError:OCMOCK_ANY];
    
    [_sut getLastEntry];
    
    OCMVerify([testingSut handleOnGetLastEntryError:LastEntryGetableErrorNoEntries]);
}
- (void) test_WhenHandleOnGetLastEntryErrorIsCalled_DoNothing {
    LastEntryGetableError error = LastEntryGetableErrorNoEntries;
    [_sut handleOnGetLastEntryError:error];
}
- (void) test_WhenHandleOnGetLastEntrySuccessIsCalled_ThenInvokeShowLastEntryOnController {
    Lyrics * lyrics = [[Lyrics alloc] init];
    [_sut handleOnGetLastEntrySuccess:lyrics];
    OCMVerify([_fakeController showLastEntry:OCMOCK_ANY]);
}
- (void) test_WhenHandleOnGetLastEntrySuccessIsCalled_ThenSetLastEntry {
    Lyrics * lyrics = [[Lyrics alloc] init];
    [_sut handleOnGetLastEntrySuccess:lyrics];
    XCTAssertNotNil(_sut.lastEntry);
}
- (void) test_WhenOnLastEntryPressedIsInvoked_InvokeNavigateToReaderOnController {
    [_sut onLastEntryPressed];
    OCMVerify([_fakeController navigateToReader:OCMOCK_ANY]);
}
@end
