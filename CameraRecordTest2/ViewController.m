//
//  ViewController.m
//  CameraRecordTest2
//
//  Created by TangQiao on 12-9-26.
//  Copyright (c) 2012年 TangQiao. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)libraryButtonPressed:(id)sender {
    debugMethod();
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) {
        return;
    }
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (IBAction)cameraButtonPressed:(id)sender {
    debugMethod();
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return;
    }
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    debugMethod();
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    // Handle a movie capture
    if (CFStringCompare ((CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        debugLog(@"movie path = %@", moviePath);
        //        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
        //            UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
        //        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    debugMethod();
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
