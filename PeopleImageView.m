/*
 
File: PeopleImageView.m
 
Abstract: Part of the People project demonstrating use of the
               SyncServices framework
 
Version: 0.1
 
Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
Computer, Inc. ("Apple") in consideration of your agreement to the
following terms, and your use, installation, modification or
redistribution of this Apple software constitutes acceptance of these
terms.  If you do not agree with these terms, please do not use,
install, modify or redistribute this Apple software.

In consideration of your agreement to abide by the following terms, and
subject to these terms, Apple grants you a personal, non-exclusive
license, under Apple's copyrights in this original Apple software (the
"Apple Software"), to use, reproduce, modify and redistribute the Apple
Software, with or without modifications, in source and/or binary forms;
provided that if you redistribute the Apple Software in its entirety and
without modifications, you must retain this notice and the following
text and disclaimers in all such redistributions of the Apple Software. 
Neither the name, trademarks, service marks or logos of Apple Computer,
Inc. may be used to endorse or promote products derived from the Apple
Software without specific prior written permission from Apple.  Except
as expressly stated in this notice, no other rights or licenses, express
or implied, are granted by Apple herein, including but not limited to
any patent rights that may be infringed by your derivative works or by
other works in which the Apple Software may be incorporated.

The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

Copyright � 2005-2009 Apple Computer, Inc., All Rights Reserved.

*/

#import "PeopleImageView.h"

@implementation PeopleImageView

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		// Add initialization code here
	}
	return self;
}

- (void)drawRect: (NSRect)rect {
    
    NSImage *image = [self image];
    if (image) {
		[image drawInRect:[self bounds]
		fromRect: NSMakeRect(0, 0, [image size].width, [image size].height)
		operation: NSCompositeSourceOver
		fraction: (CGFloat)1.0];            
	}
}

- (void)dealloc {
    [self setImage: nil];
    [super dealloc];
}

// accessors
- (NSImage *)image{
    return [[_image retain] autorelease];
}

- (void)setImage: (NSImage *)value {
    if ( _image != value ) {
        [_image release];
        _image = [value retain];
    }
}

- (int)viewType{
	return _viewType;
}

- (void)setViewType: (int)value{
	_viewType = value;
}


@end


@implementation PeopleImageView (DraggingSupport)

- (NSDragOperation) draggingEntered: (id <NSDraggingInfo>) sender {
	BOOL isValid = [NSImage canInitWithPasteboard:
		[sender draggingPasteboard]];

	return isValid ? NSDragOperationCopy : NSDragOperationNone;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>) sender {

	return [NSImage canInitWithPasteboard:
		[sender draggingPasteboard]];
}

- (BOOL)performDragOperation: (id <NSDraggingInfo>) sender {
	NSPasteboard *pb = [sender draggingPasteboard];
	NSImage *image = [[NSImage alloc] initWithPasteboard: pb];

	[self setImage: image];
	[image release];

 	[[NSNotificationCenter defaultCenter]
		postNotificationName:@"PhotoAdded" object:self];
	
	[self setNeedsDisplay: YES];
		
	if (image == nil) {
		return NO;
	}
	return YES;
}

@end
