//
//  LocalLyricsRepository.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import "LocalLyricsRepository.h"

@implementation LocalLyricsRepository

- (void)fetchLyricsForArtist:(NSString *)artist andSong:(NSString *)song onError:(void (^)(NSError *))onError onSuccess:(void (^)(Lyrics *))onSuccess {
    if (([artist isEqualToString:@"error"]) || ([song isEqualToString:@"error"])) {
        if (onError != nil) {
            NSError * error = [NSError errorWithDomain:NSURLErrorDomain code:-1001 userInfo:@{ @"NSLocalizedDescription": @"The request timed out."}];
            onError(error);
            return;
        }
    } else {
        if (onSuccess != nil) {
            NSString * lyrics = [NSString stringWithFormat:@"These are the lyrics for %@, written by %@.\nThis might be some extremely long lyrics, but they are not.\nThey are barely as long as this view, but due to my lack of creativity, I'm force to write some text.\n\nThis might be some extremely long lyrics, but they are not.\nThey are barely as long as this view, but due to my lack of creativity, I'm force to write some text.\n\nThis might be some extremely long lyrics, but they are not.\nThey are barely as long as this view, but due to my lack of creativity, I'm force to write some text.\n\nThis might be some extremely long lyrics, but they are not.\nThey are barely as long as this view, but due to my lack of creativity, I'm force to write some text.\n\n", song, artist];
            NSDate * date = [NSDate now];
            Lyrics * response = [[Lyrics alloc] initWithLyrics:lyrics artist:artist song:song andDate:date];
            onSuccess(response);
            return;
        }
    }
}

@end
