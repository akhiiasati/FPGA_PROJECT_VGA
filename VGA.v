`timescale 1ns / 1ps

module vga_syncIndex(
clock,reset,mode_1,mode_2,mode_3,mode_4,val,         //inputs - sel_module(select required function), reset(to switch on and off), val(give a value to adjust brightness and filters)
hsync,vsync,                        // hsync and vsync for the working of monitor
red, green, blue                    // red, green and blue output pixels
);

    input clock;
    input reset;
    input [7:0] val = 0;            // intialize value to zero
    input mode_1;
    input mode_2;
    input mode_3;
    input mode_4;     
    reg[7:0] red_o, blue_o, green_o;            // variables used during calcultion
    reg [15:0] r, b, g,r1,r2;                         // variables used during calcultion
    wire [3:0] result;
    wire [7:0] red_result;
    wire [7:0] blue_result;
    reg clk;

   initial begin
   clk =0;
   end
   always@(posedge clock)
   begin
    clk<=~clk;
   end

 
   output reg hsync;
   output reg vsync;
   reg [7:0] tred,tgreen,tblue;
	output reg [3:0] red,green;
	output reg [3:0] blue;
   integer i, j;
//    reg [7:0] reg_value [0:7]; // 2D array to store intermediate results
 
	reg read = 0;
	reg [14:0] addra = 0;
	reg [95:0] in1 = 0;
	wire [95:0] out2;
	
	
image  inst1(
  .clka(clk), // input clka
  .wea(read), // input [0 : 0] wea
  .addra(addra), // input [14 : 0] addra
  .dina(in1), // input [95 : 0] dina
  .douta(out2) // output [95 : 0] douta
);

   wire pixel_clk;
   reg 		pcount = 0;
   wire 	ec = (pcount == 0);
   always @ (posedge clk) pcount <= ~pcount;
   assign 	pixel_clk = ec;
   
   reg 		hblank=0,vblank=0;
   initial begin
   hsync =0;
   vsync=0;
   end
   reg [9:0] 	hc=0;      
   reg [9:0] 	vc=0;	 
	
   wire 	hsyncon,hsyncoff,hreset,hblankon;
   assign 	hblankon = ec & (hc == 690);    
   assign 	hsyncon = ec & (hc == 721);
   assign 	hsyncoff = ec & (hc == 751);
   assign 	hreset = ec & (hc == 799);
   
   wire 	blank =  (vblank | (hblank & ~hreset));    
   
   wire 	vsyncon,vsyncoff,vreset,vblankon;
   assign 	vblankon = hreset & (vc == 479);    
   assign 	vsyncon = hreset & (vc == 490);
   assign 	vsyncoff = hreset & (vc == 492);
   assign 	vreset = hreset & (vc == 523);

   always @(posedge clk) begin
   hc <= ec ? (hreset ? 0 : hc + 1) : hc;
   hblank <= hreset ? 0 : hblankon ? 1 : hblank;
   hsync <= hsyncon ? 0 : hsyncoff ? 1 : hsync; 
   
   vc <= hreset ? (vreset ? 0 : vc + 1) : vc;
   vblank <= vreset ? 0 : vblankon ? 1 : vblank;
   vsync <= vsyncon ? 0 : vsyncoff ? 1 : vsync;

end
(*DONT_OPTIMIZE = "YES"*)
bit_parallel_multiplier multiplier_inst (
        .red(tred),
        .green(tgreen),
        .blue(tblue),
        .result(result)
    );
 
 red_filter red_inst(
        .clk(pixel_clk),
        .red_color(tred),
        .blue_color(tblue),
        .value(val),
        .red_val(red_result),
        .blue_val(blue_result)
    );  
    
 always @ (posedge pixel_clk)
 begin
                
                tblue =  {out2[23], out2[22], out2[21], out2[20], out2[19], out2[18], out2[17], out2[16]};
                tgreen = {out2[15], out2[14], out2[13], out2[12], out2[11], out2[10], out2[9], out2[8]};
                tred = {out2[7], out2[6], out2[5], out2[4], out2[3], out2[2], out2[1], out2[0]};	
         
            if(blank == 0 && (hc >= 0 && hc < 160) && (vc >= 0 && vc < 115)) begin
            begin
            

//                 RGB image to gray scale image
              if(mode_1 == 1'b0)begin
              
                    if(reset) begin
                        red = 0;
                        green = 0;
                        blue = 0;
                    end else begin
                       

                        red = {result[3],result[2], result[1], result[0]};
                        green = {result[3],result[2], result[1], result[0]};
                        blue = {result[3],result[2], result[1], result[0]};
                        
                        
                                  
                    end
                              
                
                    // Increase brightness
                end 
               else if(mode_1 == 1'b1)begin
              
                    if(reset) begin
                        red = 0;
                        green = 0;
                        blue = 0;
                    end else begin
                       
                        red_o = tred;
                        green_o = tgreen;
                        blue_o = tblue;
                        
                        red_o = red_o/16;
                        blue_o = blue_o/16;
                        green_o = green_o/16;

                        red = {red_o[3],red_o[2], red_o[1], red_o[0]};
                        green = {green_o[3],green_o[2], green_o[1], green_o[0]};
                        blue = {blue_o[3],blue_o[2], blue_o[1], blue_o[0]};
                    end    
         end
                      
             if(addra <18399)
                    addra = addra + 1;
                else
                    addra = 0;
               end
            end
            else if ( hc >= 0 && hc < 160 && vc >= 364 && vc < 479)
            begin

//                 RGB image to gray scale image
              if(mode_2 == 1'b0)begin
              
                    if(reset) begin
                        red = 0;
                        green = 0;
                        blue = 0;
                    end else begin
                        red_o = tred; 
                        green_o = tgreen;
                        blue_o = tblue;
                        
                        red_o = red_o/16;
                        blue_o = blue_o/16;
                        green_o = green_o/16;

                        red = {red_o[3],red_o[2], red_o[1], red_o[0]};
                        green = {green_o[3],green_o[2], green_o[1], green_o[0]};
                        blue = {blue_o[3],blue_o[2], blue_o[1], blue_o[0]};  
                                            
                    end
                
                    // Increase brightness
                end 
            
                else if(mode_2 == 1'b1)begin
              
                    if(reset) begin
                        red = 0;
                        green = 0;
                        blue = 0;
                    end else begin
                       
                        red_o = tred;
                        green_o = tgreen;
                        blue_o = tblue;
                        
                        red_o = red_o/16;
                        blue_o = blue_o/16;
                        green_o = green_o/16;

                        red = {red_o[3],red_o[2], red_o[1], red_o[0]};
                        green = {green_o[3],green_o[2], green_o[1], green_o[0]};
                        blue = {blue_o[3],blue_o[2], blue_o[1], blue_o[0]};
                    end    
         end
                  
              
                if(addra <18399)
                    addra = addra + 1;
                else
                    addra = 0;
            end
            
            
            else if (hc >= 540 && hc < 700 && vc >= 0 && vc < 115) 
             begin
            

//                 RED COLOUR FILTER
              if(mode_3 == 1'b0)begin
              
                     if(reset) begin
                        red = 0;
                        green = 0;
                        blue = 0;
                     end else begin
                      r2 <= blue_result;
                       if(r2 >100)begin
                            blue_o = 0;
                       end else begin
                            blue_o = r2/16;
                       end
                       
                        red_o = tred/16;
                        green_o = tgreen/16;
                        red = {red_o[3],red_o[2], red_o[1], red_o[0]};
                        green = {green_o[3],green_o[2], green_o[1], green_o[0]};
                        blue = {blue_o[3],blue_o[2], blue_o[1], blue_o[0]};
                      
                    
                    end
                
                    // Increase brightness
                end
                
                else if(mode_3 == 1'b1)begin
              
                    if(reset) begin
                        red = 0;
                        green = 0;
                        blue = 0;
                    end else begin
                       
                        red_o = tred;
                        green_o = tgreen;
                        blue_o = tblue;
                        
                        red_o = red_o/16;
                        blue_o = blue_o/16;
                        green_o = green_o/16;

                        red = {red_o[3],red_o[2], red_o[1], red_o[0]};
                        green = {green_o[3],green_o[2], green_o[1], green_o[0]};
                        blue = {blue_o[3],blue_o[2], blue_o[1], blue_o[0]};
                    end    
         end
                  
               
                if(addra <18399)
                    addra = addra + 1;
                else
                    addra = 0;
            end
            
          else if ( hc >= 540 && hc < 700 && vc >= 364 && vc < 479)
             begin
            

//                 RGB image to gray scale image
               if(mode_4 == 1'b0)begin
              
                     if(reset) begin
                        red = 0;
                        green = 0;
                        blue = 0;
                     end else begin
                      r1 = red_result;
                      
                       if(r1 >100)begin
                            red_o = 0;
                       end else begin
                            red_o = tred/16;
                       end
                       
                        blue_o = tblue/16;
                        green_o = tgreen/16;
                        red = {red_o[3],red_o[2], red_o[1], red_o[0]};
                        green = {green_o[3],green_o[2], green_o[1], green_o[0]};
                        blue = {blue_o[3],blue_o[2], blue_o[1], blue_o[0]};
                     
                        end
                
                    
                end
                
                else if(mode_4 == 1'b1)begin
              
                    if(reset) begin
                        red = 0;
                        green = 0;
                        blue = 0;
                    end else begin
                       
                        red_o = tred;
                        green_o = tgreen;
                        blue_o = tblue;
                        
                        red_o = red_o/16;
                        blue_o = blue_o/16;
                        green_o = green_o/16;

                        red = {red_o[3],red_o[2], red_o[1], red_o[0]};
                        green = {green_o[3],green_o[2], green_o[1], green_o[0]};
                        blue = {blue_o[3],blue_o[2], blue_o[1], blue_o[0]};
                    end    
         end
                  
              
                   if(addra <18399)
                    addra = addra + 1;
                else
                    addra = 0;   
              

            end
            
                
            
            else
            begin
            
                red = 0;
                green = 0;
                blue = 0;
                
            end
 
            
        end    
       
    endmodule

