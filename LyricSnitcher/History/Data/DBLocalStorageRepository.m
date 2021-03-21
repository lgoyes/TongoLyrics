//
//  DBLocalStorageRepository.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <UIKit/UIKit.h>
#import "DBLocalStorageRepository.h"
#import "AppDelegate.h"
#import "DBLyrics+CoreDataClass.h"

@interface DBLocalStorageRepository()
- (NSFetchRequest*) getDefaultDBLyricsRequest;
- (NSFetchRequest*) getDBLyricsRequestForSong: (NSString*) song andArtist: (NSString*) artist;
- (void) findItemBySong: (NSString*) song andArtist: (NSString*) artist onSuccess: (void (^) (DBLyrics* item)) onSuccess onError: (void (^) (LocalStorageRepositoryError error)) onError;
- (DBLyrics *) createNewDBLyricsEntry;
- (void) updateEntry: (DBLyrics *) entry withLyrics: (Lyrics*) lyrics onSuccess: (void (^) (void)) onSuccess onError: (void (^) (LocalStorageRepositoryError error)) onError;
@end

@implementation DBLocalStorageRepository
- (instancetype)init
{
    self = [super init];
    if (self) {
        AppDelegate * delegate = (AppDelegate*) UIApplication.sharedApplication.delegate;
        _context = delegate.persistentContainer.viewContext;
    }
    return self;
}

- (void)create:(Lyrics *)item onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    DBLyrics * dbLyrics = [self createNewDBLyricsEntry];
    [self updateEntry:dbLyrics withLyrics:item onSuccess:^{
        onSuccess();
    } onError:^(LocalStorageRepositoryError error) {
        onError(error);
    }];
}

- (void)deleteBySong:(NSString *)song andArtist:(NSString *)artist onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    
    DBLocalStorageRepository * __weak weakSelf = self;
    [self findItemBySong:song andArtist:artist onSuccess:^(DBLyrics * dbLyrics) {
        [weakSelf.context deleteObject:dbLyrics];
        onSuccess();
    } onError:^(LocalStorageRepositoryError error) {
        onError(error);
    }];
}

- (void)list:(void (^)(NSArray *))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    NSFetchRequest *request = [self getDefaultDBLyricsRequest];
    
    NSError *error = nil;
    NSArray *array = [_context executeFetchRequest:request error:&error];
    if (error == nil) {
        onSuccess(array);
    } else {
        NSLog(@"Failed to list - error: %@", [error localizedDescription]);
        onError(LocalStorageRepositoryErrorList);
    }
}

- (void)readBySong:(NSString *)song andArtist:(NSString *)artist onSuccess:(void (^)(Lyrics*))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    
    [self findItemBySong:song andArtist:artist onSuccess:^(DBLyrics * dbLyrics) {
        Lyrics * lyrics = [[Lyrics alloc] initWithLyrics:dbLyrics.lyrics artist:dbLyrics.artist song:dbLyrics.song andDate:dbLyrics.date];
        onSuccess(lyrics);
    } onError:^(LocalStorageRepositoryError error) {
        onError(error);
    }];
}

- (void)updateBySong:(NSString *)song andArtist:(NSString *)artist item:(Lyrics *)item onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    
    DBLocalStorageRepository * __weak weakSelf = self;
    [self findItemBySong:song andArtist:artist onSuccess:^(DBLyrics * dbLyrics) {
        [weakSelf updateEntry:dbLyrics withLyrics:item onSuccess:^{
            onSuccess();
        } onError:^(LocalStorageRepositoryError error) {
            onError(error);
        }];
    } onError:^(LocalStorageRepositoryError error) {
        onError(error);
    }];
}

- (void)getLastRecord:(void (^)(Lyrics *))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    NSFetchRequest * request = [self getDefaultDBLyricsRequest];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error = nil;
    NSArray *array = [_context executeFetchRequest:request error:&error];
    if (error == nil) {
        if (array.count == 0) {
            NSLog(@"There are no entries");
            onError(LocalStorageRepositoryErrorNoEntries);
        } else {
            onSuccess(array[0]);
        }
    } else {
        NSLog(@"Failed to list entries - error: %@", [error localizedDescription]);
        onError(LocalStorageRepositoryErrorList);
    }
}

- (NSFetchRequest *)getDefaultDBLyricsRequest {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"DBLyrics"];
    return request;
}

- (NSFetchRequest *)getDBLyricsRequestForSong:(NSString *)song andArtist:(NSString *)artist {
    NSFetchRequest * request = [self getDefaultDBLyricsRequest];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"song == %@ && artist == %@", song, artist];
    [request setPredicate:predicate];
    return request;
}

- (void)findItemBySong:(NSString *)song andArtist:(NSString *)artist onSuccess:(void (^)(DBLyrics *))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    NSFetchRequest *request = [self getDBLyricsRequestForSong:song andArtist:artist];
    
    NSError *error = nil;
    NSArray *array = [_context executeFetchRequest:request error:&error];
    if (error == nil || array.count > 0) {
        DBLyrics * dbLyrics = (DBLyrics *) array[0];
        onSuccess(dbLyrics);
    } else {
        NSLog(@"Failed to read - error: %@", [error localizedDescription]);
        onError(LocalStorageRepositoryErrorEntryDoesNotExist);
    }
}

- (DBLyrics *)createNewDBLyricsEntry {
    DBLyrics * newEntry = (DBLyrics *)[NSEntityDescription insertNewObjectForEntityForName:@"DBLyrics" inManagedObjectContext:_context];
    return newEntry;
}

- (void)updateEntry:(DBLyrics *)entry withLyrics:(Lyrics *)lyrics onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    entry.artist = lyrics.artist;
    entry.song = lyrics.song;
    entry.lyrics = lyrics.lyrics;
    entry.date = lyrics.date;
    NSError * error;
    if (![_context save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        onError(LocalStorageRepositoryErrorCreate);
    } else {
        onSuccess();
    }
}

@end
