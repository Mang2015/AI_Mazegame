//This file will be used to create the reg_8 system verilog file

// Since we are dealing with 8 bits, we must increase the input and output logic bit counts
// In addition, the hex value will now be 8 bits so we must change that as well

module reg_8 (input  logic Clk, Reset, Load,
              input  logic [7:0]  D,
              output logic [11:0]  Data_Out,
				  output logic [11:0] counter
				  );

    always_ff @ (posedge Clk)
    begin 
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 12'b0;
		 else if (Load)
			  counter <= counter + 12'b000000000001;
			  if (counter == 12'b00000100000)
			  begin
					Data_Out <= Data_Out + 12'b000000000001;
					counter <= 12'b000000000000;
				end
			  /*Data_Out <= Data_Out % D; */
		/*
		 else if (Shift_En)
		 begin
			  //concatenate shifted in data to the previous left-most 3 bits
			  //note this works because we are in always_ff procedure block
			  Data_Out <= { Shift_In, Data_Out[7:1] }; 
	    end
		*/
    end
	
    //assign Shift_Out = Data_Out[0];

endmodule

module reg_12 (input  logic Clk, Reset, Load,
              input  logic [11:0]  D,
              output logic [11:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 12'h0;
		 else if (Load)
			  Data_Out <= D;
		/*
		 else if (Shift_En)
		 begin
			  //concatenate shifted in data to the previous left-most 3 bits
			  //note this works because we are in always_ff procedure block
			  Data_Out <= { Shift_In, Data_Out[7:1] }; 
	    end
		*/
    end
	
    //assign Shift_Out = Data_Out[0];

endmodule

module clockDivider(input logic input0,
                    input logic input1,
                    input logic clock,
                    input logic reset,
                    output logic y);

// 00 = stop, 01 = slow, 10 = medium, 11 = fast;
parameter mod = 2;
reg [mod-1:0] count, max;

assign y = ( ~input1 & ~input0 ) ? 1'b0 : count[mod-1]; /*stop clock*/

always @ (posedge clock)
begin
if( ~input1 & input0 )  /*slow*/ 
  max <= (1 << (mod-2)) - 1'b1; 
else if( input1  & ~input0 ) /*medium*/ 
  max <= (1 << (mod-1)) - 1'b1; 
else if( input1  & input0 )  /*fast*/  
  max <= (1 << mod) - 1'b1; 
end 

always @ (posedge clock, negedge reset)
begin
  if (!reset)
    count <= 0;
  else if (count == max)
    count <= 0;
  else
    count <= count + 1'b1;
end
endmodule