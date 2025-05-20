# CSG's dotfiles

If you are setting up a new machine, follow the step by step guide [here](./docs/new_dev_server.md).

## Building `workon` images

In the `docker` directory, we store dockerfiles to capture the development
environment of different projects we are actively working on. To buildd them
just run:

```bash
inv docker.build <target>
```
