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
					input maze1out, maze2out,
               output logic  is_ball,             // Whether current pixel belongs to ball or background
					output logic  goal_reach1, goal_reach2, loadReg1, loadReg2
              );
    
    parameter [9:0] Ball_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd1;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd3;        // Ball size
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
	 logic goal_reach1_in;
	 logic goal_reach2_in;
	 
	 // MAZE 1 GOAL
	 parameter [9:0] maze1_goalV = 10'd425;
	 parameter [9:0] maze1_goalH = 10'd375;
	 parameter [9:0] left_wall_idx = 10'd155;
	 parameter [9:0] top_wall_idx = 10'd105;
	 parameter [9:0] right_wall_idx = 10'd455;
	 parameter [9:0] bottom_wall_idx = 10'd405;
	 parameter [9:0] wall_thickness = 10'd30;
	
	// Vertical Walls
	 parameter [9:0] wall_1V = 10'd215;
	 parameter [9:0] wall_1H = 10'd345;
	 parameter [9:0] wall_2V = 10'd275;
	 parameter [9:0] wall_2H = 10'd225;
	 parameter [9:0] wall_3V = 10'd275;
	 parameter [9:0] wall_3H = 10'd345;
	 parameter [9:0] wall_4V = 10'd335;
	 parameter [9:0] wall_4H = 10'd255;
	 parameter [9:0] wall_5V = 10'd335;
	 parameter [9:0] wall_5H = 10'd375;
	 parameter [9:0] wall_6V = 10'd395;
	 parameter [9:0] wall_6H = 10'd225;
	// Horizontal Walls
	 parameter [9:0] wall_7V = 10'd215;
	 parameter [9:0] wall_7H = 10'd285;
	 parameter [9:0] wall_8V = 10'd275;
	 parameter [9:0] wall_8H = 10'd165;
	 parameter [9:0] wall_9V = 10'd395;
	 parameter [9:0] wall_9H = 10'd225;
	 parameter [9:0] wall_10V = 10'd395;
	 parameter [9:0] wall_10H = 10'd345;
	 
	 // MAZE 2 GOAL
	 parameter [9:0] maze3_goalV = 10'd490;
	 parameter [9:0] maze3_goalH = 10'd430;
	 parameter [9:0] left_wall_idx3 = 10'd110;
	 parameter [9:0] top_wall_idx3 = 10'd50;
	 parameter [9:0] right_wall_idx3 = 10'd510;
	 parameter [9:0] bottom_wall_idx3 = 10'd450;
	 parameter [9:0] wall_thickness3 = 10'd20;
	 
	 // Vertical Walls
	 parameter [9:0] wall_1V3 = 10'd150;
	 parameter [9:0] wall_1H3 = 10'd210;
	 parameter [9:0] wall_2V3 = 10'd150;
	 parameter [9:0] wall_2H3 = 10'd290;
	 parameter [9:0] wall_3V3 = 10'd150;
	 parameter [9:0] wall_3H3 = 10'd410;
    parameter [9:0] wall_4V3 = 10'd190;
	 parameter [9:0] wall_4H3 = 10'd170;
	 parameter [9:0] wall_5V3 = 10'd190;
	 parameter [9:0] wall_5H3 = 10'd330;
	 parameter [9:0] wall_6V3 = 10'd190;
	 parameter [9:0] wall_6H3 = 10'd450;
	 parameter [9:0] wall_7V3 = 10'd230;
	 parameter [9:0] wall_7H3 = 10'd90;
	 parameter [9:0] wall_8V3 = 10'd230;
	 parameter [9:0] wall_8H3 = 10'd210;
	 parameter [9:0] wall_9V3 = 10'd230;
	 parameter [9:0] wall_9H3 = 10'd330;
	 parameter [9:0] wall_10V3 = 10'd230;
	 parameter [9:0] wall_10H3 = 10'd410;
	 parameter [9:0] wall_11V3 = 10'd270;
	 parameter [9:0] wall_11H3 = 10'd410;
	 parameter [9:0] wall_12V3 = 10'd310;
	 parameter [9:0] wall_12H3 = 10'd290;
	 parameter [9:0] wall_13V3 = 10'd310;
	 parameter [9:0] wall_13H3 = 10'd410;
	 parameter [9:0] wall_14V3 = 10'd350;
	 parameter [9:0] wall_14H3 = 10'd90;
	 parameter [9:0] wall_15V3 = 10'd350;
	 parameter [9:0] wall_15H3 = 10'd250;
	 parameter [9:0] wall_16V3 = 10'd350;
	 parameter [9:0] wall_16H3 = 10'd370;
	 parameter [9:0] wall_17V3 = 10'd390;
	 parameter [9:0] wall_17H3 = 10'd130;
	 parameter [9:0] wall_18V3 = 10'd390;
	 parameter [9:0] wall_18H3 = 10'd290;
	 parameter [9:0] wall_19V3 = 10'd430;
	 parameter [9:0] wall_19H3 = 10'd170;
	 parameter [9:0] wall_20V3 = 10'd430;
	 parameter [9:0] wall_20H3 = 10'd410;
	 parameter [9:0] wall_21V3 = 10'd470;
	 parameter [9:0] wall_21H3 = 10'd90;
	 parameter [9:0] wall_22V3 = 10'd470;
	 parameter [9:0] wall_22H3 = 10'd330;
 	 parameter [9:0] wall_23V3 = 10'd470;
	 parameter [9:0] wall_23H3 = 10'd450;
	 // Horizontal Walls
	 parameter [9:0] wall_24V3 = 10'd150; //d210
	 parameter [9:0] wall_24H3 = 10'd90;
	 parameter [9:0] wall_25V3 = 10'd230; //d330
	 parameter [9:0] wall_25H3 = 10'd90;
	 parameter [9:0] wall_26V3 = 10'd190; //d290
	 parameter [9:0] wall_26H3 = 10'd130;
	 parameter [9:0] wall_27V3 = 10'd310; //d410
	 parameter [9:0] wall_27H3 = 10'd130;
	 parameter [9:0] wall_28V3 = 10'd430; //d490
	 parameter [9:0] wall_28H3 = 10'd130;
	 parameter [9:0] wall_29V3 = 10'd350; //510
	 parameter [9:0] wall_29H3 = 10'd170;
	 parameter [9:0] wall_30V3 = 10'd150; //d250
	 parameter [9:0] wall_30H3 = 10'd210;
	 parameter [9:0] wall_31V3 = 10'd350; //d450
	 parameter [9:0] wall_31H3 = 10'd210;
	 parameter [9:0] wall_32V3 = 10'd110; //d170
	 parameter [9:0] wall_32H3 = 10'd250;
	 parameter [9:0] wall_33V3 = 10'd230; //d290
	 parameter [9:0] wall_33H3 = 10'd250;
	 parameter [9:0] wall_34V3 = 10'd310; //d370
	 parameter [9:0] wall_34H3 = 10'd250;
	 parameter [9:0] wall_35V3 = 10'd350; //d410
	 parameter [9:0] wall_35H3 = 10'd290;
	 parameter [9:0] wall_36V3 = 10'd110; //d250
	 parameter [9:0] wall_36H3 = 10'd330;
	 parameter [9:0] wall_37V3 = 10'd270; //d370
	 parameter [9:0] wall_37H3 = 10'd330;
	 parameter [9:0] wall_38V3 = 10'd390; //d490
	 parameter [9:0] wall_38H3 = 10'd330;
	 parameter [9:0] wall_39V3 = 10'd190; //d250
	 parameter [9:0] wall_39H3 = 10'd370;
	 parameter [9:0] wall_40V3 = 10'd350; //d410
	 parameter [9:0] wall_40H3 = 10'd370;
	 parameter [9:0] wall_41V3 = 10'd150; //d210
	 parameter [9:0] wall_41H3 = 10'd410;
	 parameter [9:0] wall_42V3 = 10'd230; //d290
	 parameter [9:0] wall_42H3 = 10'd410;
	 parameter [9:0] wall_43V3 = 10'd310; //d450
	 parameter [9:0] wall_43H3 = 10'd410; 
	
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
            Ball_X_Pos <= 10'd140;
            Ball_Y_Pos <= 10'd60;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= Ball_Y_Step;
				goal_reach1 <= 1'b0;
				goal_reach2 <= 1'b0;
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
				goal_reach1 <= goal_reach1_in;
				goal_reach2 <= goal_reach2_in;
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
		  goal_reach1_in = goal_reach1; // for error
		  goal_reach2_in = goal_reach2; // for error
		  loadReg1 = 1'b0;
		  loadReg2 = 1'b0;
		  
		  if(maze1out == 1'b1)
		  begin
        
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
				case(keycode)
					8'h1A: //W
						begin
							loadReg1 = 1'b1;
							Ball_X_Motion_in = 10'd0;
							Ball_Y_Motion_in = ~(Ball_Y_Step) + 1'b1;
							
							if((Ball_Y_Pos - Ball_Size <= wall_1H && Ball_X_Pos + Ball_Size >= wall_1V && Ball_X_Pos - Ball_Size <= wall_1V + wall_thickness && Ball_Y_Pos > wall_1H)
								|| (Ball_Y_Pos - Ball_Size <= wall_2H && Ball_X_Pos + Ball_Size >= wall_2V && Ball_X_Pos - Ball_Size <= wall_2V + wall_thickness && Ball_Y_Pos > wall_2H)
								|| (Ball_Y_Pos - Ball_Size <= wall_3H && Ball_X_Pos + Ball_Size >= wall_3V && Ball_X_Pos - Ball_Size <= wall_3V + wall_thickness && Ball_Y_Pos > wall_3H)
								|| (Ball_Y_Pos - Ball_Size <= wall_4H && Ball_X_Pos + Ball_Size >= wall_4V && Ball_X_Pos - Ball_Size <= wall_4V + wall_thickness && Ball_Y_Pos > wall_4H)
								|| (Ball_Y_Pos - Ball_Size <= wall_5H && Ball_X_Pos + Ball_Size >= wall_5V && Ball_X_Pos - Ball_Size <= wall_5V + wall_thickness && Ball_Y_Pos > wall_5H)
								|| (Ball_Y_Pos - Ball_Size <= wall_6H && Ball_X_Pos + Ball_Size >= wall_6V && Ball_X_Pos - Ball_Size <= wall_6V + wall_thickness && Ball_Y_Pos > wall_6H)
								|| (Ball_Y_Pos - Ball_Size <= wall_7H && Ball_X_Pos + Ball_Size >= wall_7V && Ball_X_Pos - Ball_Size <= 10'd425 && Ball_Y_Pos > wall_7H)
								|| (Ball_Y_Pos - Ball_Size <= wall_8H && Ball_X_Pos + Ball_Size >= wall_8V && Ball_X_Pos - Ball_Size <= 10'd425 && Ball_Y_Pos > wall_8H)
								|| (Ball_Y_Pos - Ball_Size <= wall_9H && Ball_X_Pos + Ball_Size >= wall_9V && Ball_X_Pos - Ball_Size <= right_wall_idx && Ball_Y_Pos > wall_9H)
								|| (Ball_Y_Pos - Ball_Size <= wall_10H && Ball_X_Pos + Ball_Size >= wall_10V && Ball_X_Pos - Ball_Size <= right_wall_idx && Ball_Y_Pos > wall_10H))
								begin
									Ball_Y_Motion_in = Ball_Y_Step;
									Ball_X_Motion_in = 10'd0;
								end
						end
					8'h16: //S
						begin
							loadReg1 = 1'b1;
							Ball_X_Motion_in = 10'd0;
							Ball_Y_Motion_in = Ball_Y_Step;
							
							if((Ball_Y_Pos + Ball_Size >= top_wall_idx && Ball_X_Pos + Ball_Size >= wall_1V && Ball_X_Pos - Ball_Size <= wall_1V + wall_thickness && Ball_Y_Pos < top_wall_idx)
								|| (Ball_Y_Pos + Ball_Size >= top_wall_idx + wall_thickness && Ball_X_Pos + Ball_Size >= wall_2V && Ball_X_Pos - Ball_Size <= wall_2V + wall_thickness && Ball_Y_Pos < top_wall_idx + wall_thickness)
								|| (Ball_Y_Pos + Ball_Size >= 10'd255 && Ball_X_Pos + Ball_Size >= wall_3V && Ball_X_Pos - Ball_Size <= wall_3V + wall_thickness && Ball_Y_Pos < 10'd255)
								|| (Ball_Y_Pos + Ball_Size >= 10'd195 && Ball_X_Pos + Ball_Size >= wall_4V && Ball_X_Pos - Ball_Size <= wall_4V + wall_thickness && Ball_Y_Pos < 10'd195)
								|| (Ball_Y_Pos + Ball_Size >= 10'd315 && Ball_X_Pos + Ball_Size >= wall_5V && Ball_X_Pos - Ball_Size <= wall_5V + wall_thickness && Ball_Y_Pos < 10'd315)
								|| (Ball_Y_Pos + Ball_Size >= top_wall_idx + wall_thickness && Ball_X_Pos + Ball_Size >= wall_6V && Ball_X_Pos - Ball_Size <= wall_6V + wall_thickness && Ball_Y_Pos < top_wall_idx + wall_thickness)
								|| (Ball_Y_Pos + Ball_Size >= wall_7H - wall_thickness && Ball_X_Pos + Ball_Size >= wall_7V && Ball_X_Pos - Ball_Size <= 10'd425 && Ball_Y_Pos < wall_7H - wall_thickness)
								|| (Ball_Y_Pos + Ball_Size >= wall_8H - wall_thickness && Ball_X_Pos + Ball_Size >= wall_8V && Ball_X_Pos - Ball_Size <= 10'd425 && Ball_Y_Pos < wall_8H - wall_thickness)
								|| (Ball_Y_Pos + Ball_Size >= wall_9H - wall_thickness && Ball_X_Pos + Ball_Size >= wall_9V && Ball_X_Pos - Ball_Size <= right_wall_idx && Ball_Y_Pos < wall_9H - wall_thickness)
								|| (Ball_Y_Pos + Ball_Size >= wall_10H - wall_thickness && Ball_X_Pos + Ball_Size >= wall_10V && Ball_X_Pos - Ball_Size <= right_wall_idx && Ball_Y_Pos < wall_10H - wall_thickness))
								begin
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1'b1;
									Ball_X_Motion_in = 10'd0;
								end
						end
					8'h04: //A
						begin
							loadReg1 = 1'b1;
							Ball_X_Motion_in = ~(Ball_X_Step) + 1'b1;
							Ball_Y_Motion_in = 10'd0;
							
							if((Ball_X_Pos - Ball_Size <= wall_1V + wall_thickness && Ball_Y_Pos - Ball_Size <= wall_1H && Ball_Y_Pos + Ball_Size >= top_wall_idx && Ball_X_Pos > wall_1V + wall_thickness)
								|| (Ball_X_Pos - Ball_Size <= wall_2V + wall_thickness && Ball_Y_Pos - Ball_Size <= wall_2H && Ball_Y_Pos + Ball_Size >= top_wall_idx + wall_thickness && Ball_X_Pos > wall_2V + wall_thickness)
								|| (Ball_X_Pos - Ball_Size <= wall_3V + wall_thickness && Ball_Y_Pos - Ball_Size <= wall_3H && Ball_Y_Pos + Ball_Size >= 10'd255 && Ball_X_Pos > wall_3V + wall_thickness)
								|| (Ball_X_Pos - Ball_Size <= wall_4V + wall_thickness && Ball_Y_Pos - Ball_Size <= wall_4H && Ball_Y_Pos + Ball_Size >= 10'd195 && Ball_X_Pos > wall_4V + wall_thickness)
								|| (Ball_X_Pos - Ball_Size <= wall_5V + wall_thickness && Ball_Y_Pos - Ball_Size <= wall_5H && Ball_Y_Pos + Ball_Size >= 10'd315 && Ball_X_Pos > wall_5V + wall_thickness)
								|| (Ball_X_Pos - Ball_Size <= wall_6V + wall_thickness && Ball_Y_Pos - Ball_Size <= wall_6H && Ball_Y_Pos + Ball_Size >= top_wall_idx + wall_thickness && Ball_X_Pos > wall_6V + wall_thickness)
								|| (Ball_X_Pos - Ball_Size <= 10'd425 && Ball_Y_Pos - Ball_Size <= wall_7H && Ball_Y_Pos + Ball_Size >= wall_7H - wall_thickness && Ball_X_Pos > 10'd425)
								|| (Ball_X_Pos - Ball_Size <= 10'd425 && Ball_Y_Pos - Ball_Size <= wall_8H && Ball_Y_Pos + Ball_Size >= wall_8H - wall_thickness && Ball_X_Pos > 10'd425)
								|| (Ball_X_Pos - Ball_Size <= right_wall_idx && Ball_Y_Pos - Ball_Size <= wall_9H && Ball_Y_Pos + Ball_Size >= wall_9H - wall_thickness && Ball_X_Pos > right_wall_idx)
								|| (Ball_X_Pos - Ball_Size <= right_wall_idx && Ball_Y_Pos - Ball_Size <= wall_10H && Ball_Y_Pos + Ball_Size >= wall_10H - wall_thickness && Ball_X_Pos > right_wall_idx))
								begin
									Ball_X_Motion_in = Ball_X_Step;
									Ball_Y_Motion_in = 10'd0;
								end
						end
					8'h07: //D
						begin
							loadReg1 = 1'b1;
							Ball_X_Motion_in = Ball_X_Step;
							Ball_Y_Motion_in = 10'd0;
							
							if((Ball_X_Pos + Ball_Size >= wall_1V && Ball_Y_Pos - Ball_Size <= wall_1H && Ball_Y_Pos + Ball_Size >= top_wall_idx && Ball_X_Pos < wall_1V)
								|| (Ball_X_Pos + Ball_Size >= wall_2V && Ball_Y_Pos - Ball_Size <= wall_2H && Ball_Y_Pos + Ball_Size >= top_wall_idx + wall_thickness && Ball_X_Pos < wall_2V)
								|| (Ball_X_Pos + Ball_Size >= wall_3V && Ball_Y_Pos - Ball_Size <= wall_3H && Ball_Y_Pos + Ball_Size >= 10'd255 && Ball_X_Pos < wall_3V)
								|| (Ball_X_Pos + Ball_Size >= wall_4V && Ball_Y_Pos - Ball_Size <= wall_4H && Ball_Y_Pos + Ball_Size >= 10'd195 && Ball_X_Pos < wall_4V)
								|| (Ball_X_Pos + Ball_Size >= wall_5V && Ball_Y_Pos - Ball_Size <= wall_5H && Ball_Y_Pos + Ball_Size >= 10'd315 && Ball_X_Pos < wall_5V)
								|| (Ball_X_Pos + Ball_Size >= wall_6V && Ball_Y_Pos - Ball_Size <= wall_6H && Ball_Y_Pos + Ball_Size >= top_wall_idx + wall_thickness && Ball_X_Pos < wall_6V)
								|| (Ball_X_Pos + Ball_Size >= wall_7V && Ball_Y_Pos - Ball_Size <= wall_7H && Ball_Y_Pos + Ball_Size >= wall_7H - wall_thickness && Ball_X_Pos < wall_7V)
								|| (Ball_X_Pos + Ball_Size >= wall_8V && Ball_Y_Pos - Ball_Size <= wall_8H && Ball_Y_Pos + Ball_Size >= wall_8H - wall_thickness && Ball_X_Pos < wall_8V)
								|| (Ball_X_Pos + Ball_Size >= wall_9V && Ball_Y_Pos - Ball_Size <= wall_9H && Ball_Y_Pos + Ball_Size >= wall_9H - wall_thickness && Ball_X_Pos < wall_9V)
								|| (Ball_X_Pos + Ball_Size >= wall_10V && Ball_Y_Pos - Ball_Size <= wall_10H && Ball_Y_Pos + Ball_Size >= wall_10H - wall_thickness && Ball_X_Pos < wall_10V))
								begin
									Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
									Ball_Y_Motion_in = 10'd0;
								end
						end
					default:
						begin
							loadReg1 = 1'b0;
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
				else if(Ball_Y_Pos - Ball_Size <= top_wall_idx)
					begin
						Ball_Y_Motion_in = Ball_Y_Step;
						Ball_X_Motion_in = 10'd0;
					end
				else if(Ball_X_Pos + Ball_Size >= right_wall_idx)
					begin
						Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
						Ball_Y_Motion_in = 10'd0;
					end
				else if(Ball_X_Pos - Ball_Size <= left_wall_idx + wall_thickness)
					begin
						Ball_X_Motion_in = Ball_X_Step;
						Ball_Y_Motion_in = 10'd0;
					end
					
					
            // Update the ball's position with its motion
            Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
				
				if(Ball_X_Pos >= maze1_goalV && Ball_Y_Pos <= maze1_goalH && Ball_Y_Pos >= maze1_goalH - wall_thickness)
					begin
						//output that maze is finished
						goal_reach1_in = 1'b1;
						Ball_X_Pos_in = 10'd140;
						Ball_Y_Pos_in = 10'd60;
					end
				else
					goal_reach1_in = 1'b0;
        end
		  end // END OF IF FOR MAZE 1
		  
		  else if(maze2out == 1'b1)
        begin
		  
		  // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
				case(keycode)
					8'h1A: //W
						begin
							loadReg2 = 1'b1;
							Ball_X_Motion_in = 10'd0;
							Ball_Y_Motion_in = ~(Ball_Y_Step) + 1'b1;
							
							if((Ball_Y_Pos - Ball_Size <= wall_1H3 && Ball_X_Pos + Ball_Size >= wall_1V3 && Ball_X_Pos - Ball_Size <= wall_1V3 + wall_thickness3 && Ball_Y_Pos > wall_1H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_2H3 && Ball_X_Pos + Ball_Size >= wall_2V3 && Ball_X_Pos - Ball_Size <= wall_2V3 + wall_thickness3 && Ball_Y_Pos > wall_2H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_3H3 && Ball_X_Pos + Ball_Size >= wall_3V3 && Ball_X_Pos - Ball_Size <= wall_3V3 + wall_thickness3 && Ball_Y_Pos > wall_3H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_4H3 && Ball_X_Pos + Ball_Size >= wall_4V3 && Ball_X_Pos - Ball_Size <= wall_4V3 + wall_thickness3 && Ball_Y_Pos > wall_4H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_5H3 && Ball_X_Pos + Ball_Size >= wall_5V3 && Ball_X_Pos - Ball_Size <= wall_5V3 + wall_thickness3 && Ball_Y_Pos > wall_5H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_6H3 && Ball_X_Pos + Ball_Size >= wall_6V3 && Ball_X_Pos - Ball_Size <= wall_6V3 + wall_thickness3 && Ball_Y_Pos > wall_6H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_7H3 && Ball_X_Pos + Ball_Size >= wall_7V3 && Ball_X_Pos - Ball_Size <= wall_7V3 + wall_thickness3 && Ball_Y_Pos > wall_7H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_8H3 && Ball_X_Pos + Ball_Size >= wall_8V3 && Ball_X_Pos - Ball_Size <= wall_8V3 + wall_thickness3 && Ball_Y_Pos > wall_8H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_9H3 && Ball_X_Pos + Ball_Size >= wall_9V3 && Ball_X_Pos - Ball_Size <= wall_9V3 + wall_thickness3 && Ball_Y_Pos > wall_9H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_10H3 && Ball_X_Pos + Ball_Size >= wall_10V3 && Ball_X_Pos - Ball_Size <= wall_10V3 + wall_thickness3 && Ball_Y_Pos > wall_10H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_11H3 && Ball_X_Pos + Ball_Size >= wall_11V3 && Ball_X_Pos - Ball_Size <= wall_11V3 + wall_thickness3 && Ball_Y_Pos > wall_11H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_12H3 && Ball_X_Pos + Ball_Size >= wall_12V3 && Ball_X_Pos - Ball_Size <= wall_12V3 + wall_thickness3 && Ball_Y_Pos > wall_12H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_13H3 && Ball_X_Pos + Ball_Size >= wall_13V3 && Ball_X_Pos - Ball_Size <= wall_13V3 + wall_thickness3 && Ball_Y_Pos > wall_13H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_14H3 && Ball_X_Pos + Ball_Size >= wall_14V3 && Ball_X_Pos - Ball_Size <= wall_14V3 + wall_thickness3 && Ball_Y_Pos > wall_14H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_15H3 && Ball_X_Pos + Ball_Size >= wall_15V3 && Ball_X_Pos - Ball_Size <= wall_15V3 + wall_thickness3 && Ball_Y_Pos > wall_15H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_16H3 && Ball_X_Pos + Ball_Size >= wall_16V3 && Ball_X_Pos - Ball_Size <= wall_16V3 + wall_thickness3 && Ball_Y_Pos > wall_16H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_17H3 && Ball_X_Pos + Ball_Size >= wall_17V3 && Ball_X_Pos - Ball_Size <= wall_17V3 + wall_thickness3 && Ball_Y_Pos > wall_17H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_18H3 && Ball_X_Pos + Ball_Size >= wall_18V3 && Ball_X_Pos - Ball_Size <= wall_18V3 + wall_thickness3 && Ball_Y_Pos > wall_18H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_19H3 && Ball_X_Pos + Ball_Size >= wall_19V3 && Ball_X_Pos - Ball_Size <= wall_19V3 + wall_thickness3 && Ball_Y_Pos > wall_19H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_20H3 && Ball_X_Pos + Ball_Size >= wall_20V3 && Ball_X_Pos - Ball_Size <= wall_20V3 + wall_thickness3 && Ball_Y_Pos > wall_20H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_21H3 && Ball_X_Pos + Ball_Size >= wall_21V3 && Ball_X_Pos - Ball_Size <= wall_21V3 + wall_thickness3 && Ball_Y_Pos > wall_21H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_22H3 && Ball_X_Pos + Ball_Size >= wall_22V3 && Ball_X_Pos - Ball_Size <= wall_22V3 + wall_thickness3 && Ball_Y_Pos > wall_22H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_23H3 && Ball_X_Pos + Ball_Size >= wall_23V3 && Ball_X_Pos - Ball_Size <= wall_23V3 + wall_thickness3 && Ball_Y_Pos > wall_23H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_24H3 && Ball_X_Pos + Ball_Size >= wall_24V3 && Ball_X_Pos - Ball_Size <= 10'd210 && Ball_Y_Pos > wall_24H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_25H3 && Ball_X_Pos + Ball_Size >= wall_25V3 && Ball_X_Pos - Ball_Size <= 10'd330 && Ball_Y_Pos > wall_25H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_26H3 && Ball_X_Pos + Ball_Size >= wall_26V3 && Ball_X_Pos - Ball_Size <= 10'd290 && Ball_Y_Pos > wall_26H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_27H3 && Ball_X_Pos + Ball_Size >= wall_27V3 && Ball_X_Pos - Ball_Size <= 10'd410 && Ball_Y_Pos > wall_27H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_28H3 && Ball_X_Pos + Ball_Size >= wall_28V3 && Ball_X_Pos - Ball_Size <= 10'd490 && Ball_Y_Pos > wall_28H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_29H3 && Ball_X_Pos + Ball_Size >= wall_29V3 && Ball_X_Pos - Ball_Size <= 10'd510 && Ball_Y_Pos > wall_29H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_30H3 && Ball_X_Pos + Ball_Size >= wall_30V3 && Ball_X_Pos - Ball_Size <= 10'd250 && Ball_Y_Pos > wall_30H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_31H3 && Ball_X_Pos + Ball_Size >= wall_31V3 && Ball_X_Pos - Ball_Size <= 10'd450 && Ball_Y_Pos > wall_31H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_32H3 && Ball_X_Pos + Ball_Size >= wall_32V3 && Ball_X_Pos - Ball_Size <= 10'd170 && Ball_Y_Pos > wall_32H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_33H3 && Ball_X_Pos + Ball_Size >= wall_33V3 && Ball_X_Pos - Ball_Size <= 10'd290 && Ball_Y_Pos > wall_33H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_34H3 && Ball_X_Pos + Ball_Size >= wall_34V3 && Ball_X_Pos - Ball_Size <= 10'd370 && Ball_Y_Pos > wall_34H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_35H3 && Ball_X_Pos + Ball_Size >= wall_35V3 && Ball_X_Pos - Ball_Size <= 10'd410 && Ball_Y_Pos > wall_35H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_36H3 && Ball_X_Pos + Ball_Size >= wall_36V3 && Ball_X_Pos - Ball_Size <= 10'd250 && Ball_Y_Pos > wall_36H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_37H3 && Ball_X_Pos + Ball_Size >= wall_37V3 && Ball_X_Pos - Ball_Size <= 10'd370 && Ball_Y_Pos > wall_37H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_38H3 && Ball_X_Pos + Ball_Size >= wall_38V3 && Ball_X_Pos - Ball_Size <= 10'd490 && Ball_Y_Pos > wall_38H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_39H3 && Ball_X_Pos + Ball_Size >= wall_39V3 && Ball_X_Pos - Ball_Size <= 10'd250 && Ball_Y_Pos > wall_39H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_40H3 && Ball_X_Pos + Ball_Size >= wall_40V3 && Ball_X_Pos - Ball_Size <= 10'd410 && Ball_Y_Pos > wall_40H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_41H3 && Ball_X_Pos + Ball_Size >= wall_41V3 && Ball_X_Pos - Ball_Size <= 10'd210 && Ball_Y_Pos > wall_41H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_42H3 && Ball_X_Pos + Ball_Size >= wall_42V3 && Ball_X_Pos - Ball_Size <= 10'd290 && Ball_Y_Pos > wall_42H3)
								|| (Ball_Y_Pos - Ball_Size <= wall_43H3 && Ball_X_Pos + Ball_Size >= wall_43V3 && Ball_X_Pos - Ball_Size <= 10'd450 && Ball_Y_Pos > wall_43H3))
								begin
									Ball_Y_Motion_in = Ball_Y_Step;
									Ball_X_Motion_in = 10'd0;
								end
						end
					8'h16: //S
						begin
							loadReg2 = 1'b1;
							Ball_X_Motion_in = 10'd0;
							Ball_Y_Motion_in = Ball_Y_Step;
							
							if((Ball_Y_Pos + Ball_Size >= 10'd70 && Ball_X_Pos + Ball_Size >= wall_1V3 && Ball_X_Pos - Ball_Size <= wall_1V3 + wall_thickness3 && Ball_Y_Pos < 10'd70)
								|| (Ball_Y_Pos + Ball_Size >= 10'd230 && Ball_X_Pos + Ball_Size >= wall_2V3 && Ball_X_Pos - Ball_Size <= wall_2V3 + wall_thickness3 && Ball_Y_Pos < 10'd230)
								|| (Ball_Y_Pos + Ball_Size >= 10'd350 && Ball_X_Pos + Ball_Size >= wall_3V3 && Ball_X_Pos - Ball_Size <= wall_3V3 + wall_thickness3 && Ball_Y_Pos < 10'd350)
								|| (Ball_Y_Pos + Ball_Size >= 10'd70 && Ball_X_Pos + Ball_Size >= wall_4V3 && Ball_X_Pos - Ball_Size <= wall_4V3 + wall_thickness3 && Ball_Y_Pos < 10'd70)
								|| (Ball_Y_Pos + Ball_Size >= 10'd190 && Ball_X_Pos + Ball_Size >= wall_5V3 && Ball_X_Pos - Ball_Size <= wall_5V3 + wall_thickness3 && Ball_Y_Pos < 10'd190)
								|| (Ball_Y_Pos + Ball_Size >= 10'd390 && Ball_X_Pos + Ball_Size >= wall_6V3 && Ball_X_Pos - Ball_Size <= wall_6V3 + wall_thickness3 && Ball_Y_Pos < 10'd390)
								|| (Ball_Y_Pos + Ball_Size >= 10'd50 && Ball_X_Pos + Ball_Size >= wall_7V3 && Ball_X_Pos - Ball_Size <= wall_7V3 + wall_thickness3 && Ball_Y_Pos < 10'd50)
								|| (Ball_Y_Pos + Ball_Size >= 10'd150 && Ball_X_Pos + Ball_Size >= wall_8V3 && Ball_X_Pos - Ball_Size <= wall_8V3 + wall_thickness3 && Ball_Y_Pos < 10'd150)
								|| (Ball_Y_Pos + Ball_Size >= 10'd270 && Ball_X_Pos + Ball_Size >= wall_9V3 && Ball_X_Pos - Ball_Size <= wall_9V3 + wall_thickness3 && Ball_Y_Pos < 10'd270)
								|| (Ball_Y_Pos + Ball_Size >= 10'd350 && Ball_X_Pos + Ball_Size >= wall_10V3 && Ball_X_Pos - Ball_Size <= wall_10V3 + wall_thickness3 && Ball_Y_Pos < 10'd350)
								|| (Ball_Y_Pos + Ball_Size >= 10'd110 && Ball_X_Pos + Ball_Size >= wall_11V3 && Ball_X_Pos - Ball_Size <= wall_11V3 + wall_thickness3 && Ball_Y_Pos < 10'd110)
								|| (Ball_Y_Pos + Ball_Size >= 10'd70 && Ball_X_Pos + Ball_Size >= wall_12V3 && Ball_X_Pos - Ball_Size <= wall_12V3 + wall_thickness3 && Ball_Y_Pos < 10'd70)
								|| (Ball_Y_Pos + Ball_Size >= 10'd350 && Ball_X_Pos + Ball_Size >= wall_13V3 && Ball_X_Pos - Ball_Size <= wall_13V3 + wall_thickness3 && Ball_Y_Pos < 10'd350)
								|| (Ball_Y_Pos + Ball_Size >= 10'd50 && Ball_X_Pos + Ball_Size >= wall_14V3 && Ball_X_Pos - Ball_Size <= wall_14V3 + wall_thickness3 && Ball_Y_Pos < 10'd50)
								|| (Ball_Y_Pos + Ball_Size >= 10'd190 && Ball_X_Pos + Ball_Size >= wall_15V3 && Ball_X_Pos - Ball_Size <= wall_15V3 + wall_thickness3 && Ball_Y_Pos < 10'd190)
								|| (Ball_Y_Pos + Ball_Size >= 10'd270 && Ball_X_Pos + Ball_Size >= wall_16V3 && Ball_X_Pos - Ball_Size <= wall_16V3 + wall_thickness3 && Ball_Y_Pos < 10'd270)
								|| (Ball_Y_Pos + Ball_Size >= 10'd70 && Ball_X_Pos + Ball_Size >= wall_17V3 && Ball_X_Pos - Ball_Size <= wall_17V3 + wall_thickness3 && Ball_Y_Pos < 10'd70)
								|| (Ball_Y_Pos + Ball_Size >= 10'd230 && Ball_X_Pos + Ball_Size >= wall_18V3 && Ball_X_Pos - Ball_Size <= wall_18V3 + wall_thickness3 && Ball_Y_Pos < 10'd230)
								|| (Ball_Y_Pos + Ball_Size >= 10'd70 && Ball_X_Pos + Ball_Size >= wall_19V3 && Ball_X_Pos - Ball_Size <= wall_19V3 + wall_thickness3 && Ball_Y_Pos < 10'd70)
								|| (Ball_Y_Pos + Ball_Size >= 10'd190 && Ball_X_Pos + Ball_Size >= wall_20V3 && Ball_X_Pos - Ball_Size <= wall_20V3 + wall_thickness3 && Ball_Y_Pos < 10'd190)
								|| (Ball_Y_Pos + Ball_Size >= 10'd50 && Ball_X_Pos + Ball_Size >= wall_21V3 && Ball_X_Pos - Ball_Size <= wall_21V3 + wall_thickness3 && Ball_Y_Pos < 10'd50)
								|| (Ball_Y_Pos + Ball_Size >= 10'd190 && Ball_X_Pos + Ball_Size >= wall_22V3 && Ball_X_Pos - Ball_Size <= wall_22V3 + wall_thickness3 && Ball_Y_Pos < 10'd190)
								|| (Ball_Y_Pos + Ball_Size >= 10'd350 && Ball_X_Pos + Ball_Size >= wall_23V3 && Ball_X_Pos - Ball_Size <= wall_23V3 + wall_thickness3 && Ball_Y_Pos < 10'd350)
								|| (Ball_Y_Pos + Ball_Size >= wall_24H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_24V3 && Ball_X_Pos - Ball_Size <= 10'd210 && Ball_Y_Pos < wall_24H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_25H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_25V3 && Ball_X_Pos - Ball_Size <= 10'd330 && Ball_Y_Pos < wall_25H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_26H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_26V3 && Ball_X_Pos - Ball_Size <= 10'd290 && Ball_Y_Pos < wall_26H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_27H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_27V3 && Ball_X_Pos - Ball_Size <= 10'd410 && Ball_Y_Pos < wall_27H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_28H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_28V3 && Ball_X_Pos - Ball_Size <= 10'd490 && Ball_Y_Pos < wall_28H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_29H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_29V3 && Ball_X_Pos - Ball_Size <= 10'd510 && Ball_Y_Pos < wall_29H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_30H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_30V3 && Ball_X_Pos - Ball_Size <= 10'd250 && Ball_Y_Pos < wall_30H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_31H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_31V3 && Ball_X_Pos - Ball_Size <= 10'd450 && Ball_Y_Pos < wall_31H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_32H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_32V3 && Ball_X_Pos - Ball_Size <= 10'd170 && Ball_Y_Pos < wall_32H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_33H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_33V3 && Ball_X_Pos - Ball_Size <= 10'd290 && Ball_Y_Pos < wall_33H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_34H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_34V3 && Ball_X_Pos - Ball_Size <= 10'd370 && Ball_Y_Pos < wall_34H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_35H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_35V3 && Ball_X_Pos - Ball_Size <= 10'd410 && Ball_Y_Pos < wall_35H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_36H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_36V3 && Ball_X_Pos - Ball_Size <= 10'd250 && Ball_Y_Pos < wall_36H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_37H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_37V3 && Ball_X_Pos - Ball_Size <= 10'd370 && Ball_Y_Pos < wall_37H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_38H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_38V3 && Ball_X_Pos - Ball_Size <= 10'd490 && Ball_Y_Pos < wall_38H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_39H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_39V3 && Ball_X_Pos - Ball_Size <= 10'd250 && Ball_Y_Pos < wall_39H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_40H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_40V3 && Ball_X_Pos - Ball_Size <= 10'd410 && Ball_Y_Pos < wall_40H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_41H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_41V3 && Ball_X_Pos - Ball_Size <= 10'd210 && Ball_Y_Pos < wall_41H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_42H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_42V3 && Ball_X_Pos - Ball_Size <= 10'd290 && Ball_Y_Pos < wall_42H3 - wall_thickness3)
								|| (Ball_Y_Pos + Ball_Size >= wall_43H3 - wall_thickness3 && Ball_X_Pos + Ball_Size >= wall_43V3 && Ball_X_Pos - Ball_Size <= 10'd450 && Ball_Y_Pos < wall_43H3 - wall_thickness3))
								begin
									Ball_Y_Motion_in = ~(Ball_Y_Step) + 1'b1;
									Ball_X_Motion_in = 10'd0;
								end
						end
					8'h04: //A
						begin
							loadReg2 = 1'b1;
							Ball_X_Motion_in = ~(Ball_X_Step) + 1'b1;
							Ball_Y_Motion_in = 10'd0;
							
							if((Ball_X_Pos - Ball_Size <= wall_1V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_1H3 && Ball_Y_Pos + Ball_Size >= 10'd70 && Ball_X_Pos > wall_1V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_2V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_2H3 && Ball_Y_Pos + Ball_Size >= 10'd230 && Ball_X_Pos > wall_2V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_3V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_3H3 && Ball_Y_Pos + Ball_Size >= 10'd350 && Ball_X_Pos > wall_3V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_4V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_4H3 && Ball_Y_Pos + Ball_Size >= 10'd70 && Ball_X_Pos > wall_4V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_5V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_5H3 && Ball_Y_Pos + Ball_Size >= 10'd190 && Ball_X_Pos > wall_5V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_6V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_6H3 && Ball_Y_Pos + Ball_Size >= 10'd390 && Ball_X_Pos > wall_6V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_7V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_7H3 && Ball_Y_Pos + Ball_Size >= 10'd50 && Ball_X_Pos > wall_7V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_8V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_8H3 && Ball_Y_Pos + Ball_Size >= 10'd150 && Ball_X_Pos > wall_8V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_9V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_9H3 && Ball_Y_Pos + Ball_Size >= 10'd270 && Ball_X_Pos > wall_9V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_10V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_10H3 && Ball_Y_Pos + Ball_Size >= 10'd350 && Ball_X_Pos > wall_10V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_11V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_11H3 && Ball_Y_Pos + Ball_Size >= 10'd110 && Ball_X_Pos > wall_11V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_12V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_12H3 && Ball_Y_Pos + Ball_Size >= 10'd70 && Ball_X_Pos > wall_12V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_13V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_13H3 && Ball_Y_Pos + Ball_Size >= 10'd350 && Ball_X_Pos > wall_13V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_14V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_14H3 && Ball_Y_Pos + Ball_Size >= 10'd50 && Ball_X_Pos > wall_14V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_15V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_15H3 && Ball_Y_Pos + Ball_Size >= 10'd190 && Ball_X_Pos > wall_15V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_16V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_16H3 && Ball_Y_Pos + Ball_Size >= 10'd270 && Ball_X_Pos > wall_16V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_17V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_17H3 && Ball_Y_Pos + Ball_Size >= 10'd70 && Ball_X_Pos > wall_17V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_18V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_18H3 && Ball_Y_Pos + Ball_Size >= 10'd230 && Ball_X_Pos > wall_18V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_19V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_19H3 && Ball_Y_Pos + Ball_Size >= 10'd70 && Ball_X_Pos > wall_19V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_20V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_20H3 && Ball_Y_Pos + Ball_Size >= 10'd190 && Ball_X_Pos > wall_20V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_21V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_21H3 && Ball_Y_Pos + Ball_Size >= 10'd50 && Ball_X_Pos > wall_21V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_22V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_22H3 && Ball_Y_Pos + Ball_Size >= 10'd190 && Ball_X_Pos > wall_22V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= wall_23V3 + wall_thickness3 && Ball_Y_Pos - Ball_Size <= wall_23H3 && Ball_Y_Pos + Ball_Size >= 10'd350 && Ball_X_Pos > wall_23V3 + wall_thickness3)
								|| (Ball_X_Pos - Ball_Size <= 10'd210 && Ball_Y_Pos - Ball_Size <= wall_24H3 && Ball_Y_Pos + Ball_Size >= wall_24H3 - wall_thickness3 && Ball_X_Pos > 10'd210)
								|| (Ball_X_Pos - Ball_Size <= 10'd330 && Ball_Y_Pos - Ball_Size <= wall_25H3 && Ball_Y_Pos + Ball_Size >= wall_25H3 - wall_thickness3 && Ball_X_Pos > 10'd330)
								|| (Ball_X_Pos - Ball_Size <= 10'd290 && Ball_Y_Pos - Ball_Size <= wall_26H3 && Ball_Y_Pos + Ball_Size >= wall_26H3 - wall_thickness3 && Ball_X_Pos > 10'd290)
								|| (Ball_X_Pos - Ball_Size <= 10'd410 && Ball_Y_Pos - Ball_Size <= wall_27H3 && Ball_Y_Pos + Ball_Size >= wall_27H3 - wall_thickness3 && Ball_X_Pos > 10'd410)
								|| (Ball_X_Pos - Ball_Size <= 10'd490 && Ball_Y_Pos - Ball_Size <= wall_28H3 && Ball_Y_Pos + Ball_Size >= wall_28H3 - wall_thickness3 && Ball_X_Pos > 10'd490)
								|| (Ball_X_Pos - Ball_Size <= 10'd510 && Ball_Y_Pos - Ball_Size <= wall_29H3 && Ball_Y_Pos + Ball_Size >= wall_29H3 - wall_thickness3 && Ball_X_Pos > 10'd510)
								|| (Ball_X_Pos - Ball_Size <= 10'd250 && Ball_Y_Pos - Ball_Size <= wall_30H3 && Ball_Y_Pos + Ball_Size >= wall_30H3 - wall_thickness3 && Ball_X_Pos > 10'd250)
								|| (Ball_X_Pos - Ball_Size <= 10'd450 && Ball_Y_Pos - Ball_Size <= wall_31H3 && Ball_Y_Pos + Ball_Size >= wall_31H3 - wall_thickness3 && Ball_X_Pos > 10'd450)
								|| (Ball_X_Pos - Ball_Size <= 10'd170 && Ball_Y_Pos - Ball_Size <= wall_32H3 && Ball_Y_Pos + Ball_Size >= wall_32H3 - wall_thickness3 && Ball_X_Pos > 10'd170)
								|| (Ball_X_Pos - Ball_Size <= 10'd290 && Ball_Y_Pos - Ball_Size <= wall_33H3 && Ball_Y_Pos + Ball_Size >= wall_33H3 - wall_thickness3 && Ball_X_Pos > 10'd290)
								|| (Ball_X_Pos - Ball_Size <= 10'd370 && Ball_Y_Pos - Ball_Size <= wall_34H3 && Ball_Y_Pos + Ball_Size >= wall_34H3 - wall_thickness3 && Ball_X_Pos > 10'd370)
								|| (Ball_X_Pos - Ball_Size <= 10'd410 && Ball_Y_Pos - Ball_Size <= wall_35H3 && Ball_Y_Pos + Ball_Size >= wall_35H3 - wall_thickness3 && Ball_X_Pos > 10'd410)
								|| (Ball_X_Pos - Ball_Size <= 10'd250 && Ball_Y_Pos - Ball_Size <= wall_36H3 && Ball_Y_Pos + Ball_Size >= wall_36H3 - wall_thickness3 && Ball_X_Pos > 10'd250)
								|| (Ball_X_Pos - Ball_Size <= 10'd370 && Ball_Y_Pos - Ball_Size <= wall_37H3 && Ball_Y_Pos + Ball_Size >= wall_37H3 - wall_thickness3 && Ball_X_Pos > 10'd370)
								|| (Ball_X_Pos - Ball_Size <= 10'd490 && Ball_Y_Pos - Ball_Size <= wall_38H3 && Ball_Y_Pos + Ball_Size >= wall_38H3 - wall_thickness3 && Ball_X_Pos > 10'd490)
								|| (Ball_X_Pos - Ball_Size <= 10'd250 && Ball_Y_Pos - Ball_Size <= wall_39H3 && Ball_Y_Pos + Ball_Size >= wall_39H3 - wall_thickness3 && Ball_X_Pos > 10'd250)
								|| (Ball_X_Pos - Ball_Size <= 10'd410 && Ball_Y_Pos - Ball_Size <= wall_40H3 && Ball_Y_Pos + Ball_Size >= wall_40H3 - wall_thickness3 && Ball_X_Pos > 10'd410)
								|| (Ball_X_Pos - Ball_Size <= 10'd210 && Ball_Y_Pos - Ball_Size <= wall_41H3 && Ball_Y_Pos + Ball_Size >= wall_41H3 - wall_thickness3 && Ball_X_Pos > 10'd210)
								|| (Ball_X_Pos - Ball_Size <= 10'd290 && Ball_Y_Pos - Ball_Size <= wall_42H3 && Ball_Y_Pos + Ball_Size >= wall_42H3 - wall_thickness3 && Ball_X_Pos > 10'd290)
								|| (Ball_X_Pos - Ball_Size <= 10'd450 && Ball_Y_Pos - Ball_Size <= wall_43H3 && Ball_Y_Pos + Ball_Size >= wall_43H3 - wall_thickness3 && Ball_X_Pos > 10'd450))
								begin
									Ball_X_Motion_in = Ball_X_Step;
									Ball_Y_Motion_in = 10'd0;
								end
						end
					8'h07: //D
						begin
							loadReg2 = 1'b1;
							Ball_X_Motion_in = Ball_X_Step;
							Ball_Y_Motion_in = 10'd0;
							
							if((Ball_X_Pos + Ball_Size >= wall_1V3 && Ball_Y_Pos - Ball_Size <= wall_1H3 && Ball_Y_Pos + Ball_Size >= 10'd70 && Ball_X_Pos < wall_1V3)
								|| (Ball_X_Pos + Ball_Size >= wall_2V3 && Ball_Y_Pos - Ball_Size <= wall_2H3 && Ball_Y_Pos + Ball_Size >= 10'd230 && Ball_X_Pos < wall_2V3)
								|| (Ball_X_Pos + Ball_Size >= wall_3V3 && Ball_Y_Pos - Ball_Size <= wall_3H3 && Ball_Y_Pos + Ball_Size >= 10'd350 && Ball_X_Pos < wall_3V3)
								|| (Ball_X_Pos + Ball_Size >= wall_4V3 && Ball_Y_Pos - Ball_Size <= wall_4H3 && Ball_Y_Pos + Ball_Size >= 10'd70 && Ball_X_Pos < wall_4V3)
								|| (Ball_X_Pos + Ball_Size >= wall_5V3 && Ball_Y_Pos - Ball_Size <= wall_5H3 && Ball_Y_Pos + Ball_Size >= 10'd190 && Ball_X_Pos < wall_5V3)
								|| (Ball_X_Pos + Ball_Size >= wall_6V3 && Ball_Y_Pos - Ball_Size <= wall_6H3 && Ball_Y_Pos + Ball_Size >= 10'd390 && Ball_X_Pos < wall_6V3)
								|| (Ball_X_Pos + Ball_Size >= wall_7V3 && Ball_Y_Pos - Ball_Size <= wall_7H3 && Ball_Y_Pos + Ball_Size >= 10'd50 && Ball_X_Pos < wall_7V3)
								|| (Ball_X_Pos + Ball_Size >= wall_8V3 && Ball_Y_Pos - Ball_Size <= wall_8H3 && Ball_Y_Pos + Ball_Size >= 10'd150 && Ball_X_Pos < wall_8V3)
								|| (Ball_X_Pos + Ball_Size >= wall_9V3 && Ball_Y_Pos - Ball_Size <= wall_9H3 && Ball_Y_Pos + Ball_Size >= 10'd270 && Ball_X_Pos < wall_9V3)
								|| (Ball_X_Pos + Ball_Size >= wall_10V3 && Ball_Y_Pos - Ball_Size <= wall_10H3 && Ball_Y_Pos + Ball_Size >= 10'd350 && Ball_X_Pos < wall_10V3)
								|| (Ball_X_Pos + Ball_Size >= wall_11V3 && Ball_Y_Pos - Ball_Size <= wall_11H3 && Ball_Y_Pos + Ball_Size >= 10'd110 && Ball_X_Pos < wall_11V3)
								|| (Ball_X_Pos + Ball_Size >= wall_12V3 && Ball_Y_Pos - Ball_Size <= wall_12H3 && Ball_Y_Pos + Ball_Size >= 10'd70 && Ball_X_Pos < wall_12V3)
								|| (Ball_X_Pos + Ball_Size >= wall_13V3 && Ball_Y_Pos - Ball_Size <= wall_13H3 && Ball_Y_Pos + Ball_Size >= 10'd350 && Ball_X_Pos < wall_13V3)
								|| (Ball_X_Pos + Ball_Size >= wall_14V3 && Ball_Y_Pos - Ball_Size <= wall_14H3 && Ball_Y_Pos + Ball_Size >= 10'd50 && Ball_X_Pos < wall_14V3)
								|| (Ball_X_Pos + Ball_Size >= wall_15V3 && Ball_Y_Pos - Ball_Size <= wall_15H3 && Ball_Y_Pos + Ball_Size >= 10'd190 && Ball_X_Pos < wall_15V3)
								|| (Ball_X_Pos + Ball_Size >= wall_16V3 && Ball_Y_Pos - Ball_Size <= wall_16H3 && Ball_Y_Pos + Ball_Size >= 10'd270 && Ball_X_Pos < wall_16V3)
								|| (Ball_X_Pos + Ball_Size >= wall_17V3 && Ball_Y_Pos - Ball_Size <= wall_17H3 && Ball_Y_Pos + Ball_Size >= 10'd70 && Ball_X_Pos < wall_17V3)
								|| (Ball_X_Pos + Ball_Size >= wall_18V3 && Ball_Y_Pos - Ball_Size <= wall_18H3 && Ball_Y_Pos + Ball_Size >= 10'd230 && Ball_X_Pos < wall_18V3)
								|| (Ball_X_Pos + Ball_Size >= wall_19V3 && Ball_Y_Pos - Ball_Size <= wall_19H3 && Ball_Y_Pos + Ball_Size >= 10'd70 && Ball_X_Pos < wall_19V3)
								|| (Ball_X_Pos + Ball_Size >= wall_20V3 && Ball_Y_Pos - Ball_Size <= wall_20H3 && Ball_Y_Pos + Ball_Size >= 10'd190 && Ball_X_Pos < wall_20V3)
								|| (Ball_X_Pos + Ball_Size >= wall_21V3 && Ball_Y_Pos - Ball_Size <= wall_21H3 && Ball_Y_Pos + Ball_Size >= 10'd50 && Ball_X_Pos < wall_21V3)
								|| (Ball_X_Pos + Ball_Size >= wall_22V3 && Ball_Y_Pos - Ball_Size <= wall_22H3 && Ball_Y_Pos + Ball_Size >= 10'd190 && Ball_X_Pos < wall_22V3)
								|| (Ball_X_Pos + Ball_Size >= wall_23V3 && Ball_Y_Pos - Ball_Size <= wall_23H3 && Ball_Y_Pos + Ball_Size >= 10'd350 && Ball_X_Pos < wall_23V3)
								/*
								|| (Ball_X_Pos + Ball_Size >= wall_24V3 && Ball_Y_Pos - Ball_Size <= wall_24V3 && Ball_Y_Pos + Ball_Size >= wall_24V3 - wall_thickness3 && Ball_X_Pos < wall_24V3)
								|| (Ball_X_Pos + Ball_Size >= wall_25V3 && Ball_Y_Pos - Ball_Size <= wall_25V3 && Ball_Y_Pos + Ball_Size >= wall_25V3 - wall_thickness3 && Ball_X_Pos < wall_25V3)
								|| (Ball_X_Pos + Ball_Size >= wall_26V3 && Ball_Y_Pos - Ball_Size <= wall_26V3 && Ball_Y_Pos + Ball_Size >= wall_26V3 - wall_thickness3 && Ball_X_Pos < wall_26V3)
								|| (Ball_X_Pos + Ball_Size >= wall_27V3 && Ball_Y_Pos - Ball_Size <= wall_27V3 && Ball_Y_Pos + Ball_Size >= wall_27V3 - wall_thickness3 && Ball_X_Pos < wall_27V3)
								|| (Ball_X_Pos + Ball_Size >= wall_28V3 && Ball_Y_Pos - Ball_Size <= wall_28V3 && Ball_Y_Pos + Ball_Size >= wall_28V3 - wall_thickness3 && Ball_X_Pos < wall_28V3)
								|| (Ball_X_Pos + Ball_Size >= wall_29V3 && Ball_Y_Pos - Ball_Size <= wall_29V3 && Ball_Y_Pos + Ball_Size >= wall_29V3 - wall_thickness3 && Ball_X_Pos < wall_29V3)
								|| (Ball_X_Pos + Ball_Size >= wall_30V3 && Ball_Y_Pos - Ball_Size <= wall_30V3 && Ball_Y_Pos + Ball_Size >= wall_30V3 - wall_thickness3 && Ball_X_Pos < wall_30V3)
								|| (Ball_X_Pos + Ball_Size >= wall_31V3 && Ball_Y_Pos - Ball_Size <= wall_31V3 && Ball_Y_Pos + Ball_Size >= wall_31V3 - wall_thickness3 && Ball_X_Pos < wall_31V3)
								|| (Ball_X_Pos + Ball_Size >= wall_32V3 && Ball_Y_Pos - Ball_Size <= wall_32V3 && Ball_Y_Pos + Ball_Size >= wall_32V3 - wall_thickness3 && Ball_X_Pos < wall_32V3)
								|| (Ball_X_Pos + Ball_Size >= wall_33V3 && Ball_Y_Pos - Ball_Size <= wall_33V3 && Ball_Y_Pos + Ball_Size >= wall_33V3 - wall_thickness3 && Ball_X_Pos < wall_33V3)
								|| (Ball_X_Pos + Ball_Size >= wall_34V3 && Ball_Y_Pos - Ball_Size <= wall_34V3 && Ball_Y_Pos + Ball_Size >= wall_34V3 - wall_thickness3 && Ball_X_Pos < wall_34V3)
								|| (Ball_X_Pos + Ball_Size >= wall_35V3 && Ball_Y_Pos - Ball_Size <= wall_35V3 && Ball_Y_Pos + Ball_Size >= wall_35V3 - wall_thickness3 && Ball_X_Pos < wall_35V3)
								|| (Ball_X_Pos + Ball_Size >= wall_36V3 && Ball_Y_Pos - Ball_Size <= wall_36V3 && Ball_Y_Pos + Ball_Size >= wall_36V3 - wall_thickness3 && Ball_X_Pos < wall_36V3)
								|| (Ball_X_Pos + Ball_Size >= wall_37V3 && Ball_Y_Pos - Ball_Size <= wall_37V3 && Ball_Y_Pos + Ball_Size >= wall_37V3 - wall_thickness3 && Ball_X_Pos < wall_37V3)
								|| (Ball_X_Pos + Ball_Size >= wall_38V3 && Ball_Y_Pos - Ball_Size <= wall_38V3 && Ball_Y_Pos + Ball_Size >= wall_38V3 - wall_thickness3 && Ball_X_Pos < wall_38V3)
								|| (Ball_X_Pos + Ball_Size >= wall_39V3 && Ball_Y_Pos - Ball_Size <= wall_39V3 && Ball_Y_Pos + Ball_Size >= wall_39V3 - wall_thickness3 && Ball_X_Pos < wall_39V3)
								|| (Ball_X_Pos + Ball_Size >= wall_40V3 && Ball_Y_Pos - Ball_Size <= wall_40V3 && Ball_Y_Pos + Ball_Size >= wall_40V3 - wall_thickness3 && Ball_X_Pos < wall_40V3)
								|| (Ball_X_Pos + Ball_Size >= wall_41V3 && Ball_Y_Pos - Ball_Size <= wall_41V3 && Ball_Y_Pos + Ball_Size >= wall_41V3 - wall_thickness3 && Ball_X_Pos < wall_41V3)
								|| (Ball_X_Pos + Ball_Size >= wall_42V3 && Ball_Y_Pos - Ball_Size <= wall_42V3 && Ball_Y_Pos + Ball_Size >= wall_42V3 - wall_thickness3 && Ball_X_Pos < wall_42V3)
								|| (Ball_X_Pos + Ball_Size >= wall_43V3 && Ball_Y_Pos - Ball_Size <= wall_43V3 && Ball_Y_Pos + Ball_Size >= wall_43V3 - wall_thickness3 && Ball_X_Pos < wall_43V3)*/)
								begin
									Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
									Ball_Y_Motion_in = 10'd0;
								end
								
						end
					default:
						begin
							loadReg2 = 1'b0;
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
				if(Ball_Y_Pos + Ball_Size >= bottom_wall_idx3 - wall_thickness3)
					begin
						Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.
						Ball_X_Motion_in = 10'd0;
					end
				else if(Ball_Y_Pos - Ball_Size <= top_wall_idx3)
					begin
						Ball_Y_Motion_in = Ball_Y_Step;
						Ball_X_Motion_in = 10'd0;
					end
				else if(Ball_X_Pos + Ball_Size >= right_wall_idx3)
					begin
						Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
						Ball_Y_Motion_in = 10'd0;
					end
				else if(Ball_X_Pos - Ball_Size <= left_wall_idx3 + wall_thickness3)
					begin
						Ball_X_Motion_in = Ball_X_Step;
						Ball_Y_Motion_in = 10'd0;
					end

            // Update the ball's position with its motion
            Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
				
				if(Ball_X_Pos >= maze3_goalV && Ball_Y_Pos <= maze3_goalH && Ball_Y_Pos >= maze3_goalH - wall_thickness3)
					begin
						//output that maze is finished
						goal_reach2_in = 1'b1;
						Ball_X_Pos_in = 10'd30;
						Ball_Y_Pos_in = 10'd140;
					end
					else
						goal_reach2_in = 1'b0;
        end
		  
		  end //END OF IF FOR MAZE 2
		  
		  else
		  begin
		  
		  // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
				case(keycode)
					8'h1A: //W
						begin
							Ball_X_Motion_in = 10'd0;
							Ball_Y_Motion_in = ~(Ball_Y_Step) + 1'b1;
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
						end
					8'h07: //D
						begin
							Ball_X_Motion_in = Ball_X_Step;
							Ball_Y_Motion_in = 10'd0;
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
				/*	
				// Create wall conditions
				if(Ball_Y_Pos + Ball_Size >= bottom_wall_idx - wall_thickness)
					begin
						Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.
						Ball_X_Motion_in = 10'd0;
					end
				else if(Ball_Y_Pos - Ball_Size <= top_wall_idx)
					begin
						Ball_Y_Motion_in = Ball_Y_Step;
						Ball_X_Motion_in = 10'd0;
					end
				else if(Ball_X_Pos + Ball_Size >= right_wall_idx)
					begin
						Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);
						Ball_Y_Motion_in = 10'd0;
					end
				else if(Ball_X_Pos - Ball_Size <= left_wall_idx + wall_thickness)
					begin
						Ball_X_Motion_in = Ball_X_Step;
						Ball_Y_Motion_in = 10'd0;
					end
				*/
				/*	
				//if(maze1out == 1'b1)
				//begin
					if(Ball_X_Pos >= maze1_goalV && Ball_Y_Pos <= maze1_goalH && Ball_Y_Pos >= maze1_goalH - wall_thickness)
					begin
						//output that maze is finished
						goal_reach1_in = 1'b1;
						Ball_X_Pos_in = Ball_X_Pos;
						Ball_Y_Pos_in = Ball_Y_Pos;
					end
					else
						goal_reach1_in = 1'b0;
				//end
				//else
					//goal_reach1_in = 1'b0;
				*/
					
            // Update the ball's position with its motion
            Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
        end
		  
		  end // MAZE 3 CONDITION
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
