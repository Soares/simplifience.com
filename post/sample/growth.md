---
title: Growth
type: simplifience
scripts:
- '@raphael/growth'
---

<div class="caution" markdown="block">
This is not a standard simplifience article. It provides minimal intuition for $e$ necessary to understand @post[Euler's identity]sample/identity. Both $e$ and Euler's identity are @post[contrives]intro/contrives, which are @post[normally avoided]intro/decontriving.
</div>

You've probably been taught that $e$ is $2.718...$ and you might know it has something to do with logarithms. This is a poor way to look at $e$. The true nature of $e$ is simple:

<aside class="info" markdown="block">
We'll move quickly through the derivation of $e$ This sequence is about $e^{\pi i}$, not $e$ itself. The topic of growth will be covered in much more detail in the @post[Growth sequence]growth/intro.
</aside>

> $e$ is growth.

$p * e^x$ is math notation for figuring out how much stuff you get if you start with $p$ and grow it at rate $x$.

Imagine you have a colony of 100 bacteria. They each reproduce once per day. At the end of ten days, <span class="info" markdown="inline">how many bacteria</span> are there?

<aside class="info" markdown="block">
Assume immortal super-bacteria.
</aside>

At a first glance, it looks like you'll end up with about $100 * 2^{10} = 102,400$ bacteria, because the population doubles ten times. You'll actually find over $100 * e^{10} = 2,200,000$ bacteria -- more than twice as much!

Why? Because the bacteria don't reproduce in an orderly fashion. They don't all suddenly reproduce in the last minute of the day. Some reproduce hours before midnight. Others reproduce at noon, and still others reproduce in the morning.

The new second-generation bacteria born throughout day 1 start reproducing *immediately*. Some of them manage to squeeze out a child of their own before midnight. Before the end of the first day, you already have a bunch of second-generation and even a handful of *third-generation* bacteria floating around. Not many, but enough to throw off the numbers. When you compound this effect for ten days, the impact is enormous.

This is called "continuous growth". It happens when something grows and the new growths also start growing. How much impact does continuous growth have? If the growth is continuous enough, can you get *infinite* growth? If not, what's the cutoff?

These are good questions. In order to answer them we'll start with something simpler: non-continuous growth.

Consider your bank account. Imagine you get $10\%$ interest per year, to keep things simple. If you start with $100$ dollars in the bank, at the end of the year you'll have <span>$</span>110.

| Time                |                          $ |
|:--------------------|---------------------------:|
| January 1st, Year 1 |                      $100$ |
| January 1st, Year 2 | $100 + (100 * 10\%) = 110$ |

Now imagine that the bank starts paying interest every six months instead of every year. What happens? Instead of adding 10% once, we add 5% twice throughout the year.

| Time                |                            $ |
|:--------------------|-----------------------------:|
| January 1st, Year 1 |                        $100$ |
| June 1st, Year 1    |    $100 + (100 * 5\%) = 105$ |
| January 1st, Year 2 | $105 + (105 * 5\%) = 110.25$ |

<aside class="info" markdown="block">
Notice how adding $5\%$ is the same as multiplying by $1.05$.
</aside>

The second scenario makes more money. A whole 25¢! We're rich!

This happens because the second interest payment includes a little bit of interest on the <span>$</span>5 added on June 1st.

We can repeat this to get more money. If we pay out $2.5\%$ interest four times a year we end up with $((((100 * 1.025) * 1.025) * 1.025) * 1.025) =$ <span>$</span>110.38 at the end of the year. That's $100$ (the principle) multiplied by <span class="info" markdown="inline">$1.025$</span> four times (once for each quarter).

<aside class="info" markdown="block">
$1.025$ is $100\%$ of the principle plus $2.5\%$.

$\displaystyle \frac{10\%\ per\ year}{4\ quarters\ per\ year} = 2.5\%\ per\ quarter$
</aside>

If you generalize this to any principle and interest rate you can calculate the growth of your money with the formula $principle * (1 + \frac{rate}{n})^n$, where $n$ is the number of times you compound the money. This reads as "Take your principle and increase it by an $n^{th}$ fraction of the interest rate, $n$ times."

Let's see it in action with some simpler numbers. In order to visualize the interest, I want you to pretend that your bank pays you <span class="info" markdown="inline">$100\%$ interest per year</span>.

<div class="growth" data-compounds="1"></div>
<aside class="info" markdown="block">
Your money doubles every time period.

It's compounded once, so you end up with twice as much money.
</aside>

Now watch what happens when we keep the interest rate the same but compound *twice* every time period:

<div class="growth" data-compounds="2"></div>

You get the same amount of interest on the principle (shown by the teal blocks) but it's split into two payments. Then you also get *interest on your interest* (the blue block). This is the mechanism by which continuous growth can make you rich.

Unfortunately, it can't make you infinitely rich. Compounding gives diminishing returns.

<div class="growth" data-compounds="[3, 4, 5, 6, 7]"></div>

There's a cap on how much interest your interest can generate, even if you compound with infinitely fine granularity.

<div class="growth" data-compounds="0"></div>

<aside class="info" markdown="block">
If you want more you'll have to increase either your interest rate or your time period: $p * 2.718...$ is the maximum amount of money you can in a year at an interest rate of $100\%$ per year.
</aside>

It turns out that the maximum amount of growth you can get from *continuously doubling* for one time period is $≈ 271.8\%$ growth. We call this $e$, and we'll learn *why* it's roughly $2.718$ in later simplifience articles.

Remember that the growth of $p$ at rate $x$ compounded $n$ times can be calculated by $p * (1 + \frac{x}{n})^n$, which means "increase $p$ by an $n^{th}$ fraction of your interest rate $x$, $n$ times". $e$ is a name for what happens when we let $n$ get really large:

$\displaystyle p * e^x = \lim\_{n \to \infty} p * (1 + \frac{x}{n})^n$

$p * e^x$ is math shorthand for saying "start with $p$ and grow it continuously for $x$". To keep things clear, we'll use the notation $(grow\ p\ x)$ instead. When you see $(grow\ p\ x)$ it means "however much stuff you have if you start with $p$ and grow it continuously <span class="info" markdown="inline">for $x$</span>".

<aside class="info" markdown="block">
$x$ is of the form $rate * time$. If you grow <span>$</span>100 continuously at $25\%$ for two years then you'll have $(grow\ 100\ 50\%) ≈$ <span>$</span>164.87.
</aside>

This is all you need to know about $e$ in order to understand @post[Euler's identity]sample/identity, which is much easier to understand once you know that $e^{\pi i}$ means $(grow\ 1\ i)$.
