# Orca

The main commands are:

```bash
orca build   SERVICE [SERVICE ...]
orca deploy  SERVICE [SERVICE ...]
orca refresh SERVICE [SERVICE ...]
```

Don't be afraid to read the `orca` source, it is a single ~300-line file with comments.

## Installing Orca

`orca init` will set up LXD for you, assuming a ZFS pool is available called "data".

It's possible to use LVM or file-backed LXD instead.

## Services

To create a new service, create a folder at `./service/$NAME`. All files in the service directory will automatically be copied to `/` at the root of the container upon build.

The base image is deployed in the same way as a service, and can be used as an example.

There's a special file at `./service/$NAME/service` allowing you to hook various points in the build. This file uses shell functions, like the below code block. The first arg (`$1`) to each function is the lxd container name being used for your service.

Use `./orca deploy $NAME` to deploy your new service. Deploying a service first builds it as `orca-$NAME-build`, and if that is successful, replaces any running `orca-$NAME` with the built container. If you run into problems during the build, you can login to the build container with `lxc exec orca-$NAME-build bash` and inspect it, then try a deploy again after fixing your service script.

### Example `service` file

```bash
# service_build allows you to fully control the lxd container creation
#   don't define this unless you want to use a different base image
#   see orca_lxd_build_base in the `orca` script for an example of a manual service_build()
# service_build() {
#     # if service_build isn't defined, the default is to call an internal function:
#     orca_lxd_clone_base "$1"
# }

# service_prep is called on the host, before the build container starts for your service
#   this is mostly used for mounting disk images, or setting autostart order
service_prep() {
}

# service_setup is called inside the build container. This is where you run
#   apt-get, chmod, systemctl enable, etc.
service_setup() {
}

# service_deploy is called outside the container, immediately before
#   starting it after a build is done. This is a good time to set a static IP.
service_deploy() {
}

# service_refresh is run outside the container after you exec `orca refresh $NAME`
#   if you don't define it:
#     1. your service files will be pushed into the container,
#     2. service_setup will run
#     3. then the container will restart
#   defining it replaces step 3, allowing a graceful restart, e.g. `systemctl reload nginx`
# service_refresh() {
# }
```
