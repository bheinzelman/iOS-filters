//
//  ViewController.h
//  ios-filters
//
//  Created by Bert Heinzelman on 8/8/15.
//  Copyright (c) 2015 heinzelmanb. All rights reserved.
//

#import <UIKit/UIKit.h>

enum Filters
{
    DEBUG_FILTER,
    GAUSSIAN_BLUR
};

@interface ViewController : UIViewController <UIPickerViewDelegate,
                                              UIPickerViewDataSource,
                                              UIImagePickerControllerDelegate,
                                              UINavigationControllerDelegate>

@property (weak) IBOutlet UIView* pictureView;

@property (weak) IBOutlet UIPickerView* filterPicker;

@property (weak) IBOutlet UIButton* filterButton;

@property (weak) IBOutlet UIActivityIndicatorView* spinner;

@property (nonatomic, strong) NSArray* filters;

@property (nonatomic, strong) UIImage* image;

@property (weak) UIView* currentPicture;

@property (weak) UIView* nextPicture;

@property int selectedFilter;

-(void)selectImage :(UIGestureRecognizer*)gesture;


@end



