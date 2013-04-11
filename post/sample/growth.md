---
title: Growth
type: simplifience
scripts:
- '@raphael/growth'
---

<div class="caution" markdown="block">
This is not a standard simplifience article. It provides minimal intuition for $e$ necessary to understand @post[Euler's identity]sample/identity. Both $e$ and Euler's identity are @post[contrives]intro/contrives. As a @post[matter of policy]intro/taboo contrives are not mentioned.

This article is an exception to that rule. It's part of an sequence designed to show how "difficult" math can be intuitive when taught from a different point of view. If you already have a good intuition for $e$ you're encouraged to skip this article.
</div>

You've probably been taught that $e$ is $2.718...$ and you might know it has something to do with logarithms. This is a poor way to look at $e$. The true nature of $e$ is simple:

<aside class="info" markdown="block">
We'll move quickly through the derivation of $e$ This sequence is about $e^{\pi i}$, not $e$ itself. The topic of growth will be covered in much more detail in the @post[Growth sequence]growth/intro.
</aside>

> $e$ is growth.

$p * e^x$ is math notation for figuring out how much stuff you get if you start with $p$ and grow it at rate $x$.

Picture a colony of bacteria where each bacteria reproduces once a day. If you start with 100 bacteria and leave them for 10 days you'll have $100 * e^{10} ≈$ <span class="info" markdown="inline">$2,200,000$ bacteria</span>. That's exponential growth for you.

<aside class="info" markdown="block">
You'll probably have fewer, actually: bacteria aren't immortal and don't really reproduce continuously.
</aside>

How do we calculate that growth? We start by imagining non-continuous growth. Consider, for example, your bank account. Say you get $5\%$ interest on your money, to keep things simple. This interest is paid out to you every year. If you start with $100$ dollars in the bank, at the end of the year you'll have $105$ dollars.

| Time                |                         $ |
|:--------------------|--------------------------:|
| January 1st, Year 1 |                     $100$ |
| January 1st, Year 2 | $100 + (100 * 5\%) = 105$ |

<aside class="info" markdown="block">
Notice that adding $5\%$ is the same as multiplying by $1.05$.
</aside>



Now imagine that the bank starts paying interest every six months instead of every year. What happens? Instead of adding 5% once, we add 2.5% twice throughout the year.

| Time                |                                    $ |
|:--------------------|-------------------------------------:|
| January 1st, Year 1 |                                $100$ |
| June 1st, Year 1    |       $100 + (100 * 2.5\%) = 102.50$ |
| January 1st, Year 2 | $102.50 + (102.50 * 2.5\%) = 105.06$ |

The second scenario makes more money. A <span class="info" markdown="inline">whole 6¢</span>! We're rich!

<aside class="info" markdown="block">
6.25¢, if you count quarter-pennies.
</aside>

This happens because the second interest payment includes a little bit of interest on the 2.50\$ added on June 1st.

We can repeat this to get more money. If we pay out 1.25% interest four times a year we end up with $((((100 * 1.0125) * 1.0125) * 1.0125) * 1.0125) =$ <span class="info">$105.09$</span> dollars at the end of the year. That's $100$ (the principle) multiplied by <span class="info" markdown="inline">$1.0125$</span> four times (once for each quarter).

<aside class="info" markdown="block">
Rounding down to the penny.
</aside>

<aside class="info" markdown="block">
$1.0125$ is $100\%$ of the principle $+ 1.25\%$ which is the quarterly interest.

$\displaystyle \frac{5\%\ per\ year}{4\ quarters\ per\ year} = 1.25\%\ per\ quarter$
</aside>

<div class="growth"></div>

If you generalize this to any principle and interest rate you can calculate the growth of your money with the formula $principle * (1 + \frac{rate}{n})^n$, where $n$ is the number of times you compound the money.

$e$ is what happens when you compound your interest lots and lots of times (in other words, when you let $n$ get really really big). We denote this with the following formula:

$\displaystyle p * e^x = \lim\_{n \to \infty} p * (1 + \frac{x}{n})^n$

In other words, you start with your principle $p$ and expand it by an <span class="info" markdown="inline">$n^{th}$ fraction of your interest rate ($x$)</span>, $n$ times.

$p * e^x$ is math shorthand for saying "start with $p$ and grow it for $x$". To keep things clear, we'll use the notation $(grow\ p\ x)$ instead. When you see $(grow\ p\ x)$ it means "however much stuff you have if you start with $p$ and grow it continuously <span class="info" markdown="inline">for $x$</span>".

<aside class="info" markdown="block">
$x$ is of the form $rate * time$. If you grow 100 dollars continuously at $5\%$ a year then you'll have $(grow\ 100\ 15\%) ≈ 116.18$ dollars after three years.
</aside>

Instead of writing $e^{\pi i}$ we write $e^{\pi i} = 1 * e^{\pi i} = (grow\ 1\ i)$, @post[whatever that means]sample/identity.
