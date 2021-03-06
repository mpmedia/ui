// 9 april 2015
#import "uipriv_darwin.h"

@interface uiNSTextField : NSTextField
@property uiControl *uiC;
@end

@implementation uiNSTextField

- (void)viewDidMoveToSuperview
{
	if (uiDarwinControlFreeWhenAppropriate(self.uiC, [self superview])) {
		[self setTarget:nil];
		self.uiC = NULL;
	}
	[super viewDidMoveToSuperview];
}

@end

// TOOD move elsewhere
// these are based on interface builder defaults; my comments in the old code weren't very good so I don't really know what talked about what, sorry :/
void finishNewTextField(NSTextField *t, BOOL isEntry)
{
	setStandardControlFont((id) t);

	// THE ORDER OF THESE CALLS IS IMPORTANT; CHANGE IT AND THE BORDERS WILL DISAPPEAR
	[t setBordered:NO];
	[t setBezelStyle:NSTextFieldSquareBezel];
	[t setBezeled:isEntry];

	// we don't need to worry about substitutions/autocorrect here; see window_darwin.m for details

	[[t cell] setLineBreakMode:NSLineBreakByClipping];
	[[t cell] setScrollable:YES];
}

uiControl *uiNewEntry(void)
{
	uiControl *c;
	uiNSTextField *t;

	c = uiDarwinNewControl([uiNSTextField class], NO, NO);
	t = (uiNSTextField *) uiControlHandle(c);
	t.uiC = c;

	[t setSelectable:YES];		// otherwise the setting is masked by the editable default of YES
	finishNewTextField((NSTextField *) t, YES);

	return t.uiC;
}

char *uiEntryText(uiControl *c)
{
	uiNSTextField *t;

	t = (uiNSTextField *) uiControlHandle(c);
	return uiDarwinNSStringToText([t stringValue]);
}

void uiEntrySetText(uiControl *c, const char *text)
{
	uiNSTextField *t;

	t = (uiNSTextField *) uiControlHandle(c);
	[t setStringValue:toNSString(text)];
}
