//
//  CloseButton.h
//  CollectionViewExample
//
//  Created by Eric Wing on 11/18/12.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CanvasView;
@interface CloseButton : UIButton
@property(assign, nonatomic) CanvasView* canvasView;
@property(assign, nonatomic) UIView* itemView;

@end
