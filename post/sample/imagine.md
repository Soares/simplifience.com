---
title: Imagine
type: simplifience
scripts:
- '@raphael/number-line'
---

<div class="caution" markdown="block">
This is not a standard simplifience article. It provides minimal intuition for $i$ necessary to understand @post[Euler's identity]sample/identity. Both $i$ and Euler's identity are @post[contrives]intro/contrives. As a @post[matter of policy]intro/taboo contrives are not mentioned.

This article is an exception to that rule. It's part of an sequence designed to show how "difficult" math can be intuitive when taught from a different point of view. If you already have a good intuition for the complex plane you're encouraged to skip this article.
</div>

$i$ is called the "imaginary number", as if all numbers weren't imaginary. Let's correct that misconception now: $i$ is no more <span class="info" markdown="inline">nor less</span> imaginary than any other number.

<aside class="info" markdown="block">
Note that all numbers are imaginary. Have you ever seen a seven? You can search the deepest reaches of outer space, but you'll never find a wild eight.
</aside>

Consider the number line. We've been filling it in for millennia. First there were only whole numbers. At that point it wasn't so much a number line as a collection of number points.

<div class="number-line" data-only-numbers="yes" data-positives="yes"></div>
<aside class="info" markdown="block">
The number line in ancient times
</aside>



There was nothing in between the numbers, which were [whole and pure](http://www.youtube.com/watch?v=X1E7I7_r3Cw). Fractions came as a shock to everybody and really started filling things in:

<div class="number-line" data-positives="yes"></div>
<aside class="info" markdown="block">
The number line as of 3000 years ago
</aside>

But it didn't stop there. A man was allegedly [murdered](http://en.wikipedia.org/wiki/Hippasus) for discovering irrationals. Zero took an [embarrassingly long time to discover](http://yaleglobal.yale.edu/about/zero.jsp). Negative numbers were [extremely controversial](http://en.wikipedia.org/wiki/Negative_number#History) and were ignored for quite some time.

<div class="number-line"></div>
<aside class="info" markdown="block">
A number line circa 1759CE, riddled with those absurd "negative numbers".
</aside>

We've been filling in the number line for millenia. It's important to remember that discovering new types of Number doesn't make the *old* types of Number stop working: fractions are useful, but if you if you cut a living friend in half you won't have <span class="info" markdown="inline">$\frac{1}{2}$ a living friend</span>.

<aside class="info" markdown="block">
If you cut your friends in half I doubt you'll have *any* living friends.
</aside>

The add-ons to numbers are useful *only when they apply*. Negative numbers are great for counting money, but I bet you've never seen a negative cow. Before you use numbers you have to figure out how much Number makes sense for your specific situation.

We've been jamming new features into the term "Number" for ages. It should come as no surprise that there are yet more features we can shove into the overburdened number line.

The so called "imaginary numbers" are a fairly modern extension. They take the boring old number line and extend it into a *number plane*.

<div class="number-plane"></div>

There are many ways to turn the number line into a number plane. You've already encountered number planes for things like graphs and charts where you write points in the form $(1, 2)$ or $(x, y)$. Using imaginary numbers is just like using $(x, y)$ pairs. The confusing part of imaginary numbers is that we refer to a point on the number plane as *a single <span class="info" markdown="inline">two-dimensional number</span>*.

<aside class="info" markdown="block">
You can invent 3D or even 4D numbers. You can make up all sorts of crazy complications. The word "number" is a very loose term.
</aside>

The "imaginary numbers" you've heard so much about are just the vertical axis. Together with the original ("real") number line this creates the <span class="info" markdown="inline">complex plane</span>. Points on this plane are two-dimensional numbers.

<aside class="info" markdown="block">
The 'complex plane' is another poorly named @post[contrive]intro/contrives ignored by simplifience.
</aside>

<div class="complex-plane"></div>

The entity $2 + 3i$ is written in two parts. Though disjoint, it is @post[describing]reality/symbology a single unified 2D number (marked by the red dot). Why do we write one number in two parts? Because the standard notation for complex numbers is silly.

There are a few different ways that you can construct two-dimensional numbers. This "complex plane" is a type of 2D number that is really good at talking about rotation. Rotation, as it happens, is prevalent in reality.

<aside class="info" markdown="block">
These particular 2D numbers are also really good at describing oscillation.
</aside>

Because the complex plane is especially good at expressing rotation we'll use a different syntax for these 2D numbers. Specifically, we'll write them like $3\_{↺\frac{1}{8}}$, where $3$ is the length of the number and $\frac{1}{8}$ is how much it's rotated.

The complex plane acts how you'd expect a number plane to act, with one stipulation: multiplication of "complex numbers" works by multiplying the lengths and adding the rotations.

For example, try multiplying $3\_{↺0}$ (three horizontal 3) by $2\_{↺\frac{1}{4}}$ (the vertical 2).

<div class="polar-plane"></div>

You get a $6\_{↺\frac{1}{4}}$ which is the vertical six.

The complex number plane is a number plane where *numbers also have angles*. Multiplication scales the numbers and adds the angles.

The cool thing about a number plane is that the number $1$ has gotten a lot more promiscuous. It used to be that we had just one $1$. Now we have a whole bunch of ones at a all the different angles.

<div class="one-plane"></div>
<aside class="info" markdown="block">
Every point on that solid circle is a different variant of $1$, ranging from $1\_{↺0}$ through $1\_{↺\frac{1}{2}}$ all the way around to $1\_{↺1}$.
</aside>



By <span class="info" markdown="inline">convention</span>, we still refer to the original one $(1\_{↺0})$ as "one". We have a special name for the vertical one $(1\_{↺\frac{1}{4}})$. That special name is $i$.

<aside class="info" markdown="block">
A rather ridiculous convention which mainstream simplifience disregards.
</aside>


There's nothing special about imaginaries or complex numbers. Whenever we use imaginary numbers, we're using a *number plane* instead of a *number line*. On this particular number plane, multiplication is scaling and rotation. $i$ is a special name for $1\_{↺\frac{1}{4}}$.

There are some more subtleties to the complex number plane, but that's all you need to know about $i$ in order to understand @post[Euler's identity]sample/identity.
