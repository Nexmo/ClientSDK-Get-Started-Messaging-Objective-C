//
//  UserSelectionViewController.m
//  GettingStarted
//
//  Created by Paul Ardeleanu on 09/01/2020.
//  Copyright © 2020 Nexmo. All rights reserved.
//

#import "UserSelectionViewController.h"
#import <NexmoClient/NexmoClient.h>
#import "Utils.h"
#import "ConversationViewController.h"


@interface UserSelectionViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginAliceButton;
@property (weak, nonatomic) IBOutlet UIButton *loginBobButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property NXMClient *client;

@end



@implementation UserSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateInterface];
    self.client = [NXMClient shared];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateInterface];
}


//MARK: Setup Nexmo Client

- (IBAction)loginAsAlice:(id)sender {
    [self loginAs:[User Alice]];
}

- (IBAction)loginAsBob:(id)sender {
    [self loginAs:[User Bob]];
}

-(void)loginAs:(User *)user {
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:ConversationViewController.class] && [sender isKindOfClass:User.class]) {
        ((ConversationViewController *) segue.destinationViewController).user = (User *)sender;
    }
}


//MARK:- NXMClientDelegate





//MARK: - Interface

- (void)updateInterface {
    if(![NSThread isMainThread]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateInterface];
        });
        return;
    }
    self.loginAliceButton.alpha = 1;
    self.loginBobButton.alpha = 1;
    [self.activityIndicator stopAnimating];
    self.statusLabel.alpha = 0;
    if (self.user == nil) {
        return;
    }
    switch (self.client.connectionStatus) {
        case NXMConnectionStatusDisconnected:
            self.statusLabel.text = @"Disconnected";
            self.statusLabel.alpha = 1;
            break;
        case NXMConnectionStatusConnecting:
            self.loginAliceButton.alpha = 0;
            self.loginBobButton.alpha = 0;
            [self.activityIndicator startAnimating];
            self.statusLabel.text = [NSString stringWithFormat:@"Connecting as %@", self.user.name];
            self.statusLabel.alpha = 1;
            break;
        case NXMConnectionStatusConnected:
            self.loginAliceButton.alpha = 0;
            self.loginBobButton.alpha = 0;
            self.statusLabel.text = [NSString stringWithFormat:@"Connected as %@", self.user.name];
            self.statusLabel.alpha = 1;
            break;
    }
    
}


@end
