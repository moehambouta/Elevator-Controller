## Advanced Digital Design Final Project: Elevator Controller
Prof. Eylem Ekici

Students: Mohamed Hambouta, Trey Willis

## Structure
This project implements an elevator control system for a four-story building as outlined in the ECE 3561 Final Project Assignment for Spring 2024.

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
