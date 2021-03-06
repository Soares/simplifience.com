---
title: Simpliquations
stub: Simplifience equation notation explained explicitly.
---
Simplifience won't be using math equations.

This is in part due to the fact that @post[math is not a thing]foundations/mathematics.

Mostly it's because @post[math is archaic]math/archaic. The syntax of mathematics is old and poorly thought out. It is confusing and intimidating to newcomers. It doesn't display nicely on computer screens.

I don't mean to discourage you from using math equations: if you are already comfortable with math syntax, then by all means, continue using it. It is quite terse and compact.

Terseness and compactness are not the allies of education.

Compare the following:

$\displaystyle \lim\_{n\to\infty} p * (1 + \frac{r}{n})^n$



<paren><v>principle</v><func>increased by</func>

<div class="equation">
<span class="blue parenthesis">(</span><span class="teal variable">principle</span>
<span class="operation">increased by</span>
<span class="violet parenthesis">(</span><span class="red variable">rate</span>
<span class="operation">divided by</span>
<span class="orange variable">n</span><span class="violet parenthesis">)</span>
<span class="orange variable">n</span>
<span class="operation">times</span><span class="blue parenthesis">)</span>
<span class="operation">as</span>
<span class="orange variable">n</span>
<span class="operation">approaches infinity</span>
</div>

These equations say the same things. The first is far denser and is intuitive only if you have already internalized the quirks and customs of mathematics. The other is simple to understand for anyone who speaks English.

Both equations have the same level of rigor. Language is @post[a powerful tool]language/scope, and it is @post[difficult to say simple things]language/simplicity -- English is not a good medium for discussing how the universe works. In order to describe the universe, we must use a notation that leaves no room for misinterpretation: *but that language need not be mathematics*.

Simplifience will use a language @post[more suited to newcomers]intro/notation.



Notation may look something like:

@@
=|is
⩤|increased by
⋯|repeated
÷|divided by
p:principle
r:rate
o:output
n:count
@@

@@
n:number of compoundings
o = p [⩤ ⋯ n] (r ÷ n)
@@

In english, the output is the principle increased by an n<sup>th</sup> of the rate, n times, where n is the number of compoundings.

<div class="equation">
  <span class="variable o" data-symbol="o">output</span>
  <span class="operator is" data-symbol="=">is</span>
  <span class="variable p" data-symbol="p">principle</span>
  <div class="brackets one">
    <span class="open">[</span>
    <span class="operator increasedBy" data-symbol="⩤">increased</span>
    <span class="operator repeated" data-symbol="⋯">repeated</span>
    <span class="variable n" data-symbol="n">compoundings</span>
    <span class="close">]</span>
  </div>
  <div class="parenthesis two">
    <span class="open">(</span>
    <span class="variable r" data-symbol="r">rate</span>
    <span class="operator dividedBy" data-symbol="÷">divided by</span>
    <span class="variable n" data-symbol="n">compoundings</span>
    <span class="close">)</span>
  </div>
</div>
