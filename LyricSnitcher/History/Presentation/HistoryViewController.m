//
//  HistoryViewController.m
//  LyricSnitcher
//
//  Created by Luis Goyes Garces on 21/03/21.
//

#import "HistoryViewController.h"
#import "HistoryEntity.h"
#import "HistoryTableViewCell.h"
#import "ReaderViewController.h"

@interface HistoryViewController ()
@property (strong, nonatomic) id<HistoryEntityType> entity;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) NSArray * historyEntries;
@property (strong, nonatomic) NSDateFormatter * dateFormatter;
@end

@implementation HistoryViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _entity = [[HistoryEntity alloc] init];
        _historyEntries = @[];
        [_entity setController:self];
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [_dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
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
    NSLog(@"We should set some auxiliary views to the table view in a real-life project");
}

- (void)setLoadingState {
    NSLog(@"We should set some auxiliary views to the table view in a real-life project");
}

- (void)showError:(NSString *)message {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)showHistory:(NSArray *)history {
    _historyEntries = [history copy];
    [_table reloadData];
}

- (void)launchReaderWithLyrics:(Lyrics *)lyrics {
    ReaderViewController * viewController = [ReaderViewController getInstanceWith:lyrics];
    [self presentViewController:viewController animated:true completion:nil];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Lyrics * entry = _historyEntries[indexPath.row];
    HistoryTableViewCell * cell = (HistoryTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
    [cell setSong:entry.song];
    [cell setArtist:entry.artist];
    [cell setDate: [_dateFormatter stringFromDate:entry.date]];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _historyEntries.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_entity onItemSelected: (int) indexPath.row];
}

@end
