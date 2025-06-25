# Implementation of FAT-INT
This is the implementation of "FAT-INT: Frequency-Aware and Item-Wise In-band Network Telemetry for Low-Overhead and Accurate Measurement" based on the P4 language.

## Dependencies
To run this code, basic dependencies such as p4c, BMv2, Mininet and other libraries should be installed. 
### Install dependencies
1. [p4c](https://github.com/p4lang/p4c)

   ```
   source /etc/lsb-release
   echo "deb http://download.opensuse.org/repositories/home:/p4lang/xUbuntu_${DISTRIB_RELEASE}/ /" | sudo tee /etc/apt/sources.list.d/home:p4lang.list
   curl -fsSL https://download.opensuse.org/repositories/home:p4lang/xUbuntu_${DISTRIB_RELEASE}/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_p4lang.gpg > /dev/null
   sudo apt-get update
   sudo apt install p4lang-p4c
   ```
   
2. [BMv2](https://github.com/p4lang/behavioral-model)

   ```
   . /etc/os-release
   echo "deb http://download.opensuse.org/repositories/home:/p4lang/xUbuntu_${VERSION_ID}/ /" | sudo tee /etc/apt/sources.list.d/home:p4lang.list
   curl -fsSL "https://download.opensuse.org/repositories/home:p4lang/xUbuntu_${VERSION_ID}/Release.key" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_p4lang.gpg > /dev/null
   sudo apt update
   sudo apt install p4lang-bmv2
   ```

3. [P4Utils](https://github.com/nsg-ethz/p4-utils)

   ```
   git clone https://github.com/nsg-ethz/p4-utils.git
   cd p4-utils
   sudo ./install.sh
   ```

4. [Mininet](https://github.com/mininet/mininet)

## BMv2 Instructions
This repository provides a simple linear topology (i.e., 5 hops) for a FAT-INT simple example. 

1. Download the repository to the local.
   
2. Open two terminals for running a simulation.

3. Configure the network and install the FAT-INT program on BMv2 switches.
   ```
   (Terminal 1) make run FILE_PATH=[abs_path for the cloned directory]
   ```


   Note that it pauses until we 'Enter' with a "Waiting for inserting rules..." message. This is because we need to insert rules in step 4 before running the simulation.

5. Insert BMv2 rules.
   ```
   (Terminal 2) python3 [abs_path for the cloned directory]/FAT_INT/p4src/BMv2/rule/int_controller.py
   ```

6. Run simulation.


   After inserting rules, type any input (e.g., Enter) to continue the simulation on Terminal 1. Then the Mininet hosts (i.e., h1, h2) run each program automatically. Specifically, host h1 generates traffic, and host h2 receives and parses normal/INT packets.


8. See the results.


   The output logs will be stored in [abs_path for the cloned directory]/BMv2/example/packets/result.txt. Note that the simulation with default settings lasts about 10 minutes and generates 10,000 packets.

## Tofino Instructions
Our code is available in SDE 9.13.3.

1. Download the repository to the local.

2. Compile P4 program
   ```
   ./build_tofino.sh [abs_path for the cloned directory]/FAT_INT/p4src/Tofino/fat_int.p4 fat_int
   ```
   
3. Run switch model
   ```
   $SDE/run_tofino_model.sh -p fat_int
   ```
   
4. Run switch driver
   ```
   $SDE/run_switchd.sh -p fat_int
   bfshell> bfrt_python [abs_path for the cloned directory]/FAT-INT/p4src/Tofino/rule/bfrt_rule_fatint.py
   ```
   
5. Packet generation
   ```
   python3 [abs_path for the cloned directory]/FAT_INT/p4src/Tofino/packets/send_and_receive.py
   ```
