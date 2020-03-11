---
layout: home
title: Download
subtitle: Download and Install RevBayes
permalink: /download
code_layout: bash
---
<div class="row">

<div class="col-sm-4" align="center">
<img src="{{ site.baseurl }}{% link assets/img/apple.png %}" alt="" width="100px" />
<h2>Mac OS X</h2>
<p><a href="https://github.com/revbayes/revbayes.archive/releases/download/v1.0.13/RevBayes_OSX_v1.0.13.zip" class="btn btn-info" role="button">Download Executable (10.6+)</a></p>
<p>or <a href="{% page_url compile_osx %}">Compile from source</a></p>
</div>

<div class="col-sm-4" align="center">
<img src="{{ site.baseurl }}{% link assets/img/windows.png %}" alt="" width="100px" />
<h2>Windows</h2>
<p><a href="https://github.com/revbayes/revbayes.archive/releases/download/v1.0.13/RevBayes_Win_v1.0.13.zip" class="btn btn-info" role="button">Download Executable (10)</a></p>
<p>or <a href="{% page_url compile_windows %}">Compile from source</a></p>
</div>

<div class="col-sm-4" align="center">
<img src="{{ site.baseurl }}{% link assets/img/tux.png %}" alt="" width="100px" />
<h2>Linux</h2>
<p><a href="https://github.com/revbayes/revbayes.archive/releases/download/v1.0.13/RevBayes_Singularity_v1.0.13.simg" class="btn btn-info" role="button">Download Singularity Image</a></p>
<p><a href="{% page_url singularity %}">(Singularity notes)</a></p>
<hr>
<h3>Compile from source with <a href="https://spack.readthedocs.io/en/latest/">Spack</a></h3>

<pre style="text-align: left">
git clone https://github.com/spack/spack.git
cd spack/bin
./spack install revbayes ~mpi
</pre>

<hr>
<p>or <a href="{% page_url compile_linux %}">Compile from source manually</a></p>

</div>

</div>