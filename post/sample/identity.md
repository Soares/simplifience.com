---
title: Euler's Identity
type: simplifience
sequence: Imaginary Powers
members:
- growth
- semicircle
- imagine
- aftermath
scripts:
- '@raphael/identity'
- '/js/complex.js'
---

<div class="caution" markdown="block">
This is not a standard simplifience sequence. It is a sample designed to show how difficult concepts can be intuitive with a good explanation.

The articles here break many @post[simplifience policies]intro/contrives. All of the concepts covered here will show up in greater detail in later articles.
</div>

Math is obfuscated by its archaic notation and its clumsy presentation. Take, for example, the strange equation known as "Euler's Identity":

$e^{\pi i} = \text{--}1$
{:.number}

You may have stumbled across this identity before. If you haven't, take a moment to really look at it and realize how extraordinary this is.

This formula claims that $e$ (the base of the natural logarithm, an irrational number) raised to the power $\pi$ (relating circle circumference to diameter, also irrational) times *an imaginary number* is not only *meaningful*, but it's a real whole number: negative one.

This is a mind-bending assertion. An irrational raised to the power of an *imaginary irrational* is somehow equal to negative one? This identity surprised and confounded many when it was first discovered.

> Gentlemen, that is surely true, it is absolutely paradoxical; we cannot understand it, and we don't know what it means. But we have proved it, and therefore we know it must be the truth.

That's Benjamin Peirce, an American mathematician and Harvard professor failing to understand Euler's identity.

This is exactly how math shouldn't be.

Euler's identity, it turns out, is easy to understand intuitively, as long as you understand the three building blocks.

* @post[$e$ is growth]sample/growth.
* @post[$\pi$ is half the circumference of a circle]sample/semicircle.
* @post[$i$ is the number one rotated a quarter turn]sample/imagine.

<aside class="info" markdown="block">
Follow the links to build up intuitive understandings of $e$, $\pi$, and $i$. Understanding of Euler's identity will follow.
</aside>

Once you understand $e$, $\pi$, and $i$ there is only one more @post[contrive]intro/contrives standing in the way of understanding the identity.

You've been taught that $x^5$ means $x\*x\*x\*x\*x$: five $x$s multiplied together. But what's $x^i$? $x$ times itself an imaginary number of times?

Remember that $i$ is no more nor less imaginary than $1$. In fact, $i$ is just $1$ rotated $\frac{1}{4}$ turns. So then $x^i$ is $x$ times itself one time but that one time is rotated? That doesn't make sense.

The contrive here is *exponentiation* -- when you have a number plane instead of a number line, exponentiation isn't just repeated multiplication. How do you repeat something a turned number of times? What does that even mean?

The true nature of exponentiation will be revealed in other simplifience sequences. For now, we're going to dodge the problem.

$p * e^x$ is just notation for $(grow\ p\ x)$: grow principle $p$ at rate $x$ compounding continuously. You'll remember that the formula to calculate the end result is <span class="info" markdown="inline">$\displaystyle p * e^x = \lim\_{n \to \infty} p * (1 + \tfrac{x}{n})^n$</span>.

<aside class="info" markdown="block">
$(1 + \frac{x}{n})$ is amount you grow each time you compound: $100\%$ plus an $n^{th}$ fraction of the interest rate ($x$).

You scale the principle ($p$) by this amount $n$ times.

Continuous growth is growth compounded an infinite number of times ($n \to \infty$).
</aside>

Using this formula we have a way to figure out what imaginary exponents mean. At least, we can figure out one particular imaginary exponent: $\displaystyle p * e^i = (grow\ p\ i) = \lim\_{n \to \infty} p * (1 + \tfrac{i}{n})^n$

The interesting part is this: $p * e^i = (grow\ p\ i)$. This is the core of Euler's identity. $(grow\ p\ 1)$ has an obvious meaning: take $p$ and grow it by $100\%$ every time period. But what in the blazes does $(grow\ p\ i)$ mean?

$i$ is just $1$ rotated a quarter turn. So what $(grow\ p\ i)$ means is this:

> Take the principle and grow it by $100\%$ per time period, making the interest perpendicular to the principle.

Remember that the use of $i$ puts us on a number plane, not a number line. It's not enough to say that we add $100\%$ interest: we also have to specify which direction the interest is added in. Growing $i$ is the same as growing $100\%$ except that the interest is paid out a quarter turn away from the principle.

To see how this works, let's consider growing 1 by $i$, compounding <span class="info" markdown="inline">only once</span>. This is just $1 * (1 + i)^1$ = $1 + i$. You start at one, and then all of the interest is vertical.

<div class="complex-plane"></div>

We've stepped off of the number line and onto the number plane: when you grow a number by $i$, you're going perpindicular.

What if we compound twice? We start with $1$. Then our first interest payment is $\frac{i}{2}$, so we're at $1 + \frac{i}{2}$.

The second interest payment isn't $\frac{i}{2}$ -- the second interest payment is $50\%$, but remember that all interest payments are *perpendicular to the value*, and the value is now $1 + \frac{i}{2}$. We pay out $50\%$ of the magnitude of the new value, paid with a $\frac{1}{4}$ turn. Check it out:

<div class="compound" data-n="2"></div>

<aside class="info" markdown="block">
Interest payments are the dashed lines. They are $50\%$ of the current value in magnitude and $\frac{1}{4}$ of a turn rotated.
</aside>

Take a moment to look at a circle. Notice how at any point along the edge of a circle the circle is *locally straight*. If you zoom in where the circle intercepts the horizontal axis, the circle looks vertical. In other words, the line tangent to a circle is <span class="info" markdown="inline">perpendicular to the radius</span>.

<aside class="info" markdown="block">
This property is sufficient to define circles.
</aside>

<div class="tangents"></div>

<aside class="info" markdown="block">
Circles are like a bunch of infinitely short right triangles all stacked atop each other.
</aside>

Keep that in mind while we compound three times, paying a third of the value each time and paying out at right angles.

<div class="compound" data-n="3"></div>

<aside class="info" markdown="block">
Make three right triangles where the height is $\frac{1}{3}$ of the previous hypotenuse and stack them atop each other.
</aside>

Do you see what's going on here? The more we compound the interest payments, the less it goes into *increasing* the principle and the more it goes into *turning* the principle.

When the perpendicular growth is compounded continuously (as $n \to \infty$), *all* of the growth goes towards pushing the principle onto a new axis, and *none* of it goes towards growth. Check it out:

<div class="compound" data-n="[1, 2, 3, 4, 5, 6, 7, 10, 20, 30]" data-circle="true"></div>

<aside class="info" markdown="block">
$(1 + \frac{i}{n})^n$ for $n$ from $1$ to $30$.

The more we compound the more the growth goes towards rotating the principle instead of extending it.
</aside>

We're creating shorter and shorter right triangles and stacking them on top of each other. Sound familiar?

> Continuous growth which is always perpendicular to the principle is just another way to say "circular motion".

Woah. That's pretty cool. $e^i = (grow\ 1\ i)$ describes circular motion. How much circular motion? One radius distance. The original principle ($1$) is acting as the radius of the circular motion. The growth rate is $i$ which is just another name for $1$ at a quarter turn. In circular growth the interest never accumulates, it only rotates. $(grow\ 1\ i)$ is one radius-distance of circular movement, also known as "rotation by one radian".

$e^{2i} = (grow\ 1\ 2i)$ is twice as much circular motion: rotation by two radians. And $e^{\pi i} = (grow\ 1\ \pi i)$?

<div class="compound" data-n="[1, 2, 3, 4, 5, 6, 7, 10, 25, 50, 100]" data-circle="true" data-factor="pi"></div>

<aside class="info" markdown="block">
$e^{\pi i} = (grow\ 1\ \pi i) = (rotate\ 1\ \pi)$

Calculated by $\displaystyle \lim\_{n \to \infty} (1 + \tfrac{\pi\ i}{n})^n$.
</aside>

It's $\pi$ radian distances of rotation, which is a walk halfway around the circle.

$e^{\pi i} = \text{--}1$
{:.number}

<aside class="info" markdown="block">
Don't forget to read the @post[aftermath]sample/aftermath.
</aside>
