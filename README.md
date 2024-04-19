## Advanced Digital Design Final Project: Elevator Controller
Prof. Eylem Ekici
Students: Mohamed Hambouta, Trey Wilis

## Structure
This project implements an elevator control system for a four-story building as outlined in the ECE 3561 Project 3 Assignment for Spring 2024.

### Components
- **Elevator Controller**: Manages the movement and door operations of the elevator using input signals such as UP_REQ, DN_REQ, and GO_REQ.
- **Elevator Simulator**: Simulates the physical operations of an elevator, including moving between floors and opening/closing doors in response to controller commands.
- **Inputs**: Includes SYSCLK for timing, POC for system resets, floor request signals (UP_REQ, DN_REQ, GO_REQ), and EF for current floor indication.
- **Outputs**: Controls signals for elevator movement (EMVUP, EMVDN) and door operations (EOPEN, ECLOSE).

### Functionality
- **Control Logic**: Implements a SCAN scheduling algorithm to manage elevator movement efficiently based on active requests.
- **Simulator Details**: Simulates elevator behavior such as floor transitions and door operations with realistic timing delays.

### Accessibility Features
- **Open/Close Buttons**: Allowing doors to be manually opened or closed when the elevator is stationary.
- **Priority Access Call Button**: Provides prioritized elevator access at each floor.

## Development Tools
- **VHDL**: The project is developed using VHDL for both the controller and simulator logic as well as the test bench.
- **Xilinx Environment**: Utilizes the Xilinx software suite for simulation and testing. 
- **ModelSim**: Used for running simulations and visually verifying signal behaviors and interactions.

## Testing
![image](https://github.com/moehambouta/Elevator-Controller/assets/74828685/ebf59563-8edf-4e16-8886-5dde3de1d4fe)
Visual test of the request sequence as specified by the assignment.

![image](https://github.com/moehambouta/Elevator-Controller/assets/74828685/43eeaa82-99ea-4cc3-9b33-03e3a638b990)
Scenario test for simultaneous button presses.

![image](https://github.com/moehambouta/Elevator-Controller/assets/74828685/28122947-ae61-4980-9309-cde2e0209e9d)
Functionality test for the manual door open button.

![image](https://github.com/moehambouta/Elevator-Controller/assets/74828685/f1e2f121-7165-41f1-a939-ac1018cda7cc)
Operational test for the priority access button.

For a more detailed explanation of each component, simulation results, and a discussion on the challenges faced, refer to the accompanying project report. (In progress - 90% done)
