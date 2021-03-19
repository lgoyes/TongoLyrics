//
//  SearchPresentationContract.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#ifndef SearchPresentationContract_h
#define SearchPresentationContract_h

#import <Foundation/Foundation.h>

@protocol SearchControllerType <NSObject>
- (NSString*) getSong;
- (NSString*) getArtist;
- (void) hideSongError;
- (void) showSongError;
- (void) hideArtistError;
- (void) showArtistError;
@end

@protocol SearchEntityType <NSObject>
- (void) onSearchButtonPressed;
@end

#endif /* SearchPresentationContract_h */
