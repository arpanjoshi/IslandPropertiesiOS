//
//  SearchViewController.m
//  MyIslandProperty
//
//  Created by Adrian Rusin on 12/24/15.
//  Copyright (c) 2015 David Roman. All rights reserved.
//

#import "SearchViewController.h"
#import "DetailCollectionViewController.h"
#import "MBProgressHUD.h"
#import "DropboxCell.h"
#import "DetailCollectionViewController.h"

@interface SearchViewController ()<UISearchBarDelegate>

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!loadData) {
        loadData = @"";
    }
    
    marrDownloadData = [[NSMutableArray alloc] init];
    searchedResult = [[NSMutableArray alloc]init];
    imageArray = [[NSMutableArray alloc]init];
    countArray = [[NSMutableArray alloc]init];
    folderArray = [[NSMutableArray alloc]init];
    
    client = [DBClientsManager authorizedClient];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(fetchAllDropboxData) withObject:nil afterDelay:.1];
}
-(void)viewWillAppear:(BOOL)animated{
    
}

#pragma mark - Dropbox Methods

-(void)fetchAllDropboxData
{
    [[client.filesRoutes listFolder:@""]
     setResponseBlock:^(DBFILESListFolderResult *response, DBFILESListFolderError *routeError, DBRequestError *networkError) {
         if (response) {
             NSArray<DBFILESMetadata *> *entries = response.entries;
             NSString *cursor = response.cursor;
             BOOL hasMore = [response.hasMore boolValue];
             
             [self printEntries:entries];
             
             if (hasMore) {
                 NSLog(@"Folder is large enough where we need to call `listFolderContinue:`");
                 
                 [self listFolderContinueWithClient:client cursor:cursor];
             } else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 searchedResult = folderArray;
                 [self.tableView reloadData];
                 NSLog(@"List folder complete.");
             }
         } else {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSLog(@"%@\n%@\n", routeError, networkError);
         }
     }];
}

- (void)listFolderContinueWithClient:(DBUserClient *)client1 cursor:(NSString *)cursor {
    [[client1.filesRoutes listFolderContinue:cursor]
     setResponseBlock:^(DBFILESListFolderResult *response, DBFILESListFolderContinueError *routeError,
                        DBRequestError *networkError) {
         if (response) {
             NSArray<DBFILESMetadata *> *entries = response.entries;
             NSString *cursor = response.cursor;
             BOOL hasMore = [response.hasMore boolValue];
             
             [self printEntries:entries];
             
             if (hasMore)
             {
                 [self listFolderContinueWithClient:client cursor:cursor];
             } else
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 searchedResult = folderArray;
                 [self.tableView reloadData];
                 NSLog(@"List folder complete.");
             }
         } else {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSLog(@"%@\n%@\n", routeError, networkError);
         }
     }];
}

- (void)printEntries:(NSArray<DBFILESMetadata *> *)entries {
    for (DBFILESMetadata *entry in entries) {
        if ([entry isKindOfClass:[DBFILESFileMetadata class]]) {
            DBFILESFileMetadata *fileMetadata = (DBFILESFileMetadata *)entry;
            NSLog(@"File data: %@\n", fileMetadata);
        } else if ([entry isKindOfClass:[DBFILESFolderMetadata class]]) {
            DBFILESFolderMetadata *folderMetadata = (DBFILESFolderMetadata *)entry;
            NSLog(@"Folder data: %@\n", folderMetadata);
            [folderArray addObject:folderMetadata];
        } else if ([entry isKindOfClass:[DBFILESDeletedMetadata class]]) {
            DBFILESDeletedMetadata *deletedMetadata = (DBFILESDeletedMetadata *)entry;
            NSLog(@"Deleted data: %@\n", deletedMetadata);
        }
    }
}

#pragma mark - UITableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchedResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id_property_cell"];
    
    DBFILESFolderMetadata * metadata = [searchedResult objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.lblTitle.text = metadata.name;
    cell.lblPcs.hidden=YES;
    cell.lblDate.hidden=YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    DropboxCell *cell = (DropboxCell*)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.lblPcs.text isEqualToString:@""]) {
        return;
    }
    DBFILESFolderMetadata *metadata = [searchedResult objectAtIndex:indexPath.row];
    
    DetailCollectionViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"id_detail_view_new"];
    vc.loadData = metadata.pathDisplay;
    vc.strPropertyName = metadata.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - search bar

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO];
    searchBar.text=@"";
    [searchBar resignFirstResponder];
    searchedResult = folderArray;
    [_tableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
    searchedResult = [[folderArray filteredArrayUsingPredicate:predicate] mutableCopy];
    [self.tableView reloadData];
    
}
@end
