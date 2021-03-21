//
//  SearchPresentationContract.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#ifndef SearchPresentationContract_h
#define SearchPresentationContract_h

#import <Foundation/Foundation.h>
#import "Lyrics.h"

@protocol SearchControllerType <NSObject>
- (NSString*) getSong;
- (NSString*) getArtist;
- (void) hideSongError;
- (void) showSongError;
- (void) hideArtistError;
- (void) showArtistError;
- (void) setLoadingState;
- (void) setSteadyState;
- (void) showError: (NSString*) message;
- (void) navigateToReader: (Lyrics*) lyrics;
- (void) showLastEntry: (Lyrics*) lyrics;
@end

@protocol SearchEntityType <NSObject>
- (void) onSearchButtonPressed;
- (void) setController: (id<SearchControllerType>) controller;
- (void) start;
- (void) onLastEntryPressed;
@end

#endif /* SearchPresentationContract_h */
