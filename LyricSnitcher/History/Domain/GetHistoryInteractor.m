//
//  GetHistoryInteractor.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 20/03/21.
//

#import "GetHistoryInteractor.h"
#import "DBLocalStorageRepository.h"
#import "SimplifiedLocalStorageRepository.h"

@interface GetHistoryInteractor()
+ (id<LocalStorageRepositoryType>) getRepositoryFor:(SystemConfigType) config;
@end

@implementation GetHistoryInteractor

- (instancetype)initWithSystemConfig:(SystemConfigType)systemConfig {
    self = [super init];
    if (self) {
        _localStorageRepository = [GetHistoryInteractor getRepositoryFor:systemConfig];
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        SystemConfigType systemConfig = [SystemConfig getCurrent];
        _localStorageRepository = [GetHistoryInteractor getRepositoryFor:systemConfig];
    }
    return self;
}

- (void)getHistory:(void (^)(HistoryGetableError))onError onSuccess:(void (^)(NSArray * history))onSuccess {
    [_localStorageRepository list:^(NSArray *entries) {
        onSuccess(entries);
    } onError:^(LocalStorageRepositoryError error) {
        onError(HistoryGetableErrorUnknown);
    }];
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
