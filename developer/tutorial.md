---
title: Writing a user tutorial
category: Developer
index: 4
code_layout: none
---

Writing a tutorial for fun and profit!

Including a citation
==================

### Markdown:
```markdown
{% raw %}This is a citation {% cite Felsenstein1981 %}.{% endraw %}
``` 
### Output:
This is a citation {% cite Felsenstein1981 %}

Including a figure
==================

### Markdown:
```markdown
{% raw %}{% figure example %}
<img src="images/example.png" width="200">
{% figcaption %}
This is an example figure caption. You can include *Markdown* and $\LaTeX$.
{% endfigcaption %}
{% endfigure %}

This is a reference to {% figref example %}{% endraw %}
``` 
### Output:
{% figure example %}
<img src="images/example.png" width="200">
{% figcaption %}
This is an example figure caption. You can include *Markdown* and $\LaTeX$.
{% endfigcaption %}
{% endfigure %}
 
This is a reference to {% figref example %}