//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [7:0]	  keycode,
               output logic  is_ball             // Whether current pixel belongs to ball or background
              );
    
    parameter [9:0] Ball_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd1;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd2;        // Ball size
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
	 
	 // temp variables
	 parameter [9:0] left_wall_idx = 10'd260;
	 parameter [9:0] right_wall_idx = 10'd380;
	 parameter [9:0] top_wall_idx = 10'd180;
	 parameter [9:0] bottom_wall_idx = 10'd300;
	 parameter [9:0] wall_thickness = 10'd5;
	 
	 // Vertical Walls
	parameter [9:0] wall_1_V = 10'd275;
	parameter [9:0] wall_1_H = 10'd280;
	parameter [9:0] wall_2_V = 10'd290;
	parameter [9:0] wall_2_H = 10'd215;
	parameter [9:0] wall_3_V = 10'd320;
	parameter [9:0] wall_3_H = 10'd285;
	parameter [9:0] wall_4_V = 10'd360;
	parameter [9:0] wall_4_H = 10'd250;
	parameter [9:0] wall_5_V = 10'd290;
	parameter [9:0] wall_5_H = 10'd250; // H is top edge
	
	// Horizontal Walls
	parameter [9:0] wall_6_V = 10'd290;
	parameter [9:0] wall_6_H = 10'd235; //bottom edge
	parameter [9:0] wall_7_V = 10'd350; //right edge
	parameter [9:0] wall_7_H = 10'd250; //bottom edge
	parameter [9:0] wall_8_V = 10'd350; //left edge
	parameter [9:0] wall_8_H = 10'd275; //bottom edge
    
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= Ball_Y_Step;
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Ball_X_Pos_in = Ball_X_Pos;
        Ball_Y_Pos_in = Ball_Y_Pos;
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
        
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
				case(keycode)
					8'h1A: //W
						begin
							Ball_X_Motion_in = 10'd0;
							Ball_Y_Motion_in = ~(Ball_Y_Step) + 1'b1;
							
							if((Ball_Y_Pos - Ball_Size <= wall_1_H && Ball_X_Pos + Ball_Size >= wall_1_V && Ball_X_Pos - Ball_Size <= wall_1_V + wall_thickness && Ball_Y_Pos > wall_1_H)
								|| (Ball_Y_Pos - Ball_Size <= wall_2_H && Ball_X_Pos + Ball_Size >= wall_2_V && Ball_X_Pos - Ball_Size <= wall_2_V + wall_thickness && Ball_Y_Pos > wall_2_H))
								begin
									Ball_Y_Motion_in = Ball_Y_Step;
									Ball_X_Motion_in = 10'd0;
								end
						end
					8'h16: //S
						begin
							Ball_X_Motion_in = 10'd0;
							Ball_Y_Motion_in = Ball_Y_Step;
						end
					8'h04: //A
						begin
							Ball_X_Motion_in = ~(Ball_X_Step) + 1'b1;
							Ball_Y_Motion_in = 10'd0;
							
							if((Ball_X_Pos - Ball_Size <= wall_1_V + wall_thickness && Ball_Y_Pos >= top_wall_idx + wall_thickness && Ball_Y_Pos - Ball_Size <= wall_1_H && Ball_X_Pos > wall_1_V + wall_thickness)
								|| (Ball_X_Pos - Ball_Size <= wall_2_V + wall_thickness && Ball_Y_Pos >= top_wall_idx + wall_thickness && Ball_Y_Pos - Ball_Size <= wall_2_H && Ball_X_Pos > wall_2_V + wall_thickness))
								begin
									Ball_X_Motion_in = Ball_X_Step;
									Ball_Y_Motion_in = 10'd0;
								end
						end
					8'h07: //D
						begin
							Ball_X_Motion_in = Ball_X_Step;
							Ball_Y_Motion_in = 10'd0;
							
							if((Ball_X_Pos + Ball_Size >= wall_1_V && Ball_Y_Pos + Ball_Size >= top_wall_idx + wall_thickness && Ball_Y_Pos - Ball_Size <= wall_1_H && Ball_X_Pos < wall_1_V)
								|| (Ball_X_Pos + Ball_Size >= wall_2_V && Ball_Y_Pos + Ball_Size >= top_wall_idx + wall_thickness && Ball_Y_Pos - Ball_Size <= wall_2_H && Ball_X_Pos < wall_2_V))
								begin
									Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
									Ball_Y_Motion_in = 10'd0;
								end
						end
					default:
						begin
							//Ball_X_Motion_in = Ball_X_Motion;
							//Ball_Y_Motion_in = Ball_Y_Motion;
							Ball_X_Motion_in = 10'd0;
							Ball_Y_Motion_in = 10'd0;
						end
				endcase
				
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
            // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
            if( Ball_Y_Pos + Ball_Size >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
					begin
						Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.
						Ball_X_Motion_in = 10'd0;
					end  
            else if ( Ball_Y_Pos <= Ball_Y_Min + Ball_Size )  // Ball is at the top edge, BOUNCE!
					begin
						Ball_Y_Motion_in = Ball_Y_Step;
						Ball_X_Motion_in = 10'd0;
					end
            // TODO: Add other boundary detections and handle keypress here.
				
				else if (Ball_X_Pos + Ball_Size >= Ball_X_Max)
					begin
						Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
						Ball_Y_Motion_in = 10'd0;
					end
				else if(Ball_X_Pos <= Ball_X_Min + Ball_Size)
					begin
						Ball_X_Motion_in = Ball_X_Step;
						Ball_Y_Motion_in = 10'd0;
					end
					
				// Create wall conditions
				if(Ball_Y_Pos + Ball_Size >= bottom_wall_idx - wall_thickness)
					begin
						Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.
						Ball_X_Motion_in = 10'd0;
					end
				else if(Ball_Y_Pos - Ball_Size <= top_wall_idx + wall_thickness)
					begin
						Ball_Y_Motion_in = Ball_Y_Step;
						Ball_X_Motion_in = 10'd0;
					end
				else if(Ball_X_Pos + Ball_Size >= right_wall_idx - wall_thickness)
					begin
						Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
						Ball_Y_Motion_in = 10'd0;
					end
				else if(Ball_X_Pos - Ball_Size <= left_wall_idx + wall_thickness)
					begin
						Ball_X_Motion_in = Ball_X_Step;
						Ball_Y_Motion_in = 10'd0;
					end
					
				/*
				// Intermediate Walls
				if(Ball_X_Pos + Ball_Size >= wall_1_V && Ball_Y_Pos + Ball_Size >= top_wall_idx + wall_thickness && Ball_Y_Pos - Ball_Size <= wall_1_H)
					begin
						Ball_X_Motion_in = 10'd0;//(~(Ball_X_Step) + 1'b1);
						Ball_Y_Motion_in = 10'd0;
					end
				else if(Ball_X_Pos - Ball_Size <= wall_1_V + wall_thickness && Ball_Y_Pos >= top_wall_idx + wall_thickness && Ball_Y_Pos - Ball_Size <= wall_1_H)
					begin
						Ball_X_Motion_in = 10'd0;//Ball_X_Step;
						Ball_Y_Motion_in = 10'd0;
					end
				else if(Ball_Y_Pos - Ball_Size <= wall_1_H && Ball_X_Pos + Ball_Size >= wall_1_V && Ball_X_Pos - Ball_Size <= wall_1_V + wall_thickness)
					begin
						Ball_Y_Motion_in = 10'd0;//Ball_Y_Step;
						Ball_X_Motion_in = 10'd0;
					end
				*/
					
            // Update the ball's position with its motion
            Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
        end
        
        /**************************************************************************************
            ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
            Hidden Question #2/2:
               Notice that Ball_Y_Pos is updated using Ball_Y_Motion. 
              Will the new value of Ball_Y_Motion be used when Ball_Y_Pos is updated, or the old? 
              What is the difference between writing
                "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;" and 
                "Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion_in;"?
              How will this impact behavior of the ball during a bounce, and how might that interact with a response to a keypress?
              Give an answer in your Post-Lab.
        **************************************************************************************/
    end
    
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    assign Size = Ball_Size;
    always_comb begin
        if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) ) 
            is_ball = 1'b1;
        else
            is_ball = 1'b0;
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    end
    
endmodule
