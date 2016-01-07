//
//  RoomMembersViewController.m
//  MyXMPP
//
//  Created by halloworld on 15/12/30.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import "RoomMembersViewController.h"

@interface RoomMembersViewController () <UITableViewDataSource, UITableViewDelegate, XMPPRoomDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *peopleJoined;

@end

@implementation RoomMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.room addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.room fetchMembersList];
    [self.room fetchModeratorsList];
    [self.room fetchBanList];
}


- (NSMutableArray *)peopleJoined {
    if (_peopleJoined == nil) {
        _peopleJoined = [[NSMutableArray alloc] init];
    }
    return _peopleJoined;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    NSXMLElement *ele = [self.peopleJoined objectAtIndex:indexPath.row];
    cell.textLabel.text = [[ele attributeForName:@"affiliation"] stringValue];
    cell.detailTextLabel.text = [[ele attributeForName:@"jid"] stringValue];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.peopleJoined count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items {
    [self.peopleJoined addObjectsFromArray:items];
    [self.tableView reloadData];
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError {
    NSLog(@"%s", __FUNCTION__);
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items {
    [self.peopleJoined addObjectsFromArray:items];
    [self.tableView reloadData];
}


- (void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError {
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items {
    NSLog(@"%s", __FUNCTION__);
    [self.peopleJoined addObjectsFromArray:items];
    [self.tableView reloadData];
}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError {
}

@end
