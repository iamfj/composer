# Composer

This docker image of composer contains composer with the most used 
php extensions.

I use composer on every new project directly from a docker container 
and I'm tired of building a new docker image every time a package 
needs an extension.

If I forget an extension, feel free to open a pull request or ticket 
to add it.

# What is Composer?

Composer is a tool for dependency management in PHP, written in PHP. 
It allows you to declare the libraries your project depends on and 
it will manage (install/update) them for you.

You can read more about Composer in [our official documentation](https://getcomposer.org/doc/)
or [our official docker image](https://hub.docker.com/_/composer).

![Composer](https://raw.githubusercontent.com/docker-library/docs/58f7363e6cfa78f8cd54af16eab51c63c1232002/composer/logo.png)

# How to use this image

### Basic Usage

```shell
docker run \
  --rm --interactive --tty \
  --volume $PWD:/app \
  ghcr.io/iamfj/composer/php-latest/composer <command>
```

### Persist cache / global configuration

You can bind mount the Composer home directory from your host to the 
container to enable a persistent cache or share global configuration:

```shell
docker run \
  --rm --interactive --tty \
  --volume $PWD:/app \
  --volume ${COMPOSER_HOME:-$HOME/.composer}:/tmp \
  ghcr.io/iamfj/composer/php-latest/composer <command>
```

**Note:** this relies on the fact that the `COMPOSER_HOME` value is set 
to `/tmp` in the image by default.

### Filesystem permissions

By default, Composer runs as root inside the container. This can lead 
to permission issues on your host filesystem. You can work around 
this by running the container with a different user:

```shell
docker run \
  --rm --interactive --tty \
  --volume $PWD:/app \
  --user $(id -u):$(id -g) \
  ghcr.io/iamfj/composer/php-latest/composer <command>
```

See: https://docs.docker.com/engine/reference/run/#user for details.

**Note:** Docker for Mac behaves differently and this tip might not 
apply to Docker for Mac users.

### Private repositories / SSH agent

When you need to access private repositories, you will either need 
to share your configured credentials, or mount your `ssh-agent` socket 
inside the running container:

```shell
eval $(ssh-agent); \
docker run \
  --rm --interactive --tty \
  --volume $PWD:/app \
  --volume $SSH_AUTH_SOCK:/ssh-auth.sock \
  --env SSH_AUTH_SOCK=/ssh-auth.sock \
  ghcr.io/iamfj/composer/php-latest/composer <command>
```

**Note:** On OSX this requires Docker For Mac v2.2.0.0 or later, 
see [docker/for-mac#410](https://github.com/docker/for-mac/issues/410).

When combining the use of private repositories with running Composer as 
another user, you can run into non-existent user errors (thrown by ssh). 
To work around this, bind mount the host passwd and group files 
(read-only) into the container:

```shell
eval $(ssh-agent); \
docker run \
  --rm --interactive --tty \
  --volume $PWD:/app \
  --volume $SSH_AUTH_SOCK:/ssh-auth.sock \
  --volume /etc/passwd:/etc/passwd:ro \
  --volume /etc/group:/etc/group:ro \
  --env SSH_AUTH_SOCK=/ssh-auth.sock \
  --user $(id -u):$(id -g) \
  ghcr.io/iamfj/composer/php-latest/composer <command>
```

# Available Tags

[Here](https://github.com/iamfj?tab=packages&repo_name=composer) you can find all available tags for different php versions.
