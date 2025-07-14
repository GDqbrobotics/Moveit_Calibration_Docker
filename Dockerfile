FROM ros:noetic-perception

ENV WS_DIR="/ros_ws"
WORKDIR ${WS_DIR}

SHELL ["/bin/bash", "-c"]

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y \
    build-essential \
    cmake \
    python3-catkin-tools \
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
    ros-noetic-realsense2-* \
    ros-noetic-geometric-shapes \
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
    ros-noetic-moveit-simple-controller-manager \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
 && apt-get install -y \
    ros-noetic-ur-robot-driver \
 && rm -rf /var/lib/apt/lists/*

WORKDIR ${WS_DIR}/src

RUN git clone https://github.com/moveit/moveit_calibration.git
COPY . .

WORKDIR ${WS_DIR}

RUN source /opt/ros/noetic/setup.bash \
 && catkin build

ARG DEBIAN_FRONTEND=dialog

RUN touch /root/.bashrc \
 && echo "source /ros_ws/devel/setup.bash" >> /root/.bashrc \
 && echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc

CMD source /ros_ws/devel/setup.bash \
   && roslaunch start_calibration launcher.launch robot_ip:=${ROBOT_IP}