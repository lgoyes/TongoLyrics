//
//  GetLyricsInteractor.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <Foundation/Foundation.h>
#import "LyricsRepositoryProtocol.h"
#import "SystemConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface GetLyricsInteractor : NSObject
@property (nonatomic) id<LyricsRepositoryProtocol> networkRepository;
- (void) getLyricsForArtist: (NSString*) artist andSong:(NSString*) song onError:(void (^) (NSError* error))onError onSuccess:(void (^) (Lyrics* response)) onSuccess;
- (instancetype) initWithSystemConfig:(SystemConfigType) systemConfig;
@end

NS_ASSUME_NONNULL_END
