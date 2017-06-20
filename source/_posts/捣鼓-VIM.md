title: 捣鼓 VIM
author: 田_田
tags:
  - Tools
categories: []
date: 2016-03-19 11:43:00
---
近期花了不少时间弄vim，把几个github上星星数较高的的试了一遍。

<!-- more -->

```
amix/vimrc
skwp/dotfiles
spf13/spf13-vim
```
有的冲突还是非常严重的，比如spf13的markdown插件和自动补全neocomplete插件就一直有冲突，看了很久都解决不了，弃疗之。 
最后选了humiaozuzu/dot-vimrc为原型的版本自己定制，这个版本非常清爽。 
直接复制源下来，然后拷贝到合适的位置，用vundle自动安装。
```
git clone git://github.com/humiaozuzu/dot-vimrc.git
~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
```

Setup Vundle:
```
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
```
Install bundles. Launch vim(ignore the errors and they will disappear after installing needed plugins)and run:
```
:BundleInstall
```
然后是ubuntu记得装一下下面的vim 扩展包（server版本庄vim-nox）
```
sudo apt-get install vim-gtk
```
今天先到这，后续慢慢写使用心得。