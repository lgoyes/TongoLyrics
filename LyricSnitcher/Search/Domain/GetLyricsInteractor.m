//
//  GetLyricsInteractor.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import "GetLyricsInteractor.h"
#import "RemoteLyricsRepository.h"
#import "LocalLyricsRepository.h"

@implementation GetLyricsInteractor
- (void)getLyricsForArtist:(NSString *)artist andSong:(NSString *)song onError:(void (^)(NSError * _Nonnull))onError onSuccess:(void (^)(Lyrics * _Nonnull))onSuccess {
    [_networkRepository fetchLyricsForArtist:artist andSong:song onError:^(NSError *error) {
        if (onError != nil) {
            onError(error);
        }
    } onSuccess:^(Lyrics *response) {
        if (onSuccess != nil) {
            onSuccess(response);
        }
    }];
}
- (instancetype) initWithSystemConfig:(SystemConfigType) systemConfig {
    self = [super init];
    if (self) {
        switch (systemConfig) {
            case SystemConfigTypeRelease:
                _networkRepository = [[RemoteLyricsRepository alloc] init];
                break;
            case SystemConfigTypeDebug:
                _networkRepository = [[LocalLyricsRepository alloc] init];
                break;
        }
    }
    return self;
}
@end
