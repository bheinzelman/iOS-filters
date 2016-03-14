//
//  ViewController.m
//  ios-filters
//
//  Created by Bert Heinzelman on 8/8/15.
//  Copyright (c) 2015 heinzelmanb. All rights reserved.
//

#import "ViewController.h"
#import "AFilter.h"
#import "Negative.h"
#import "FilterFactory.h"

@interface ViewController ()

-(void)didFilter;

@property BOOL didFinish;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _filters =[[NSArray alloc] initWithObjects:@"Normal", @"Negative", @"Sharpen", @"Edge", nil];
    
    _filterPicker.delegate = self;
    
    _filterPicker.dataSource = self;
    
    UIGestureRecognizer* imageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImage:)];
    
    [_pictureView addGestureRecognizer:imageGesture];
    
    [self.filterButton addTarget:self action:@selector(didPressFilter) forControlEvents:UIControlEventTouchUpInside];
    
    self.currentPicture = nil;
    
    self.selectedFilter = 0;
    
    self.didFinish = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didPressFilter
{
    if (_image == nil)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"No image selected" message:@"Please select an image" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:NO completion:nil];
        
        self.didFinish = YES;
    }
    else
    {
        self.spinner.alpha = 1;
        
        [self.spinner startAnimating];
        
        // we want to run on back end thread, but we need to update UI from the main thread
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
            
            AFilter* filter = [FilterFactory getFilter:self.selectedFilter];
            
            UIImage* im = [filter filter:self.image];
            
            dispatch_async(dispatch_get_main_queue(), ^{
        
                if (self.currentPicture != nil)
                {
                    [self.currentPicture removeFromSuperview];
                }
            
                UIImageView* image = [[UIImageView alloc] initWithImage:im];
            
                image.frame = CGRectMake(0, 0, _pictureView.frame.size.width, _pictureView.frame.size.height);
            
           
                //update UI in main thread.
                 [_pictureView addSubview:image];
                
                self.currentPicture = image;
                
                [self didFilter];
            });
        
       });
    }
}

-(void)didFilter {
    [self.spinner stopAnimating];
    
    self.spinner.alpha = 0;
    
    self.didFinish = YES;
    UIImageWriteToSavedPhotosAlbum(((UIImageView*)self.currentPicture).image, nil, nil, nil);
}


#pragma mark UI_PICKER DELEGATE
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString* ret = self.filters[row];
    
    return ret;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.filters count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.didFinish) {
        self.selectedFilter = (int)row;
        
        self.didFinish = NO;
        
        [self didPressFilter];
    }
}

#pragma mark UI_IMAGE_PICKER DELEGATE

-(void)selectImage:(UIGestureRecognizer*)gesture {
    self.spinner.alpha = 1;
    
    [self.spinner startAnimating];
    
    UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
    
    imagePicker.allowsEditing = YES;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePicker animated:YES completion:^()
     {
        [self.spinner stopAnimating];
         
         self.spinner.alpha = 0;
     }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (self.currentPicture != nil)
    {
        [self.currentPicture removeFromSuperview];
    }
    
    self.image = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    UIImageView* newImage = [[UIImageView alloc] initWithImage:_image];
    
    newImage.frame = CGRectMake(0, 0, self.pictureView.frame.size.width, self.pictureView.frame.size.height);
    
    [self.pictureView addSubview:newImage];
    
    self.currentPicture = newImage;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
