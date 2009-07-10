/*
 * Copyright (c) 2009, Richard Drake
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *   1. Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 *   2. Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *   3. Neither the name of the Mobile Education Project, the University of
 *      Ontario Institute of Technology (UOIT), nor the names of its
 *      contributors may be used to endorse or promote products derived from
 *      this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "SearchController.h"


@implementation SearchController

@synthesize searchBar, ovc;

- (void)searchBarTextDidBeginEditing:(UISearchBar *)sb {
	searching = YES;
	self.searchBar.showsCancelButton = YES;
	self.tableView.scrollEnabled = NO;
	
	if (ovc == nil)
		ovc = [[OverlayViewController alloc] initWithNibName:@"OverlayView" bundle:nil];
	
	CGFloat yaxis = self.navigationController.navigationBar.frame.size.height;
	CGFloat width = self.view.frame.size.width;
	CGFloat height = self.view.frame.size.height;
	
	//Parameters x = origion on x-axis, y = origon on y-axis.
	CGRect frame = CGRectMake(0, yaxis, width, height);
	ovc.view.frame = frame;
	ovc.view.backgroundColor = [UIColor grayColor];
	ovc.view.alpha = 0.3;
	
	ovc.cont = self;
	
	[self.tableView insertSubview:ovc.view aboveSubview:self.parentViewController.view];
}

- (void)endSearch {
	[self.ovc.view removeFromSuperview];
	[self.searchBar resignFirstResponder];
	[self.tableView reloadData];
	
	self.tableView.scrollEnabled = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)sb {
	self.searchBar.showsCancelButton = NO;
	[self endSearch];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)sb {
	[self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)sb {
	self.searchBar.text = @"";
	searching = NO;
	[self.tableView reloadData];
	[self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
