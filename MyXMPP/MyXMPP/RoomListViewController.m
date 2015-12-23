//
//  RoomListViewController.m
//  MyXMPP
//
//  Created by halloworld on 15/12/16.
//  Copyright © 2015年 halloworld. All rights reserved.
//

#import "RoomListViewController.h"
#import "XMPPManager.h"
#import "RoomChatViewController.h"

@interface RoomListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *roomListView;

@end

@implementation RoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh_room_list) name:@"refresh_room_list" object:nil];
}


- (IBAction)btnCreateRoomTap:(id)sender {
    [[XMPPManager shareInterface] createRoom];
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"roomCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    XMPPRoom *room = [[XMPPManager shareInterface] roomsJoined][indexPath.row];
    cell.textLabel.text = [[room roomJID] full];
    cell.detailTextLabel.text = [room myNickname];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[XMPPManager shareInterface] roomsJoined] count];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XMPPRoom *room = [[XMPPManager shareInterface] roomsJoined][indexPath.row];
    RoomChatViewController *chat = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RoomChatViewController"];
    chat.room = room;
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)refresh_room_list {
    [self.roomListView reloadData];
}

@end
