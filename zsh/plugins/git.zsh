#Git 分支查找/Git Commit 查找
_fzf_gco() {
    git branch | fzf | sed -e "s/* //g" | xargs -I {} git checkout {}
}
 
_fzf_gcs() {
    git log --oneline | fzf | grep -o -E "^[0-9a-z]+" | xargs -I {} git show {}
}
