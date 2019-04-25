# red-graphviz

Graph visualization for Red with graphviz

Dot-language syntax is defined [here](https://graphviz.gitlab.io/_pages/doc/info/lang.html).

## Differences from normal Dot syntax:

* Instead of curly braces square braces are used.

* Red-graphviz syntax uses set-words instead of "attribute =" (e.g. `color: 'red`]).

* Node ports are mimicked by urls (eg. `node:ne`) or by get-words, which are attached to strings and tags (e.g. `"Are we ready?":e -> <Let's go!>:w`). In case of lit-words and numbers, get-word should be separated from the name by space (e.g. `'node :sw`).

* There are no commas and semicolons.

## Differences from normal Red syntax:

* Lit-word may not include dashes.

* usual red words cannot (yet) be used for attribute values (e.g. instead of `center: true` `center: 'true` should be used)
