//
//  DetailCollectionViewController.m
//  MyIslandProperty
//
//  Created by Adrian Rusin on 12/24/15.
//  Copyright (c) 2015 David Roman. All rights reserved.
//

#import "DetailCollectionViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "UploadViewController.h"

#define myDelegate (AppDelegate*)[[UIApplication sharedApplication]delegate]

@interface DetailCollectionViewController (){
    
    MBProgressHUD *hud;
}

@end

@implementation DetailCollectionViewController
@synthesize loadData, strPropertyName;

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    client = [DBClientsManager authorizedClient];
    
    //Get DBFiles folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    folderPath = [libraryDirectory stringByAppendingPathComponent:strPropertyName];
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];

    //remove folder
    if ([filemgr removeItemAtPath:folderPath error:NULL]) {
        NSLog(@"Remove successful");
    }
    else NSLog(@"Remove failed");
    
    //create DBFiles folder
    NSError *error;
    [filemgr createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:&error];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    marrDownloadData = [[NSMutableArray alloc] init];
    imageArray = [[NSMutableArray alloc] init];
    finalArray  = [[NSMutableArray alloc]init];
    
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //[self performSelector:@selector(fetchAllDropboxData) withObject:nil afterDelay:.1];
    
    //[self getAllPictures];
}
- (void) viewWillAppear:(BOOL)animated {
    
    [imageArray removeAllObjects];
    [marrDownloadData removeAllObjects];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(fetchAllDropboxData) withObject:nil afterDelay:.1];
}

#pragma mark - Dropbox Methods

-(void)fetchAllDropboxData
{
    [[client.filesRoutes listFolder:loadData]
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
                 if (imageArray.count>0)
                 {
                     [self downloadImagesForIndex:0];
                 }
                 else
                 {
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                 }
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
                 if (imageArray.count>0)
                 {
                     [self downloadImagesForIndex:0];
                 }
                 else
                 {
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                 }
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
            if ([[fileMetadata.name pathExtension] isEqualToString:@"png"] || [[fileMetadata.name pathExtension] isEqualToString:@"jpg"] || [[fileMetadata.name pathExtension] isEqualToString:@"jpeg"])
            {
                [imageArray addObject:fileMetadata];
            }
        } else if ([entry isKindOfClass:[DBFILESFolderMetadata class]]) {
            DBFILESFolderMetadata *folderMetadata = (DBFILESFolderMetadata *)entry;
            NSLog(@"Folder data: %@\n", folderMetadata);
        } else if ([entry isKindOfClass:[DBFILESDeletedMetadata class]]) {
            DBFILESDeletedMetadata *deletedMetadata = (DBFILESDeletedMetadata *)entry;
            NSLog(@"Deleted data: %@\n", deletedMetadata);
        }
    }
}

-(void)downloadImagesForIndex:(long)index
{
    DBFILESFileMetadata *metadata = [imageArray objectAtIndex:index];
    
    [[[client.filesRoutes downloadData:metadata.pathDisplay]
      setResponseBlock:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *networkError,
                         NSData *fileContents) {
          if (result) {
              NSLog(@"%@\n", result);
              //NSString *dataStr = [[NSString alloc] initWithData:fileContents encoding:NSUTF8StringEncoding];
              //NSLog(@"%@\n", dataStr);
              
              UIImage *image = [UIImage imageWithData:fileContents];
              [finalArray addObject:image];
              
              NSString *filePath = [folderPath stringByAppendingPathComponent:metadata.name]; //Add the file name
              [fileContents writeToFile:filePath atomically:YES];
              if (index==imageArray.count-1)
              {
                  [self.collectionView reloadData];
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
              }
              else
              {
                  [self downloadImagesForIndex:index+1];
              }
          } else {
              NSLog(@"%@\n%@\n", routeError, networkError);
          }
      }] setProgressBlock:^(int64_t bytesDownloaded, int64_t totalBytesDownloaded, int64_t totalBytesExpectedToDownload) {
          NSLog(@"%lld\n%lld\n%lld\n", bytesDownloaded, totalBytesDownloaded, totalBytesExpectedToDownload);
      }];
}

/*#pragma mark - DBRestClientDelegate Methods for Load Data
- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata *)metadata
{
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([metadata.contents count]==0) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Empty!"
                                                           message:@"No images to display"
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        alert.tag = 20;
            [alert show];
        return;
    }
    
    nDownloads = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    cntMetaData = 0;
    for (int i = 0; i < [metadata.contents count]; i++) {
        DBMetadata *data = [metadata.contents objectAtIndex:i];
        
        //pictures only
        if(data.thumbnailExists){
            [marrDownloadData addObject:data];
            cntMetaData++;
        }
    }
    
    for (int i = 0; i < [metadata.contents count]; i++) {
        DBMetadata *data = [metadata.contents objectAtIndex:i];
        
        NSLog(@"data.filename = %@", data.path);
        if (data.thumbnailExists) {
            [self performSelector:@selector(downloadFileFromDropBox:) withObject:data.path afterDelay:.1];

        }
        
    }
    [self.collectionView reloadData];
    
}

-(void)downloadFileFromDropBox:(NSString *)filePath
{
    int i = [AppDelegate sharedAppDelegate].downloadFileIndex;
    i = i+1;
    [AppDelegate sharedAppDelegate].downloadFileIndex = i;
    
    NSString *fileName = [NSString stringWithFormat:@"DBFiles/image%d", i];
    
    [self.restClient loadFile:filePath intoPath:[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName]];
}


- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    [self.collectionView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark - DBRestClientDelegate Methods for Download Data
- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath
{
    NSLog(@"%@", destPath);
    nDownloads++;
    if (nDownloads == cntMetaData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    [imageArray addObject:[UIImage imageNamed:destPath]];
    if(self.largeImageView.image == nil)self.largeImageView.image = imageArray[0];
    [self.collectionView reloadData];
}

-(void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error
{
    nDownloads++;
    if (nDownloads == cntMetaData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:[error localizedDescription]
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
    [alert show];
}

*/
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem     *)item
{
    //insert your back button handling logic here
    // let the pop happen
    NSLog(@"Ok");
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//#pragma mark <UICollectionViewDataSource>
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete method implementation -- Return the number of sections
//    return 0;
//}
//
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the section
//    return 0;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell
//    
//    return cell;
//}
//
#pragma mark - UICollectionView DataSource
-(NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"count = %lu", (unsigned long)marrDownloadData.count);
    return imageArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//
    
    static NSString *identifier = @"id_cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];

    UIImage *image = [finalArray objectAtIndex:indexPath.item];
    imageView.image = image;
    
    if (indexPath.item==0)
    {
        self.largeImageView.image = image;
        _largeImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(self.view.frame.size.width / 3 - 4, self.view.frame.size.width / 3 - 4);
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

#pragma mark - UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    self.largeImageView.image = [[AppDelegate sharedAppDelegate].imageArray objectAtIndex:indexPath.row];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath];
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"photo_frame.png"]];
    
    UIImage *image = [finalArray objectAtIndex:indexPath.item];
    self.largeImageView.image = image;
    _largeImageView.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath];
    cell.backgroundView = nil;
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 20) {
        
        //[self.navigationController popToRootViewControllerAnimated:YES];
//        NSInteger a = [self.navigationController.viewControllers count];
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:a-2] animated:YES];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UploadViewController *controller = [segue destinationViewController];
    controller.strPropertyName = self.strPropertyName;
    controller.finalArray  = [[NSArray alloc]initWithArray:finalArray];
    //    finalArray = nil;
    
}

-(void)getAllPictures
{
    finalArray = nil;
    finalArray = [[NSMutableArray alloc]init];
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    for (int i=0; i<10; i++) {
        [self loadImageFromIndex:i withAssetLibrary:(ALAssetsLibrary*)assetsLibrary];
    }
}
- (void)loadImageFromIndex:(int)index withAssetLibrary:(ALAssetsLibrary*)library {
    
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        // Within the group enumeration block, filter to enumerate your photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        long temp = [group numberOfAssets]-1-index;
        //if index exceeds bounds, kill the method
        if (temp < 0 || temp > [group numberOfAssets]-1) {
            return;
        }
        
        // Chooses the photo at the index
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:temp] options:0 usingBlock:^(ALAsset *alAsset, NSUInteger inde, BOOL *innerStop) {
            // The end of the enumeration is signaled by asset == nil.
            
            if (alAsset) {
                ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                UIImage *tempImage = [UIImage imageWithCGImage:[representation fullScreenImage]];
                
                // Do something with the image
                [finalArray addObject:tempImage];
                //                tempImage = nil;
                *stop = YES; *innerStop = YES;
                
            }
        }];
    }
     
                         failureBlock: ^(NSError *error) {
                             NSLog(@"None");
                         }];
}
@end
