# red-graphviz
Graph visualization for Red with graphviz<br>
Dot-language syntax is defined <a href="http://www.graphviz.org/content/dot-language">here</a>.

<h2>Differences from usual Dot syntax:</h2>
<ul><li>Instead of curly braces square braces are used.</li>
<li>Red-graphviz syntax uses set-words instead of "attribute =" (e.g. [color: 'red]).</li>
<li>Ports are mimicked by urls (eg. node:ne) or by get-words, which are attached to strings and tags (e.g. "Are we ready?":e -> &lt;Let's go!&gt;:w). In case of lit-words and numbers, get-word should be separated from the name by space (e.g. 'node :sw).</li>
<li>There are no commas and semicolons.</li>
</ul>
<h2>Differences from usual Red syntax:</h2>
<ul><li>Lit-word may not include dashes.</li>
<li>usual red words cannot (yet) be used for attribute values (e.g. instead of `color: red` `color: 'red` should be used)</li></ul>
