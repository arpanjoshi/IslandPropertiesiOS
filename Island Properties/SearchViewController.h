//
//  SearchViewController.h
//  MyIslandProperty
//
//  Created by Adrian Rusin on 12/24/15.
//  Copyright (c) 2015 David Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

@interface SearchViewController : UIViewController<UISearchBarDelegate>{
    NSString *loadData;
    NSMutableArray *marrDownloadData;
    NSMutableArray *folderArray;
    NSMutableArray *searchedResult;
    NSMutableArray *imageArray;
    NSMutableArray *countArray;
    
    DBUserClient *client;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property(strong, nonatomic) NSMutableArray *searchResults;


@end
