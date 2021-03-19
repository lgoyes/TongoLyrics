//
//  RemoteLyricsRepository.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 18/03/21.
//

#import <Foundation/Foundation.h>
#import "LyricsRepositoryProtocol.h"
#import "APILyrics.h"

NS_ASSUME_NONNULL_BEGIN

@interface RemoteLyricsRepository : NSObject <LyricsRepositoryProtocol>
- (NSString*) formatStringURLForArtist: (NSString*) artist andSong:(NSString*) song;
- (NSURL*) getURLForArtist: (NSString*) artist andSong:(NSString*) song;
- (void) _fetchLyricsForArtist: (NSString*) artist andSong:(NSString*) song onError:(void (^) (NSError* error))onError onSuccess:(void (^) (APILyrics* response)) onSuccess;
- (Lyrics*) mapAPIResponse: (APILyrics*) response withArtist:(NSString*) artist song: (NSString*) song andDate: (NSDate*) date;
@end

NS_ASSUME_NONNULL_END
