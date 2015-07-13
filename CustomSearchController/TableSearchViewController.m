
//
//  TableSearchViewController.m
//  CustomSearchController
//
//  Created by Julien Hoachuck on 5/5/15.
//  Copyright (c) 2015 Pandodroid. All rights reserved.
//

#import "TableSearchViewController.h"
#import "CustomSearchController.h"
#import "item.h"

@interface TableSearchViewController ()

@end

@implementation TableSearchViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UINavigationItem *navItem = self.navigationItem;
    navItem.title = @"Custom Search Controller";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Instantiate Search Controller and set this UIViewController as delegate
    _searchController = [[CustomSearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate  = self;


    [self.searchController.searchBar sizeToFit];
    // Get rid of sorrounding searchbar background color
    self.searchController.searchBar.barTintColor = [UIColor clearColor];
    self.searchController.searchBar.backgroundImage = [UIImage new];
    self.searchController.searchBar.placeholder = @"Search the items by name.";
    
    // Add the searchBar to searchView in the IB (TableSearchViewController.xib)
    [self.searchView addSubview:self.searchController.searchBar];

    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;

    _filteredItems = _items;
    // Custom cell initialization

    [self.tableView registerNib:nil forCellReuseIdentifier:@"SimpleTableItem"];

   
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (self.searchControllerWasActive) {
        self.searchController.active = self.searchControllerWasActive;
        _searchControllerWasActive = NO;
        
        if (self.searchControllerSearchFieldWasFirstResponder) {
            [self.searchController.searchBar becomeFirstResponder];
            _searchControllerSearchFieldWasFirstResponder = NO;
        }
    }
}

// --------------------- TableView Delegate Methods ------------------//

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_filteredItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    item *tempItem = self.filteredItems[indexPath.row];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
     
     cell.textLabel.text=tempItem.name;
   
    return cell;
}

// --------------------- UISearchController Delegate Methods ------------------//

- (void)willPresentSearchController:(UISearchController *)searchController
{
    self.searchController.hidesNavigationBarDuringPresentation = false; // stop from animating
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didDismissSearchController:(UISearchController *)searchController{
    //_filteredItems = _items;
    [self.tableView reloadData];
}

// --------------------- UISearchResultsUpdating Delegate Methods ------------------//

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = [self.items mutableCopy];
    //NSMutableArray *searchResults = [NSMutableArray array];

    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
 
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
   
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"name"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        
        [searchItemsPredicate addObject:finalPredicate];

        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    

    NSCompoundPredicate *finalCompoundPredicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    

    
    // Set the searchResults to filteredItems array
    self.filteredItems = searchResults;
    

    // update with filterResults array... and then when dismissing searched deals to filterResults
    
    //figure out how to relaod data in dealtableview
    [self.tableView reloadData];
}


// --------------------- UIState Restoration ------------------//

// we restore several items for state restoration:
//  1) Search controller's active state,
//  2) search text,
//  3) first responder

NSString *const ViewControllerTitleKey = @"ViewControllerTitleKey";
NSString *const SearchControllerIsActiveKey = @"SearchControllerIsActiveKey";
NSString *const SearchBarTextKey = @"SearchBarTextKey";
NSString *const SearchBarIsFirstResponderKey = @"SearchBarIsFirstResponderKey";

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
    [super encodeRestorableStateWithCoder:coder];
    
    // encode the view state so it can be restored later
    
    // encode the title
    [coder encodeObject:self.title forKey:ViewControllerTitleKey];
    
    UISearchController *searchController = self.searchController;
    
    // encode the search controller's active state
    BOOL searchDisplayControllerIsActive = searchController.isActive;
    [coder encodeBool:searchDisplayControllerIsActive forKey:SearchControllerIsActiveKey];
    
    // encode the first responser status
    if (searchDisplayControllerIsActive) {
        [coder encodeBool:[searchController.searchBar isFirstResponder] forKey:SearchBarIsFirstResponderKey];
    }
    
    // encode the search bar text
    [coder encodeObject:searchController.searchBar.text forKey:SearchBarTextKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    
    // restore the title
    self.title = [coder decodeObjectForKey:ViewControllerTitleKey];
    
    // restore the active state:
    // we can't make the searchController active here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerWasActive = [coder decodeBoolForKey:SearchControllerIsActiveKey];
    
    // restore the first responder status:
    // we can't make the searchController first responder here since it's not part of the view
    // hierarchy yet, instead we do it in viewWillAppear
    //
    _searchControllerSearchFieldWasFirstResponder = [coder decodeBoolForKey:SearchBarIsFirstResponderKey];
    
    // restore the text in the search field
    self.searchController.searchBar.text = [coder decodeObjectForKey:SearchBarTextKey];
}


@end
