//
//  iTVMasterViewController.m
//  iTV
//
//  Created by Ahmed Farghaly on 7/4/14.
//  Copyright (c) 2014 Ahmed Farghaly. All rights reserved.
//

#import "iTVMasterViewController.h"

#import "iTVDetailViewController.h"

@interface iTVMasterViewController ()
{
    NSArray *channelsData;
}

@end



// - - - - - - - - - - - -



@implementation iTVMasterViewController


#pragma mark - UIViewController methods



- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    
    [super awakeFromNib];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailViewController = (iTVDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *channelsDataPath = [bundle pathForResource:@"channelsData" ofType:@"plist"];
    channelsData = [NSArray arrayWithContentsOfFile:channelsDataPath];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}



// - - - - - - - - - - - -



#pragma mark - UITableViewDataSource methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [channelsData count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];

    if(nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSDictionary *channelData = channelsData[[indexPath row]];
    
    cell.textLabel.text = channelData[@"channelName"];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:24];
    
    cell.detailTextLabel.text = channelData[@"channelCountry"];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    cell.imageView.image = [UIImage imageNamed:channelData[@"channelLogo"]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"did select");
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
//        NSDate *object = _objects[indexPath.row];
//        self.detailViewController.detailItem = object;
        
    }
    else
    {
        
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        [[segue destinationViewController] setDetailItem:object];
    }
}



@end
