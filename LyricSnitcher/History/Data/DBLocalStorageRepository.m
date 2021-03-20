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
    DBLyrics * dbLyrics = (DBLyrics *)[NSEntityDescription insertNewObjectForEntityForName:@"DBLyrics" inManagedObjectContext:_context];
    dbLyrics.artist = item.artist;
    dbLyrics.song = item.song;
    dbLyrics.lyrics = item.lyrics;
    dbLyrics.date = item.date;
    NSError * error;
    if (![_context save:&error]) {
        NSLog(@"Failed to save - error: %@", [error localizedDescription]);
        onError(LocalStorageRepositoryErrorCreate);
    } else {
        onSuccess();
    }
}

- (void)deleteBySong:(NSString *)song andArtist:(NSString *)artist onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"DBLyrics"];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"song == %@ && artist == %@", song, artist];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [_context executeFetchRequest:request error:&error];
    if (error == nil || array.count == 0) {
        DBLyrics * dbLyrics = (DBLyrics *) array[0];
        [_context deleteObject:dbLyrics];
        onSuccess();
    } else {
        NSLog(@"Failed to delete - error: %@", [error localizedDescription]);
        onError(LocalStorageRepositoryErrorEntryDoesNotExist);
    }
}

- (void)list:(void (^)(NSArray *))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"DBLyrics"];
    
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
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"DBLyrics"];

    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"song == %@ && artist == %@", song, artist];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [_context executeFetchRequest:request error:&error];
    if (error == nil || array.count == 0) {
        DBLyrics * dbLyrics = (DBLyrics *) array[0];
        Lyrics * lyrics = [[Lyrics alloc] initWithLyrics:dbLyrics.lyrics artist:dbLyrics.artist song:dbLyrics.song andDate:dbLyrics.date];
        onSuccess(lyrics);
    } else {
        NSLog(@"Failed to read - error: %@", [error localizedDescription]);
        onError(LocalStorageRepositoryErrorEntryDoesNotExist);
    }
}

- (void)updateBySong:(NSString *)song andArtist:(NSString *)artist item:(Lyrics *)item onSuccess:(void (^)(void))onSuccess onError:(void (^)(LocalStorageRepositoryError))onError {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"DBLyrics"];

    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"song == %@ && artist == %@", song, artist];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [_context executeFetchRequest:request error:&error];
    if (error == nil || array.count == 0) {
        DBLyrics * dbLyrics = (DBLyrics *) array[0];
        dbLyrics.artist = item.artist;
        dbLyrics.song = item.song;
        dbLyrics.lyrics = item.lyrics;
        dbLyrics.date = item.date;
        NSError * error;
        if (![_context save:&error]) {
            NSLog(@"Failed to save - error: %@", [error localizedDescription]);
            onError(LocalStorageRepositoryErrorEntryDoesNotExist);
        } else {
            onSuccess();
        }
    } else {
        NSLog(@"Failed to read - error: %@", [error localizedDescription]);
        onError(LocalStorageRepositoryErrorEntryDoesNotExist);
    }
}

@end
