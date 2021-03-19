//
//  SearchEntity.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <Foundation/Foundation.h>
#import "SearchPresentationContract.h"
#import "LyricsGetable.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchEntity : NSObject <SearchEntityType>
@property (weak, nonatomic) id<SearchControllerType> controller;
@property (nonatomic) id<LyricsGetable> getLyricsInteractor;
- (BOOL) validateSongField;
- (BOOL) validateArtistField;
- (BOOL) validateForm;
- (void) startLoadingUI;
- (void) stopLoadingUI;
- (void) searchLyrics;
- (void) handleLyricsSearchError: (LyricsGetableError) error;
- (void) handleLyricsSearchSuccess: (Lyrics*) response;
- (NSString*) getErrorMessageFor: (LyricsGetableError) error;
@end

NS_ASSUME_NONNULL_END
