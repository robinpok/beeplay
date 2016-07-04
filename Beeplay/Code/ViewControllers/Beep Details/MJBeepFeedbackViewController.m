//
//  MJBeepFeedbackViewController.m
//  Beeplay
//
//  Created by Saül Baró on 10/16/13.
//  Copyright (c) 2013 Mobile Jazz. All rights reserved.
//

#import "MJBeepFeedbackViewController.h"

#import "MJBeepsViewController.h"

#import "MJBeep.h"

#import "MJBeepSubscription.h"
#import "MJImageCell.h"
#import "MJController.h"

#import "UIImage+Resize.h"
#import "UIView+FirstResponder.h"
#import "UIViewController+KeyboardManager.h"
#import "UIViewController+AlertMessages.h"
#import "UIViewController+PerformTaskWithProgress.h"
#import "UIColor+BeeplayColors.h"

@import MobileCoreServices;

@interface MJBeepFeedbackViewController () <UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UIActionSheetDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *location;
}
@property (weak, nonatomic) IBOutlet UITextView *feedbackView;

@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UICollectionView *imageCollection;

@property (strong, nonatomic) NSMutableArray *selectedImages;
@property (strong, nonatomic) NSMutableArray *imagesToDisplay;

@end

static NSUInteger const kMaximumNumberOfImages = 5;
static NSUInteger const kMaximumSize = 800;

@implementation MJBeepFeedbackViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    // Same corner radius as in UITextField
//    self.feedbackView.layer.cornerRadius = 5.0f;
//    CGFloat colorComponent = 204.0f/255.0f;
//    self.feedbackView.layer.borderColor = [[UIColor colorWithRed:colorComponent
//                                                           green:colorComponent
//                                                            blue:colorComponent
//                                                           alpha:1.0f] CGColor];
//    self.feedbackView.layer.borderWidth = 0.5f;
    
//    [self setupTextView];
    
    if (locationManager == nil)
        locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = 10;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    
    self.addImageButton.backgroundColor = [UIColor bp_signUpButtonColor];
    self.addImageButton.layer.cornerRadius = 5.0f;

    self.sendButton.backgroundColor = [UIColor bp_greenButtonColor];
    self.sendButton.layer.cornerRadius = 5.0f;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    location = [locations lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [locationManager startUpdatingLocation];
            break;
            
        default:
            [locationManager stopUpdatingLocation];
            location = nil;
            break;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupPhotoOptions];
}

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    self.feedbackView.contentOffset = CGPointMake(0, 0);
//    self.feedbackView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    self.feedbackView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//}

- (void)setupPhotoOptions
{
    if (self.beep.photoRequired) {
        self.addImageButton.enabled = YES;
        self.addImageButton.hidden = NO;
        self.imageCollection.hidden = NO;
    }
    else {
        self.addImageButton.enabled = NO;
        self.addImageButton.hidden = YES;
        self.imageCollection.hidden = YES;
    }
}

- (NSMutableArray *)selectedImages
{
    if (!_selectedImages) {
        _selectedImages = [[NSMutableArray alloc] init];
    }
    return _selectedImages;
}

- (NSMutableArray *)imagesToDisplay
{
    if (!_imagesToDisplay) {
        _imagesToDisplay = [[NSMutableArray alloc] init];
    }
    return _imagesToDisplay;
}

- (void)setupAddImagesButton
{
    self.addImageButton.enabled = [self.selectedImages count] < kMaximumNumberOfImages ? YES : NO;
}

#pragma mark - Actions

- (IBAction)sendFeedback
{
    [[self.view findFirstResponder] resignFirstResponder];
    NSLog(@"%f, %f", self.beep.latitude, self.beep.longitude);
    if (self.beep.geolocationRequired &&
        (location == nil || [location distanceFromLocation:
                             [[CLLocation alloc] initWithLatitude:self.beep.latitude longitude:self.beep.longitude]] > 200)) {
            [self alertWithTitle:@"¡Demasiado lejos!" message:NSLocalizedString(@"Desde aquí no puedes completar este Beep.", nil)];
    }
    else if (self.feedbackView.text == nil
        || [self.feedbackView.text isEqualToString:@""]
        || self.feedbackView.textColor == [UIColor lightGrayColor]) {
        [self displayErrorMessage:NSLocalizedString(@"Debes introducir la información del Beep.", nil)];
    }
    else if (self.beep.photoRequired
             && (!self.selectedImages || [self.selectedImages count] == 0)) {
        [self displayErrorMessage:NSLocalizedString(@"Debes añadir como mínimo una foto.", nil)];
    }
    else {
        [self performTaskWithProgress:^(NSError *__autoreleasing *error) {
            if (error) {
                
                *error = [[MJController sharedInstance] sendFeedback:self.feedbackView.text
                                                          withImages:self.selectedImages
                                                             forBeep:self.beep];
                if (!*error) {
                    self.beepSubscription.status = MJBeepSubscriptionStatusFeedbackSent;
                    *error = [[MJController sharedInstance] updateSubscription:self.beepSubscription];
                }
            }
        } completionHandler:^(NSError *error) {
            if (error) {
                [self displayErrorMessage:@"No se ha podido enviar el informe correctamente."];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self alertWithTitle:NSLocalizedString(@"Informe enviado", nil)
                                 message:NSLocalizedString(@"Beeplay revisará tu solicitud y en breve recibirás el saldo en tu cuenta.", nil)];
                    [[NSNotificationCenter defaultCenter] postNotificationName:BeepsViewControllerReloadDataNotification
                                                                        object:self];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
    }
}

- (IBAction)addImage
{
    [self.view resignFirstResponder];

    UIActionSheet *openInMenu = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:nil];
    
    NSArray *otherButtonTitles;
    if (self.beep.cameraRollAllowed) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
            && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            otherButtonTitles = @[NSLocalizedString(@"Hacer foto", nil),
                                  NSLocalizedString(@"Seleccionar foto existente", nil),
                                  NSLocalizedString(@"Cancelar", nil)];
        }
        else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            otherButtonTitles = @[NSLocalizedString(@"Hacer foto", nil),
                                  NSLocalizedString(@"Cancelar", nil)];
        }
        else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            otherButtonTitles = @[NSLocalizedString(@"Seleccionar foto existente", nil),
                                  NSLocalizedString(@"Cancelar", nil)];
        }
    }
    else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            otherButtonTitles = @[NSLocalizedString(@"Hacer foto", nil),
                                  NSLocalizedString(@"Cancelar", nil)];
        }
    }
    
    for (NSString *buttonTitle in otherButtonTitles) {
        [openInMenu addButtonWithTitle:buttonTitle];
    }
    
    if (otherButtonTitles && [otherButtonTitles count] > 0) {
        openInMenu.cancelButtonIndex = [otherButtonTitles count] - 1;
        [openInMenu showInView:self.view];
    }
}

#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet
willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *selectedButtonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([selectedButtonTitle isEqualToString:NSLocalizedString(@"Hacer foto", nil)]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker
                           animated:YES
                         completion:NULL];
    }
    else if ([selectedButtonTitle isEqualToString:NSLocalizedString(@"Seleccionar foto existente", nil)]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker
                           animated:YES
                         completion:NULL];
    }
}

- (IBAction)removeImage:(UIButton *)sender
{
    CGRect frame = [sender convertRect:sender.bounds toView:self.imageCollection];
    NSIndexPath *imageIndexPath = [self.imageCollection indexPathForItemAtPoint:frame.origin];
    [self.imagesToDisplay removeObjectAtIndex:imageIndexPath.item];
    [self.selectedImages removeObjectAtIndex:imageIndexPath.item];
    [self.imageCollection deleteItemsAtIndexPaths:@[imageIndexPath]];
    [self setupAddImagesButton];
}

#pragma mark - Image picker delegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    // Handle a still image picked from a photo album
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)  == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        }
        else {
            imageToUse = originalImage;
        }
        
        if (imageToUse.size.width > kMaximumSize
            || imageToUse.size.height > kMaximumSize) {
            imageToUse = [imageToUse resizeImageToSize:CGSizeMake(800, 800)];
        }
        
        [self.selectedImages addObject:imageToUse];
        
        imageToUse = [imageToUse cropImageToSquareSize:CGSizeMake(272, 272)];
        [self.imagesToDisplay addObject:imageToUse];
    }
    
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   [self.imageCollection reloadData];
                                   [self scrollToLastItem];
                                   [self setupAddImagesButton];
                               }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES
                               completion:NULL];
}

- (void)scrollToLastItem
{
    [self.imageCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[self.imagesToDisplay count] - 1 inSection:0]
                                 atScrollPosition:UICollectionViewScrollPositionRight
                                         animated:YES];
}

#pragma mark - Text view delegate

//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    if (self.feedbackView.textColor == [UIColor lightGrayColor]) {
//        self.feedbackView.text = @"";
//        self.feedbackView.textColor = [UIColor blackColor];
//    }
//    
//    return YES;
//}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if(self.feedbackView.text.length == 0) {
//        [self setupTextView];
        [self.feedbackView resignFirstResponder];
    }
}
//
//- (void)setupTextView
//{
//    self.feedbackView.textColor = [UIColor lightGrayColor];
//    self.feedbackView.text = NSLocalizedString(@"Introduce aquí la información del Beep", nil);
//}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.imagesToDisplay count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const CellIdentifier = @"ImageCell";
    MJImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier
                                                                  forIndexPath:indexPath];
    cell.imageView.image = self.imagesToDisplay[indexPath.item];
    
    return cell;
}


@end
