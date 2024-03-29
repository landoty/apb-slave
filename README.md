# Advanced Peripheral Bus Protocol (Slave)

This protocol for the Advanced Peripheral Bus, written in Verilog, models 
the behavoir of the APB Slave as it reads and writes data from the master. 

This is my first attempt at Verilog, creating this project for undergraduate 
research. Please feel free to provide feedback of any sorts!</p>

# Basic Design Flow:

### State Diagram: ###
![State Diagram](https://github.com/landoty/apb-slave/blob/main/apb-imgs/state_diagram.png)

### Data Flow: ###
![Data Flow](https://github.com/landoty/apb-slave/blob/main/apb-imgs/data_flow.png)

### Testbenches:
   - Write: 
      ![Write](https://github.com/landoty/apb-slave/blob/main/apb-imgs/write.png)
   - Read: 
      ![Read](https://github.com/landoty/apb-slave/blob/main/apb-imgs/read.png)
   - Reset: 
      ![Reset](https://github.com/landoty/apb-slave/blob/main/apb-imgs/reset.png)
   - Error:
      ![Reset](https://github.com/landoty/apb-slave/blob/main/apb-imgs/error.png)
