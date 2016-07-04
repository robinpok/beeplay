//
//  MJDocumentViewerViewController.m
//  Beeplay
//
//  Created by Saül Baró on 10/10/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJDocumentViewerViewController.h"

@interface MJDocumentViewerViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *documentViewer;
@property (strong, nonatomic) NSString *previousBackButtonTitle;

@end

static NSString * const kTermsOfUseAndPrivacyPolicyFileName = @"terms_of_use_and_privacy_policy";

@implementation MJDocumentViewerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadDocument];
}

- (void)setViewerType:(MJDocumentViewerType)viewerType
{
    if (_viewerType != viewerType) {
        _viewerType = viewerType;
        [self loadDocument];
    }
}

- (void)loadDocument
{
    NSString *documentName;
    switch (self.viewerType) {
        case MJDocumentViewerTypeTermsOfUse: {
            self.title = NSLocalizedString(@"Condiciones de uso", nil);
            documentName = kTermsOfUseAndPrivacyPolicyFileName;
        }
            break;
    }
    
    NSString *documentPath = [[NSBundle mainBundle] pathForResource:documentName ofType:@"html"];
    NSData *documentData = [NSData dataWithContentsOfFile:documentPath];
    [self.documentViewer loadData:documentData
                         MIMEType:@"text/html"
                 textEncodingName:@"UTF-8"
                          baseURL:[NSURL URLWithString:@""]];
}

#pragma mark - Web view delegate

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL shouldLoad = YES;
    NSURL *url = request.URL;
    if ([url.scheme isEqual:@"http"] || [url.scheme isEqual:@"https"]) {
        [[UIApplication sharedApplication] openURL:url];
        shouldLoad = NO;
    }
    return shouldLoad;
}

@end
