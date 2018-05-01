//This file will be used to create the reg_8 system verilog file

// Since we are dealing with 8 bits, we must increase the input and output logic bit counts
// In addition, the hex value will now be 8 bits so we must change that as well

module reg_8 (input  logic Clk, Reset, Load,
              input  logic [7:0]  D,
              output logic [7:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 8'b0;
		 else if (Load)
			  Data_Out <= Data_Out + 8'b00000001;
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
