//
//  SettingsViewController.m
//  MyIslandProperty
//
//  Created by Adrian Rusin on 12/26/15.
//  Copyright (c) 2015 David Roman. All rights reserved.
//

#import "SettingsViewController.h"
#import "MBProgressHUD.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize btnDelete;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.btnDelete.enabled = FALSE;
    if (!loadData) {
        loadData = @"";
    }
    
    marrDownloadData = [[NSMutableArray alloc] init];
    folderArray = [[NSMutableArray alloc] init];
//    searchedResult = [[NSMutableArray alloc]init];
//    imageArray = [[NSMutableArray alloc]init];
//    countArray = [[NSMutableArray alloc]init];
    
    client = [DBClientsManager authorizedClient];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(fetchAllDropboxData) withObject:nil afterDelay:.1];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [folderArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id_cell_settings" forIndexPath:indexPath];

    DBFILESFolderMetadata * metadata = [folderArray objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = metadata.name;
    cell.detailTextLabel.hidden=YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    nSelectedRow = indexPath.row;
    self.btnDelete.enabled = TRUE;
    
//    UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    if ([cell.lblPcs.text isEqualToString:@""]) {
//        return;
//    }
//    DBMetadata *metadata = [searchedResult objectAtIndex:indexPath.row];
//    
//    DetailCollectionViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"id_detail_view_new"];
//    vc.loadData = metadata.path;
//    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnDeleteTapped:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DBFILESFolderMetadata * metadata = [folderArray objectAtIndex:nSelectedRow];
    [[client.filesRoutes delete_:[NSString stringWithFormat:@"/%@", metadata.name]]
     setResponseBlock:^(DBFILESMetadata *result, DBFILESDeleteError *routeError, DBRequestError *networkError)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (result) {
             NSLog(@"%@\n", result);
             [folderArray removeObjectAtIndex:nSelectedRow];
             [self.tableView reloadData];
         } else {
             // Error is with the route specifically (status code 409)
             if (routeError) {
                 if ([routeError isPathLookup]) {
                     // Can safely access this field
                     DBFILESLookupError *pathLookup = routeError.pathLookup;
                     NSLog(@"%@\n", pathLookup);
                 } else if ([routeError isPathWrite]) {
                     DBFILESWriteError *pathWrite = routeError.pathWrite;
                     NSLog(@"%@\n", pathWrite);
                     
                     // This would cause a runtime error
                     // DBFILESLookupError *pathLookup = routeError.pathLookup;
                 }
             }
             NSLog(@"%@\n%@\n", routeError, networkError);
         }
     }];
}
@end
