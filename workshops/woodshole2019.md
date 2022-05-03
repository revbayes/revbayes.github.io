---
layout: workshop
type: workshop
title: Bayesian Phylogenetics in RevBayes
location: Workshop on Molecular Evolution at MBL, Woods Hole, MA
startdate: 2019-08-01
enddate: 2019-08-11
registration: https://molevol.mbl.edu

description: 
- <p>Instruction in Bayesian phylogenetic inference and divergence-time estimation will be taught at <a href="https://molevol.mbl.edu/index.php/Main_Page">the Workshop on Molecular Evolution</a> at the <a href="http://www.mbl.edu/">Marine Biological Laboratory</a> (MBL). This course was founded in 1988 and is the longest-running workshop serving the field of evolutionary biology. Students work closely with internationally-recognized scientists, receiving (i) high-level instruction in the principles of molecular evolution and evolutionary genomics, (ii) advanced training in statistical methods best suited to modern datasets, and (iii) hands-on experience with the latest software tools (often from the authors of the programs they are using). The material is delivered via lectures, discussions, and bioinformatic exercises motivated by contemporary topics in molecular evolution. A hallmark of this workshop is the direct interaction between students and field-leading scientists. The workshop serves graduate students, postdocs, and established faculty from around the world seeking to apply the principles of molecular evolution to questions of anthropology, conservation genetics, development, behavior, physiology, and ecology. The workshop also welcomes participants from federal agencies and science journalists. A priority of this workshop is to foster an environment where students can learn from each other as well from the course faculty.</p><p>For the full workshop content, list of faculty, and schedule, please see the <a href="https://molevol.mbl.edu/index.php/Schedule">main course website</a>.</p><p>Instructions for working with the RevBayes tutorials on MBL computing resources are provided in the section on <a href="woodshole2019#using-revbayes-on-the-mbl-cluster">Using RevBayes on the MBL Cluster</a> below.</p>

instructors:
- <a href="http://mlandis.github.io/">Michael Landis</a>
- <a href="http://phyloworks.org/">Tracy Heath</a>
- <a href="http://willpett.github.io">Walker Pett</a>
- <a href="https://ib.berkeley.edu/people/faculty/huelsenbeckj">John Huelsenbeck</a>
- <a href="https://phylogeny.uconn.edu/">Paul Lewis</a>

software:
- <a href="https://github.com/revbayes/revbayes/releases/tag/v1.0.10">RevBayes v1.0.10</a> or <a href="https://github.com/revbayes/revbayes/releases/tag/v1.0.12">v1.0.12 (Mac only)</a> 
- <a href="http://tree.bio.ed.ac.uk/software/tracer/">Tracer</a>
- <a href="http://tree.bio.ed.ac.uk/software/figtree/">FigTree</a>
- A simple text editor, such as Sublime Text, NotePad++, TextWrangler, BBEdit, vim, or emacs 

schedule:
  - starttime: 2019-08-04T09:00
    endtime: 2019-08-04T12:00
    topic: "Lecture: Bayesian Phylogenetics"
    material: <a href="https://molevol.mbl.edu/index.php/Paul_Lewis">Lecture slides and other materials</a>
    instructors: Paul Lewis
  
  - starttime: 2019-08-22T12:00
    endtime: 2019-08-22T14:00
    topic: Lunch
  
  - starttime: 2019-08-04T14:00
    endtime: 2019-08-04T15:30
    topic: "Lecture: Phylogenetic Inference and Graphical Models"
    material: <a href="https://molevol.mbl.edu/images/4/44/Lecture_phylo_pgm_mlandis_WH2019.pdf">Lecture slides</a>
    instructors: Michael Landis

  - starttime: 2019-08-04T15:30
    endtime: 2019-08-04T16:00
    topic: "Lab: Intro to RevBayes"
    tutorials: intro
    instructors: Michael Landis

  - starttime: 2019-08-04T16:00
    endtime: 2019-08-04T17:00
    topic: "Lab: Phylogenetic Inference under the JC Model"
    tutorials: ctmc
    instructors: Michael Landis

  - starttime: 2019-08-04T17:00
    endtime: 2019-08-04T19:00
    topic: Dinner

  - starttime: 2019-08-04T19:00
    endtime: 2019-08-04T20:00
    topic: "Lab: Phylogenetic Inference under HKY & GTR Models"
    tutorials: ctmc
    instructors: Walker Pett

  - starttime: 2019-08-04T20:00
    endtime: 2019-08-04T21:00
    topic: "Lecture: Bayesian Divergence-Time Estimation"
    material: <a href="https://figshare.com/articles/Bayesian_Divergence-Time_Estimation_Lecture/6849005">Lecture slides</a>
    instructors: Tracy Heath

  - starttime: 2019-08-04T21:00
    endtime: 2019-08-04T22:00
    topic: "Lab: Divergence-Time Estimation in RevBayes (part 1)"
    tutorials: fbd
    instructors: Walker Pett

  - starttime: 2019-08-05T09:00
    endtime: 2019-08-05T17:00
    topic: <a href="https://molevol.mbl.edu/index.php/Schedule">See course schedule</a>

  - starttime: 2019-08-05T19:00
    endtime: 2019-08-05T20:30
    topic: "Lecture: Likelihood-based Phylogenetic Inference"
    material: <a href="https://molevol.mbl.edu/index.php/John_Huelsenbeck">Lecture slides and other materials</a> 
    instructors: John Huelsenbeck

  - starttime: 2019-08-05T20:30
    endtime: 2019-08-05T22:00
    topic: "Lab: Divergence-Time Estimation in RevBayes (part 2)"
    tutorials: fbd
    instructors: Walker Pett
---

## Using RevBayes on the MBL Cluster 

### Executing RevBayes

For the tutorials used in this workshop, you may want to use the version of RevBayes on the MBL cluster. 

Once you log in, you can use RevBayes from any directory on the cluster by just typing `rb`.

```
rb
```
{:.bash}


```
Build from master (94149b) on Mon Jul 23 15:55:28 EDT 2019

Visit the website www.RevBayes.com for more information about RevBayes.

RevBayes is free software released under the GPL license, version 3. Type 'license()' for details.

To quit RevBayes type 'quit()' or 'q()'.


>
```
{:.Rev-output}

### Downloading Data Files

Some of the tutorials you will us have data files associated with them. You will find hyperlinks to all of the required files on the tutorial page. These should be listed in the "Data files and scripts" box at the top of the tutorial page below the table of contents.

For this workshop, we recommend that you create a new folder for each tutorial that you work through. 
Follow the directions in the tutorial for creating your directory structure. 
Then download the individual files using `wget`.

For example, in the tutorial on divergence times, you will need to download the sequence data file:

```
wget https://revbayes.github.io/tutorials/fbd/data/bears_cytb.nex
```
{:.bash}

### Writing Rev Scripts

Some tutorials require that you write several modular Rev scripts to define your model and MCMC analysis. 
We reccomend that you compose these files on your own computer or using the text editor on the MBL cluster.
If you create these files on your personal machine, you will have to upload them to the cluster using `scp` or cyberduck.





