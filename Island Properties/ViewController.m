//
//  ViewController.m
//  MyIslandProperty
//
//  Created by Adrian Rusin on 12/23/15.
//  Copyright (c) 2015 David Roman. All rights reserved.
//

#import "ViewController.h"
#import "AddNewPropertyViewController.h"
#import "SearchViewController.h"
#import "SettingsViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnDropbox;
@property (weak, nonatomic) IBOutlet UIButton *btnLogout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    loggedIn = FALSE;
    // Do any additional setup after loading the view, typically from a nib.
    
//    alert = [[UIAlertView alloc] initWithTitle:@"LOG IN" message:@"Please enter your username and password:" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    
//    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
//    alert.tag = 12;
    
    //[alert addButtonWithTitle:@"Go"];
//    [alert show];
    CGSize buttonSize = self.btnDropbox.frame.size;
    NSString *buttonTitle = self.btnDropbox.titleLabel.text;
    CGSize titleSize = [buttonTitle sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12.f] }];
    UIImage *buttonImage = self.btnDropbox.imageView.image;
    CGSize buttonImageSize = buttonImage.size;
    
    CGFloat offsetBetweenImageAndText = 0; //vertical space between image and text
    
    [self.btnDropbox setImageEdgeInsets:UIEdgeInsetsMake((buttonSize.height - (titleSize.height + buttonImageSize.height)) / 2 - offsetBetweenImageAndText,
                                                (buttonSize.width - buttonImageSize.width) / 2,
                                                0,0)];
    [self.btnDropbox setTitleEdgeInsets:UIEdgeInsetsMake((buttonSize.height - (titleSize.height + buttonImageSize.height)) / 2 + buttonImageSize.height + offsetBetweenImageAndText,
                                                titleSize.width + [self.btnDropbox imageEdgeInsets].left > buttonSize.width ? -buttonImage.size.width  +  (buttonSize.width - titleSize.width) / 2 : (buttonSize.width - titleSize.width) / 2 - buttonImage.size.width,
                                                0,0)];
    
    buttonSize = self.btnLogout.frame.size;
    buttonTitle = self.btnLogout.titleLabel.text;
    titleSize = [buttonTitle sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12.f] }];
    buttonImage = self.btnLogout.imageView.image;
    buttonImageSize = buttonImage.size;
    
   
    [self.btnLogout setImageEdgeInsets:UIEdgeInsetsMake((buttonSize.height - (titleSize.height + buttonImageSize.height)) / 2 - offsetBetweenImageAndText,
                                                         (buttonSize.width - buttonImageSize.width) / 2,
                                                         0,0)];
    [self.btnLogout setTitleEdgeInsets:UIEdgeInsetsMake((buttonSize.height - (titleSize.height + buttonImageSize.height)) / 2 + buttonImageSize.height + offsetBetweenImageAndText,
                                                         titleSize.width + [self.btnLogout imageEdgeInsets].left > buttonSize.width ? -buttonImage.size.width  +  (buttonSize.width - titleSize.width) / 2 : (buttonSize.width - titleSize.width) / 2 - buttonImage.size.width,
                                                         0,0)];
    
    self.btnDropbox.hidden = YES;
    self.btnLogout.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxLoginDone) name:@"OPEN_DROPBOX_VIEW" object:nil];
    
    client = [DBClientsManager authorizedClient];
    if (client.accessToken)
    {
        NSLog(@"Access Token: %@", client.accessToken);
        self.btnDropbox.hidden = NO;
        self.btnLogout.hidden = NO;
    }
    else
    {
        // [self authorizeDB];
        self.btnDropbox.hidden = YES;
        self.btnLogout.hidden = YES;
    }
}

-(void)authorizeDB
{
    [DBClientsManager authorizeFromController:[UIApplication sharedApplication]
                                   controller:self
                                      openURL:^(NSURL *url) {
                                          [[UIApplication sharedApplication] openURL:url];
                                      }];
}

-(void)dropboxLoginDone
{
    self.btnDropbox.hidden = NO;
    self.btnLogout.hidden = NO;
    client = [DBClientsManager authorizedClient];
    UIAlertView *alertLoginDone = [[UIAlertView alloc] initWithTitle:nil message:@"User logged in successfully." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alertLoginDone show];
}

- (IBAction)onDropbox:(id)sender {
}
- (IBAction)onLogout:(id)sender {
    [DBClientsManager unlinkAndResetClients];
//    exit(0);
}


- (IBAction)btnIPATapped:(id)sender {
    if (client.accessToken)
    {
        AddNewPropertyViewController *s2 = [self.storyboard instantiateViewControllerWithIdentifier:@"id_add_new_property"];
        s2.ipaOrAddress = 1;
        [self.navigationController pushViewController:s2 animated:YES];
    }
    else{
        
        [self authorizeDB];
        NSLog(@"Not Linked!");
    }
    
}

- (IBAction)btnSettingsTapped:(id)sender {
    if (client.accessToken)
    {
        SettingsViewController *s2 = [self.storyboard instantiateViewControllerWithIdentifier:@"id_settings"];
        [self.navigationController pushViewController:s2 animated:YES];
    }
    else{
        
        [self authorizeDB];
        NSLog(@"Not Linked!");
    }

}

- (IBAction)btnAddressTapped:(id)sender
{
    if (client.accessToken)
    {
        AddNewPropertyViewController *s2 = [self.storyboard instantiateViewControllerWithIdentifier:@"id_add_new_property"];
        s2.ipaOrAddress = 0;
        [self.navigationController pushViewController:s2 animated:YES];
    }
    else{
        
        [self authorizeDB];
        NSLog(@"Not Linked!");
    }
}

- (IBAction)btnSearchTapped:(id)sender {
    
    if (client.accessToken)
    {
        SearchViewController *s2 = [self.storyboard instantiateViewControllerWithIdentifier:@"id_search"];
        [self.navigationController pushViewController:s2 animated:YES];
    }
    else{
        
        [self authorizeDB];
        NSLog(@"Not Linked!");
    }
}
@end
