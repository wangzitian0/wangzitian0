title: Git个人总结
author: 田_田
tags:
  - Tools
  - Best Practice
categories: []
date: 2014-11-20 12:28:00
---
## 基本使用

基本使用可以查看阮神博客，我只摘取我自己常用的命令 [ruanyf's blog](http://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html)，注释里面添加的缩写为 oh-my-zsh 里面的 alias 命令。

<!-- more -->


### 新建代码库

初始化一个Git仓库，使用`git init` 或者 `git clone` 命令 从已有项目中克隆。
```
# 在当前目录新建一个Git代码库
$ git init
# 新建一个目录，将其初始化为Git代码库
$ git init [project-name]
# 下载一个项目和它的整个代码历史
$ git clone [url]
```
### 配置
Git的设置文件为.gitconfig，它可以在用户主目录下（全局配置），也可以在项目目录下（项目配置）。
```
# 设置提交代码时的用户信息
$ git config [--global] user.name "[name]"
$ git config [--global] user.email "[email address]"
```
### 增加/删除文件
```
# ga 添加指定文件/子目录到暂存区
$ git add [file1] [dir]
# 删除工作区文件/子目录到暂存区
$ git rm [file1] [dir]
# 添加当前目录的所有文件改动到暂存区
$ git add .
# 停止追踪指定文件，但该文件会保留在工作区
$ git rm --cached [file]
# 改名文件，S -> T
$ git mv [S] [T]
```
### 代码提交
```
# gcmsg 提交暂存区到仓库区
$ git commit -m [message]
# 提交暂存区的指定文件到仓库区
$ git commit [file1]... -m [message]
# 提交时显示所有diff信息
$ git commit -v

# 在 review 不通过等情况下，可以通过这个命令撤销+再提交 commit
# 使用一次新的commit，替代上一次提交。   这是一个实用命令！
$ git commit --amend -m [message]
```

### 分支
```
$ git branch               # gb  列出所有本地分支
$ git branch -a            # gba 列出所有本地分支和远程分支
$ git branch [branch-name] # 新建一个分支，但依然停留在当前分支
$ git checkout -b [branch] # gco 新建一个分支，并切换到该分支

# 新建一个分支，指向指定commit
$ git branch [branch] [commit]

# gco 切换到指定分支，并更新工作区
$ git checkout [branch-name]

# 建立追踪关系，在现有分支与指定的远程分支之间
$ git branch --set-upstream [branch] [remote-branch]

# gm 合并指定分支到当前分支
$ git merge [branch]

# gcp 选择一个commit，合并进当前分支。超级实用命令，典型场景可以把自己的某一次改动并入主分支。
$ git cherry-pick [commit]

# gbd 删除分支
$ git branch -d [branch-name]

# 删除远程分支
$ git branch -dr [remote/branch]
```

### 标签
```
# 列出所有tag
$ git tag

# 新建一个tag在当前commit
$ git tag [tag]

# 删除本地tag
$ git tag -d [tag]

# 删除远程tag
$ git push origin :refs/tags/[tagName]

# 提交指定tag
$ git push [remote] [tag]

# 提交所有tag,   gpoat = git push origin all tag 
$ git push [remote] --tags
```

### 查看信息
```
# gst 显示有变更的文件
$ git status

# glg 显示commit历史，以及每次commit发生变更的文件
$ git log --stat

# glol 显示某个commit之后的所有变动，每个commit占据一行
$ git log [tag] HEAD --pretty=format:%s

# 显示某个commit之后的所有变动，其"提交说明"必须符合搜索条件
$ git log [tag] HEAD --grep feature

# 显示某个文件的版本历史，包括文件改名
$ git log --follow [file]
$ git whatchanged [file]

# 显示指定文件相关的每一次diff
$ git log -p [file]

# 显示过去5次提交
$ git log -5 --pretty --oneline

# 显示所有提交过的用户，按提交次数排序
$ git shortlog -sn

# gbl 显示指定文件是什么人在什么时间修改过
$ git blame [file]

# gd 显示暂存区和工作区的差异
$ git diff

# gdca 显示暂存区和上一个commit的差异
$ git diff --cached [file]

# 显示工作区与当前分支最新commit之间的差异
$ git diff HEAD

# 显示两次提交之间的差异
$ git diff [first-branch]...[second-branch]
```

### 远程同步
```
# gf 下载远程仓库的所有变动
$ git fetch

# gr -v 显示所有远程仓库
$ git remote -v

# 显示某个远程仓库的信息
$ git remote show [remote]

# gra 增加一个新的远程仓库，并命名
$ git remote add [shortname] [url]

# gl 取回远程仓库的变化，并与本地分支合并
$ git pull [remote] [branch]

# gp 上传本地指定分支到远程仓库
$ git push [remote] [branch]

# 强行推送所有分支当前分支到远程仓库，即使有冲突
$ git push [remote] --all --force
```

### 撤销
```
# 恢复暂存区的指定文件到工作区
$ git checkout [file]

# 恢复某个commit的指定文件到暂存区和工作区
$ git checkout [commit] [file]

# 恢复暂存区的所有文件到工作区
$ git checkout .

# 重置暂存区的指定文件，与上一次commit保持一致，但工作区不变
$ git reset [file]

# 重置暂存区与工作区，与上一次commit保持一致
$ git reset --hard

# 重置当前分支的指针为指定commit，同时重置暂存区，但工作区不变
$ git reset [commit]

# 重置当前分支的HEAD为指定commit，同时重置暂存区和工作区，与指定commit一致
$ git reset --hard [commit]

# 重置当前HEAD为指定commit，但保持暂存区和工作区不变
$ git reset --keep [commit]

# 新建一个commit，用来撤销指定commit
# 后者的所有变化都将被前者抵消，并且应用到当前分支
# 比如线上回滚，一般会保留挂掉的提交，然后 revert 新建提交来回滚。
$ git revert [commit]

# 暂时将未提交的变化移除，稍后再移入。非常实用的命令，避免在文件夹之间拷贝内容
$ git stash
$ git stash pop
```

## Github工作流
Github是强调多人合作的做法，而且希望工程实现持续集成。算是一种比较优美的工作流。

- 第一步：根据需求，从master拉出新分支，不区分功能分支或补丁分支。
- 第二步：新分支开发完成后，或者需要讨论的时候，就向master发起一个pull request（简称PR）。
- 第三步：Pull Request既是一个通知，让别人注意到你的请求，又是一种对话机制，大家一起评审和讨论你的代码。对话过程中，你还可以不断提交代码。
第四步：你的Pull Request被接受，合并进master，重新部署后，原来你拉出来的那个分支就被删除。（先部署再合并也可。）

## git branch 策略

Git Flow常用的分支

- Production 分支
 - 也就是我们经常使用的Master分支，这个分支最近发布到生产环境的代码，最近发布的Release， 这个分支只能从其他分支合并，不能在这个分支直接修改
- Develop 分支
 - 这个分支是我们是我们的主开发分支，包含所有要发布到下一个Release的代码，这个主要合并与其他分支，比如Feature分支
- Feature 分支
 - 这个分支主要是用来开发一个新的功能，一旦开发完成，我们合并回Develop分支进入下一个Release
- Release分支
 - 当你需要一个发布一个新Release的时候，我们基于Develop分支创建一个Release分支，完成Release后，我们合并到Master和Develop分支
- Hotfix分支
 - 当我们在Production发现新的Bug时候，我们需要创建一个Hotfix, 完成Hotfix后，我们合并回Master和Develop分支，所以Hotfix的改动会进入下一个Release
 
 
## Best Practice
- Never work on master
- Pulling master should never create a merge commit
- Tests are run after pull and before commit
- Describe Features in Issues
- Work on Issue Specific Feature Branches
- Regularly git rebase origin/master Feature Branches to updated master
- Interactive Rebase before Creating Pull Request
- Peer Review Pull Request
- Delete Feature Branch after Pull Request Approval