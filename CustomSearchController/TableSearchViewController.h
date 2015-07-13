//
//  TableSearchViewController.h
//  CustomSearchController
//
//  Created by Julien Hoachuck on 5/5/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableSearchViewController : UIViewController <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate>

// Elements in Interface Builder
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *searchView; // Connected to view above table view in IB

// SearchController
@property (nonatomic, strong) UISearchController *searchController;

// For state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

@property (strong, nonatomic) NSArray *filteredItems;
@property (strong, nonatomic) NSArray *items;

@end
