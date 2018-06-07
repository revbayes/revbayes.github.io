---
layout: home
title: Workshops
subtitle: RevBayes Workshops
permalink: /workshops/
---

Throughout the year, the members of the RevBayes development team and our collaborators teach workshops on molecular evolution, phylogenetics, and Bayesian inference using RevBayes. Additionally, we have occasional <a href="{{ site.baseurl }}{% link workshops/hackathons.md %}">hackathons</a> which bring together developers to work on the software and methods for phylogenetic analysis. 

{% assign workshops = site.pages | where:"layout","workshop" | sort: "startdate" | reverse %}

{% for workshop in workshops %}
	{% capture startdate %}{{ workshop.startdate | date: '%s' | divided_by: 3600 | divided_by: 24 }}{% endcapture %}
    {% if workshop.enddate %}
        {% capture enddate %}{{ workshop.enddate | date: '%s' | divided_by: 3600 | divided_by: 24 }}{% endcapture %}
    {% else %}
        {% assign enddate = startdate %}
    {% endif %}

	{% capture event %}
		<tr class="event" id="{{ startdate }}-{{ enddate }}">
		<td>{{ workshop.startdate | date: "%B %-d, %Y" }}</td>
		<td><a href="{{ site.baseurl }}{{ workshop.url }}">{{ workshop.title }}</a></td>
		<td>{{ workshop.location }}</td>
		<td>{{ workshop.instructors | join: ", " }}</td>
		</tr>
	{% endcapture %}

	{% assign events = events | append: event %}
{% endfor %}

<div id="workshops">
<table class="table table-striped" style="width:100%">
<tr class="header">
<td width="15%"><b>Date</b></td>
<td width="25%"><b>Course Title</b></td>
<td width="25%"><b>Location</b></td>
<td width="25%"><b>Instructors</b></td>
</tr>
{{ events }}
<tr>
    <td>May 31, 2018</td>
    <td><a href="https://revbayes.github.io/revbayes-site/tutorials/model_testing_ppred_inf/">PPS with Revbayes and P3</a></td>
    <td>Columbus, OH</td>
    <td>Lyndon Coghill</td>
</tr>
<tr>
    <td>October 23-27, 2017</td>
    <td><a href="http://www.forbio.uio.no/events/courses/2017/RevBayes_and_BEAST2.html">Bayesian Phylogenetics Workshop</a></td>
    <td>Gothenberg, Sweden</td>
    <td>Walker Pett</td>
</tr>
<tr>
    <td>October 21, 2017</td>
    <td><a href="https://github.com/mlandis/revbayes_fossils">Bayesian fossil tip dating using RevBayes</a></td>
    <td>Geological Society of America Meeting, Seattle, Washington</td>
    <td>Rachel Warnock and Michael Landis</td>
</tr>
<tr>
    <td>September 25-28, 2017</td>
    <td><a href="https://github.com/phyloworks/revbayes-workshop2017">Bayesian inference of phylogenies with RevBayes</a></td>
    <td>International Biogeography Society Meeting, Bangalore, India</td>
    <td>Walker Pett, Tracy Heath</td>
</tr>
<tr>
    <td>August 13-14, 2017</td>
    <td><a href="https://github.com/phyloworks/revbayes-workshop2017">Bayesian Phylogenetics in RevBayes</a></td>
    <td>Iowa State University, Ames, Iowa</td>
    <td>Walker Pett, Tracy Heath</td>
</tr>
<tr>
    <td>August 7-11, 2017</td>
    <td><a href="http://www.nimbios.org/tutorials/revbayes">Bayesian phylogenetics using RevBayes</a></td>
    <td>NIMBioS, Knoxville, Tennessee</td>
    <td>Bastien Boussau, Will Freyman, Emma Goldberg, Tracy A. Heath, Sebastian Höhna, John Huelsenbeck</td>
</tr>
<tr>
    <td>July 20-30, 2017</td>
    <td><a href="https://molevol.mbl.edu/index.php/RevBayes">Bayesian Phylogenetics in RevBayes</a></td>
    <td>Workshop on Molecular Evolution at Woods Hole, Massachusetts</td>
    <td>Tracy Heath and Michael Landis</td>
</tr>
<tr>
    <td>March 11-17, 2017</td>
    <td><a href="http://treethinkers.org/2017-bodega-applied-phylogenetics-workshop/">Workshop in Applied Phylogenetics</a></td>
    <td>Bodega Bay Applied Phylogenetics, California</td>
    <td>Peter Wainright, April Wright, Bob Thomson, Rachel Warnock, Sebastian Höhna,
    Jeremy Brown, Joanna Chiu, Michael Landis, Sam Price, Bruce Rannala</td>
</tr>
<tr>
    <td>January 27, 2017</td>
    <td><a href="http://evomics.org/2017-workshop-on-phylogenomics-cesky-krumlov/">Bayesian phylogenetic inference and divergence time estimation using RevBayes</a></td>
    <td>Workshop on Phylogenomics, Český Krumlov, Czechia</td>
    <td>Tracy Heath</td>
</tr>
<tr>
    <td>January 7-8, 2017</td>
    <td>
        <a href="https://github.com/ssb2017/revbayes_intro">RevBayes Introduction</a>, 
        <a href="https://github.com/ssb2017/revbayes_biogeography">Biogeography</a>, 
        <a href="https://github.com/ssb2017/revbayes_fossils">Fossilized-Birth-Death</a> and 
        <a href="https://github.com/ssb2017/revbayes_reliability">Model Adequacy</a>
    </td>
    <td>SSB Standalone Meeting, Baton Rouge, Louisiana</td>
    <td>Sebastian Höhna, Lyndon Coghill, Will Freyman, Michael Landis, Tracy Heath, Walker Pett, and April Wright</td>
</tr>
<tr>
    <td>December 9+16, 2017</td>
    <td>An introduction to Bayesian phylogenetics and biogeographic dating</td>
    <td>Yale University, New Haven, Connecticut</td>
    <td>Michael Landis</td>
</tr>
<tr>
    <td>July 18-29, 2016</td>
    <td><a href="https://molevol.mbl.edu/index.php/RevBayes">Bayesian Phylogenetics in RevBayes</a></td>
    <td>Workshop on Molecular Evolution at Woods Hole, Massachusetts</td>
    <td>Tracy Heath and Michael Landis</td>
</tr>
<tr>
    <td>March 21-23, 2016</td>
    <td>Phylogenetic inference using RevBayes</td>
    <td>UC Irvine, California</td>
    <td>Sebastian Höhna</td>
</tr>
<tr>
    <td>September 14, 2015</td>
    <td>Bayesian phylogenetic using RevBayes</td>
    <td>LSU, Baton Rouge, Louisiana</td>
    <td></td>
</tr>
<tr>
    <td>July 20-29, 2015</td>
    <td><a href="https://molevol.mbl.edu/index.php/RevBayes">Bayesian Phylogenetics in RevBayes</a></td>
    <td>Workshop on Molecular Evolution at Woods Hole, Massachusetts</td>
    <td>Tracy Heath and Michael Landis</td>
</tr>
<tr>
    <td>June 26, 2015</td>
    <td><a href="http://phyloworks.org/resources/evol2015ws.html">Model-based Molecular Systematics Workshop</a></td>
    <td>Guaruja, Brazil</td>
    <td>Tracy Heath</td>
</tr>
<tr>
    <td>March 2015</td>
    <td><a href="http://phyloworks.org/resources/revbayesintro.html">Introduction to RevBayes</a></td>
    <td>University of Minnesota, St. Paul MN, USA</td>
    <td>Tracy Heath</td>
</tr>
<tr>
    <td>March 23-27, 2015</td>
    <td>Introduction to Bayesian phylogenetics using RevBayes</td>
    <td>UC Berkeley, California</td>
    <td>Sebastian Höhna, Michael Landis, John Huelsenbeck</td>
</tr>
<tr>
    <td>March 8-14, 2015</td>
    <td><a href="http://treethinkers.org/2015-bodega-applied-phylogenetics-workshop/">Workshop in Applied Phylogenetics</a></td>
    <td>Bodega Bay Applied Phylogenetics, California</td>
    <td>Jonathan Eisen, Rich Glor, Tracy Heath, Sebastian Höhna, John Huelsenbeck, Michael Landis, Sarah Longo, Mike May, Brian Moore, Peter Wainwright, Sam Price, Bruce Rannala, Bob Thomson</td>
</tr>
<tr>
    <td>Jan 25 - Feb 7, 2015</td>
    <td><a href="http://evomics.org/workshops/workshop-on-molecular-evolution/2015-workshop-on-molecular-evolution-cesky-krumlov/">Bayesian phylogenetic inference using RevBayes</a></td>
    <td>Molecular Evolution Workshop, Český Krumlov, Czechia</td>
    <td>Sebastian Höhna</td>
</tr>
<tr>
    <td>August 25-31, 2014</td>
    <td><a href="https://www.nescent.org/science/awards_summary.php-id=431.html">NESCent Academy Course: Phylogenetic Analysis Using RevBayes</a></td>
    <td>NESCent, Durham, North Carolina</td>
    <td>Tracy Heath, Brian Moore, Fredrik Ronquist, John Huelsenbeck, Michael Landis, Sebastian Höhna, Tanja Stadler, Bastien Boussau</td>
</tr>
<tr>
    <td>July 28-August 6, 2014</td>
    <td><a href="https://molevol.mbl.edu/index.php/RevBayes">Bayesian phylogenetic inference using RevBayes</a></td>
    <td>Workshop on Molecular Evolution at Woods Hole, Massachusetts</td>
    <td>Tracy Heath and Michael Landis</td>
</tr>
<tr>
    <td>March 11-15, 2013</td>
    <td>First RevBayes workshop</td>
    <td>Groningen University, The Netherlands</td>
    <td></td>
</tr>
</table>
</div>

<script type="text/javascript" src="{{ site.baseurl }}/assets/js/vendor/jquery.min.js"></script>
<script type="text/javascript" src="{{ site.baseurl }}{% link assets/js/workshops.js %}"></script>