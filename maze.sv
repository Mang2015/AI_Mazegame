// This file will be used to output the maze to the monitor

module maze ( input Clk, Reset, frame_clk,
				  input [9:0] DrawX, DrawY,
				  output logic is_maze
				);

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
	
	always_comb
	begin
		// Left Wall
		if(DrawX >= left_wall_idx && DrawX <= left_wall_idx + wall_thickness
			&& DrawY >= top_wall_idx && DrawY <= bottom_wall_idx)
			begin
				is_maze = 1'b1;
			end
		// Right Wall
		else if(DrawX <= right_wall_idx && DrawX >= right_wall_idx - wall_thickness
					&& DrawY >= top_wall_idx && DrawY <= bottom_wall_idx)
			begin
				is_maze = 1'b1;
			end
		// Top Wall
		else if(DrawY >= top_wall_idx && DrawY <= top_wall_idx + wall_thickness
					&& DrawX >= left_wall_idx && DrawX <= right_wall_idx)
			begin
				is_maze = 1'b1;
			end
		else if(DrawY <= bottom_wall_idx && DrawY >= bottom_wall_idx - wall_thickness
					&& DrawX >= left_wall_idx && DrawX <= right_wall_idx)
			begin
				is_maze = 1'b1;
			end
		// Wall 1
		else if(DrawX >= wall_1_V && DrawX <= wall_1_V + wall_thickness
					&& DrawY >= top_wall_idx && DrawY <= wall_1_H)
			begin
				is_maze = 1'b1;
			end
		// Wall 2
		else if(DrawX >= wall_2_V && DrawX <= wall_2_V + wall_thickness
					&& DrawY >= top_wall_idx && DrawY <= wall_2_H)
			begin
				is_maze = 1'b1;
			end
		// Wall 3
		else if(DrawX >= wall_3_V && DrawX <= wall_3_V + wall_thickness
					&& DrawY >= top_wall_idx && DrawY <= wall_3_H)
			begin
				is_maze = 1'b1;
			end
		// Wall 4
		else if(DrawX >= wall_4_V && DrawX <= wall_4_V + wall_thickness
					&& DrawY >= top_wall_idx && DrawY <= wall_4_H)
			begin
				is_maze = 1'b1;
			end
		// Wall 5
		else if(DrawX >= wall_5_V && DrawX <= wall_5_V + wall_thickness
					&& DrawY <= bottom_wall_idx && DrawY >= wall_5_H)
			begin
				is_maze = 1'b1;
			end
		// Wall 6
		else if(DrawX >= wall_6_V && DrawX <= wall_3_V
					&& DrawY <= wall_6_H && DrawY >= wall_6_H - wall_thickness)
			begin
				is_maze = 1'b1;
			end
		// Wall 7
		else if(DrawX >= wall_3_V + wall_thickness && DrawX <= wall_7_V
					&& DrawY <= wall_7_H && DrawY >= wall_7_H - wall_thickness)
			begin
				is_maze = 1'b1;
			end
		// Wall 8
		else if(DrawX >= wall_8_V && DrawX <= right_wall_idx - wall_thickness
					&& DrawY <= wall_8_H && DrawY >= wall_8_H - wall_thickness)
			begin
				is_maze = 1'b1;
			end
		else
			begin
				is_maze = 1'b0;
			end
	end
	
endmodule
