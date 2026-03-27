/** Function to shift the current view to the left/right
 *
 * @param: "arg->i" stores the number of tags to shift right (positive value)
 *          or left (negative value)
 */
void
shiftview(const Arg *arg)
{
	Arg shifted;
	unsigned int steps;

	shifted.ui = selmon->tagset[selmon->seltags] & ~SPTAGMASK;
	if (!shifted.ui)
		return;

	if (arg->i > 0) { /* left circular shift */
		steps = arg->i % LENGTH(tags);
		shifted.ui = (shifted.ui << steps)
		   | (shifted.ui >> (LENGTH(tags) - steps));
	} else { /* right circular shift */
		steps = (-arg->i) % LENGTH(tags);
		shifted.ui = (shifted.ui >> steps)
		   | (shifted.ui << (LENGTH(tags) - steps));
	}
	shifted.ui &= TAGMASK;

	view(&shifted);
}

void
shifttag(const Arg *arg)
{
	Arg a;
	unsigned int shifted, steps;

	if (!selmon->sel)
		return;

	shifted = selmon->sel->tags & TAGMASK;
	if (!shifted)
		return;

	if (arg->i > 0) { /* left circular shift */
		steps = arg->i % LENGTH(tags);
		shifted = (shifted << steps)
		   | (shifted >> (LENGTH(tags) - steps));
	} else { /* right circular shift */
		steps = (-arg->i) % LENGTH(tags);
		shifted = (shifted >> steps)
		   | (shifted << (LENGTH(tags) - steps));
	}

	a.ui = shifted & TAGMASK;
	tag(&a);
}
