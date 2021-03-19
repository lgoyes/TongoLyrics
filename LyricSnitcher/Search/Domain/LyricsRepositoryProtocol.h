//
//  LyricsRepositoryProtocol.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 18/03/21.
//

#ifndef LyricsRepositoryProtocol_h
#define LyricsRepositoryProtocol_h

#import "Lyrics.h"

@protocol LyricsRepositoryProtocol <NSObject>
- (void) fetchLyricsForArtist: (NSString*) artist andSong:(NSString*) song onError:(void (^) (NSError* error))onError onSuccess:(void (^) (Lyrics* response)) onSuccess;
@end

#endif /* LyricsRepositoryProtocol_h */
