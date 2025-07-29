FROM moveit/moveit:noetic-source

ENV WS_DIR="/ros_ws"
WORKDIR ${WS_DIR}

SHELL ["/bin/bash", "-c"]

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y \
    build-essential \
    cmake \
    git-all \
    software-properties-common \
    libjsoncpp-dev \
    ros-noetic-handeye \
    ros-noetic-criutils \
    ros-noetic-baldor \
    ros-noetic-geometric-shapes \
    ros-noetic-rviz-visual-tools \
    ros-noetic-image-geometry \
    ros-noetic-rviz \
    ros-noetic-geometric-shapes \
    libgflags-dev \
    ros-noetic-camera-info-manager \
    ros-noetic-image-transport-plugins \
    ros-noetic-compressed-image-transport \
    ros-noetic-image-transport \
    ros-noetic-image-publisher \
    libgoogle-glog-dev \
    libusb-1.0-0-dev \
    libeigen3-dev \
    ros-noetic-diagnostic-updater \
    ros-noetic-diagnostic-msgs \
    libdw-dev \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
 && apt-get install -y \
    ros-noetic-moveit-core \
    ros-noetic-moveit-ros-visualization \
    ros-noetic-moveit-ros-perception \
    ros-noetic-moveit-ros-planning \
    ros-noetic-moveit-ros-planning-interface \
    ros-noetic-moveit-visual-tools \
    ros-noetic-moveit-fake-controller-manager \
    ros-noetic-moveit-kinematics \
    ros-noetic-moveit-planners-ompl \
    ros-noetic-moveit-ros-visualization \
    ros-noetic-moveit-setup-assistant \
    ros-noetic-moveit-simple-controller-manager 

RUN mkdir -p /ur_ws/src \
 && source /opt/ros/noetic/setup.bash \
 && cd /ur_ws \
 && rosdep update --include-eol-distros \
 && git clone -b disable_dashboard_client_on_X https://github.com/urfeex/Universal_Robots_ROS_Driver.git src/ur_robot_driver \
 && rosdep install -y -q --from-paths . --ignore-src \
 && catkin build

WORKDIR ${WS_DIR}/src

RUN git clone https://github.com/moveit/moveit_calibration.git
RUN git clone https://github.com/orbbec/OrbbecSDK_ROS1.git
COPY . .

WORKDIR ${WS_DIR}

RUN source /opt/ros/noetic/setup.bash \
   && source /ur_ws/devel/setup.bash \
   && catkin build \
   && source devel/setup.sh \
   && source ./devel/setup.bash \
   && roscd orbbec_camera \
   && bash ./scripts/install_udev_rules.sh \

ARG DEBIAN_FRONTEND=dialog

RUN touch /root/.bashrc \
 && echo "source /ros_ws/devel/setup.bash" >> /root/.bashrc \
 && echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc

CMD source /ros_ws/devel/setup.bash \
   && roslaunch start_calibration launcher.launch robot_ip:=${ROBOT_IP} robot_model:=${ROBOT_MODEL}