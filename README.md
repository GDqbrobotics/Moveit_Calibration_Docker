# Docker for Moveit Calibration on ROS Noetic


## 0. Overview
This repository contains a Docker and all the documentation required to launch an [Intel Realsense camera](https://www.intel.co.uk/content/www/uk/en/architecture-and-technology/realsense-overview.html) with the [Moveit Calibration Noetic repo](https://github.com/moveit/moveit_calibration).

## 1. Creating a Docker
There are two different approaches for creating a Docker for a Realsense camera, one uses existing **Debian packages** while the other performs a full **compilation from source**. It is then important to mount `/dev` as a volume so that the Docker can access the hardware.

In the `docker-compose.yml` this is done with the options:

```yaml
    volumes:
      - /dev:/dev
    device_cgroup_rules:
      - 'c 81:* rmw'
      - 'c 189:* rmw'
```

For more information on how to obtain these device cgroup rules see [here](https://github.com/2b-t/docker-for-robotics/blob/main/doc/WorkingWithHardware.md). 


## 2. Launching
Allow the container to display contents on your host machine by typing

```bash
$ xhost +local:root
```

Then build the Docker container with

```shell
$ docker compose -f docker-compose-gui.yml build
```
or directly with the [`devcontainer` in Visual Studio Code](https://code.visualstudio.com/docs/devcontainers/containers).
After it is done building **connect the Realsense**, start the container

```shell
$ docker compose -f docker-compose-gui.yml up
```
The system have to be connected with the UR Robot before the container can be started. in the file _docker-compose-gui.yml_ the parameter ROBOT_IP has to be changed to the IP address of the UR Robot.