//
//  LocalStorageRepository.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#ifndef LocalStorageRepository_h
#define LocalStorageRepository_h

typedef enum {
    LocalStorageRepositoryErrorCreate = 0,
    LocalStorageRepositoryErrorStart = LocalStorageRepositoryErrorCreate,
    LocalStorageRepositoryErrorEntryDoesNotExist = 1,
    LocalStorageRepositoryErrorList = 1,
    LocalStorageRepositoryErrorUnknown = 2,
    LocalStorageRepositoryErrorEnd = LocalStorageRepositoryErrorUnknown
} LocalStorageRepositoryError;

#import "Lyrics.h"

@protocol LocalStorageRepositoryType <NSObject>
- (void) create: (Lyrics *) item onSuccess: (void (^) (void)) onSuccess onError: (void (^) (LocalStorageRepositoryError error)) onError;
- (void) list: (void (^) (NSArray* entries)) onSuccess onError:(void (^) (LocalStorageRepositoryError error)) onError;
- (void) updateBySong: (NSString*) song andArtist:(NSString*)artist item: (Lyrics*) item onSuccess:(void (^) (void)) onSuccess onError:(void (^) (LocalStorageRepositoryError error)) onError;
- (void) deleteBySong: (NSString*) song andArtist:(NSString*)artist onSuccess:(void (^) (void)) onSuccess onError:(void (^) (LocalStorageRepositoryError error)) onError;
- (void) readBySong: (NSString*) song andArtist:(NSString*)artist onSuccess:(void (^) (Lyrics * item)) onSuccess onError:(void (^) (LocalStorageRepositoryError error)) onError;
@end

#endif /* LocalStorageRepository_h */
