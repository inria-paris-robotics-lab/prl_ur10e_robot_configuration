# prl_ur10e_robot_configuration
Standard configuration for the UR10e of the Robotic Lab fo Inria Paris

## Setups
The UR10e workbench has a few differents swappable grippers and sensors. Their configurations are available here.  

All the configurations are stored in the [/config](/config) folder. Each configuration contains a list of used devices and calibrations parameters that contain the positions of the arm, gripper, sensors, and kinematic parameters of the UR10e arm.

### Custom gripper URDF
In the `*_setup.yaml` file, the type of gripper used for each arm is specified. Standard types are: 'onrobot-rg2', 'onrobot-rg6', 'onrobot-rg6-v2', etc. 

To attach custom tools at the end the arm, custom URDFs need to be created to update the robot model. Those custom tools/URDF might not be long-lasting enough to integrate them in prl_ur5_robot repo. Thus, is what the custom_gripper/ directory of this repo is made for.

#### Usage

For example, to create a custom tool/gripper named `my_gripper`, `prl_ur10e_description` expects to see :
* A file `prl_ur10e_robot_configuration/urdf/my_gripper.urdf.xacro` containing:
```
<?xml version="1.0"?>
<robot xmlns:xacro="http://wiki.ros.org/xacro">
  <xacro:macro name="my_gripper" params="parent *origin prefix">
      ...
  </xacro:macro>
</robot>
```
with the first link being the child of `${parent}` with a transform of `*origin` and all the link and joint having the prefix `${prefix}` in front of their names.
* A file `prl_ur10e_robot_configuration/urdf/my_gripper.srdf.xacro` containing:
```
<?xml version="1.0" encoding="UTF-8"?>
<robot xmlns:xacro="http://wiki.ros.org/xacro">
    <xacro:macro name="cylinder_tool_group_define" params="prefix">
        ...$1...
    </xacro:macro>

    <xacro:macro name="cylinder_tool_autocol" params="prefix">
        ...$2...
    </xacro:macro>

    <xacro:macro name="cylinder_tool_col_with" params="prefix link">
        ...$3...
    </xacro:macro>
</robot>
```
with `$1` being `<link>` and `<joint>` tags defining the gripper, `$2` being `<disable_collision>` tags to disable all the necessary autocollisions inside the gripper, and `$3` being `<disable_collision>` tags to disable the collisions between all the gripper links and an arbitrary `${link}` link.

Then in `*_setup.yaml` set:
```
...
  gripper: "custom:my_gripper"
...
```

**Note**: It is strongly recommended to create a link named `${prefix}_grasp_frame` in the gripper URDF (corresponding to the tip/grasp point of the gripper/tool) to keep consistency with the other grippers.