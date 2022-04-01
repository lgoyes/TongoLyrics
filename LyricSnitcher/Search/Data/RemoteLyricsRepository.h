//
//  RemoteLyricsRepository.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 18/03/21.
//

#import <Foundation/Foundation.h>
#import "LyricsRepositoryProtocol.h"
#import "APILyrics.h"
#import "RESTClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface RemoteLyricsRepository : NSObject <LyricsRepositoryProtocol>
@property (nonatomic, strong) RESTClient* webClient;
- (NSString*) formatStringURLForArtist: (NSString*) artist andSong:(NSString*) song;
- (Lyrics*) mapAPIResponse: (APILyrics*) response withArtist:(NSString*) artist song: (NSString*) song andDate: (NSDate*) date;
@end

NS_ASSUME_NONNULL_END
