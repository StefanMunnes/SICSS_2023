---
marp: true
size: 16:9
paginate: true
_paginate: false
title: Introduction to Workflow and Git(Hub)
_class: invert
footer: SICSS Berlin - Day 1 - 2023/07/03
---

<!-- headingDivider: 1 -->

# Introduction to Workflow and Git(Hub)


# Best practice: **Folder and file structure**

1. separate folders for scripts, data, output, and reports
2. raw data files separate from processed data
3. clear and consistent names for script and output files
4. numbering, lowercase, and separate words with underscores or hyphens
5. if date necessary, usually in the end, sort by YYYYMMDD
6. multiple script files for different (sub) tasks (max 100 lines)


# Best practice: **Efficient R scripts**

1. define libraries, default variables, source code at top of script
2. comment and structure sections (# ---- headline ----)
3. use pipe operator |> (magritter: %>%) for combining functions
4. use indentations and spaces for readability
5. [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) - use lists, lapply, vectorization, and functions
6. use relative paths for data and output
7.  avoid hard coded subsetting and indexing


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

- Swiss army knife of coding and file management
  - search (and replace) in whole project folder
  - side-by-side editor windows
  - better file and folder management
  - customizable (with extensions)
- multiple languages supported (e.g. R, Python, LaTeX, Markdown)
- Git(Hub): easy integration for better workflow
- with R:
  - run multiple R Sessions in parallel
  - scripts still editable if process busy


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
- share, publish, and collaborate on projects


# Git: **How to use it**

|         | Ease of use                           | Efficiency                          | Nerdiness                             |
| ------- | ------------------------------------- | ----------------------------------- | ------------------------------------- |
| CLI     | $\bullet\circ\circ\circ\circ$         | $\bullet\bullet\circ\circ\circ$     | $\bullet\bullet\bullet\bullet\bullet$ |
| GUI     | $\bullet\bullet\bullet\circ\circ$     | $\bullet\bullet\bullet\circ\circ$   | $\bullet\bullet\circ\circ\circ$       |
| RStudio | $\bullet\bullet\bullet\bullet\circ$   | $\bullet\bullet\bullet\circ\circ$   | $\bullet\bullet\bullet\circ\circ$     |
| VSCode  | $\bullet\bullet\bullet\bullet\bullet$ | $\bullet\bullet\bullet\bullet\circ$ | $\bullet\bullet\bullet\bullet\circ$   |

---

![bg 65%](img/Git-Working-Tree.png)


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

# GitHub: **Remote and cooperative workflow**

```
$ git clone <git-repo-url>

$ git branch < branch-name>
$ git checkout <name-of-your-branch>
OR BOTH IN ONE
$ git checkout -b <name-of-your-branch>

$ git push -u (<remote> OR origin) <branch-name> 

& git fetch
& git merge <branch-name>
OR BOTH IN ONE
$ git pull <remote> (<branch-name>)

$ git fork 
```

# GitHub: **Credentials**

- for GitHub remote commands: username and personal access token needed
- Settings $\rightarrow$ Developer Setting $\rightarrow$ Personal Access Tokens $\rightarrow$ Generate new token
- on local machine enter username and PAT every time, or:
  1. `git config credential.helper store`
  2. use VSCode


# GitHub: **.gitignore**

**Why:** text file with folders and files (patterns) not to track

**What:** sensitive data; temp and old files; big data files; outputs
  $\rightarrow$ usually track just plain text files (e.g. R scripts, TeX source, etc.) 

**How:** 2 approaches ([helpful online tool creates content automatically](https://www.toptal.com/developers/gitignore))

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

1. install git
2. create a GitHub account
3. tell user name to become a collaborator
4. clone our course material [**repository**](https://www.github.com/StefanMunnes/SICSS_Berlin_2023)
5. add a personal folder and test file
6. push this changes to the remote repository
7. pull changes of the other participants
