// This file will be used for the control unit

module control(input logic Clk, Reset, goal_reach1, goal_reach2,
					output logic maze1out, maze2out, maze3out);

	enum logic [2:0] {ResetState, Maze1, Maze1Wait, Maze2, Maze2Wait, Maze3, Maze3Wait} curr_state, next_state;
	
	always_ff @ (posedge Clk)
	begin
		if(Reset)
			curr_state <= ResetState;
		else
			curr_state <= next_state;
	end
	
	always_comb
	begin
		next_state = curr_state;
		
		unique case(curr_state)
		
			ResetState:		next_state = Maze1;
			Maze1:			if(goal_reach1 == 1'b1)
									next_state = Maze2;
								else
									next_state = Maze1Wait;
			Maze1Wait:		next_state = Maze1;
			Maze2:			if(goal_reach2 == 1'b1)
									next_state = Maze3;
								else
									next_state = Maze2Wait;
			Maze2Wait:		next_state = Maze2;
			Maze3:			next_state = Maze3Wait;
								//if(goal_reach == 1'b1)
								//	next_state = Maze1;
								//else
								//	next_state = Maze3Wait;
			Maze3Wait:		next_state = Maze3;
			
		endcase
		
		case(curr_state)
			
			ResetState:
			begin
				maze1out = 1'b1;
				maze2out = 1'b0;
				maze3out = 1'b0;
			end
			
			Maze1:
			begin
				maze1out = 1'b1;
				maze2out = 1'b0;
				maze3out = 1'b0;
			end
			
			Maze1Wait:
			begin
				maze1out = 1'b1;
				maze2out = 1'b0;
				maze3out = 1'b0;
			end
			
			Maze2:
			begin
				maze1out = 1'b0;
				maze2out = 1'b1;
				maze3out = 1'b0;
			end
			
			Maze2Wait:
			begin
				maze1out = 1'b0;
				maze2out = 1'b1;
				maze3out = 1'b0;
			end
			
			Maze3:
			begin
				maze1out = 1'b0;
				maze2out = 1'b0;
				maze3out = 1'b1;
			end
			
			Maze3Wait:
			begin
				maze1out = 1'b0;
				maze2out = 1'b0;
				maze3out = 1'b1;
			end
		
		endcase
	end

endmodule
