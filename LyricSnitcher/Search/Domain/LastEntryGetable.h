//
//  LastEntryGetable.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 21/03/21.
//

#ifndef LastEntryGetable_h
#define LastEntryGetable_h

#import <Foundation/Foundation.h>
#import "Lyrics.h"

typedef enum {
    LastEntryGetableErrorNoEntries = 0,
} LastEntryGetableError;

@protocol LastEntryGetable <NSObject>
- (void) getLastEntry: (void (^) (Lyrics * entry)) onSuccess onError:(void (^) (LastEntryGetableError error)) onError;
@end


#endif /* LastEntryGetable_h */
