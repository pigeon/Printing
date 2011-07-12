//
//  RootViewController.m
//  PrintTestApp
//
//  Created by Dmytro Golub on 12/07/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemAction 
											   target:self 
											   action:@selector(printDocument)] autorelease];
	NSError* error = nil;
	NSString* htmlStr =  [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"printText" ofType:@"html"] 
											   usedEncoding:nil 
													  error:&error];
	
	[(UIWebView*)self.view loadHTMLString:htmlStr baseURL:nil];
}




#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


-(void)printDocument
{		
	NSString* htmlStr =  [NSString stringWithContentsOfFile:[[NSBundle mainBundle] 
															 pathForResource:@"printText" 
															          ofType:@"html"] 
						  usedEncoding:nil 
						  error:NULL];
	
	UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
	
	UIPrintInfo *printInfo = [UIPrintInfo printInfo];
	printInfo.outputType = UIPrintInfoOutputGeneral;
	printInfo.jobName = @"Test Print Job";
	pic.printInfo = printInfo;
	
	
	UIMarkupTextPrintFormatter* textFormatter = [[UIMarkupTextPrintFormatter alloc] 
												 initWithMarkupText:htmlStr];
	
	textFormatter.startPage = 0;
	textFormatter.contentInsets = UIEdgeInsetsMake(72.0, 72.0, 72.0, 72.0);
	textFormatter.maximumContentWidth = 6 * 72.0;
	pic.printFormatter = textFormatter;
	[textFormatter release];
	pic.showsPageRange = YES;	
		
	void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
		^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
			if (!completed && error) {
				NSLog(@"Printing error: %@", error);
			}
		};
		
		
	[pic presentFromBarButtonItem:self.navigationItem.leftBarButtonItem 
						 animated:YES 
				completionHandler:completionHandler];
		
}

- (void)dealloc {
    [super dealloc];
}


@end

