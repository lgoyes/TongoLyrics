//
//  HistoryGetable.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 20/03/21.
//

#ifndef HistoryGetable_h
#define HistoryGetable_h

#import <Foundation/Foundation.h>
#import "Lyrics.h"

typedef enum {
    HistoryGetableErrorUnknown = 0,
    HistoryGetableErrorStart = HistoryGetableErrorUnknown,
    LyricsGetableErrorStop = HistoryGetableErrorUnknown
} HistoryGetableError;

@protocol HistoryGetable <NSObject>
- (void) getHistory: (void (^) (HistoryGetableError error))onError onSuccess:(void (^) (NSArray* history)) onSuccess;
@end


#endif /* HistoryGetable_h */
