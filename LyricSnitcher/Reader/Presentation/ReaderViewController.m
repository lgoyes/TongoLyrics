//
//  ReaderViewController.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import "ReaderViewController.h"

@interface ReaderViewController ()

@end

@implementation ReaderViewController
+ (ReaderViewController *)getInstanceWith:(Lyrics *)content {
    return [[ReaderViewController alloc] initWithNibName:@"ReaderView" bundle:nil];
}
@end
