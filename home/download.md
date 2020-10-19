---
layout: home
title: Download
subtitle: Download and Install RevBayes
permalink: /download
code_layout: bash
---

<div class="row">
<p>Current version: 1.1.0</p>
<p>New release planned for November 2020. See the <a href="https://github.com/revbayes/revbayes/blob/development/NEWS.md">latest changes</a> on GitHub.</p>
</div>
<br><br>

<div class="row">

<div class="col-sm-4" align="center">
<img src="{{ site.baseurl }}{% link assets/img/apple.png %}" alt="" width="100px" />
<h2>Mac OS X</h2>
<p><a href="https://github.com/revbayes/revbayes/releases/download/1.1.0/RevBayes_OSX_1.1.0.zip" class="btn btn-info" role="button">Download Executable (10.6+)</a></p>
<p>or <a href="{% page_url compile_osx %}">Compile from source</a></p>
</div>

<div class="col-sm-4" align="center">
<img src="{{ site.baseurl }}{% link assets/img/windows.png %}" alt="" width="100px" />
<h2>Windows</h2>
<p><a href="https://github.com/revbayes/revbayes/releases/download/1.1.0/RevBayes_Win_1.1.0.zip" class="btn btn-info" role="button">Download Executable (10)</a></p>
<p>or <a href="{% page_url compile_windows %}">Compile from source</a></p>
</div>

<div class="col-sm-4" align="center">
<img src="{{ site.baseurl }}{% link assets/img/tux.png %}" alt="" width="100px" />
<h2>Linux</h2>
<p><a href="{% page_url singularity %}" class="btn btn-info" role="button">Download Singularity Image</a></p>
<p>or <a href="{% page_url compile_linux %}">Compile from source</a></p>
</div>

</div>

<br><br>
<div class="row">
<p><a href="{% page_url gui_setup %}">Integration with Jupyter and RStudio</a></p>
<p><a href="{% page_url compile_spack %}">Compile with Spack</a></p>
</div>
