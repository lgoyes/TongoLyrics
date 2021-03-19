//
//  ReaderViewController.h
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import <UIKit/UIKit.h>
#import "Lyrics.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReaderViewController : UIViewController
+ (ReaderViewController *) getInstanceWith: (Lyrics *) content;
@end

NS_ASSUME_NONNULL_END
