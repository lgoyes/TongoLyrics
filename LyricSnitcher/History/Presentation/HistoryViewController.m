//
//  HistoryViewController.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 21/03/21.
//

#import "HistoryViewController.h"
#import "HistoryEntity.h"
#import "HistoryTableViewCell.h"

@interface HistoryViewController ()
@property (strong, nonatomic) id<HistoryEntityType> entity;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray * historyEntries;
@end

@implementation HistoryViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _entity = [[HistoryEntity alloc] init];
        _historyEntries = @[];
        [_entity setController:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_table setDelegate:self];
    [_table setDataSource:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_entity start];
}

- (void)setEmptyState {
    
}

- (void)setLoadingState {
    
}

- (void)showError:(NSString *)message {
    
}

- (void)showHistory:(NSArray *)history {
    _historyEntries = [history copy];
    [_table reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Lyrics * entry = _historyEntries[indexPath.row];
    HistoryTableViewCell * cell = (HistoryTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    [cell setSong:entry.song];
    [cell setArtist:entry.artist];
    [cell setDate:@"Dummy-date"];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _historyEntries.count;
}

@end
