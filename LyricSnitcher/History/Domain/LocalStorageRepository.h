//
//  LocalStorageRepository.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#ifndef LocalStorageRepository_h
#define LocalStorageRepository_h

#import "Lyrics.h"

@protocol LocalStorageRepositoryType <NSObject>
- (void) create: (Lyrics *) item;
- (NSArray*) list;
- (void) updateBySong: (NSString*) song andArtist:(NSString*)artist item: (Lyrics*) item;
- (void) deleteBySong: (NSString*) song andArtist:(NSString*)artist;
- (void) readBySong: (NSString*) song andArtist:(NSString*)artist;
@end

#endif /* LocalStorageRepository_h */
