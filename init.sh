mkdir themes
git clone https://github.com/next-theme/hexo-theme-next themes/next
git clone https://github.com/theme-next/theme-next-han source/lib/Han

git config --global filter.gitignore.clean "sed '\/#gitignore$/'d"
git config --global filter.gitignore.smudge cat

export HEXO_ALGOLIA_INDEXING_KEY=6a2714c5b665823e7132db2aedb81233

# /home/zitian/ftest/wangzitian0/themes/next/layout/_third-party/comments/gitment.swig    id: window.location.pathname   ->  id: '{{ page.date }}',
# https://draveness.me/git-comments-initialize

# https://github.com/theme-next/hexo-leancloud-counter-security
