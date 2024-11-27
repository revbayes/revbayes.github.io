---
layout: home
title: Download
subtitle: Download and Install RevBayes
permalink: /download
code_layout: bash
---

<div class="row">
<p>Current version: {{ site.version }}</p>
<p>See the <a href="https://github.com/revbayes/revbayes/blob/development/NEWS.md">list of changes</a> on GitHub.</p>
</div>
<br><br>


<div class="row">

<div class="col-sm-4" align="center">
<img src="{{ site.baseurl }}{% link assets/img/apple.png %}" alt="" width="100px" />
<h2>Mac OS X</h2>
<p><a href="https://github.com/revbayes/revbayes/releases/download/{{ site.version }}/revbayes-{{ site.version }}-mac-intel64.tar.gz" class="btn btn-info" role="button">Download Intel Executable (10.11+)</a></p>
<p><a href="https://github.com/revbayes/revbayes/releases/download/{{ site.version }}/revbayes-{{ site.version }}-mac-arm64.tar.gz" class="btn btn-info" role="button">Download Apple Silicon Executable (10.11+)</a></p>
<p>or <a href="{% page_url compile_osx %}">Compile from source</a></p>
</div>

<div class="col-sm-4" align="center">
<img src="{{ site.baseurl }}{% link assets/img/windows.png %}" alt="" width="100px" />
<h2>Windows</h2>
<p><a href="https://github.com/revbayes/revbayes/releases/download/{{ site.version }}/revbayes-{{ site.version }}-win64.tar.gz" class="btn btn-info" role="button">Download Executable (10)</a></p>
<p>or <a href="{% page_url compile_windows %}">Compile from source</a></p>
</div>

<div class="col-sm-4" align="center">
<img src="{{ site.baseurl }}{% link assets/img/tux.png %}" alt="" width="100px" />
<h2>Linux</h2>
<p><a href="https://github.com/revbayes/revbayes/releases/download/{{ site.version }}/revbayes-{{site.version}}-linux64.tar.gz" class="btn btn-info" role="button">Download Executable</a></p>
<p><a href="https://github.com/revbayes/revbayes/releases/download/{{ site.version }}/revbayes-{{site.version}}-linux64-singularity.simg" class="btn btn-info" role="button">Download Singularity Image</a></p>
<p>or <a href="{% page_url compile_linux %}">Compile from source</a></p>
</div>

</div>

<br><br>
<div class="row">
<p><a href="{% page_url interfaces %}">RevBayes Interface Tools</a> (GUIs and notebooks)</p>
<p><a href="{% page_url compile_spack %}">Compile with Spack</a></p>
</div>
