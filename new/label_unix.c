// 11 april 2015
#include "uipriv_unix.h"

struct label {
};

static void onDestroy(GtkWidget *widget, gpointer data)
{
	struct label *l = (struct label *) data;

	uiFree(l);
}

uiControl *uiNewLabel(const char *text)
{
	uiControl *c;
	struct label *l;
	GtkWidget *widget;

	c = uiUnixNewControl(GTK_TYPE_LABEL,
		FALSE, FALSE,
		"label", text,
		"xalign", 0.0,		// note: must be a float constant, otherwise the ... will turn it into an int and we get segfaults on some platforms (thanks ebassi in irc.gimp.net/#gtk+)
		// TODO yalign 0?
		NULL);

	widget = GTK_WIDGET(uiControlHandle(c));

	l = uiNew(struct label);
	g_signal_connect(widget, "destroy", G_CALLBACK(onDestroy), l);
	c->data = l;

	return c;
}

char *uiLabelText(uiControl *c)
{
	// TODO change g_strdup() to a wrapper function for export in ui_unix.h
	return g_strdup(gtk_label_get_text(GTK_LABEL(uiControlHandle(c))));
}

void uiLabelSetText(uiControl *c, const char *text)
{
	gtk_label_set_text(GTK_LABEL(uiControlHandle(c)), text);
}
