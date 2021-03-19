//
//  LyricsGetable.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#ifndef LyricsGetable_h
#define LyricsGetable_h

#import <Foundation/Foundation.h>
#import "Lyrics.h"

@protocol LyricsGetable <NSObject>
- (void) getLyricsForArtist: (NSString*) artist andSong:(NSString*) song onError:(void (^) (NSError* error))onError onSuccess:(void (^) (Lyrics* response)) onSuccess;
@end

#endif /* LyricsGetable_h */
