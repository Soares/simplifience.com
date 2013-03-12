---
title: Color Scheme Test
---
[Unvisited body link](/nowhere)<br/>
[Visited body link](http://google.com)<br/>
@post[Unvisited stub]newstub<br/>
@post[Visited stub]stub<br/>
<br/>
@post[Missing stub]missing

{% for type in [
  "main",
  "rules",
  "rigor",
  "simplifience",
  "knowledge",
  "rant",
  "caution",
  "define",
  "computer",
  ] %}

<span class="{{ type }}">Commentated.</span>
<em class="{{ type }}">Emphasized.</em>
<strong class="{{ type }}">Strong.</strong>

<aside class="{{ type }} inline" markdown="block">
Commentary text. <br/>
$2 + 2 = 4$<br/>
Fusce eu nunc leo, id volutpat nibh [Visited link](http://google.com). In sit
amet nibh leo. [Unvisited](unvisited). Curabitur nec dui lacus. Aenean
porttitor, ligula vel euismod rutrum, eros est bibendum eros @post[Visited
stub]stub, in sagittis tortor nisl non erat. Suspendisse pulvinar blandit nisl
sed gravida. @post[Unvisited
stub]newstub.

@post[Missing stub]missing.
</aside>

{% endfor %}

Pellentesque ac sapien nisi, at euismod nisl. Cras quis facilisis mi. Nullam
auctor nibh blandit odio ultrices cursus. Vestibulum mollis justo ac tellus
sagittis molestie. Donec in tortor non lacus sagittis congue ut id massa. Sed
lobortis laoreet magna sit amet suscipit. Cum sociis natoque penatibus et
magnis dis parturient montes, nascetur ridiculus mus. Mauris vitae est quis
tellus auctor rutrum vitae facilisis velit. Nullam non diam justo. In pharetra
viverra dui sit amet faucibus. Sed ullamcorper accumsan bibendum. Fusce ornare
metus non elit dictum aliquam. Donec a felis ipsum.

Fusce eu nunc leo, id volutpat nibh. In sit amet nibh leo. Curabitur nec dui
lacus. Aenean porttitor, ligula vel euismod rutrum, eros est bibendum eros, in
sagittis tortor nisl non erat. Suspendisse pulvinar blandit nisl sed gravida.
Etiam ut urna quis arcu gravida blandit eget quis tellus. Morbi ornare nulla
vel nisi posuere in molestie felis commodo. Aenean non leo eros, et varius
erat. Mauris tristique dui et eros tempor dignissim. Aliquam ut ultricies
ligula.
