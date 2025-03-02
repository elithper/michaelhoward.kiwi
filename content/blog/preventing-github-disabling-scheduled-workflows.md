+++
title = "Preventing GitHub from disabling my scheduled certificate renewal workflow"
date = "2025-03-02"
description = "How I stopped my scheduled GitHub Actions TLS certificate renewal workflow from being disabled every 60 days"
tags = ["GitHub Actions"]
+++

## Intro

In January, I set up a GitHub Actions workflow to renew the certificate on _assets.michaelhoward.kiwi_, the subdomain I use for object storage. Each month, the workflow uses David Coles' [acme-linode-objectstorage](https://github.com/dcoles/acme-linode-objectstorage) tool to request a new TLS certificate and handle the resulting ACME challenge.

## The problem

It was all working suspiciously smoothly[^1] until I received an email from GitHub saying the scheduled workflow was about to be disabled.

![GitHub's email warning the workflow would be disabled](/images/workflow-expiration-email.png "but why tho?")

I was confused. What's the point of scheduling a workflow that requires routine intervention?

It turns out this is intended behaviour (for public repositories, at least). As noted [in the docs](https://docs.github.com/en/actions/managing-workflow-runs-and-deployments/managing-workflow-runs/disabling-and-enabling-a-workflow?tool=webui) (emphasis mine):

> To prevent unnecessary workflow runs, scheduled workflows may be disabled automatically. When a public repository is forked, scheduled workflows are disabled by default. **In a public repository, scheduled workflows are automatically disabled when no repository activity has occurred in 60 days.**

I'm not a fan of this, since manually re-enabling the workflow every 60 days largely defeats the purpose of the automation. Ideally, I'd be able to disable this behaviour, but alas.

Instead, I had two options:

- Set up more automation to make regular dummy commits to the repo
- Make the repo private

## The solution

For the sake of simplicity, I opted for the latter. The repository's visibility is now set to private, which is a shame because I'm sure there's someone out there who'd want to do something similar.

While I understand GitHub doesn't want the headache of millions of workflows in abandoned repos running indefinitely, it would be nice to set up personal automation like this and still keep it public.

In future, I'll have to make sure that all of my scheduled workflows are in private repositories.

## The workflow

For posterity, I'm including the workflow file at the end of this post.

For the action to run, `BUCKET_NAME` must be set to the custom domain used for the bucket, e.g. `assets.michaelhoward.kiwi`.

Additionally, two secrets need to be added to the repository:

- `ACCOUNT_KEY`: a Let's Encrypt account key generated locally with `openssl genrsa 4096`.
- `LINODE_TOKEN`: a Linode API key with the object storage read/write permissions.

Note that it's also possible to trigger the workflow manually through either GitHub's web interface or command line client.

```yaml
name: Renew certificate for Linode Object Storage

on:
  schedule:
    - cron: '0 0 1 * *'
  workflow_dispatch:


jobs:
  renew_cert:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          repository: dcoles/acme-linode-objectstorage
      - uses: actions/setup-python@v5
        with:
          python-version: '3.13'
      - name: Install Python deps and run cert update tool
        run: |
          echo -e "$ACCOUNT_KEY" > ./account_key.pem
          pip install -r requirements.txt
          python -m acme_linode_objectstorage -k ./account_key.pem --agree-to-terms-of-service "$BUCKET_NAME"
        env:
          BUCKET_NAME: ${{ vars.BUCKET_NAME }}
          LINODE_TOKEN: ${{ secrets.LINODE_TOKEN }}
          ACCOUNT_KEY: ${{ secrets.ACCOUNT_KEY }}
```

[^1]: Certainly much more smoothly than waiting for a periodic email from Let's Encrypt telling me the certificate was about to expire and then manually completing the ACME challenge to renew it.
