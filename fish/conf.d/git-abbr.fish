# Editing files
abbr --add srcf ". ~/.config/fish/config.fish"
abbr --add codef "code ~/.config/fish/"

# Git
abbr --add ga "git add"
abbr --add gst "git status"
abbr --add gc "git commit --verbose"
abbr --add gca "git commit --all --verbose"
abbr --add gcm "git commit -m"
abbr --add gcam "git commit --all -m"
abbr --add gcaa "git commit --all --amend"

abbr --add glog 'git log --oneline --decorate --graph'
abbr --add glog10 'git log --oneline --decorate --graph HEAD~10..HEAD'
abbr --add gdiff 'git diff | less --tabs=4 -RFX --pattern "^(Date|added|deleted|modified): "'
abbr --add gprom 'git pull --rebase origin master'
abbr --add gprop 'git pull --rebase origin master-passing-tests'

abbr --add guar "git undo; and git add .; and git redo"

abbr --add grs "git restore --staged"
abbr --add grs "git restore --staged"

# Checkout
abbr --add gco "git checkout"
abbr --add gcom "git checkout master"
abbr --add gcob "git checkout -b jdelaney/"

abbr --add gmp "git checkout master; and git pull"

# Bazel
abbr --add bt "bazel test --test_output=streamed"