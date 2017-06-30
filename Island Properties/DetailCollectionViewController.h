//
//  DetailCollectionViewController.h
//  MyIslandProperty
//
//  Created by Adrian Rusin on 12/24/15.
//  Copyright (c) 2015 David Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailCollectionViewController : UIViewController{
    NSString *loadData;
    NSMutableArray *marrDownloadData;
    NSMutableArray *imageArray;
    NSInteger nDownloads;
    NSInteger cntMetaData;
    NSMutableArray *finalArray;
    DBUserClient *client;
    NSString *folderPath;
    long selectedIndex;
}
@property(nonatomic, strong) NSString *loadData;
@property(nonatomic, strong) NSString *strPropertyName;
//@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *largeImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end
