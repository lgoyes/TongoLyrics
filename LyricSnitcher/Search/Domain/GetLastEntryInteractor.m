//
//  GetLastEntryInteractor.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 21/03/21.
//

#import "GetLastEntryInteractor.h"
#import "DBLocalStorageRepository.h"
#import "SimplifiedLocalStorageRepository.h"

@interface GetLastEntryInteractor()
+ (id<LocalStorageRepositoryType>) getRepositoryFor:(SystemConfigType) config;
@end

@implementation GetLastEntryInteractor

- (void)getLastEntry:(void (^)(Lyrics *))onSuccess onError:(void (^)(LastEntryGetableError))onError {
    [_localStorageRepository getLastRecord:^(Lyrics *item) {
        onSuccess(item);
    } onError:^(LocalStorageRepositoryError error) {
        onError(LastEntryGetableErrorNoEntries);
    }];
}

- (instancetype)initWithSystemConfig:(SystemConfigType)systemConfig {
    self = [super init];
    if (self) {
        _localStorageRepository = [GetLastEntryInteractor getRepositoryFor:systemConfig];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        SystemConfigType systemConfig = [SystemConfig getCurrent];
        _localStorageRepository = [GetLastEntryInteractor getRepositoryFor:systemConfig];
    }
    return self;
}

+ (id<LocalStorageRepositoryType>)getRepositoryFor:(SystemConfigType)config {
    switch (config) {
        case SystemConfigTypeRelease:
            return [[DBLocalStorageRepository alloc] init];
        case SystemConfigTypeDebug:
            return [[SimplifiedLocalStorageRepository alloc] initWithEntryManager:SimplifiedEntriesManager.sharedManager];
    }
}

@end
