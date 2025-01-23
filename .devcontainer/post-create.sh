#!/bin/sh

# write keys to file
mkdir -p ~/.ssh
echo "$CS_PRIVATE_KEY" > ~/.ssh/id_ed25519
echo "$CS_PUBLIC_KEY" > ~/.ssh/id_ed25519.pub

# set appropriate permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

# add Sourcehut to known_hosts to avoid prompt
ssh-keyscan -t ed25519 git.sr.ht > ~/.ssh/known_hosts

# set up multiple remotes
git remote add all git@github.com:elithper/"$RepositoryName"
git remote set-url --add all git@git.sr.ht:~elithper/"$RepositoryName"
git branch --set-upstream-to master
