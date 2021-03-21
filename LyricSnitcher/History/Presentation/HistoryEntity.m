//
//  HistoryEntity.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 20/03/21.
//

#import "HistoryEntity.h"
#import "GetHistoryInteractor.h"

@implementation HistoryEntity
- (instancetype)init
{
    self = [super init];
    if (self) {
        _getHistoryInteractor = [[GetHistoryInteractor alloc] init];
    }
    return self;
}
- (void)start {
    [self startLoading];
    [self getHistory];
}
- (void)startLoading {
    [_controller setLoadingState];
}
- (void) getHistory {
    HistoryEntity * __weak weakSelf = self;
    [_getHistoryInteractor getHistory:^(HistoryGetableError error) {
        [weakSelf handleHistoryError:error];
    } onSuccess:^(NSArray *history) {
        [weakSelf handleHistorySuccess:history];
    }];
}
- (void)handleHistoryError:(HistoryGetableError)error {
    [_controller showError:@"Unable to load local files. Please re-install the app"];
}
- (void)handleHistorySuccess:(NSArray *)history {
    if (history.count > 0) {
        [_controller showHistory:history];
    } else {
        [_controller setEmptyState];
    }
}
@end
