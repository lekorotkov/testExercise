//
//  ViewController.m
//  Korotkov_Test_Project
//
//  Created by Alexey Korotkov on 2.11.15.
//  Copyright © 2015 Alexey Korotkov. All rights reserved.
//

#import "ViewController.h"
#import "ProgressTableViewCell.h"
#import "NumberOfActiveDownloadsView.h"

#define kProgressCellIdentifier @"ProgressCell"

static const int            kMaximumConnectionsPerHost = 8;
static const NSTimeInterval kTimeoutIntervalForRequest = 1000;
static const int            kNumberOfDownloads = 100;

@interface ViewController () <NSURLSessionDelegate, UITableViewDataSource, UITableViewDelegate, NSURLSessionDownloadDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *operationsArray;
@property (weak, nonatomic) IBOutlet UILabel *currentActiveOperationslabel;
@property (weak, nonatomic) IBOutlet NumberOfActiveDownloadsView *numberOfActiveDownloads;

@property (nonatomic, strong) NSMutableArray *progressesArray;
@property (nonatomic, strong) NSMutableArray *downloadTaskArray;
@property (nonatomic, strong) NSURLSession *session;

@end

@implementation ViewController

#pragma mark ViewControllerLifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.downloadTaskArray = [[NSMutableArray alloc] init];
    self.progressesArray = [[NSMutableArray alloc] init];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.timeoutIntervalForRequest = kTimeoutIntervalForRequest;
    config.HTTPMaximumConnectionsPerHost = kMaximumConnectionsPerHost;
    
    self.session =
    [NSURLSession sessionWithConfiguration:config
     delegate:self
     delegateQueue:[NSOperationQueue mainQueue]];
    
    for (int i = 0; i < kNumberOfDownloads; i++) {
        NSURL *downloadURL = [NSURL URLWithString:@"http://www.kaisertooling.com/files/publications/00_BIGKAISER_Volume1_EN_low.pdf"];
        
        NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:downloadURL];
        
        NSProgress *progress = [[NSProgress alloc] init];
        progress.kind = NSProgressKindFile;
        
        [self.progressesArray addObject:progress];
        
        [self.downloadTaskArray addObject:task];
        
        if (task.taskIdentifier <= kMaximumConnectionsPerHost) {
            [task resume];
        }
    }
    
    [self updateNumberOfRunningDownloads];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark UI update

- (void)updateNumberOfRunningDownloads {
    int numberOfRunningDownloads = 0;
    for (NSURLSessionDataTask *dataTask in self.downloadTaskArray) {
        if (dataTask.state == NSURLSessionTaskStateRunning) {
            numberOfRunningDownloads++;
        }
    }
    self.numberOfActiveDownloads.counter = numberOfRunningDownloads;
    [self.numberOfActiveDownloads setNeedsDisplay];
    self.currentActiveOperationslabel.text = [NSString stringWithFormat:@"%d",numberOfRunningDownloads];
}

#pragma mark TableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kProgressCellIdentifier];
    cell.state = [self.downloadTaskArray[indexPath.row] state];
    if ([self.downloadTaskArray[indexPath.row] state] == NSURLSessionTaskStateRunning) {
        NSProgress *progress = self.progressesArray[indexPath.row];
        cell.fractionCompleted = progress.fractionCompleted;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.downloadTaskArray.count;
}

#pragma mark NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    [self updateNumberOfRunningDownloads];
    
    for (NSURLSessionDownloadTask *task in self.downloadTaskArray) {
        if (task.state == NSURLSessionTaskStateSuspended) {
            [task resume];
            break;
        }
    }
    
    [self.tableView reloadData];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    NSIndexPath *path = [NSIndexPath indexPathForRow:downloadTask.taskIdentifier-1 inSection:0];
    ProgressTableViewCell *cell = (ProgressTableViewCell*)[self.tableView cellForRowAtIndexPath:path];
    NSProgress *progress = self.progressesArray[downloadTask.taskIdentifier-1];
    
    progress.totalUnitCount = totalBytesExpectedToWrite;
    progress.completedUnitCount = totalBytesWritten;
    
    cell.fractionCompleted = progress.fractionCompleted;
    
    cell.progressView.progress = progress.fractionCompleted;
    
    cell.progressLabel.text = [NSString stringWithFormat:@"Downloading... %@",progress.localizedAdditionalDescription];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    [self updateNumberOfRunningDownloads];
}

@end
