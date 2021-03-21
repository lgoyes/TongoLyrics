//
//  HistoryEntity.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 20/03/21.
//

#import <Foundation/Foundation.h>
#import "HistoryPresentationContract.h"
#import "HistoryGetable.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryEntity : NSObject <HistoryEntityType>
@property (weak, nonatomic) id<HistoryControllerType> controller;
@property (strong, nonatomic) id<HistoryGetable> getHistoryInteractor;
@property (strong, nonatomic) NSArray * historyEntries;
- (void) getHistory;
- (void) startLoading;
- (void) handleHistoryError: (HistoryGetableError) error;
- (void) handleHistorySuccess: (NSArray*) history;
@end

NS_ASSUME_NONNULL_END
