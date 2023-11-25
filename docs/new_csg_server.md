# CSG Server Config

In general, we want to have a long-running server for any kind of house-keeping
tasks, and as a safe island on the internet.

In addition, we use this server (CSG server) to host my personal website (
[carlossegarra.com](https://carlossegarra.com)), as well as my `pass` git
server.

This document includes instructions to provision a new CSG server from scratch.

Currently, we use a Scaleway `DEV-M` server, which is accessible at the
following IP:

```bash
ssh csegarra@163.172.177.63
```

the server only allows public-key logging, so you will have to get your public
key in there.

## Setting-up the `pass` server

In order to set-up the pass server, create a new directory in the server and
initialise an empty `git` server:

```bash
mkdir -p csg-pass; cd csg-pass
git init --bare
```

then, in your local `pass` store, update the remote to point to this new
location:

```bash
cd ~/.password-store
git remote set-url origin ${server_ip:or_alias}:/path/to/csg-pass
```

## Setting-up the website

First, we will need to make sure that the `carlossegarra.com` domain points
to the new IP.

The `carlossegarra.com` domain is purchased with IONOS, so you will have to
access their website to change the IP: `https://ionos.es`.

There, it should be straightforward to update the IP that `carlossegarra.com`
points to under DNS configuration.

Second, to deploy the website, make sure that the IP and username variables in
the `csg-web/tasks/deploy.py` are updated, then, clone the repo in the server:

```bash
ssh csg-paris
git clone https://github.com/csegarragonz/csg-web.git
```

in addition, you will have to install and run the `certbot` configuration once:

```bash
sudo apt install -y certbot python3-certbot-apache
sudo certbot certonly --standalone

# Add crontab entry
0 */12 * * * /home/csegarra/csg-web/bin/renew_certs.sh
```

Then, follow the instructions to deploy a self-hosted GitHub runner on the
new server (running under the same user).

Finally, change something on the website to make sure the GHA pipeline works
as expected:

```bash
inv update.last-modified
```
