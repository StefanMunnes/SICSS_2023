---
marp: true
title: Introduction to Workflow and Git(Hub)
_class: invert
footer: SICSS Berlin - Day 1 - 2023/07/03
size: 16:9
paginate: true
_paginate: false
math: mathjax
headingDivider: 1
---

# Introduction to Workflow and Git(Hub)

<!--
- first day: go one with more formal and technical stuff
- share some over all experience and recommendations for good workflow
- working with data and code, reports and presentations
1. folder and file structure
2. small advertisement for using a code editor 
3. using git and github, getting course material and work together
-->


# Best practice: **Folder and file structure**

1. use separate folders for scripts, data, output, and reports
2. separate raw data files from processed data
3. use clear and consistent names for script, data, and output files:
	- numbering, lowercase, connect words with underscores or hyphens
	- if date is necessary, put at the end, sort by YYYYMMDD
4. multiple script files for different (sub) tasks (max 100 lines)

<!--
- different styles and also personnel preferences
- just some recommendations from our own work experience
- become really handy when collaborating with other's
- in the end: needs to work for you, and your collaborates
- use pre- and suffixes
-->

# Best practice: **Efficient R scripts**

1) define libraries, default variables, source code at top of script
2) comment and structure sections (# ---- headline ----)
3) use pipe operator |> (magritter: %>%) for combining functions
4) use indentations and spaces for readability
5) max line length of 80 characters
6) [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) - use lists, lapply, vectorization, and functions
7) use relative paths for data and output
8)  avoid hard coded subsetting and indexing


# Best practice: **Resources**

- [Best Coding Practices for R](https://bookdown.org/content/d1e53ac9-28ce-472f-bc2c-f499f18264a3/folder.html)
- [Structuring R projects](https://www.r-bloggers.com/2018/08/structuring-r-projects/)
- [R Best Practices](https://kdestasio.github.io/post/r_best_practices/)
- [Tips for organising your R code](https://www.r-bloggers.com/2023/01/tips-for-organising-your-r-code/)
- [Nice R Code](https://nicercode.github.io/)
- [Repeating things: looping and the apply family](https://nicercode.github.io/guides/repeating-things/)


# Code Editor: **VSCode**

![h:530 drop-shadow:0,10px,20px,rgba(0,0,0,.4)](img/r_vscode.png)


# Code Editor: **Benefits**

- Swiss army knife for coding and file management
  - search (and replace) in whole project folder
  - side-by-side editor windows
  - better file and folder management
  - customizable (with extensions)
- multiple languages supported (e.g. R, Python, LaTeX, Markdown)
- easy Git(Hub) integration for better workflow
- with R:
  - run multiple R Sessions in parallel
  - scripts still editable if process is busy


# Code Editor: **Resources**

- https://code.visualstudio.com/docs/languages/r
- https://renkun.me/2019/12/11/writing-r-in-vscode-a-fresh-start/
- https://schiff.co.nz/blog/r-and-vscode/
- https://rolkra.github.io/R-VSCode/


# Git: **Idea and concept**

![bg left:40% 75%](img/xkcd_files.png)

- distributed version control system
- track and document changes in code
- compare and find differences
- "time travel maschine"
- helps to imagine changes as smaller tasks
- collaborate on projects, share and publish them

<!--
- started 2005 by Linus Torvald
  
- mostly used by software developers
- more and more in academia: open data -> open code
  
- steep learning curve
- recommend to test this two weeks and see how it goes and if useful
-->

# Git: **How to use it**

|                                                         | Ease of use                           | Efficiency                          | Nerdiness                             |
| ------------------------------------------------------- | ------------------------------------- | ----------------------------------- | ------------------------------------- |
| CLI                                                     | $\bullet\circ\circ\circ\circ$         | $\bullet\bullet\circ\circ\circ$     | $\bullet\bullet\bullet\bullet\bullet$ |
| [GUI](https://de.wikipedia.org/wiki/Liste_von_Git-GUIs) | $\bullet\bullet\bullet\circ\circ$     | $\bullet\bullet\bullet\circ\circ$   | $\bullet\bullet\circ\circ\circ$       |
| RStudio                                                 | $\bullet\bullet\bullet\circ\circ$     | $\bullet\bullet\bullet\bullet\circ$ | $\bullet\bullet\bullet\circ\circ$     |
| VSCode                                                  | $\bullet\bullet\bullet\bullet\bullet$ | $\bullet\bullet\bullet\bullet\circ$ | $\bullet\bullet\bullet\bullet\circ$   |

<!--
- small table compares different variants to use git
- first place a simple tool used from the command line
  
- following I will show commands: helps to see the workflow and learn keywords and concepts
- using GUI or CE does the same but much more user friendly
-->

---

![bg 70%](img/git_flow.gif)

<!--
- small graph with the basics command and workflow
- important: local and remote
- commands always start with git
- then command what you want to do
- mostly followed by arguments and options

- I present commands -> concepts are the same in a GUI, named identical
-->

# Git: **First and basic steps**

```
$ git config --global user.name <your name>
$ git init <your repository name>
$ git status

$ git add <file-name-1> <file-name-2> OR --all
$ git commit -m “<commit-message>”
OR BOTH IN ONE
$ git commit -am “<commit-message>”
```

<!--
- git config: first step after installation
- sets the author name (and email) address respectively to be used with your commits
- git init is used to start a new repository
- git status gives us all the necessary information about the current branch
  whether the current branch is up to date
  Whether there is anything to commit, push or pull
  Whether there are files staged, unstaged or untracked
  Whether there are files created, modified or deleted
- git add adds file(s) or all to the staging area
- git commit records or snapshots the file permanently in the version history
-->

# GitHub: **Remote and cooperative workflow**

```
$ git clone <git-repo-url>

$ git branch < branch-name>
$ git checkout <name-of-your-branch>
OR BOTH IN ONE
$ git checkout -b <name-of-your-branch>

$ git push

& git fetch
& git merge <branch-name>
OR BOTH IN ONE
$ git pull <remote> (<branch-name>)

$ git fork 
```

<!--
- git clone makes an identical copy of the latest version of a project in a repository and saves it to your computer
By using branches, several developers are able to work in parallel on the same project simultaneously
- git branch creates a new branch
- use git checkout mostly for switching from one branch to another
- git push sends the committed changes of master branch to your remote repository
- git fetch update your local dev branch:
- git merge merges your new branch with the parent/main branch.
- git pull fetches and merges changes on the remote server to your working directory
- git fork creates a linked copie from other people's repositories.
-->

# GitHub: **Credentials**

- for GitHub remote commands: Account and personal access token needed
- Settings $\rightarrow$ Developer Setting $\rightarrow$ Personal Access Tokens $\rightarrow$ Generate new token
- on local machine enter username and PAT every time, or:
  1. `git config credential.helper store`
  2. use VSCode


# GitHub: **.gitignore**

**How it works:** text file with folder names and files (patterns) not to track

**Use case:** sensitive data; temp and old files; big data files; outputs
  $\rightarrow$ usually track just plain text files (e.g. R scripts, TeX source, etc.) 

**Get startet:** 2 approaches ([helpful online tool creates content automatically](https://www.toptal.com/developers/gitignore))

```
/data/old
passworts.txt
*.doc
------OR------
/*
!.gitignore
!/scripts
```

# Git: **Resources**

- [Intro to Git, for the Social Scientist](https://www.nimirea.com/blog/2019/05/10/git-for-social-scientists/)
- [Git for Social Scientists](https://jortdevreeze.com/en/blog/how-git-can-make-you-a-more-effective-social-scientist/)
- [Git for Students in the Social Sciences](https://www.shirokuriwaki.com/programming/kuriwaki_github_handout.pdf)
- [GitHub - The Perks of Collaboration](https://cosimameyer.com/post/git-the-perks-of-collaboration-and-version-control/)
- [AI tool suggesting git command](https://www.gitfluence.com/)


# Exercise: **Course material**

![bg left:40% 90%](img/github_setup.png)

0. find in groups
1. install git
2. create a GitHub account
3. become collaborator (tell user name)
4. clone our course material [**repository**](https://www.github.com/StefanMunnes/SICSS_Berlin_2023)
5. add a personal folder and test file
6. push this changes to the remote repository
7. pull changes of the other participants
