#!/bin/env bash

# Retreive values from yaml files using pyyaml (which is a ROS Noetic dependency)
function parse_yaml() {
    python << EOF
import yaml,sys
try:
    with open("$1", 'r') as f:
        print(yaml.safe_load(f)$2)
except KeyError: # If the key is not found, output nothing
    pass
EOF
}

config_file=`rospack  find prl_ur10e_robot_configuration`/config/standard_setup.yaml


export PRL_CONFIG_GRIPPER=$(parse_yaml $config_file "['arm']['gripper']")

export PRL_CONFIG_GRIPPER_CONTROLLER=$(parse_yaml $config_file "['arm']['gripper_controller']")