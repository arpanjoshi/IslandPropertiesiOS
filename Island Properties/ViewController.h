//
//  ViewController.h
//  MyIslandProperty
//
//  Created by Adrian Rusin on 12/23/15.
//  Copyright (c) 2015 David Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

@interface ViewController : UIViewController{
    UIAlertView *alert;
//   int ipOrAddress;
//    BOOL loggedIn;
    DBUserClient *client;
}

- (IBAction)btnIPATapped:(id)sender;
- (IBAction)btnSettingsTapped:(id)sender;

- (IBAction)btnAddressTapped:(id)sender;
- (IBAction)btnSearchTapped:(id)sender;

@end

