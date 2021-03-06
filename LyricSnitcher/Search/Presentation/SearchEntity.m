//
//  SearchEntity.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import "SearchEntity.h"
#import "GetLyricsInteractor.h"
#import "GetLastEntryInteractor.h"

@implementation SearchEntity
- (instancetype)init
{
    self = [super init];
    if (self) {
        _getLyricsInteractor = [[GetLyricsInteractor alloc] init];
        _getLastEntryInteractor = [[GetLastEntryInteractor alloc] init];
    }
    return self;
}
- (void)start {
    [self getLastEntry];
}
- (void)getLastEntry {
    SearchEntity * __weak weakSelf = self;
    [_getLastEntryInteractor getLastEntry:^(Lyrics *entry) {
        [weakSelf handleOnGetLastEntrySuccess:entry];
    } onError:^(LastEntryGetableError error) {
        [weakSelf handleOnGetLastEntryError:error];
    }];
}

- (void)handleOnGetLastEntrySuccess:(Lyrics *)lyrics {
    _lastEntry = lyrics;
    [_controller showLastEntry:lyrics];
}

- (void)handleOnGetLastEntryError:(LastEntryGetableError)error {
    NSLog(@"There are not entries in the history");
}

- (BOOL)validateSongField {
    NSString * song = [_controller getSong];
    return (song != nil) && ![song isEqualToString:@""];
}
- (BOOL)validateArtistField {
    NSString * artist = [_controller getArtist];
    return (artist != nil) && ![artist isEqualToString:@""];
}
- (BOOL)validateForm {
    BOOL songValid = [self validateSongField];
    if (songValid) {
        [_controller hideSongError];
    } else {
        [_controller showSongError];
    }
    
    BOOL artistValid = [self validateArtistField];
    if (artistValid) {
        [_controller hideArtistError];
    } else {
        [_controller showArtistError];
    }
    
    return songValid && artistValid;
}
- (void) onSearchButtonPressed {
    [self startLoadingUI];
    BOOL isValid = [self validateForm];
    if (isValid) {
        [self searchLyrics];
    } else {
        [self stopLoadingUI];
    }
}
- (void)startLoadingUI {
    [_controller setLoadingState];
}
- (void)stopLoadingUI {
    [_controller setSteadyState];
}
- (void)searchLyrics {
    NSString * song = [_controller getSong];
    NSString * artist = [_controller getArtist];
    SearchEntity * __weak weakSelf = self;
    [_getLyricsInteractor getLyricsForArtist:artist andSong:song onError:^(LyricsGetableError error) {
        [weakSelf handleLyricsSearchError:error];
    } onSuccess:^(Lyrics *response) {
        [weakSelf handleLyricsSearchSuccess:response];
    }];
}
- (void)handleLyricsSearchError: (LyricsGetableError) error {
    [self stopLoadingUI];
    NSString * errorMessage = [self getErrorMessageFor:error];
    [_controller showError:errorMessage];
}
- (void)handleLyricsSearchSuccess:(Lyrics *)response {
    [self stopLoadingUI];
    [_controller showLastEntry:response];
    [_controller navigateToReader:response];
}

- (NSString *)getErrorMessageFor:(LyricsGetableError)error {
    switch (error) {
        case LyricsGetableErrorNoResult:
            return @"No lyrics found.";
        case LyricsGetableErrorUnknown:
            return @"Please check your network connection.";
        case LyricsGetableErrorUnableToStoreInDB:
            return @"There is an error with the history. Please re-install the app.";
    }
}
- (void)onLastEntryPressed {
    [_controller navigateToReader:_lastEntry];
}
@end
