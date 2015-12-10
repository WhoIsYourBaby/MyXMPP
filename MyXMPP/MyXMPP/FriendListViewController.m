//
//  FriendListViewController.m
//  MyXMPP
//
//  Created by halloworld on 15/12/7.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import "FriendListViewController.h"
#import <CoreData/CoreData.h>
#import "XMPPManager.h"

@interface FriendListViewController () <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSFetchedResultsController *fetchController;
@property (nonatomic, weak) IBOutlet UITableView *friendTable;

@end

@implementation FriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - NSFetchedResultsController & Delegate

- (NSFetchedResultsController *)fetchController {
    //初始化NSFetchedResultsController
    if (_fetchController == nil) {
        //1、获得数据库上下文
        XMPPRosterCoreDataStorage *rosterStorage = [[XMPPManager shareInterface] xmppRosterStorage];
        NSManagedObjectContext *objContext = [rosterStorage mainThreadManagedObjectContext];
        
        //2、设定命令集
        NSEntityDescription *entyDes = [NSEntityDescription entityForName:NSStringFromClass([XMPPUserCoreDataStorageObject class]) inManagedObjectContext:objContext];
        NSSortDescriptor *sortDes = [[NSSortDescriptor alloc] initWithKey:@"jidStr" ascending:YES];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entyDes];
        [request setSortDescriptors:@[sortDes]];
        
        //3、初始化NSFetchedResultsController并执行查询
        _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:objContext sectionNameKeyPath:@"sectionNum" cacheName:nil];
        [_fetchController setDelegate:self];
        NSError *err = nil;
        [_fetchController performFetch:&err];
        NSAssert(err == nil, [err description]);
    }
    return _fetchController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.friendTable reloadData];
}


#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    XMPPUserCoreDataStorageObject *friend = [self.fetchController objectAtIndexPath:indexPath];
    cell.textLabel.text = friend.jidStr;
    cell.textLabel.text = friend.nickname;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchController sections] objectAtIndex:section];
    return sectionInfo.numberOfObjects;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
