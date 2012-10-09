//
//  ViewController.m
//  CameraRecordTest2
//
//  Created by TangQiao on 12-9-26.
//  Copyright (c) 2012年 TangQiao. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()

@end


/**
 *

 UIImagePickerControllerQualityTypeMedium
 一分钟的视频:
 最小6M, 最大19M
 60分钟的视频：
 最小360M, 最大1.14G

 UIImagePickerControllerQualityType640x480
 一分钟视频：
 26M,30M

 UIImagePickerControllerQualityTypeLow
 一分钟视频：
 1.3M

 */
@implementation ViewController {
    NSString * _moviePath;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _moviePath = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupPicker:(UIImagePickerController *)picker {
    picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
    picker.allowsEditing = YES;
    //picker.videoMaximumDuration = 60.0f;
    picker.delegate = self;
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
}

- (IBAction)libraryButtonPressed:(id)sender {
    debugMethod();
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO) {
        return;
    }

    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self setupPicker:picker];
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)cameraButtonPressed:(id)sender {
    debugMethod();
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return;
    }

    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self setupPicker:picker];
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)playButtonPressed:(id)sender {
    debugMethod();
    if (_moviePath != nil) {
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:_moviePath] == NO) {
            debugLog(@"file is not exist");
            return;
        }
        MPMoviePlayerViewController * player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:_moviePath]];
        [self presentViewController:player animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    debugMethod();
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    // Handle a movie capture
    if (CFStringCompare ((CFStringRef)mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        debugLog(@"movie path = %@", moviePath);
        _moviePath = moviePath;
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSDictionary * attr = [fileManager attributesOfItemAtPath:moviePath error:nil];
        // error checking
        unsigned long long size = [attr fileSize];
        NSString * message = [NSString stringWithFormat:@"file size = %lld KB", size/1000];
        debugLog(@"%@", message);
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
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
