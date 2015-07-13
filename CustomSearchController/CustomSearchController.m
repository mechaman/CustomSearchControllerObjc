//
//  CustomSearchController.m
//  CustomSearchController
//
//  Created by Julien Hoachuck on 5/7/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import "CustomSearchController.h"
#import "CustomSearchBar.h"

@implementation CustomSearchController
{
    UISearchBar *_searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UISearchBar *)searchBar {
    
    if (_searchBar == nil) {
        _searchBar = [[CustomSearchBar alloc] initWithFrame:CGRectZero];
        _searchBar.delegate = self; // different from table search by apple where delegate was set to view controller where the UISearchController was instantiated or in our case where CustomSearchController was instantiated.
    }
    return _searchBar;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchBar.text length] > 0) {
        self.active = true;
    } else {
        self.active = false;
    }
}

/*
 Since CustomSearchController is the delegate of the search bar we must implement the UISearchBarDelegate method.
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"Became first responder");
    [searchBar resignFirstResponder];
}


@end
