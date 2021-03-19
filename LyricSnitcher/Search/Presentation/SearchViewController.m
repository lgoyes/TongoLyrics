//
//  SearchViewController.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import "SearchViewController.h"
#import "SearchEntity.h"

@interface SearchViewController()
@property (weak, nonatomic) IBOutlet UITextField *songTextField;
@property (weak, nonatomic) IBOutlet UITextField *artistTextField;
@property (weak, nonatomic) IBOutlet UIButton *getLyricsButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingLyricsActivityIndicator;
@property (weak, nonatomic) IBOutlet UIStackView *previousSearchStackContainer;

@property (nonatomic) SearchEntity * entity;
@end

@implementation SearchViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _entity = [[SearchEntity alloc] init];
    }
    return self;
}

- (IBAction)onGetLyricsButtonPressed:(UIButton *)sender {
    
}
- (NSString *)getArtist { 
    return nil;
}

- (NSString *)getSong { 
    return nil;
}
@end
