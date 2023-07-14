# PIC16F877A-Traffic-Light-using-PIC-Assembly
Assembly program for a PIC16F877A microcontroller that controls traffic flow for a crossroad to prevent accidents.  Pedestrian lights added to assure safety to both drivers and pedestrians.

# Summary

This project uses the PIC16877A microcontroller to demonstrate an automated traffic light system. The system relies on a sequential approach with two seven-segment displays as a timer to operate in the absence of sensors, and the timer counts 40 seconds and 5 seconds when both sides are yellow. To ensure synchronization between the traffic lights and pedestrian lights, the pedestrian lights remain red when the traffic light turns yellow. This prevents pedestrians from crossing the road when drivers may be inclined to accelerate through a yellow light, enhancing pedestrian safety.

# Illustration

![image](https://github.com/Seifhusseinn/PIC16F877A-Traffic-Light-using-PIC-Assembly/assets/108237683/767848c4-bae7-48a8-a7c2-a9a0b7ffce15)

# Approach

The PIC16877A microcontroller is the central controller used in a traffic light and pedestrian management system. It controls a total of six LED lights (red, green, and yellow) attached to each road, as well as four additional LED lights (red and green) for pedestrian traffic management. The system also includes two push buttons: one serves as a hardware external reset button connected to the microcontroller's MCLR (Master Clear) pin, and the other is for pedestrians to press when they reach the end of the sidewalk.

To ensure accurate timing, a 16MHz crystal is used as an external oscillator, connected to two 22nF capacitors that are connected to ground. This oscillator provides a precise clock signal for the microcontroller's operations. Each LED is connected to 220 ohms and grounded from other side and the seven segments are connected to 220 ohm resisors to avoid damaging components. 

The pedestrian switch is connected to the RB0 pin, which is configured as an interrupt pin. When a pedestrian presses the button, the timer decreases to 19 if the counter is above 20. This feature is implemented to prevent pedestrian congestion on the sidewalks of both sides of the road.

# Circuit Schematic
![image](https://github.com/Seifhusseinn/PIC16F877A-Traffic-Light-using-PIC-Assembly/assets/108237683/4789f49f-1d3c-46d8-9c30-f2c8483009de)
