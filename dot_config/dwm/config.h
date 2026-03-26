/* See LICENSE file for copyright and license details. */

/* Constants */
#define TERMINAL "kitty"
#define TERMCLASS "kitty"
#define BROWSER "firefox"

/* appearance */
static unsigned int borderpx  = 2;        /* border pixel of windows */
static unsigned int snap      = 32;       /* snap pixel */
static unsigned int gappih    = 20;       /* horiz inner gap between windows */
static unsigned int gappiv    = 10;       /* vert inner gap between windows */
static unsigned int gappoh    = 10;       /* horiz outer gap between windows and screen edge */
static unsigned int gappov    = 30;       /* vert outer gap between windows and screen edge */
static int swallowfloating    = 0;        /* 1 means swallow floating windows by default */
static int smartgaps          = 0;        /* 1 means no outer gap when there is only one window */
static int showbar            = 1;        /* 0 means no bar */
static int topbar             = 1;        /* 0 means bottom bar */
static char *fonts[]          = { "monospace:size=11", "NotoColorEmoji:pixelsize=11:antialias=true:autohint=true"  };
static char normbgcolor[]           = "#111315";
static char normbordercolor[]       = "#2A2D31";
static char normfgcolor[]           = "#C7CCD1";
static char selfgcolor[]            = "#F4F4F6";
static char selbordercolor[]        = "#50fa7b";
static char selbgcolor[]            = "#2A2D31";
static char titlebgcolor[]          = "#1C1F24";
static char titlebordercolor[]      = "#2A2D31";
static char titlefgcolor[]          = "#F4F4F6";
static char *colors[][3] = {
       /*               fg           bg           border   */
       [SchemeNorm]  = { normfgcolor,  normbgcolor,  normbordercolor  },
       [SchemeSel]   = { selfgcolor,   selbgcolor,   selbordercolor   },
       [SchemeTitle] = { titlefgcolor, titlebgcolor, titlebordercolor },
};

typedef struct {
	const char *name;
	const void *cmd;
} Sp;
const char *spcmd1[] = {TERMINAL, "--name", "spterm", NULL };
const char *spcmd2[] = {TERMINAL, "--name", "spcalc", "--override", "font_size=16", "-e", "bc", "-lq", NULL };
static Sp scratchpads[] = {
	/* name          cmd  */
	{"spterm",      spcmd1},
	{"spcalc",      spcmd2},
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	*/
	/* class    instance      title       	 tags mask    isfloating   isterminal  noswallow  monitor */
	{ "Gimp",     NULL,       NULL,          1 << 8,      0,           0,          0,         -1 },
	{ TERMCLASS,  NULL,       NULL,       	 0,           0,           1,          0,         -1 },
	{ NULL,       NULL,       "Event Tester", 0,          0,           0,          1,         -1 },
	{ TERMCLASS,  "floatterm", NULL,       	 0,           1,           1,          0,         -1 },
	{ TERMCLASS,  "bg",        NULL,       	 1 << 7,      0,           1,          0,         -1 },
	{ TERMCLASS,  "spterm",    NULL,       	 SPTAG(0),    1,           1,          0,         -1 },
	{ TERMCLASS,  "spcalc",    NULL,       	 SPTAG(1),    1,           1,          0,         -1 },
};

/* layout(s) */
static float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static int nmaster     = 1;    /* number of clients in master area */
static int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",	tile },	                /* Default: Master on left, slaves on right */
	{ "TTT",	bstack },               /* Master on top, slaves on bottom */

	{ "[@]",	spiral },               /* Fibonacci spiral */
	{ "[\\]",	dwindle },              /* Decreasing in size right and leftward */

	{ "[D]",	deck },	                /* Master on left, slaves in monocle-like mode on right */
	{ "[M]",	monocle },              /* All windows on top of eachother */

	{ "|M|",	centeredmaster },               /* Master in middle, slaves on sides */
	{ ">M>",	centeredfloatingmaster },       /* Same but master floats */

	{ "><>",	NULL },	                /* no layout function means floating behavior */
	{ NULL,		NULL },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },
#define STACKKEYS(MOD,ACTION) \
	{ MOD,	XK_j,	ACTION##stack,	{.i = INC(+1) } }, \
	{ MOD,	XK_k,	ACTION##stack,	{.i = INC(-1) } }, \
	{ MOD,  XK_v,   ACTION##stack,  {.i = 0 } }, \
	/* { MOD, XK_grave, ACTION##stack, {.i = PREVSEL } }, \ */
	/* { MOD, XK_a,     ACTION##stack, {.i = 1 } }, \ */
	/* { MOD, XK_z,     ACTION##stack, {.i = 2 } }, \ */
	/* { MOD, XK_x,     ACTION##stack, {.i = -1 } }, */

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *termcmd[]  = { TERMINAL, NULL };
static const char *dmenucmd[] = {
	"dmenu_run", "-i",
	"-nb", "#111315",
	"-nf", "#C7CCD1",
	"-sb", "#2A2D31",
	"-sf", "#F4F4F6",
	NULL
};
static const char *notesmenu[] = { "/home/mattia/.config/scripts/dmenunotes", NULL };
static const char *sysmenu[] = { "/home/mattia/.config/scripts/dmenusys", NULL };

/*
 * Xresources preferences to load at startup
 */
ResourcePref resources[] = {
		{ "borderpx",		INTEGER, &borderpx },
		{ "snap",		INTEGER, &snap },
		{ "showbar",		INTEGER, &showbar },
		{ "topbar",		INTEGER, &topbar },
		{ "nmaster",		INTEGER, &nmaster },
		{ "resizehints",	INTEGER, &resizehints },
		{ "mfact",		FLOAT,	&mfact },
		{ "gappih",		INTEGER, &gappih },
		{ "gappiv",		INTEGER, &gappiv },
		{ "gappoh",		INTEGER, &gappoh },
		{ "gappov",		INTEGER, &gappov },
		{ "swallowfloating",	INTEGER, &swallowfloating },
		{ "smartgaps",		INTEGER, &smartgaps },
};

#include <X11/XF86keysym.h>
#include "shiftview.c"

static const Key keys[] = {
	/* modifier                     key            function                argument */
	STACKKEYS(MODKEY,                              focus)
	STACKKEYS(MODKEY|ShiftMask,                    push)
	/* { MODKEY|ShiftMask,		XK_Escape,     spawn,	               SHCMD("") }, */
	{ MODKEY,			XK_grave,      spawn,	               {.v = (const char*[]){ "dmenuunicode", NULL } } },
	/* { MODKEY|ShiftMask,		XK_grave,      togglescratch,	       SHCMD("") }, */
	TAGKEYS(			XK_1,          0)
	TAGKEYS(			XK_2,          1)
	TAGKEYS(			XK_3,          2)
	TAGKEYS(			XK_4,          3)
	TAGKEYS(			XK_5,          4)
	TAGKEYS(			XK_6,          5)
	TAGKEYS(			XK_7,          6)
	TAGKEYS(			XK_8,          7)
	TAGKEYS(			XK_9,          8)
	{ MODKEY,			XK_0,	       view,                   {.ui = ~0 } },
	{ MODKEY|ShiftMask,		XK_0,	       tag,                    {.ui = ~0 } },
	{ MODKEY,			XK_BackSpace,  spawn,                  {.v = (const char*[]){ "sysact", NULL } } },
	{ MODKEY|ShiftMask,		XK_BackSpace,  spawn,                  {.v = (const char*[]){ "sysact", NULL } } },

	{ MODKEY,			XK_Tab,        view,                   {0} },
	/* { MODKEY|ShiftMask,		XK_Tab,	       spawn,                  SHCMD("") }, */
	{ MODKEY,			XK_q,          killclient,             {0} },
	{ MODKEY|ShiftMask,		XK_q,          spawn,                  {.v = (const char*[]){ "sysact", NULL } } },
	{ MODKEY,			XK_w,          spawn,                  {.v = (const char*[]){ BROWSER, NULL } } },
	{ MODKEY|ShiftMask,		XK_w,          spawn,                  {.v = (const char*[]){ TERMINAL, "-e", "nmtui", NULL } } },
	{ MODKEY,			XK_e,          spawn,                  SHCMD("bemoji") },
	{ MODKEY, 			XK_F1, 		   spawn, 				   SHCMD("~/.config/scripts/cheatsheet-menu") },
	{ MODKEY,			XK_r,          spawn,                  {.v = (const char*[]){ TERMINAL, "-e", "lfub", NULL } } },
	{ MODKEY|ShiftMask,		XK_r,          spawn,                  {.v = (const char*[]){ TERMINAL, "-e", "htop", NULL } } },
	{ MODKEY,			XK_t,          setlayout,              {.v = &layouts[0]} }, /* tile */
	{ MODKEY|ShiftMask,		XK_t,          setlayout,              {.v = &layouts[1]} }, /* bstack */
	{ MODKEY,			XK_y,          setlayout,              {.v = &layouts[2]} }, /* spiral */
	{ MODKEY|ShiftMask,		XK_y,          setlayout,              {.v = &layouts[3]} }, /* dwindle */
	{ MODKEY,			XK_u,          setlayout,              {.v = &layouts[4]} }, /* deck */
	{ MODKEY|ShiftMask,		XK_u,          setlayout,              {.v = &layouts[5]} }, /* monocle */
	{ MODKEY,			XK_i,          setlayout,              {.v = &layouts[6]} }, /* centeredmaster */
	{ MODKEY|ShiftMask,		XK_i,          setlayout,              {.v = &layouts[7]} }, /* centeredfloatingmaster */
	{ MODKEY,			XK_o,          incnmaster,             {.i = +1 } },
	{ MODKEY|ShiftMask,		XK_o,          incnmaster,             {.i = -1 } },
	{ MODKEY,			XK_backslash,  view,                   {0} },
	/* { MODKEY|ShiftMask,		XK_backslash,  spawn,                  SHCMD("") }, */

	{ MODKEY,			XK_a,          togglegaps,             {0} },
	{ MODKEY|ShiftMask,		XK_a,          defaultgaps,            {0} },
	{ MODKEY,			XK_s,          togglesticky,           {0} },
	/* { MODKEY|ShiftMask,		XK_s,          spawn,                  SHCMD("") }, */
	{ MODKEY,			XK_f,          togglefullscr,          {0} },
	{ MODKEY|ShiftMask,		XK_f,          setlayout,              {.v = &layouts[8]} },
	{ MODKEY,			XK_h,          setmfact,               {.f = -0.05} },
	/* J and K are automatically bound above in STACKEYS */
	{ MODKEY,			XK_l,          setmfact,               {.f = +0.05} },
	/* { MODKEY|ShiftMask,		XK_apostrophe, spawn,                  SHCMD("") }, */
	{ MODKEY|ShiftMask,		XK_apostrophe, togglesmartgaps,        {0} },
	{ MODKEY,			XK_Return,     spawn,                  {.v = termcmd } },
	{ MODKEY|ShiftMask,		XK_Return,     togglescratch,          {.ui = 0} },

	{ MODKEY,			XK_z,          incrgaps,               {.i = +3 } },
	/* { MODKEY|ShiftMask,		XK_z,          spawn,                  SHCMD("") }, */
	{ MODKEY,			XK_x,          incrgaps,               {.i = -3 } },
	/* { MODKEY|ShiftMask,		XK_x,          spawn,                  SHCMD("") }, */
	{ MODKEY,			XK_c,          spawn,                  {.v = (const char*[]){ TERMINAL, "-e", "profanity", NULL } } },
	/* { MODKEY|ShiftMask,		XK_c,          spawn,                  SHCMD("") }, */
	/* V is automatically bound above in STACKKEYS */
	{ MODKEY,			XK_b,          togglebar,              {0} },
	/* { MODKEY|ShiftMask,		XK_b,          spawn,                  SHCMD("") }, */
	{ MODKEY,			XK_n,          spawn,                  {.v = notesmenu } },
	{ MODKEY,			XK_Left,       focusstack,             {.i = INC(-1) } },
	{ MODKEY|ShiftMask,		XK_Left,       shifttag,               { .i = -1 } },
	{ MODKEY|ControlMask,		XK_Left,       shiftview,              { .i = -1 } },
	{ MODKEY,			XK_Right,      focusstack,             {.i = INC(+1) } },
	{ MODKEY|ShiftMask,		XK_Right,      shifttag,               { .i = +1 } },
	{ MODKEY|ControlMask,		XK_Right,      shiftview,              { .i = +1 } },
	{ MODKEY,			XK_Insert,     spawn,                  SHCMD("xdotool type $(grep -v '^#' ~/.local/share/larbs/snippets | dmenu -i -l 50 -nb '#111315' -nf '#C7CCD1' -sb '#2A2D31' -sf '#F4F4F6' | cut -d' ' -f1)") },

	{ MODKEY,			XK_space,      zoom,                   {0} },
	{ MODKEY|ShiftMask,		XK_space,      togglefloating,         {0} },
	{ ControlMask,			XK_space,      spawn,                  {.v = dmenucmd } },
	{ MODKEY,			XK_Delete,     spawn,                  {.v = sysmenu } },

	{ 0,				XK_Print,      spawn,                  SHCMD("maim pic-full-$(date '+%y%m%d-%H%M-%S').png") },
	{ ShiftMask,			XK_Print,      spawn,                  {.v = (const char*[]){ "maimpick", NULL } } },
	{ MODKEY,			XK_Scroll_Lock, spawn,                 SHCMD("killall screenkey || screenkey &") },

	/* { 0, XF86XK_PowerOff,                       spawn,                  {.v = (const char*[]){ "sysact", NULL } } }, */
	{ 0, XF86XK_Sleep,                             spawn,                  {.v = (const char*[]){ "sudo", "-A", "zzz", NULL } } },
	{ 0, XF86XK_WWW,                               spawn,                  {.v = (const char*[]){ BROWSER, NULL } } },
	{ 0, XF86XK_DOS,                               spawn,                  {.v = termcmd } },
	{ 0, XF86XK_ScreenSaver,                       spawn,                  SHCMD("slock & xset dpms force off; mpc pause; pauseallmpv") },
	{ 0, XF86XK_TaskPane,                          spawn,                  {.v = (const char*[]){ TERMINAL, "-e", "htop", NULL } } },
	{ 0, XF86XK_MyComputer,                        spawn,                  {.v = (const char*[]){ TERMINAL, "-e",  "lfub",  "/", NULL } } },
	/* { 0, XF86XK_Battery,                        spawn,                  SHCMD("") }, */
	{ 0, XF86XK_Launch1,                           spawn,                  {.v = (const char*[]){ "xset", "dpms", "force", "off", NULL } } },
	{ 0, XF86XK_TouchpadToggle,                    spawn,                  SHCMD("(synclient | grep 'TouchpadOff.*1' && synclient TouchpadOff=0) || synclient TouchpadOff=1") },
	{ 0, XF86XK_TouchpadOff,                       spawn,                  {.v = (const char*[]){ "synclient", "TouchpadOff=1", NULL } } },
	{ 0, XF86XK_TouchpadOn,                        spawn,                  {.v = (const char*[]){ "synclient", "TouchpadOff=0", NULL } } },
	{ 0, XF86XK_MonBrightnessUp,                   spawn,                  {.v = (const char*[]){ "xbacklight", "-inc", "15", NULL } } },
	{ 0, XF86XK_MonBrightnessDown,                 spawn,                  {.v = (const char*[]){ "xbacklight", "-dec", "15", NULL } } },
	{ 0, XF86XK_AudioMute,                         spawn,                  SHCMD("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle; kill -44 $(pidof dwmblocks)") },
	{ 0, XF86XK_AudioRaiseVolume,                  spawn,                  SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%- && wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+; kill -44 $(pidof dwmblocks)") },
	{ 0, XF86XK_AudioLowerVolume,                  spawn,                  SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%+ && wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-; kill -44 $(pidof dwmblocks)") },

	/* { MODKEY|Mod4Mask,           XK_h,          incrgaps,               {.i = +1 } }, */
	/* { MODKEY|Mod4Mask,           XK_l,          incrgaps,               {.i = -1 } }, */
	/* { MODKEY|Mod4Mask|ShiftMask, XK_h,          incrogaps,              {.i = +1 } }, */
	/* { MODKEY|Mod4Mask|ShiftMask, XK_l,          incrogaps,              {.i = -1 } }, */
	/* { MODKEY|Mod4Mask|ControlMask, XK_h,        incrigaps,              {.i = +1 } }, */
	/* { MODKEY|Mod4Mask|ControlMask, XK_l,        incrigaps,              {.i = -1 } }, */
	/* { MODKEY|Mod4Mask|ShiftMask, XK_0,          defaultgaps,            {0} }, */
	/* { MODKEY,                    XK_y,          incrihgaps,             {.i = +1 } }, */
	/* { MODKEY,                    XK_o,          incrihgaps,             {.i = -1 } }, */
	/* { MODKEY|ControlMask,        XK_y,          incrivgaps,             {.i = +1 } }, */
	/* { MODKEY|ControlMask,        XK_o,          incrivgaps,             {.i = -1 } }, */
	/* { MODKEY|Mod4Mask,           XK_y,          incrohgaps,             {.i = +1 } }, */
	/* { MODKEY|Mod4Mask,           XK_o,          incrohgaps,             {.i = -1 } }, */
	/* { MODKEY|ShiftMask,          XK_y,          incrovgaps,             {.i = +1 } }, */
	/* { MODKEY|ShiftMask,          XK_o,          incrovgaps,             {.i = -1 } }, */

};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask           button          function        argument */
#ifndef __OpenBSD__
	{ ClkWinTitle,          0,                   Button2,        zoom,           {0} },
	{ ClkStatusText,        0,                   Button1,        sigdwmblocks,   {.i = 1} },
	{ ClkStatusText,        0,                   Button2,        sigdwmblocks,   {.i = 2} },
	{ ClkStatusText,        0,                   Button3,        sigdwmblocks,   {.i = 3} },
	{ ClkStatusText,        0,                   Button4,        spawn,          SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%- && wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+ ") },
	{ ClkStatusText,        0,                   Button5,        spawn,          SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%+ && wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-") },
	{ ClkStatusText,        ShiftMask,           Button1,        sigdwmblocks,   {.i = 6} },
#endif
	{ ClkStatusText,        ShiftMask,           Button3,        spawn,          SHCMD(TERMINAL " -e nvim ~/.local/src/dwmblocks/config.h") },
	{ ClkClientWin,         MODKEY,              Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,              Button2,        defaultgaps,    {0} },
	{ ClkClientWin,         MODKEY,              Button3,        resizemouse,    {0} },
	{ ClkClientWin,		MODKEY,		     Button4,	     incrgaps,       {.i = +1} },
	{ ClkClientWin,		MODKEY,		     Button5,	     incrgaps,       {.i = -1} },
	{ ClkTagBar,            0,                   Button1,        view,           {0} },
	{ ClkTagBar,            0,                   Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,              Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,              Button3,        toggletag,      {0} },
	{ ClkTagBar,		0,		     Button4,	     shiftview,      {.i = -1} },
	{ ClkTagBar,		0,		     Button5,	     shiftview,      {.i = 1} },
	{ ClkRootWin,		0,		     Button2,	     togglebar,      {0} },
};
