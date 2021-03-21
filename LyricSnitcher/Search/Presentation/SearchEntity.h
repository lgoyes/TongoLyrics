//
//  SearchEntity.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <Foundation/Foundation.h>
#import "SearchPresentationContract.h"
#import "LyricsGetable.h"
#import "LastEntryGetable.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchEntity : NSObject <SearchEntityType>
@property (weak, nonatomic) id<SearchControllerType> controller;
@property (strong, nonatomic) id<LyricsGetable> getLyricsInteractor;
@property (strong, nonatomic) id<LastEntryGetable> getLastEntryInteractor;
@property (strong, nonatomic) Lyrics * lastEntry;
- (BOOL) validateSongField;
- (BOOL) validateArtistField;
- (BOOL) validateForm;
- (void) startLoadingUI;
- (void) stopLoadingUI;
- (void) searchLyrics;
- (void) handleLyricsSearchError: (LyricsGetableError) error;
- (void) handleLyricsSearchSuccess: (Lyrics*) response;
- (NSString*) getErrorMessageFor: (LyricsGetableError) error;
- (void) getLastEntry;
- (void) handleOnGetLastEntrySuccess: (Lyrics *) lyrics;
- (void) handleOnGetLastEntryError: (LastEntryGetableError) error;
@end

NS_ASSUME_NONNULL_END
