---
title: Imagine
type: simplifience
scripts:
- '@raphael/number-line'
---

<div class="caution" markdown="block">
This is not a standard simplifience article. It provides minimal intuition for $i$ necessary to understand @post[Euler's identity]sample/identity. Both $i$ and Euler's identity are @post[contrives]intro/contrives, which are @post[normally avoided]intro/decontriving.
</div>

$i$ is called the "imaginary number", as if all numbers aren't imaginary. Let's correct that misconception now: $i$ is no more <span class="info" markdown="inline">nor less</span> imaginary than any other number.

<aside class="info" markdown="block">
Note that all numbers are imaginary. Have you ever seen a seven? I'm not asking about @post[the symbol]reality/symbology, but the thing which it represents. You can search the deepest reaches of outer space, but you'll never find a wild seven.
</aside>

Consider the number line. We've been filling it in for millennia.

First there were only whole numbers. You can't really even call it a number line: it's more of a collection of number dots.

<div class="number-line" data-only-numbers="yes" data-positives="yes"></div>
<aside class="info" markdown="block">
The number line in ancient times
</aside>

There was nothing in between the numbers, which were whole and pure. Fractions came as a shock to everybody and really started filling things in:

<div class="number-line" data-positives="yes"></div>
<aside class="info" markdown="block">
The number line as of 3000 years ago
</aside>

But it didn't stop there. A man was allegedly [murdered](http://www.youtube.com/watch?v=X1E7I7_r3Cw) for discovering irrationals. Zero took an [embarrassingly long time to discover](http://yaleglobal.yale.edu/about/zero.jsp). Negative numbers were [extremely controversial](http://en.wikipedia.org/wiki/Negative_number#History) and were ignored for quite some time.

<div class="number-line"></div>
<aside class="info" markdown="block">
A number line circa 1759CE, riddled with those absurd "negative numbers".
</aside>

It's important to remember that discovering new types of Number doesn't make the *old* types of Number stop working: fractions are useful, but if you if you cut a living friend in half you won't have <span class="info" markdown="inline">half a living friend</span>.

<aside class="info" markdown="block">
If you cut your friends in half I doubt you'll have *any* living friends.
</aside>

The new features of the number line are only useful *when they apply*. Negative numbers are great for counting money, but I bet you've never seen a negative cow. Before you use numbers you have to figure out how much Number applies to your specific situation.

We've been jamming new features into the term "Number" for millennia. It should come as no surprise that there are yet more features we can shove into the overburdened number line.

The so called "imaginary numbers" are a fairly modern extension. They take the boring old number line and extend it into a *number plane*.

<div class="number-plane"></div>

There are many ways to turn the number line into a number plane. You've already encountered number planes for things like graphs and charts where you write points in the form $(1, 2)$ or $(x, y)$. Using imaginary numbers is just like using $(x, y)$ pairs. The confusing part of imaginary numbers is that we refer to a point on the number plane as *a single <span class="info" markdown="inline">two-dimensional number</span>*.

<aside class="info" markdown="block">
You don't have to stop there. You can invent 3D numbers too. Or even 4D numbers. You can make up all sorts of crazy features. "Number" is a very loose term.
</aside>

The "imaginary numbers" you've heard so much about are just the vertical axis of the number plane. Together with the original ("real") number line this creates the <span class="info" markdown="inline">complex plane</span>. Points on this plane are two-dimensional numbers.

<aside class="info" markdown="block">
The 'complex plane' is another poorly named @post[contrive]intro/contrives ignored by simplifience.
</aside>

<div class="complex-plane"></div>

The entity $2 + 3i$ is written in two parts. Don't let the notation confuse you: though disjoint, it is @post[describing]reality/symbology a single unified 2D number (marked by the red dot). Why do we write one number in two parts? Don't ask me. It's a silly convention.

There are a few different ways that you can construct two-dimensional numbers. The complex plane is a type of 2D number that is really good at talking about rotation. Rotation, as it happens, is <span class="info" markdown="inline">prevalent in reality</span>.

<aside class="info" markdown="block">
It's how you get from one dimension to another dimension.
</aside>

In the interest of clarity we'll introduce a new syntax for these 2D numbers that makes it easy to see their rotation. We'll write them like $3\_{↺\frac{1}{8}}$, where $3$ is the size of the number and $\frac{1}{8}$ is how much it's rotated.

The complex plane acts how you'd expect a number plane to act, with one stipulation: multiplication of "complex numbers" works by multiplying the lengths and adding the rotations.

For example, try multiplying $3\_{↺0}$ (three horizontal 3) by $2\_{↺\frac{1}{4}}$ (the vertical 2).

<div class="polar-plane"></div>

<div class="asides">
<style>
  .tick {opacity: 0.3}
  .tick.active {opacity: 1}
</style>
<aside class="info tick zero" markdown="block">
$3\_{↺\ 0}$ multiplied by $2\_{↺\frac{1}{4}}$
</aside>
<aside class="info tick one" markdown="block">
$3 * 2$
</aside>
<aside class="info tick two" markdown="block">
$↺\ 0$ plus $↺\frac{1}{4}$
</aside>
<aside class="info tick three" markdown="block">
$= 6\_{↺\frac{1}{4}}$
</aside>


</div>

You get a $6\_{↺\frac{1}{4}}$ which is the vertical six, also known as $6i$.

The complex number plane is a number plane where *numbers also have angles*. Multiplication scales the numbers and adds the angles.

The cool thing about a number plane is that the number $1$ has gotten a lot more promiscuous. It used to be that we had just one $1$. Now we have a whole bunch of ones at a all the different angles.

<div class="one-plane"></div>
<aside class="info" markdown="block">
Every point on that solid circle is a different variant of $1$, ranging from $1\_{↺0}$ through $1\_{↺\frac{1}{2}}$ all the way around to $1\_{↺1}$.
</aside>



By <span class="info" markdown="inline">convention</span>, we still refer to the original one $(1\_{↺0})$ as "one" and the half-turned one $(1\_{↺\frac{1}{2}})$ as "negative one". We have a special name for the vertical one $(1\_{↺\frac{1}{4}})$. That special name is $i$.

<aside class="info" markdown="block">
A rather ridiculous convention which mainstream simplifience disregards.
</aside>


There's nothing special about imaginaries or complex numbers. Whenever we use imaginary numbers, we're using a *number plane* instead of a *number line*. On this particular number plane, multiplication is scaling rotation.

There are some more subtleties to the complex number plane, but that's all you need to know about $i$ in order to understand @post[Euler's identity]sample/identity.
