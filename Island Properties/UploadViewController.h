//
//  UploadViewController.h
//  MyIslandProperty
//
//  Created by Adrian Rusin on 12/24/15.
//  Copyright (c) 2015 David Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

@interface UploadViewController : UIViewController<UIImagePickerControllerDelegate>{
    UIAlertView *alert;
    NSString *strMessage;
    int nPics, nSuccess, nFailed;
    
    NSMutableArray *marrUploadData;
    NSString *loadData;
    
    UIImage *imagePhoto;
    bool isImageUploading;
    
    DBUserClient *client;
    
}
@property(nonatomic, strong) NSString *strPropertyName;
@property(nonatomic, strong) NSArray *finalArray;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnUpload;
@property (weak, nonatomic) IBOutlet UIButton *btnTakePhoto;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *largeImageView;
- (IBAction)btnTakePhotoTapped:(id)sender;



@end
