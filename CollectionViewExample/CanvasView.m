//
//  CanvasView.m
//  CollectionViewExample
//
//  Created by Eric Wing on 11/18/12.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "CanvasView.h"
#import "CloseButton.h"

@interface CanvasView ()
@property(retain, nonatomic) UIView* currentHitObject;
//@property(copy, nonatomic) NSArray* listOfItems;
@property(retain, nonatomic) UIPanGestureRecognizer* panRecognizer;
@property(retain, nonatomic) UILongPressGestureRecognizer* longPressRecognizer;
@property(assign, nonatomic) _Bool inDeleteMode;

@end

@implementation CanvasView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

		
    }
    return self;
}

/*
- (void) addSubview:(UIView *)view
{
	[super addSubview:view];
	
}
*/

- (void) awakeFromNib
{

	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragging:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelegate:self];
	[self addGestureRecognizer:panRecognizer];
	_panRecognizer = panRecognizer;
	
	
	UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressing:)];
//	[pressRecognizer setMinimumNumberOfTouches:1];
//	[pressRecognizer setMaximumNumberOfTouches:1];
	[pressRecognizer setDelegate:self];
	[self addGestureRecognizer:pressRecognizer];
	_longPressRecognizer = pressRecognizer;
	
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognize:(UIGestureRecognizer *)otherGestureRecognizer
{
    // If you have multiple gesture recognizers in this delegate, you can filter them by comparing the gestureRecognizer parameter to your saved objects
    return NO; // Also, very important.
}

#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kAnimationRotateDeg 1.0

-(void)longPressing:(UILongPressGestureRecognizer *)gesture
{
	if([self inDeleteMode])
	{
		return;
	}
	
	if(gesture.state == UIGestureRecognizerStateBegan)
    {
//		[[self panRecognizer] setEnabled:NO];
		NSArray* views = [self subviews];
		
		if([views count] == 0)
		{
			return;
		}
		else
		{
			[self setInDeleteMode:true];
		}
		for(UIView* item_view in views)
		{
			
//			UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,120,120)];
//			[closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
			
//			CloseButton *closeButton = [CloseButton buttonWithType:UIButtonTypeRoundedRect];
			CloseButton *closeButton = [[CloseButton alloc] initWithFrame:CGRectMake(0,0,88,88)];
//			closeButton.buttonType = UIButtonTypeRoundedRect;
			closeButton.frame = CGRectMake(20, 20, 88, 88);
			[closeButton setTitle:@"X" forState:UIControlStateNormal];
			[closeButton setCanvasView:self];
			[closeButton setItemView:item_view];
			[closeButton addTarget:closeButton action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
//			[myView addSubview:closeButton];
			
			[item_view addSubview:closeButton];
			
			
			NSInteger randomInt = arc4random()%500;
			float r = (randomInt/500.0)+0.5;
			
			CGAffineTransform leftWobble = CGAffineTransformMakeRotation(degreesToRadians( (kAnimationRotateDeg * -1.0) - r ));
			CGAffineTransform rightWobble = CGAffineTransformMakeRotation(degreesToRadians( kAnimationRotateDeg + r ));
			
			item_view.transform = leftWobble;  // starting point
			
			[[item_view layer] setAnchorPoint:CGPointMake(0.5, 0.5)];
			
			[UIView animateWithDuration:0.1
								  delay:0
								options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
							 animations:^{
								 [UIView setAnimationRepeatCount:NSNotFound];
								 item_view.transform = rightWobble; }
							 completion:nil];
		}
		
	}
	else if(UIGestureRecognizerStateEnded == gesture.state
			|| UIGestureRecognizerStateCancelled == gesture.state
			|| UIGestureRecognizerStateFailed == gesture.state
			)
	{
		NSLog(@"ended: %d", gesture.state);
//		[[self panRecognizer] setEnabled:YES];

	}
	
}

- (void) setInDeleteMode:(bool)inDeleteMode
{
	_inDeleteMode = inDeleteMode;
	if(inDeleteMode)
	{
		[[self panRecognizer] setEnabled:NO];
	}
	else
	{
		[[self panRecognizer] setEnabled:YES];

	}
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if([self inDeleteMode])
	{
		[self setInDeleteMode:false];
		
		NSArray* views = [self subviews];
		for(UIView* item_view in views)
		{
			[item_view.layer removeAllAnimations];

			item_view.transform = CGAffineTransformIdentity;
		}

	}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	/*
	if([self inDeleteMode])
	{
		[self setInDeleteMode:false];
	}
	 */
}

-(void)dragging:(UIPanGestureRecognizer *)gesture
{
	CGPoint touch_point = [gesture locationInView:self];

	NSLog(@"dragging %f, %f", touch_point.x, touch_point.y);
	if([self inDeleteMode])
	{
		return;
	}

	
	if(gesture.state == UIGestureRecognizerStateBegan)
    {
		UIView* hit_obj = [self hitTest:touch_point withEvent:nil];
		if(hit_obj && self != hit_obj)
		{
			NSLog(@"hit: %@", hit_obj);
			[self setCurrentHitObject:hit_obj];
		}
		else
		{
			NSLog(@"didn't hit");
		}

	}
	else if(UIGestureRecognizerStateEnded == gesture.state
			|| UIGestureRecognizerStateCancelled == gesture.state
			|| UIGestureRecognizerStateFailed == gesture.state
			)
	{
		NSLog(@"ended: %d", gesture.state);
		[self setCurrentHitObject:nil];
	}
	else
	{
		if(nil != [self currentHitObject])
		{
			CGFloat width = [[self currentHitObject] frame].size.width;
			CGFloat height = [[self currentHitObject] frame].size.height;
			// Setting the position in initWithFrame isn't working for me. It's probably because this is a cell class.
			// The position needs to be offset so it is in the center of the icon instead of the corner.
			CGRect target_frame = CGRectMake(touch_point.x - width/2, touch_point.y - height/2, width, height);
			
			[[self currentHitObject] setFrame:target_frame];
			
		}
		else
		{
			NSLog(@"no hit object");
		}
	}

		

}

@end
