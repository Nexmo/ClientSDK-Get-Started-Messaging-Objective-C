//
//  ConversationViewController.m
//  GettingStarted
//
//  Created by Paul Ardeleanu on 10/01/2020.
//  Copyright © 2020 Nexmo. All rights reserved.
//

#import "ConversationViewController.h"
#import <NexmoClient/NexmoClient.h>
#import "Utils.h"
#import "User.h"

@interface ConversationViewController () <NXMConversationDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputTextFieldBottomConstraint;

@property (weak, nonatomic) IBOutlet UITextView *conversationTextView;

@property NSError *error;
@property NXMConversation *conversation;
@property NSMutableArray *events;

@end

@implementation ConversationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:true];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    [self.inputTextField setDelegate:self];
    self.conversationTextView.text = @"";
    [self updateInterface];
    [self getConversation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = [NSString stringWithFormat: @"Conversation with %@", self.user.interlocutor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)cancel {
    [[NXMClient shared] logout];
    [self.navigationController popViewControllerAnimated:true];
}

- (void)keyboardWasShown:(NSNotification *)notification {
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    self.inputTextFieldBottomConstraint.constant = keyboardRect.size.height;
}


//MARK:- Interface

- (void)updateInterface {
    if(![NSThread isMainThread]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateInterface];
        });
        return;
    }
    
    // default interface - loading screen
    [self.activityIndicator startAnimating];
    self.statusLabel.alpha = 1.0;
    self.statusLabel.text = @"Loading...";
    self.conversationTextView.alpha = 0;
    self.inputTextField.alpha = 0;
    
    // if error found, show it
    if(self.error != nil) {
        [self.activityIndicator stopAnimating];
        self.statusLabel.text = self.error.localizedDescription;
        return;
    }
    
    // the conversation is being retrieved
    if(self.conversation == nil) {
        self.statusLabel.text = @"Loading conversation...";
        return;
    }
    
    // the conversation events are being retrieved
    if(self.events == nil) {
        self.statusLabel.text = @"Loading events...";
        return;
    }
    
    // ready to display events
    [self.activityIndicator stopAnimating];
    self.statusLabel.alpha = 0.0;
    self.conversationTextView.alpha = 1;
    self.inputTextField.alpha = 1;
    
    // no events found
    if(self.events.count == 0) {
        self.conversationTextView.text = @"No messages yet";
        return;
    }
    
    self.conversationTextView.text = @"";
    
    // events found - show them based on their type
    for(id event in self.events) {
        if ([event isKindOfClass: [NXMMemberEvent class]]) {
            [self showMemberEvent:event];
        }
        if ([event isKindOfClass: [NXMTextEvent class]]) {
            [self showTextEvent:event];
        }
    }
    
    
}

//MARK: Show events

- (void)showMemberEvent:(NXMMemberEvent *)event {
    switch (event.state) {
        case NXMMemberStateInvited:
            [self addConversationLine:[NSString stringWithFormat:@"%@ was invited.", event.member.user.name]];
            break;
        case NXMMemberStateJoined:
            [self addConversationLine:[NSString stringWithFormat:@"%@ joined.", event.member.user.name]];
            break;
        case NXMMemberStateLeft:
            [self addConversationLine:[NSString stringWithFormat:@"%@ left.", event.member.user.name]];
            break;
    }
}

- (void)showTextEvent:(NXMTextEvent *)event {
    if (event.text.length > 0) {
        [self addConversationLine:[NSString stringWithFormat:@"%@ said: %@", event.fromMember.user.name, event.text]];
    }
}

- (void)addConversationLine:(NSString *)line {
    if (self.conversationTextView.text.length > 0) {
        self.conversationTextView.text = [NSString stringWithFormat:@"%@\n%@", self.conversationTextView.text, line];
    } else {
        self.conversationTextView.text = line;
    }
}



//MARK: Fetch Conversation

- (void)getConversation {
    [NXMClient.shared getConversationWithUuid:kConversationUUID completionHandler:^(NSError * _Nullable error, NXMConversation * _Nullable conversation) {
        self.error = error;
        self.conversation = conversation;
        [self updateInterface];
        [conversation setDelegate:self];  // NEW LINE
        [self getEvents];
    }];
}

- (void)getEvents {
    [self.conversation getEvents:^(NSError * _Nullable error, NSArray<NXMEvent *> * _Nullable events) {
        self.error = error;
        self.events = [events mutableCopy];
        [self updateInterface];
    }];
}


//MARK: Send a message

- (void)sendMessage:(NSString *)message {
    [self.inputTextField resignFirstResponder];
    self.inputTextField.enabled = NO;
    [self.activityIndicator startAnimating];
    [self.conversation sendText:message completionHandler:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.inputTextField.enabled = YES;
            [self.activityIndicator stopAnimating];
            [self getEvents];
        });
    }];
}


//MARK: UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.inputTextFieldBottomConstraint.constant = 10;;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        [self sendMessage:textField.text];
    }
    textField.text = @"";
    [textField resignFirstResponder];
    return TRUE;
}


//MARK: Conversation Delegate

- (void)conversation:(NXMConversation *)conversation didReceive:(NSError *)error {
    NSLog(@"Conversation error: %@", error.localizedDescription);
}
- (void)conversation:(NXMConversation *)conversation didReceiveTextEvent:(NXMTextEvent *)event {
    [self.events addObject:event];
    [self updateInterface];
}

@end
