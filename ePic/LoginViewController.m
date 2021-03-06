//
//  ViewController.m
//  ePic
//
//  Created by Adam Smith on 6/10/13.
//  Copyright (c) 2013 acs. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserManager.h"

@interface LoginViewController ()
@property (nonatomic, strong) User *currentUser;
@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // register for the session change notification
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(sessionStateChanged:)
        name:FBSessionStateChangedNotification
        object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // unregister for notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}



#pragma mark - button actions

- (IBAction)performLogin:(id)sender {
    
//    [self.spinner startAnimating];
    
    [APP_DELEGATE openSessionWithAllowLoginUI:YES];
}



#pragma mark - utility methods

- (void)sessionStateChanged:(NSNotification *)notification {
    
    //if success then dismiss the modal
    if (FBSession.activeSession.isOpen) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
