//
//  HistoryPresentationContract.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 20/03/21.
//

#ifndef HistoryPresentationContract_h
#define HistoryPresentationContract_h

#import <Foundation/Foundation.h>

@protocol HistoryControllerType <NSObject>
- (void)showError:(NSString *)message;
- (void)showHistory:(NSArray*) history;
- (void)setEmptyState;
- (void)setLoadingState;
@end

@protocol HistoryEntityType <NSObject>
- (void) start;
- (void) setController: (id<HistoryControllerType>) controller;
@end

#endif /* HistoryPresentationContract_h */
