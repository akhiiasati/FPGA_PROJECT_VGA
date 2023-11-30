# FPGA_PROJECT_VGA

##Image Processing Toolbox Documentation

### Introduction:
The Image Processing Toolbox is a comprehensive Verilog-based project designed for the Basys3 FPGA as part of the ES 203: Digital Systems course at IITGN, under the guidance of Prof. Joycee Mekie. The toolbox specializes in convolution-based image processing operations, accepting input images in binary format, processing them in the FPGA Block RAM, and displaying the results on a VGA display. The project employs Verilog for hardware description and Python for converting digital images into binary format, with development carried out using the Vivado software suite.

### Block Memory:
The Block Memory module plays a pivotal role in storing image data in binary format within the Verilog project. A Python script converts images into binary form, with each row containing 24 bits (8 bits for each color channel). The Block Memory module is configured with addresses equal to the total number of rows and 24 data bits, enabling storage of a single pixel in each address. For convolution operations requiring simultaneous access to multiple pixels, the module allows dynamic address manipulation.

### VGA Interface:
The VGA interface is tailored for a 480p display with a 60Hz refresh rate, systematically updating pixels during each refresh cycle. A counter traverses the display area, and the hsync signal facilitates transitions between display, retrace, and border areas. The project poster provides detailed visualizations of these processes. The VGA interface code is adept at rendering images on the monitor by fetching data from the Block RAM.

### Two Implementations:
The Image Processing Toolbox project offers two distinct implementations:

Verilog Implementation: This version facilitates reading, processing, and writing images from the system. Relevant files can be found in the "BIPT" and "Blurring" folders.
FPGA Implementation: This version showcases the output of images loaded into the block RAM on a monitor. Necessary files are located in the "Final Project" folder.
COE (Coefficient) File:
A COE file, used to initialize block RAMs or ROMs in Xilinx FPGA designs, is an integral part of the project. This file contains binary or hexadecimal numbers in a specific format. For detailed information on COE file syntax and structure, consult the Xilinx documentation on COE File Syntax.

For further details, code snippets, and visual representations, please refer to the project repository on GitHub. This toolbox represents a comprehensive approach to FPGA-based image processing, providing valuable insights for digital systems enthusiasts.
