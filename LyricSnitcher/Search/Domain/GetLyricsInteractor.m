//
//  GetLyricsInteractor.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import "GetLyricsInteractor.h"
#import "RemoteLyricsRepository.h"
#import "LocalLyricsRepository.h"
#import "DBLocalStorageRepository.h"
#import "SimplifiedLocalStorageRepository.h"

@interface GetLyricsInteractor()
+ (id<LyricsRepositoryProtocol>) getNetworkRepositoryFor:(SystemConfigType) config;
+ (id<LocalStorageRepositoryType>) getLocalStorageRepositoryFor:(SystemConfigType) config;
@end

@implementation GetLyricsInteractor
- (void)getLyricsForArtist:(NSString *)artist andSong:(NSString *)song onError:(void (^)(LyricsGetableError))onError onSuccess:(void (^)(Lyrics * _Nonnull))onSuccess {
    GetLyricsInteractor * __weak weakSelf = self;
    [_networkRepository fetchLyricsForArtist:artist andSong:song onError:^(NSError *error) {
        if (onError != nil) {
            if (error != nil && error.localizedDescription != nil && ([error.localizedDescription isEqualToString:@"The request timed out."] || [error.localizedDescription isEqualToString:@"No lyrics found."])) {
                onError(LyricsGetableErrorNoResult);
            } else {
                onError(LyricsGetableErrorUnknown);
            }
        }
    } onSuccess:^(Lyrics *response) {
        [weakSelf.localStorageRepository create:response onSuccess:^{
            if (onSuccess != nil) {
                onSuccess(response);
            }
        } onError:^(LocalStorageRepositoryError error) {
            onError(LyricsGetableErrorUnableToStoreInDB);
        }];
    }];
}
- (instancetype) initWithSystemConfig:(SystemConfigType) systemConfig {
    self = [super init];
    if (self) {
        _networkRepository = [GetLyricsInteractor getNetworkRepositoryFor:systemConfig];
        _localStorageRepository = [GetLyricsInteractor getLocalStorageRepositoryFor:systemConfig];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        SystemConfigType systemConfig = [SystemConfig getCurrent];
        _networkRepository = [GetLyricsInteractor getNetworkRepositoryFor:systemConfig];
        _localStorageRepository = [GetLyricsInteractor getLocalStorageRepositoryFor:systemConfig];
    }
    return self;
}
+(id<LyricsRepositoryProtocol>)getNetworkRepositoryFor:(SystemConfigType)config {
    switch (config) {
        case SystemConfigTypeRelease:
            return [[RemoteLyricsRepository alloc] init];
        case SystemConfigTypeDebug:
            return [[LocalLyricsRepository alloc] init];
    }
}
+ (id<LocalStorageRepositoryType>)getLocalStorageRepositoryFor:(SystemConfigType)config {
    switch (config) {
        case SystemConfigTypeRelease:
            return [[DBLocalStorageRepository alloc] init];
        case SystemConfigTypeDebug:
            return [[SimplifiedLocalStorageRepository alloc] initWithEntryManager:SimplifiedEntriesManager.sharedManager];
    }
}
@end
