//
//  LocalLyricsRepository.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import "LocalLyricsRepository.h"

@implementation LocalLyricsRepository

- (void)fetchLyricsForArtist:(NSString *)artist andSong:(NSString *)song onError:(void (^)(NSError *))onError onSuccess:(void (^)(APILyrics *))onSuccess {
    if (([artist isEqualToString:@"non-existing-artist"]) || ([song isEqualToString:@"non-existing-song"])) {
        if (onError != nil) {
            NSError * error = [NSError errorWithDomain:NSURLErrorDomain code:-1001 userInfo:@{ @"NSLocalizedDescription": @"The request timed out."}];
            onError(error);
            return;
        }
    } else {
        if (onSuccess != nil) {
            NSString * lyrics = [NSString stringWithFormat:@"These are the lyrics for %@, written by %@", song, artist];
            APILyrics * response = [[APILyrics alloc] initWithLyrics:lyrics];
            onSuccess(response);
            return;
        }
    }
}

@end
