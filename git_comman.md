# git branch

```
# create new branch
git branch branch_name

git switch branch_name

# rename branch
git branch -m new_brach_name

# delete a branch
git branch -d branch_name


# merge branch
# for merge: go to the target branch and merge, for example go to the master branch and merge develop to master branch

git switch master
git merge develop



```
## git checkout
```
# git checkout
# this command can work to switch between commit, branch, files 

git checkout commit_hash


```

# git restore
```
# git restore used for restore a specific file from previous commit
git restore --source=1fbcb2c myfile.txt
git add .
git commit -m "restored myfile form '1fbcb2c' commit "

git restore --source=HEAD~4 myfile.txt

# also used for back a file to begining of a commit

```



# git reset
```
# git reset allow us to remove commits and reset the branch

```

# git stash
```
git stash
git stash pop



```
