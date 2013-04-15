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
This is not a standard simplifience sequence. It is an intuitive explanation of a formula commonly considered difficult to understand.

This sequence demonstrates how difficult concepts can be made intuitive with the right explanation. The articles here breaks many @post[simplifience policies]intro/taboo. We'll encounter @post[contrives]intro/contrives without fixing them and we'll refer to concepts by their common names instead of making up @post[better ones]intro/names.

All of the concepts covered here show up in greater detail in mainstream simplifience sequences.
</div>

Math is obfuscated by its archaic notation and its clumsy presentation. Take, for example, the strange equation known as "Euler's Identity":

$e^{\pi i} = \text{--}1$
{:.number}

You may have stumbled across this identity before. If you haven't, take a moment to really look at it and realize how extraordinary this is.

This formula claims that $e$ (the base of the natural logarithm, an irrational number) raised to the power $\pi$ (relating circle circumference to diameter, also irrational) times *an imaginary number* is not only *meaningful*, but it's a real whole number: negative one.

This is a mind-bending assertion. One irrational raised to the power of an *imaginary irrational* somehow equal to negative one? This identity surprised and confounded many when it was first discovered.

> Gentlemen, that is surely true, it is absolutely paradoxical; we cannot understand it, and we don't know what it means. But we have proved it, and therefore we know it must be the truth.

That's Benjamin Peirce, an American mathematician and Harvard professor failing to understand the identity.

This is exactly how math shouldn't be.

Euler's identity, it turns out, is easy to understand intuitively, as long as you understand the three building blocks.

<aside class="info" markdown="block">
Follow the links to build up intuitive understandings of $e$, $\pi$, and $i$. Euler's identity will follow.
</aside>

* @post[$e$ is growth]sample/growth.
* @post[$\pi$ is half the circumference of a circle]sample/semicircle.
* @post[$i$ is the number one rotated a quarter turn]sample/imagine.

Once you understand $e$, $\pi$, and $i$ there is only one more @post[contrive]intro/contrives standing in the way of understanding the identity.

You've been taught that $x^5$ means $x\*x\*x\*x\*x$: five $x$s multiplied together. But what's $x^i$? $x$ times itself an imaginary number of times?

Remember that $i$ is no more nor less imaginary than $1$. In fact, $i$ is just $1$ rotated $\frac{1}{4}$ turns. So then $x^i$ is $x$ times itself one time but that one time is rotated? That doesn't make sense.

The contrive here is *exponentiation* -- when you have a number plane instead of a number line, exponentiation isn't just repeated multiplication. The true nature of exponentiation will be revealed in other simplifience sequences. For now, we're going to dodge the problem.

$p * e^x$ is just notation for $(grow\ p\ x)$: grow principle $p$ at rate $x$ compounding continuously. You'll remember that the formula to calculate the end result is <span class="info" markdown="inline">$\displaystyle \lim\_{n \to \infty} p * (1 + \frac{x}{n})^n$</span>.

<aside class="info" markdown="block">
$(1 + \frac{x}{n})$ is amount you grow each time you compound: $100\%$ plus an $n^{th}$ fraction of the interest rate ($x$).

You scale the principle ($p$) by this amount $n$ times.

Continuous growth is growth compounded an infinite number of times. Hence the $\displaystyle \lim\_{n \to \infty}$.
</aside>

Using this formula we have a way to figure out what imaginary exponents mean. At least, we can figure out one particular imaginary exponent: $\displaystyle e^i = 1 * e^i = (grow\ 1\ i) = \lim\_{n \to \infty} 1 * (1 + \frac{i}{n})^n$

The interesting part is this: $e^i = (grow\ 1\ i)$. This is the core of Euler's identity. $(grow\ p\ 1)$ has an obvious meaning: take $p$ and grow it by $100\%$ every time period. But what in the blazes does $(grow\ p\ i)$ mean?

$i$ is just $1$ rotated a quarter turn. So what $(grow\ p\ i)$ means is this:

> Take the principle and grow it by $100\%$ per time period, making the interest perpendicular to the principle.

Remember that the use of $i$ puts us on a number plane, not a number line. It's not enough to say that we add $100\%$ interest: we also have to specify which direction the interest is added in. In the case of $e^i$ the interest is rotated a quarter turn away from the principle.

To see how this works, let's consider growing 1 by $i$, compounding <span class="info" markdown="inline">only once</span>. This is just $1 * (1 + i)^1$ = $1 + i$. You start at one, and then all of the interest is vertical.

<div class="complex-plane"></div>

We've stepped off of the number line and onto the number plane: when you grow a number by $i$, you're going perpindicular.

What if we compound twice? We start with $1$. Then our first interest payment is $\frac{i}{2}$, so we're at $1 + \frac{i}{2}$.

The second interest payment *isn't $\frac{i}{2}$* -  the second interest payment still has a *magnitude* of one half, but remember that all interest payments are <span class="info" markdown="inline">*perpindicular to the principle*</span>, and the principle is now $1 + \frac{i}{2}$. The new interest has a magnitude of $\frac{1}{2}$ but it's given at a right angle to the principle.

<aside class="info" markdown="block">
I'm going to abuse the term "principle" here to mean "the result of the previous step".
</aside>

<div class="compound" data-n="2"></div>

<aside class="info" markdown="block">
Between each point, the distance is $\frac{1}{2}$ and the angle of rotation is $\frac{1}{4}$.
</aside>

Take a moment to look at a circle. Notice how at any point along the edge of a circle the circle is *locally straight*. If you zoom in where the circle intercepts the horizontal axis, the circle looks vertical. In other words, the line tangent to a circle is <span class="info" markdown="inline">perpendicular to the radius</span>.

<aside class="info" markdown="block">
This property is sufficient to define circles.
</aside>

<div class="tangents"></div>

<aside class="info" markdown="block">
Circles are like a bunch of infinitely short right triangles all stacked atop each other.
</aside>

Now let's compound three times. We start with principle $1$ and grow it by $1\_↺\frac{1}{4}$, compounding thrice. The magnitude of growth is $1$ and each new growth adds a quarter-turn. When we compound thrice we'll add three payments of $\frac{1}{3}$, adding a quarter turn each time.

<div class="compound" data-n="3"></div>

<aside class="info" markdown="block">
It's like making three right triangles with height $\frac{1}{3}$ and stacking them atop each other.
</aside>

Do you see what's going on here? The more we compound the interest payments, the less it goes into *increasing* the principle and the more it goes into *turning* the principle.

When the perpendicular growth is compounded continuously (as $n \to \infty$), *all* of the growth goes towards pushing the principle onto a new axis, and *none* of it goes towards growth. Check it out:

<div class="compound" data-n="[1, 2, 3, 4, 5, 6, 7, 10, 20, 30]" data-circle="true"></div>

<aside class="info" markdown="block">
$(1 + \frac{i}{n})^n$ for $n$ from $1$ to $30$.

The more we compound the more the growth goes towards rotating the principle instead of extending it.
</aside>

> Continuous growth which is always perpendicular to the principle is just another way to say "circular motion".

Woah. That's pretty cool. $e^i = (grow\ 1\ i)$ describes circular motion. How much circular motion? One radius distance. The original principle ($1$) is acting as the radius of the circular motion. The growth rate is $i$ which is just another name for $1$ at a quarter turn. In circular growth the interest never accumulates, it only rotates. $(grow\ 1\ i)$ is one radius-distance of circular movement, also known as "rotation by one radian".

$e^{2i} = (grow\ 1\ 2i)$ is twice as much circular motion: rotation by two radians. And $e^{\pi i} = (grow\ 1\ \pi i)$?

<div class="compound" data-n="[1, 2, 3, 4, 5, 6, 7, 10, 25, 50, 100]" data-circle="true" data-factor="pi"></div>

<aside class="info" markdown="block">
$e^{\pi i} = (grow\ 1\ \pi i) = (rotate\ 1\ \pi) = (1 + \frac{i}{n})^n$ shown for $n$ from $1$ to $100$.
</aside>



It's $\pi$ radian distances of rotation, which is a walk halfway around the circle.

$e^{\pi i} = \text{--}1$
{:.number}

You should now have a better understanding not only of Euler's identity but of $e$, $i$, and $pi$. Hopefully this explanation has left you with a number of <span class="info" markdown="inline">questions</span>. A common one is @post[why has nobody told me this]sample/aftermath? In fact, there are a number of ways to make this explanation even more obvious and intuitive. For that, we'll need to dig a little deeper and correct a number of unmentioned @post[contrives]intro/contrives.

<aside class="info" markdown="block">
Why is $\pi$ half a circle?

Why don't we write $1\_{↺\frac{1}{4}}$ instead of $i$?
</aside>

For that, we'll need @post[simplifience]intro/motivation.
