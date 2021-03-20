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

typedef enum {
    LyricsGetableErrorNoResult = 0,
    LyricsGetableErrorStart = LyricsGetableErrorNoResult,
    LyricsGetableErrorUnableToStoreInDB = 1,
    LyricsGetableErrorUnknown = 2,
    LyricsGetableErrorStop = LyricsGetableErrorUnknown
} LyricsGetableError;

@protocol LyricsGetable <NSObject>
- (void) getLyricsForArtist: (NSString*) artist andSong:(NSString*) song onError:(void (^) (LyricsGetableError error))onError onSuccess:(void (^) (Lyrics* response)) onSuccess;
@end

#endif /* LyricsGetable_h */
