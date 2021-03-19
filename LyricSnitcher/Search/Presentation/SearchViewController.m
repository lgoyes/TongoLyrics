//
//  SearchViewController.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 19/03/21.
//

#import "SearchViewController.h"
#import "SearchEntity.h"
#import "SearchPresentationContract.h"

@interface SearchViewController()
@property (weak, nonatomic) IBOutlet UITextField *songTextField;
@property (weak, nonatomic) IBOutlet UITextField *artistTextField;
@property (weak, nonatomic) IBOutlet UIButton *getLyricsButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingLyricsActivityIndicator;
@property (weak, nonatomic) IBOutlet UIStackView *previousSearchStackContainer;

@property (nonatomic) id<SearchEntityType> entity;
@end

@implementation SearchViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _entity = [[SearchEntity alloc] init];
        [_entity setController:self];
    }
    return self;
}

- (IBAction)onGetLyricsButtonPressed:(UIButton *)sender {
    [_entity onSearchButtonPressed];
}

- (NSString *)getArtist {
    return _artistTextField.text;
}

- (NSString *)getSong {
    return _songTextField.text;
}

- (void)hideArtistError {
    
}


- (void)hideSongError {
    
}


- (void)setLoadingState {
    
}


- (void)setSteadyState {
    
}


- (void)showArtistError {
    
}


- (void)showSongError {
    
}

- (void)showError:(NSString *)message {
    
}

- (void)navigateToReader:(Lyrics *)lyrics {
    
}

@end
