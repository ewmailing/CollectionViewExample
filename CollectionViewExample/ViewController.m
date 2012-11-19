//
//  ViewController.m
//  CollectionViewExample
//
//  Created by Tim on 9/5/12.
//  Copyright (c) 2012 Charismatic Megafauna Ltd. All rights reserved.
//

#import "ViewController.h"
#import "CVCell.h"
#import <QuartzCore/QuartzCore.h>
#import "OBDragDropManager.h"
#import "UIView+OBDropZone.h"
#import "CanvasView.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) IBOutlet CanvasView* canvasView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create data for collection views
    NSMutableArray *firstSection = [[NSMutableArray alloc] init];
    NSMutableArray *secondSection = [[NSMutableArray alloc] init];
    
    for (int i=0; i<150; i++) {
        [firstSection addObject:[NSString stringWithFormat:@"Cell %d", i]];
//        [secondSection addObject:[NSString stringWithFormat:@"item %d", i]];
    }

    self.dataArray = [[NSArray alloc] initWithObjects:firstSection, secondSection, nil];
    
    /* Uncomment this block to use nib-based cells */
    //UINib *cellNib = [UINib nibWithNibName:@"NibCell" bundle:nil];
    //[self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
    /* end of nib-based cells block */
    
    /* uncomment this block to use subclassed cells */
    [self.collectionView registerClass:[CVCell class] forCellWithReuseIdentifier:@"cvCell"];
    /* end of subclass-based cells block */
    
    // Configure layout
	/*
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(111, 111)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.collectionView setCollectionViewLayout:flowLayout];
    */
	
	[self.collectionView setAllowsSelection:YES];
	

	OBDragDropManager *dragDropManager = [OBDragDropManager sharedManager];
    UILongPressGestureRecognizer *dragDropRecognizer = [dragDropManager createLongPressDragDropGestureRecognizerWithSource:self];
    [[self collectionView] addGestureRecognizer:dragDropRecognizer];
	
	[[self canvasView] setDropZoneHandler:self];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.collectionView = nil;
    self.dataArray = nil;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.dataArray count];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    NSMutableArray *sectionArray = [self.dataArray objectAtIndex:section];
    return [sectionArray count];

}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Setup cell identifier
    static NSString *cellIdentifier = @"cvCell";

    /*  Uncomment this block to use nib-based cells */
    // UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    // UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    // [titleLabel setText:cellData];
    /* end of nib-based cell block */
    
    /* Uncomment this block to use subclass-based cells */
    CVCell *cell = (CVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
    NSString *cellData = [data objectAtIndex:indexPath.row];
    [cell.titleLabel setText:cellData];
    /* end of subclass-based cells block */
 
    // Return the cell
    return cell;
    
}

#if 0
-(void)move:(id)sender
{
	NSLog(@"move");
}
	
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

	
	
	return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *theCollectionViewCell = [self.collectionView cellForItemAtIndexPath:indexPath];

	
//	theCollectionViewCell.backgroundColor = [UIColor blueColor];
	theCollectionViewCell.layer.borderColor = [[UIColor yellowColor] CGColor];
	theCollectionViewCell.layer.borderWidth = 4;
	/*
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
	[panRecognizer setMinimumNumberOfTouches:1];
	[panRecognizer setMaximumNumberOfTouches:1];
	[panRecognizer setDelegate:self];
	[collectionView addGestureRecognizer:panRecognizer];
	NSLog(@"shouldSelectItemAtIndexPath");
	 */
	
}
- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *theCollectionViewCell = [self.collectionView cellForItemAtIndexPath:indexPath];
	
	
	//	theCollectionViewCell.backgroundColor = [UIColor blueColor];
	theCollectionViewCell.layer.borderColor = nil;
	theCollectionViewCell.layer.borderWidth = 0;
}
#endif



#pragma mark - OBOvumSource

-(OBOvum *) createOvumFromView:(UIView*)sourceView
{
	NSLog(@"createOvumFromView");
	OBOvum *ovum = [[[OBOvum alloc] init] autorelease];
	ovum.dataObject = [NSNumber numberWithInteger:sourceView.tag];
	return ovum;
}


-(UIView *) createDragRepresentationOfSourceView:(UIView *)sourceView inWindow:(UIWindow*)window gestureRecognizer:(UIGestureRecognizer*)recognizer
{
	NSLog(@"createDragRepresentationOfSourceView");
//	indexPathForItemAtPoint;

	CGPoint touch_point = [recognizer locationInView:sourceView];
	NSIndexPath* indexPath = [[self collectionView] indexPathForItemAtPoint:touch_point];
	UICollectionViewCell *theCollectionViewCell = [[self collectionView] cellForItemAtIndexPath:indexPath];

	
	
	CGRect frame = [sourceView convertRect:sourceView.bounds toView:sourceView.window];
	frame = [window convertRect:frame fromWindow:sourceView.window];
	
//	CVCell *dragView = [[[CVCell alloc] initWithFrame:frame] autorelease];
	// LEAK???
	CVCell *dragView = [[CVCell alloc] initWithFrame:frame];
	
	/*
	dragView.backgroundColor = sourceView.backgroundColor;
	dragView.layer.cornerRadius = 5.0;
	dragView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
	dragView.layer.borderWidth = 1.0;
	dragView.layer.masksToBounds = YES;
	 */
	
//	CVCell *cell = (CVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
//    NSString *cellData = [data objectAtIndex:indexPath.row];
    [[dragView titleLabel] setText:[[theCollectionViewCell titleLabel] text]];
	
	
	return dragView;
}


-(void) dragViewWillAppear:(UIView *)dragView inWindow:(UIWindow*)window atLocation:(CGPoint)location
{
	NSLog(@"dragViewWillAppear");

	dragView.transform = CGAffineTransformIdentity;
	dragView.alpha = 0.0;
	dragView.center = location;
	
	[UIView animateWithDuration:0.25 animations:^{
		dragView.transform = CGAffineTransformMakeScale(0.80, 0.80);
		dragView.alpha = 0.75;
	}];
}



#pragma mark - OBDropZone

static NSInteger kLabelTag = 2323;




-(OBDropAction) ovumEntered:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
	NSLog(@"Ovum<0x%x> %@ Entered", (int)ovum, ovum.dataObject);
    /*
	CGFloat red = 0.33 + 0.66 * location.y / self.view.frame.size.height;
	view.layer.borderColor = [UIColor colorWithRed:red green:0.0 blue:0.0 alpha:1.0].CGColor;
	view.layer.borderWidth = 5.0;
	
	CGRect labelFrame = CGRectMake(ovum.dragView.bounds.origin.x, ovum.dragView.bounds.origin.y, ovum.dragView.bounds.size.width, ovum.dragView.bounds.size.height / 2);
	UILabel *label = [[[UILabel alloc] initWithFrame:labelFrame] autorelease];
	label.text = @"Ovum entered";
	label.tag = kLabelTag;
	label.backgroundColor = [UIColor clearColor];
	label.opaque = NO;
	label.font = [UIFont boldSystemFontOfSize:24.0];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor whiteColor];
	[ovum.dragView addSubview:label];
	*/
//	return OBDropActionMove;
	
	self.canvasView.backgroundColor = [UIColor redColor];
    return OBDropActionCopy;    // Return OBDropActionNone if view is not currently accepting this ovum

}

-(OBDropAction) ovumMoved:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
	 NSLog(@"Ovum<0x%x> %@ Moved", (int)ovum, ovum.dataObject);
	/*
	CGFloat hiphopopotamus = 0.33 + 0.66 * location.y / self.view.frame.size.height;
	
	// This tester currently only supports dragging from left to right view
	if ([ovum.dataObject isKindOfClass:[NSNumber class]])
	{
		UIView *itemView = [self.view viewWithTag:[ovum.dataObject integerValue]];
		if ([rightViewContents containsObject:itemView])
		{
			view.layer.borderColor = [UIColor colorWithRed:hiphopopotamus green:0.0 blue:0.0 alpha:1.0].CGColor;
			view.layer.borderWidth = 5.0;
			
			UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
			label.text = @"Cannot Drop Here";
			
			return OBDropActionNone;
		}
	}
	
	view.layer.borderColor = [UIColor colorWithRed:0.0 green:hiphopopotamus blue:0.0 alpha:1.0].CGColor;
	view.layer.borderWidth = 5.0;
	
	UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
	label.text = [NSString stringWithFormat:@"Ovum at %@", NSStringFromCGPoint(location)];
	*/
	
	
	return OBDropActionMove;
}

-(void) ovumExited:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
	NSLog(@"Ovum<0x%x> %@ Exited", (int)ovum, ovum.dataObject);
	/*
	view.layer.borderColor = [UIColor clearColor].CGColor;
	view.layer.borderWidth = 0.0;
	
	UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
	[label removeFromSuperview];
	 */
	
	self.canvasView.backgroundColor = [UIColor clearColor];

}

-(void) ovumDropped:(OBOvum*)ovum inView:(UIView*)view atLocation:(CGPoint)location
{
	NSLog(@"Ovum<0x%x> %@ Dropped", (int)ovum, ovum.dataObject);
	/*
	view.layer.borderColor = [UIColor clearColor].CGColor;
	view.layer.borderWidth = 0.0;
	
	UILabel *label = (UILabel*) [ovum.dragView viewWithTag:kLabelTag];
	[label removeFromSuperview];
	
	if ([ovum.dataObject isKindOfClass:[NSNumber class]])
	{
		UIView *itemView = [self.view viewWithTag:[ovum.dataObject integerValue]];
		if (itemView)
		{
			[itemView retain];
			[itemView removeFromSuperview];
			[leftViewContents removeObject:itemView];
			
			NSInteger insertionIndex = [self insertionIndexForLocation:location withContents:rightViewContents];
			[rightView insertSubview:itemView atIndex:insertionIndex];
			[rightViewContents insertObject:itemView atIndex:insertionIndex];
			
			[itemView release];
		}
	}
	 */
	
	self.canvasView.backgroundColor = [UIColor clearColor];

	
	CVCell *the_view = [[CVCell alloc] initWithFrame:CGRectMake(location.x, location.y, 44, 44)];
	
	/*
	 dragView.backgroundColor = sourceView.backgroundColor;
	 dragView.layer.cornerRadius = 5.0;
	 dragView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:1.0].CGColor;
	 dragView.layer.borderWidth = 1.0;
	 dragView.layer.masksToBounds = YES;
	 */
	
	//	CVCell *cell = (CVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
	//    NSMutableArray *data = [self.dataArray objectAtIndex:indexPath.section];
	//    NSString *cellData = [data objectAtIndex:indexPath.row];
    [[the_view titleLabel] setText:[[ovum.dragView titleLabel] text]];

	
	
//	UIView* the_view = [ovum.dragView retain];
	CGFloat width = [ovum.dragView frame].size.width;
	CGFloat height = [ovum.dragView frame].size.height;
	// Setting the position in initWithFrame isn't working for me. It's probably because this is a cell class.
	// The position needs to be offset so it is in the center of the icon instead of the corner.
	CGRect target_frame = CGRectMake(location.x - width/2, location.y - height/2, width, height);
	
	[the_view setFrame:target_frame];
	[view addSubview:the_view];
}

#if 0
-(void) handleDropAnimationForOvum:(OBOvum*)ovum withDragView:(UIView*)dragView dragDropManager:(OBDragDropManager*)dragDropManager
{
	NSLog(@"handleDropAnimationForOvum");
/*
	if ([ovum.dataObject isKindOfClass:[NSNumber class]])
	{
		UIView *itemView = [self.view viewWithTag:[ovum.dataObject integerValue]];
		
		// Set the initial position of the view to match that of the drag view
		CGRect dragViewFrameInTargetWindow = [ovum.dragView.window convertRect:dragView.frame toWindow:self.canvasView.window];
		dragViewFrameInTargetWindow = [self.canvasView convertRect:dragViewFrameInTargetWindow fromView:self.canvasView.window];
		itemView.frame = dragViewFrameInTargetWindow;
		
		CGRect viewFrame = [ovum.dragView.window convertRect:itemView.frame fromView:itemView.superview];
		
		void (^animation)() = ^{
//			dragView.frame = viewFrame;
			
//			[self layoutScrollView:leftView withContents:leftViewContents];
//			[self layoutScrollView:rightView withContents:rightViewContents];
		};
		
		[dragDropManager animateOvumDrop:ovum withAnimation:animation completion:nil];
	}
 */
}
#endif

@end
