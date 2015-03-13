//
//  WebViewController.m
//  TicTacToe
//
//  Created by Rockstar. on 3/12/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *networkActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *string = @"http://en.wikipedia.org/wiki/Tic-tac-toe";
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",string]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    [_backButton setEnabled:NO];
    [_forwardButton setEnabled:NO];
    // Do any additional setup after loading the view, typically from a nib.

}

#pragma mark - UIWebView
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_networkActivityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_networkActivityIndicator stopAnimating];
    self.backButton.enabled  = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;

}


#pragma mark - Actions
- (IBAction)onBackButtonPressed:(UIButton *)sender {
    [_webView goBack];
}


- (IBAction)onForwardPressed:(id)sender {
    [_webView goForward];
}

- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [_webView stopLoading];
}

- (IBAction)onReloadButtonPressed:(id)sender {
    [_webView reload];
}

- (IBAction)onNewFeatureButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
