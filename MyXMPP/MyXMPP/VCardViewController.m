//
//  VCardViewController.m
//  MyXMPP
//
//  Created by halloworld on 16/1/10.
//  Copyright © 2016年 halloworld. All rights reserved.
//

#import "VCardViewController.h"
#import "XMPPManager.h"

@interface VCardViewController () <UIImagePickerControllerDelegate, XMPPvCardTempModuleDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nicknameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;

@end

@implementation VCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(btnDoneTap)];
    XMPPvCardTempModule *mod = [[XMPPManager shareInterface] vCardModule];
    [mod addDelegate:self delegateQueue:dispatch_get_main_queue()];
    XMPPvCardTemp *myVcard = [mod myvCardTemp];
    UIImage *img = [UIImage imageWithData:myVcard.photo];
    [self.headerButton setImage:img forState:UIControlStateNormal];
    self.nicknameText.text = myVcard.nickname;
    NSArray *emails = [myVcard emailAddresses];
    NSXMLElement *emEle = emails[0];
    self.emailText.text = [emEle stringValue];
}


- (IBAction)btnHeaderImageTap:(id)sender {
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = info[UIImagePickerControllerEditedImage];
    [self.headerButton setImage:img forState:UIControlStateNormal];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnDoneTap {
    /*
     <vCard xmlns='vcard-temp'>
     <FN>Peter Saint-Andre</FN>
     <N>
     <FAMILY>Saint-Andre</FAMILY>
     <GIVEN>Peter</GIVEN>
     <MIDDLE/>
     </N>
     <NICKNAME>stpeter</NICKNAME>
     <URL>http://www.xmpp.org/xsf/people/stpeter.shtml</URL>
     <BDAY>1966-08-06</BDAY>
     <ORG>
     <ORGNAME>XMPP Standards Foundation</ORGNAME>
     <ORGUNIT/>
     </ORG>
     <TITLE>Executive Director</TITLE>
     <ROLE>Patron Saint</ROLE>
     <TEL><WORK/><VOICE/><NUMBER>303-308-3282</NUMBER></TEL>
     <TEL><WORK/><FAX/><NUMBER/></TEL>
     <TEL><WORK/><MSG/><NUMBER/></TEL>
     <ADR>
     <WORK/>
     <EXTADD>Suite 600</EXTADD>
     <STREET>1899 Wynkoop Street</STREET>
     <LOCALITY>Denver</LOCALITY>
     <REGION>CO</REGION>
     <PCODE>80202</PCODE>
     <CTRY>USA</CTRY>
     </ADR>
     <TEL><HOME/><VOICE/><NUMBER>303-555-1212</NUMBER></TEL>
     <TEL><HOME/><FAX/><NUMBER/></TEL>
     <TEL><HOME/><MSG/><NUMBER/></TEL>
     <ADR>
     <HOME/>
     <EXTADD/>
     <STREET/>
     <LOCALITY>Denver</LOCALITY>
     <REGION>CO</REGION>
     <PCODE>80209</PCODE>
     <CTRY>USA</CTRY>
     </ADR>
     <EMAIL><INTERNET>abc@qq.com</INTERNET></EMAIL>
     <JABBERID>stpeter@jabber.org</JABBERID>
     <DESC>
     Check out my blog at https://stpeter.im/
     </DESC>
     </vCard>
     */
    XMPPvCardTemp *vCard = [XMPPvCardTemp vCardTemp];
    vCard.nickname = self.nicknameText.text;
    UIImage *header = [self.headerButton imageForState:UIControlStateNormal];
    vCard.photo = UIImageJPEGRepresentation(header, 1.f);
    NSXMLElement *xmlElement = [NSXMLElement elementWithName:@"EMAIL"];
    NSXMLElement *netEmail = [NSXMLElement elementWithName:@"INTERNET" stringValue:self.emailText.text];
    [xmlElement addChild:netEmail];
    XMPPvCardTempEmail *email = [XMPPvCardTempEmail vCardEmailFromElement:xmlElement];
    [vCard addEmailAddress:email];
    [[[XMPPManager shareInterface] vCardModule] updateMyvCardTemp:vCard];
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule
        didReceivevCardTemp:(XMPPvCardTemp *)vCardTemp
                     forJID:(XMPPJID *)jid {
    NSLog(@"%s", __FUNCTION__);
}

- (void)xmppvCardTempModuleDidUpdateMyvCard:(XMPPvCardTempModule *)vCardTempModule {
    NSLog(@"%s", __FUNCTION__);
}

- (void)xmppvCardTempModule:(XMPPvCardTempModule *)vCardTempModule failedToUpdateMyvCard:(NSXMLElement *)error {
    NSLog(@"%s", __FUNCTION__);
}

@end
