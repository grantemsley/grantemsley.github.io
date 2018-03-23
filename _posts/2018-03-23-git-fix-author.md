---
title: Fix author name in commits
category: Git

---

Sometimes I commit things from a new system where I haven't properly set my name and email address. This make github not attribute those commits to me.  So how do I fix that?

## Set your name so it doesn't happen again

To set it for the whole system, use:
```
git config --global user.name "Correct Name"
git config --global user.email "youremail@address.com"
```

If you want to set it only for the repository you are working in, omit the `--global` flag.

## Correct name in most recent commit

For the last commit done, it's really easy to fix this.  This command will change the author name and email address:

```
git commit --amend --author="Correct Name <youremail@address.com>"
```

You should think twice about doing this if you've already pushed the commit.  It will replace that previous commit, and anyone else who has already pulled the changes will end up having trouble pulling the new version.

## Correct all instances of your incorrect name

So maybe you didn't notice at first that git wasn't using your name, and commited a bunch of things.  [Github has a nice little script for that](https://help.github.com/articles/changing-author-info/).

Remember though that this will rewrite history.  That makes it really hard to sync changes others may have made to their own repos, invalidates pull requests, and causes all other sorts of havoc. If there are a lot of other people using your repository, don't do this.

But if it's a repo that only you are using, or you don't mind forcing everyone else to clone a fresh copy of the repo and throw away any unmerged changes, it does work.

Basically you:
1. Make sure you have a good, completely up to date, copy of your repo somewhere to fall back on if this goes wrong
2. Open Git Bash
3. Create a bare clone of your repository
```
git clone --bare https://github.com/user/repo.git
cd repo.git
```
4. Save this script to a file and edit the settings at the top to match your incorrect and correct info
```
#!/bin/sh

git filter-branch --env-filter '
OLD_EMAIL="your-old-email@example.com"
CORRECT_NAME="Your Correct Name"
CORRECT_EMAIL="your-correct-email@example.com"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
```
5. Run the script
6. Force push the corrected history with `git push --force --tags origin 'refs/heads/*'`
7. Once you've made sure everything looks good on github, delete the `repo.git` folder
8. Check out a fresh copy of your repo as normal

There are ways to update your existing repo with the updated history, but a normal `git pull` command will just throw errors.  It's generally easier to just clone a fresh copy.