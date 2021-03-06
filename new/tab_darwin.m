// 12 april 2015
#import "uipriv_darwin.h"

// TODO
// - verify margins against extra space around the tab
// - free child containers properly

@interface uiNSTabView : NSTabView
@property uiControl *uiC;
@end

@implementation uiNSTabView

- (void)viewDidMoveToSuperview
{
	// TODO free all tabs explicitly
	if (uiDarwinControlFreeWhenAppropriate(self.uiC, [self superview]))
		self.uiC = NULL;
	[super viewDidMoveToSuperview];
}

@end

// the default new control implementation uses -sizeToFit, which we don't have with NSTabView
// fortunately, we do have -minimumSize
static void preferredSize(uiControl *c, uiSizing *d, intmax_t *width, intmax_t *height)
{
	uiNSTabView *tv;
	NSSize s;

	tv = (uiNSTabView *) uiControlHandle(c);
	s = [tv minimumSize];
	*width = (intmax_t) (s.width);
	*height = (intmax_t) (s.height);
}

uiControl *uiNewTab(void)
{
	uiControl *c;
	uiNSTabView *t;

	c = uiDarwinNewControl([uiNSTabView class], NO, NO);
	c->preferredSize = preferredSize;
	t = (uiNSTabView *) uiControlHandle(c);
	t.uiC = c;

	// also good for NSTabView (same selector and everything)
	setStandardControlFont((NSControl *) t);

	return c;
}

void uiTabAddPage(uiControl *c, const char *name, uiControl *child)
{
	uiNSTabView *tv;
	uiParent *content;
	NSTabViewItem *i;

	content = uiNewParent(0);
	uiParentSetChild(content, child);

	i = [[NSTabViewItem alloc] initWithIdentifier:nil];
	[i setLabel:toNSString(name)];
	[i setView:((NSView *) uiParentHandle(content))];
	tv = (uiNSTabView *) uiControlHandle(c);
	[tv addTabViewItem:i];
}
