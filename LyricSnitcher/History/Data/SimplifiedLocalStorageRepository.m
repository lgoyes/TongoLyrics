//
//  SimplifiedLocalStorageRepository.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 20/03/21.
//

#import "SimplifiedLocalStorageRepository.h"
#import "Lyrics.h"

@interface SimplifiedLocalStorageRepository()
@property (strong, nonatomic) NSMutableArray* entries;
@end

@implementation SimplifiedLocalStorageRepository

- (instancetype)init
{
    self = [super init];
    if (self) {
        Lyrics * defaultEntry = [[Lyrics alloc] initWithLyrics:@"dummy-string-for-lyrics" artist:@"dummy-string-for-artist" song:@"dummy-string-for-song" andDate:[NSDate now]];
        _entries = [@[defaultEntry] mutableCopy];
        _shouldSuccessfullyStoreEntry = true;
    }
    return self;
}

- (instancetype)initWithEntryManager: (SimplifiedEntriesManager*) manager {
    self = [super init];
    if (self) {
        _entries = manager.entries;
        _shouldSuccessfullyStoreEntry = true;
    }
    return self;
}

- (NSArray *)getEntries {
    return _entries;
}

- (void)clearEntries {
    _entries = [@[] mutableCopy];
}

- (void)create:(Lyrics *)item onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    if (_shouldSuccessfullyStoreEntry) {
        [_entries addObject:item];
        onSuccess();
    } else {
        onError(LocalStorageRepositoryErrorCreate);
    }
}

- (void)deleteBySong:(NSString *)song andArtist:(NSString *)artist onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    for (Lyrics* entry in _entries) {
        if ([entry.song isEqualToString:song] && [entry.artist isEqualToString:artist]) {
            [_entries removeObject:entry];
            onSuccess();
            return;
        }
    }
    onError(LocalStorageRepositoryErrorEntryDoesNotExist);
}

- (void)list:(void (^)(NSArray *))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    onSuccess([_entries copy]);
}

- (void)readBySong:(NSString *)song andArtist:(NSString *)artist onSuccess:(void (^)(Lyrics *))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    for (Lyrics* entry in _entries) {
        if ([entry.song isEqualToString:song] && [entry.artist isEqualToString:artist]) {
            onSuccess(entry);
            return;
        }
    }
    onError(LocalStorageRepositoryErrorEntryDoesNotExist);
}

- (void)updateBySong:(NSString *)song andArtist:(NSString *)artist item:(Lyrics *)item onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    for (Lyrics* entry in _entries) {
        if ([entry.song isEqualToString:song] && [entry.artist isEqualToString:artist]) {
            entry.lyrics = item.lyrics;
            entry.song = item.song;
            entry.artist = item.artist;
            entry.date = item.date;
            onSuccess();
            return;
        }
    }
    onError(LocalStorageRepositoryErrorEntryDoesNotExist);
}

- (void)getLastRecord:(void (^)(Lyrics *))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    int numberOfEntries = (int) _entries.count;
    if (numberOfEntries > 0) {
        onSuccess(_entries[numberOfEntries-1]);
    } else {
        onError(LocalStorageRepositoryErrorNoEntries);
    }
}

@end
