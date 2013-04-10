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
Note that all numbers are imaginary. Have you ever seen a seven? You can search the deepest reaches of space, but you'll never find a wild eight.
</aside>

Consider the number line. We've been filling it in for millennia. First there were only whole numbers. At that point it wasn't so much a number line as a collection of number dots.

<div class="number-line"></div>
<aside class="info" markdown="block">
The number line in ancient times
</aside>



There was nothing in between the numbers, which were [whole and pure](http://www.youtube.com/watch?v=X1E7I7_r3Cw). Fractions came as a shock to everybody and really started filling things in:

<div class="natural-line"></div>
<aside class="info" markdown="block">
The number line as of 3000 years ago
</aside>

But it didn't stop there. A man was allegedly [murdered](http://en.wikipedia.org/wiki/Hippasus) for discovering irrationals. Zero took an [embarrassingly long time to discover](http://yaleglobal.yale.edu/about/zero.jsp). Negative numbers were [extremely controversial](http://en.wikipedia.org/wiki/Negative_number#History) and were ignored for quite some time.

<div class="number-line"></div>
<aside class="info" markdown="block">
A number line riddled with absurd "negatives numbers" circa 1759CE.
</aside>

Adding new powers to the number line doesn't mean that existing numbers start acting differently. Fractions are useful, but if you if you cut a living friend in half you won't have <span class="info" markdown="inline">half a living friend</span>.

<aside class="info" markdown="block">
If you cut your friends in half I doubt you'll have *any* living friends.
</aside>

The add-ons to numbers are useful *only when they apply*. Negative numbers are great for counting money, but I bet you've never seen a negative cow. Before you use numbers you have to figure out how much Number makes sense for that specific situation.

We've been jamming new features into Number for ages. It should come as no surprise that there are yet more features we can shove into the poor overburdened number line.

The so called "imaginary numbers" are a fairly modern extension. They take the boring old number line and extend it into a *number plane*.

<!--TODO: number plane.-->

There are many ways to turn the number line into a number plane. You've probably already encountered number planes for things like graphs and charts where you write points in the form $(1, 2)$ or $(x, y)$. Using imaginary numbers is just like using $(x, y)$ pairs. In fact, it's identical. The confusing part of imaginary numbers is that we refer to a point on the number plane as *a single two-dimensional number*.

<!--TODO: cartesian plane-->

The "imaginary numbers" are a name for the vertical axis. Together with the original ("real") number line this creates the <span class="info" markdown="inline">complex plane</span>. Points on this plane are two-dimensional numbers.

<aside class="info" markdown="block">
The 'complex plane' is another poorly named @post[contrive]intro/contrives ignored by simplifience.
</aside>

There are a few different ways that you can construct two-dimensional numbers. This "complex plane" is a type of 2D number that is really good at talking about rotation. Rotation (and oscillation) is prevalent in reality.

The complex plane acts how you'd expect a number plane to act, with <span class="info" markdown="inline">one stipulation</span>: multiplication of "complex numbers" works by multiplying the magnitudes and then adding the angles.

<aside class="info" markdown="block">
There are more subtleties to the complex plane which are explored in simplifience proper. We don't need them at the moment.
</aside>

For example, try multiplying the normal old horizontal $3$ (three rotated zero turns) by the vertical $2$ (two rotated a quarter turn):

<!--TODO: 3 * 2-->

You get a vertical six.

Now try <span class="info" markdown="inline">$4\_↺\frac{1}{8}$</span> times $2\_↺\frac{1}{8}$

<aside class="info" markdown="block">
$4\_↺\frac{1}{8}$ is notation for "$4$ rotated by $\frac{1}{8}$ turns".
</aside>

<!--TODO: 4 * 2 -->

You get $8\_↺\frac{1}{4}$. The complex number plane is a number plane where *numbers also have angles*. Multiplication scales the numbers and adds the angles.

The cool thing about a number plane is that the number $1$ has gotten a lot more promiscuous. It used to be that we had just one $1$. Now we have a whole bunch of ones at a all the different angles.

<!--TODO: Unit circle-->

By <span class="info" markdown="inline">convention</span>, we still refer to the original one $(1\_↺0)$ as "one". We have a special name for the vertical one $(1\_↺\frac{1}{4})$. That special name is $i$.

<aside class="info" markdown="block">
A rather ridiculous convention which mainstream simplifience disregards.
</aside>



There's nothing special about imaginaries or complex numbers. Whenever we use imaginary numbers, we're using a *number plane* instead of a *number line*. On this particular number plane, multiplication is done by scaling the lengths and adding the angles. $i$ is a special name for $1\_↺\frac{1}{4}$.

That's all you need to know about $i$ in order to understand @post[Euler's identity]sample/identity.
