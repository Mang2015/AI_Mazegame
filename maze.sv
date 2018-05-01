// This file will be used to output the maze to the monitor

module maze ( input Clk, Reset, frame_clk,
				  input [9:0] DrawX, DrawY,
				  input maze1out, maze2out, maze3out,
				  input [7:0] path,
				  output logic is_maze, 
				  output logic is_goal,
				  output logic is_path
				);
				
	// MAZE 1
	parameter [9:0] left_wall_idx = 10'd155;
	parameter [9:0] top_wall_idx = 10'd105;
	parameter [9:0] right_wall_idx = 10'd455;
	parameter [9:0] bottom_wall_idx = 10'd405;
	parameter [9:0] wall_thickness = 10'd30;
	
	parameter [9:0] goal_V = 10'd425;
	parameter [9:0] goal_H = 10'd375;
	
	// Vertical Walls
	// 2,1 -> 2,8
	parameter [9:0] wall_1V = 10'd215;
	parameter [9:0] wall_1H = 10'd345;
	// 4,2 -> 4,4
	parameter [9:0] wall_2V = 10'd275;
	parameter [9:0] wall_2H = 10'd225;
	// 4,6 -> 4,8
	parameter [9:0] wall_3V = 10'd275;
	parameter [9:0] wall_3H = 10'd345;
	// 6,4 -> 6,5
	parameter [9:0] wall_4V = 10'd335;
	parameter [9:0] wall_4H = 10'd255;
	// 6,8 -> 6,9
	parameter [9:0] wall_5V = 10'd335;
	parameter [9:0] wall_5H = 10'd375;
	// 8,2 -> 8,4
	parameter [9:0] wall_6V = 10'd395;
	parameter [9:0] wall_6H = 10'd225;
	
	// Horizontal Walls
	// 2,6 -> 8,6
	parameter [9:0] wall_7V = 10'd215;
	parameter [9:0] wall_7H = 10'd285;
	// 4,2 -> 8,2
	parameter [9:0] wall_8V = 10'd275;
	parameter [9:0] wall_8H = 10'd165;
	// 8,4 -> 9,4
	parameter [9:0] wall_9V = 10'd425;
	parameter [9:0] wall_9H = 10'd225;
	// 8,8 -> 9,8
	parameter [9:0] wall_10V = 10'd395;
	parameter [9:0] wall_10H = 10'd345;
	
	// MAZE 1 AI
	
	//Path
	// 1 (1,1)
	parameter [9:0] path1_V = 10'd185;
	parameter [9:0] path1_H = 10'd135;
	
	// 2 (1,2)
	parameter [9:0] path2_V = 10'd185;
	parameter [9:0] path2_H = 10'd165;
	
	// 3 (1,3)
	parameter [9:0] path3_V = 10'd185;
	parameter [9:0] path3_H = 10'd195;
	
	// 4 (1,4)
	parameter [9:0] path4_V = 10'd185;
	parameter [9:0] path4_H = 10'd225;
	
	// 5 (1,5)
	parameter [9:0] path5_V = 10'd185;
	parameter [9:0] path5_H = 10'd255;

	// 6 (1,6)
	parameter [9:0] path6_V = 10'd185;
	parameter [9:0] path6_H = 10'd285;
	
	// 7 (1,7)
	parameter [9:0] path7_V = 10'd185;
	parameter [9:0] path7_H = 10'd315;
	
	// 8 (1,8)
	parameter [9:0] path8_V = 10'd185;
	parameter [9:0] path8_H = 10'd345;
	
	// 9 (1,9)
	parameter [9:0] path9_V = 10'd185;
	parameter [9:0] path9_H = 10'd375;
	
	// 10 (2,9)
	parameter [9:0] path10_V = 10'd215;
	parameter [9:0] path10_H = 10'd375;
	
	// 11 (3,9)
	parameter [9:0] path11_V = 10'd245;
	parameter [9:0] path11_H = 10'd375;
	
	// 12 (4,9)
	parameter [9:0] path12_V = 10'd275;
	parameter [9:0] path12_H = 10'd375;
	
	// 13 (5,9)
	parameter [9:0] path13_V = 10'd305;
	parameter [9:0] path13_H = 10'd375;
	
	// 14 (5,8)
	parameter [9:0] path14_V = 10'd305;
	parameter [9:0] path14_H = 10'd345;
	
	// 15 (5,7)
	parameter [9:0] path15_V = 10'd305;
	parameter [9:0] path15_H = 10'd315;
	
	// 16 (6,7)
	parameter [9:0] path16_V = 10'd335;
	parameter [9:0] path16_H = 10'd315;
	
	// 17 (7,7) 69
	parameter [9:0] path17_V = 10'd365;
	parameter [9:0] path17_H = 10'd315;
	
	// 18 (8,7) 68 
	parameter [9:0] path18_V = 10'd395;
	parameter [9:0] path18_H = 10'd315;
	
	// 19 (9,7) 67 
	parameter [9:0] path19_V = 10'd425;
	parameter [9:0] path19_H = 10'd315;
	
	// 20(9,6) 66
	parameter [9:0] path20_V = 10'd425;
	parameter [9:0] path20_H = 10'd285;
	
	// 21 (9,5) 65
	parameter [9:0] path21_V = 10'd425;
	parameter [9:0] path21_H = 10'd255;
	
	// 22 (8,5) 64
	parameter [9:0] path22_V = 10'd395;
	parameter [9:0] path22_H = 10'd255;
	
	// 23 (7,5) 63
	parameter [9:0] path23_V = 10'd365;
	parameter [9:0] path23_H = 10'd255;
	
	// 24 (7,4) 62
	parameter [9:0] path24_V = 10'd365;
	parameter [9:0] path24_H = 10'd225;
	
	// 25 (7,3) 61
	parameter [9:0] path25_V = 10'd365;
	parameter [9:0] path25_H = 10'd195;
	
	// 26 (6,3) 60
	parameter [9:0] path26_V = 10'd335;
	parameter [9:0] path26_H = 10'd195;
	
	//(5,3) 59
	parameter [9:0] path27_V = 10'd305;
	parameter [9:0] path27_H = 10'd195;
	
	//(5,4) 58
	parameter [9:0] path28_V = 10'd305;
	parameter [9:0] path28_H = 10'd225;
	
	//(5,5) 57
	parameter [9:0] path29_V = 10'd305;
	parameter [9:0] path29_H = 10'd255;
	
	//(4,5) 56
	parameter [9:0] path30_V = 10'd275;
	parameter [9:0] path30_H = 10'd255;
	
	//(3,5) 55
	parameter [9:0] path31_V = 10'd245;
	parameter [9:0] path31_H = 10'd255;
	
	//(3,4) 54
	parameter [9:0] path32_V = 10'd245;
	parameter [9:0] path32_H = 10'd225;
	
	//(3,3) 53
	parameter [9:0] path33_V = 10'd245;
	parameter [9:0] path33_H = 10'd195;
	
	//(3,2) 52
	parameter [9:0] path34_V = 10'd245;
	parameter [9:0] path34_H = 10'd165;
	
	//(3,1) 51
	parameter [9:0] path35_V = 10'd245;
	parameter [9:0] path35_H = 10'd135;
	
	//(4,1) 50
	parameter [9:0] path36_V = 10'd275;
	parameter [9:0] path36_H = 10'd135;
	
	//(5,1) 49
	parameter [9:0] path37_V = 10'd305;
	parameter [9:0] path37_H = 10'd135;
	
	//(6,1) 48
	parameter [9:0] path38_V = 10'd335;
	parameter [9:0] path38_H = 10'd135;
	
	//(7,1) 47
	parameter [9:0] path39_V = 10'd365;
	parameter [9:0] path39_H = 10'd135;
	
	//(8,1) 46
	parameter [9:0] path40_V = 10'd395;
	parameter [9:0] path40_H = 10'd135;
	
	//(9,1) 45
	parameter [9:0] path41_V = 10'd425;
	parameter [9:0] path41_H = 10'd135;
	
	//(9,2) 44
	parameter [9:0] path42_V = 10'd425;
	parameter [9:0] path42_H = 10'd165;
	
	//(9,3)
	parameter [9:0] path43_V = 10'd425;
	parameter [9:0] path43_H = 10'd195;
	
	//(7,8)
	parameter [9:0] path70_V = 10'd365;
	parameter [9:0] path70_H = 10'd345;
	
	//(7,9)
	parameter [9:0] path71_V = 10'd365;
	parameter [9:0] path71_H = 10'd375;
	
	//(8,9)
	parameter [9:0] path72_V = 10'd395;
	parameter [9:0] path72_H = 10'd375;
	
	// MAZE 2 - EVEN THO THIS SAYS 3 ITS ACTUALLY MAZE 2
	parameter [9:0] left_wall_idx3 = 10'd110;
	parameter [9:0] top_wall_idx3 = 10'd50;
	parameter [9:0] right_wall_idx3 = 10'd510;
	parameter [9:0] bottom_wall_idx3 = 10'd450;
	parameter [9:0] wall_thickness3 = 10'd20;
	
	parameter [9:0] maze3_goalV = 10'd490;
	parameter [9:0] maze3_goalH = 10'd430;
	
	// Vertical Walls
	// 2,2 -> 2,8
	parameter [9:0] wall_1V3 = 10'd150;
	parameter [9:0] wall_1H3 = 10'd210; //d70
	// 2,10, 2,12
	parameter [9:0] wall_2V3 = 10'd150;
	parameter [9:0] wall_2H3 = 10'd290;
	// 2,16 2,18
	parameter [9:0] wall_3V3 = 10'd150;
	parameter [9:0] wall_3H3 = 10'd410;
	// 4,2 -> 4,6
	parameter [9:0] wall_4V3 = 10'd190;
	parameter [9:0] wall_4H3 = 10'd170;
	// 4,8 -> 4,14
	parameter [9:0] wall_5V3 = 10'd190;
	parameter [9:0] wall_5H3 = 10'd330;
	// 4,18 -> 4,20
	parameter [9:0] wall_6V3 = 10'd190;
	parameter [9:0] wall_6H3 = 10'd450;
	// 6,0 -> 6,2
	parameter [9:0] wall_7V3 = 10'd230;
	parameter [9:0] wall_7H3 = 10'd90;
	// 6,6 -> 6,8
	parameter [9:0] wall_8V3 = 10'd230;
	parameter [9:0] wall_8H3 = 10'd210;
	// 6,12 -> 6,14
	parameter [9:0] wall_9V3 = 10'd230;
	parameter [9:0] wall_9H3 = 10'd330;
	// 6,16 -> 6,18
	parameter [9:0] wall_10V3 = 10'd230;
	parameter [9:0] wall_10H3 = 10'd410;
	// 8,4 -> 8,18
	parameter [9:0] wall_11V3 = 10'd270;
	parameter [9:0] wall_11H3 = 10'd410;
	// 10,2 -> 10,12
	parameter [9:0] wall_12V3 = 10'd310;
	parameter [9:0] wall_12H3 = 10'd290;
	// 10,16 -> 10,18
	parameter [9:0] wall_13V3 = 10'd310;
	parameter [9:0] wall_13H3 = 10'd410;
	// 12,0 -> 12,2
	parameter [9:0] wall_14V3 = 10'd350;
	parameter [9:0] wall_14H3 = 10'd90;
	// 12,8 -> 12,10
	parameter [9:0] wall_15V3 = 10'd350;
	parameter [9:0] wall_15H3 = 10'd250;
	// 12,12 -> 12,16
	parameter [9:0] wall_16V3 = 10'd350;
	parameter [9:0] wall_16H3 = 10'd370;
	// 14,2 -> 14,4
	parameter [9:0] wall_17V3 = 10'd390;
	parameter [9:0] wall_17H3 = 10'd130;
	// 14,10 -> 14,12
	parameter [9:0] wall_18V3 = 10'd390;
	parameter [9:0] wall_18H3 = 10'd290;
	// 16,2 -> 16,6
	parameter [9:0] wall_19V3 = 10'd430;
	parameter [9:0] wall_19H3 = 10'd170;
	// 16,8 -> 16,18
	parameter [9:0] wall_20V3 = 10'd430;
	parameter [9:0] wall_20H3 = 10'd410;
	// 18,0 -> 18,2
	parameter [9:0] wall_21V3 = 10'd470;
	parameter [9:0] wall_21H3 = 10'd90;
	// 18,8 -> 18,14
	parameter [9:0] wall_22V3 = 10'd470;
	parameter [9:0] wall_22H3 = 10'd330;
	// 18,16 -> 18,20
	parameter [9:0] wall_23V3 = 10'd470;
	parameter [9:0] wall_23H3 = 10'd450;
	
	// Horizontal Walls
	// 2,2 -> 4,2
	parameter [9:0] wall_24V3 = 10'd150; //d210
	parameter [9:0] wall_24H3 = 10'd90;
	// 6,2 -> 10,2
	parameter [9:0] wall_25V3 = 10'd230; //d330
	parameter [9:0] wall_25H3 = 10'd90;
	// 4,4 -> 8,4
	parameter [9:0] wall_26V3 = 10'd190; //d290
	parameter [9:0] wall_26H3 = 10'd130;
	// 10,4 -> 14,4
	parameter [9:0] wall_27V3 = 10'd310; //d410
	parameter [9:0] wall_27H3 = 10'd130;
	// 16,4 -> 18,4
	parameter [9:0] wall_28V3 = 10'd430; //d490
	parameter [9:0] wall_28H3 = 10'd130;
	// 12,6 -> 20,6
	parameter [9:0] wall_29V3 = 10'd350; //510
	parameter [9:0] wall_29H3 = 10'd170;
	// 2,8 -> 6,8
	parameter [9:0] wall_30V3 = 10'd150; //d250
	parameter [9:0] wall_30H3 = 10'd210;
	// 12,8 -> 16,8
	parameter [9:0] wall_31V3 = 10'd350; //d450
	parameter [9:0] wall_31H3 = 10'd210;
	// 0,10 -> 2,10
	parameter [9:0] wall_32V3 = 10'd110; //d170
	parameter [9:0] wall_32H3 = 10'd250;
	// 6,10 -> 8,10
	parameter [9:0] wall_33V3 = 10'd230; //d290
	parameter [9:0] wall_33H3 = 10'd250;
	// 10,10 -> 12,10
	parameter [9:0] wall_34V3 = 10'd310; //d370
	parameter [9:0] wall_34H3 = 10'd250;
	// 12,12 -> 14,12
	parameter [9:0] wall_35V3 = 10'd350; //d410
	parameter [9:0] wall_35H3 = 10'd290;
	// 0,14 -> 6,14
	parameter [9:0] wall_36V3 = 10'd110; //d250
	parameter [9:0] wall_36H3 = 10'd330;
	// 8,14 -> 12,14
	parameter [9:0] wall_37V3 = 10'd270; //d370
	parameter [9:0] wall_37H3 = 10'd330;
	// 14,14 -> 18,14
	parameter [9:0] wall_38V3 = 10'd390; //d490
	parameter [9:0] wall_38H3 = 10'd330;
	// 4,16 -> 6,16
	parameter [9:0] wall_39V3 = 10'd190; //d250
	parameter [9:0] wall_39H3 = 10'd370;
	// 12,16 -> 14,16
	parameter [9:0] wall_40V3 = 10'd350; //d410
	parameter [9:0] wall_40H3 = 10'd370;
	// 2,18 -> 4,18
	parameter [9:0] wall_41V3 = 10'd150; //d210
	parameter [9:0] wall_41H3 = 10'd410;
	// 6,18 -> 8,18
	parameter [9:0] wall_42V3 = 10'd230; //d290
	parameter [9:0] wall_42H3 = 10'd410;
	// 10,18 -> 16,18
	parameter [9:0] wall_43V3 = 10'd310; //d450
	parameter [9:0] wall_43H3 = 10'd410;
	
	// MAZE 2 AI
	
	parameter [9:0] path1_V2 = 10'd130; //1,1
	parameter [9:0] path1_H2 = 10'd70;
	
	parameter [9:0] path2_V2 = 10'd150;
	parameter [9:0] path2_H2 = 10'd70;
	
	parameter [9:0] path3_V2 = 10'd170;
	parameter [9:0] path3_H2 = 10'd70;
	
	parameter [9:0] path4_V2 = 10'd190;
	parameter [9:0] path4_H2 = 10'd70;
	
	parameter [9:0] path5_V2 = 10'd210; //5,1
	parameter [9:0] path5_H2 = 10'd70;
	
	parameter [9:0] path6_V2 = 10'd210;
	parameter [9:0] path6_H2 = 10'd90;
	
	parameter [9:0] path7_V2 = 10'd210; //5,3
	parameter [9:0] path7_H2 = 10'd110;
	
	parameter [9:0] path8_V2 = 10'd230;
	parameter [9:0] path8_H2 = 10'd110;
	
	parameter [9:0] path9_V2 = 10'd250;
	parameter [9:0] path9_H2 = 10'd110;
	
	parameter [9:0] path10_V2 = 10'd270;
	parameter [9:0] path10_H2 = 10'd110;
	
	parameter [9:0] path11_V2 = 10'd290; //9,3
	parameter [9:0] path11_H2 = 10'd110;
	
	parameter [9:0] path12_V2 = 10'd290;
	parameter [9:0] path12_H2 = 10'd130;
	
	parameter [9:0] path13_V2 = 10'd290;
	parameter [9:0] path13_H2 = 10'd150;
	
	parameter [9:0] path14_V2 = 10'd290;
	parameter [9:0] path14_H2 = 10'd170;
	
	parameter [9:0] path15_V2 = 10'd290;
	parameter [9:0] path15_H2 = 10'd190;
	
	parameter [9:0] path16_V2 = 10'd290;
	parameter [9:0] path16_H2 = 10'd210;
	
	parameter [9:0] path17_V2 = 10'd290;
	parameter [9:0] path17_H2 = 10'd230;
	
	parameter [9:0] path18_V2 = 10'd290;
	parameter [9:0] path18_H2 = 10'd250;
	
	parameter [9:0] path19_V2 = 10'd290;
	parameter [9:0] path19_H2 = 10'd270;
	
	parameter [9:0] path20_V2 = 10'd290;
	parameter [9:0] path20_H2 = 10'd290;
	
	parameter [9:0] path21_V2 = 10'd290; //9,13
	parameter [9:0] path21_H2 = 10'd310;
	
	parameter [9:0] path22_V2 = 10'd310;
	parameter [9:0] path22_H2 = 10'd310;
	
	parameter [9:0] path23_V2 = 10'd330; //11,13
	parameter [9:0] path23_H2 = 10'd310;
	
	parameter [9:0] path24_V2 = 10'd330;
	parameter [9:0] path24_H2 = 10'd290;
	
	parameter [9:0] path25_V2 = 10'd330; //11,11
	parameter [9:0] path25_H2 = 10'd270;
	
	parameter [9:0] path26_V2 = 10'd350;
	parameter [9:0] path26_H2 = 10'd270;
	
	parameter [9:0] path27_V2 = 10'd370; //13,11
	parameter [9:0] path27_H2 = 10'd270;
	
	parameter [9:0] path28_V2 = 10'd370;
	parameter [9:0] path28_H2 = 10'd250;
	
	parameter [9:0] path29_V2 = 10'd370; //13,9
	parameter [9:0] path29_H2 = 10'd230;
	
	parameter [9:0] path30_V2 = 10'd390;
	parameter [9:0] path30_H2 = 10'd230;
	
	parameter [9:0] path31_V2 = 10'd410; //15,9
	parameter [9:0] path31_H2 = 10'd230;
	
	parameter [9:0] path32_V2 = 10'd410;
	parameter [9:0] path32_H2 = 10'd250;
	
	parameter [9:0] path33_V2 = 10'd410;
	parameter [9:0] path33_H2 = 10'd270;
	
	parameter [9:0] path34_V2 = 10'd410;
	parameter [9:0] path34_H2 = 10'd290;
	
	parameter [9:0] path35_V2 = 10'd410; //15,13
	parameter [9:0] path35_H2 = 10'd310;
	
	parameter [9:0] path36_V2 = 10'd390;
	parameter [9:0] path36_H2 = 10'd310;
	
	parameter [9:0] path37_V2 = 10'd370; //13,13
	parameter [9:0] path37_H2 = 10'd310;
	
	parameter [9:0] path38_V2 = 10'd370; 
	parameter [9:0] path38_H2 = 10'd330;
	
	parameter [9:0] path39_V2 = 10'd370; //13,15
	parameter [9:0] path39_H2 = 10'd350;
	
	parameter [9:0] path40_V2 = 10'd390; 
	parameter [9:0] path40_H2 = 10'd350;
	
	parameter [9:0] path41_V2 = 10'd410; //15,15 
	parameter [9:0] path41_H2 = 10'd350;
	
	parameter [9:0] path42_V2 = 10'd410;
	parameter [9:0] path42_H2 = 10'd370;
	
	parameter [9:0] path43_V2 = 10'd410; //15,17
	parameter [9:0] path43_H2 = 10'd390;
	
	parameter [9:0] path44_V2 = 10'd390;
	parameter [9:0] path44_H2 = 10'd390;
	
	parameter [9:0] path45_V2 = 10'd370; 
	parameter [9:0] path45_H2 = 10'd390;
	
	parameter [9:0] path46_V2 = 10'd350; 
	parameter [9:0] path46_H2 = 10'd390;
	
	parameter [9:0] path47_V2 = 10'd330; //11,17
	parameter [9:0] path47_H2 = 10'd390;
	
	parameter [9:0] path48_V2 = 10'd330;
	parameter [9:0] path48_H2 = 10'd370;
	
	parameter [9:0] path49_V2 = 10'd330; //11,15
	parameter [9:0] path49_H2 = 10'd350;
	
	parameter [9:0] path50_V2 = 10'd310;
	parameter [9:0] path50_H2 = 10'd350;
	
	parameter [9:0] path51_V2 = 10'd290; //9,15
	parameter [9:0] path51_H2 = 10'd350;
	
	parameter [9:0] path52_V2 = 10'd290;
	parameter [9:0] path52_H2 = 10'd370;
	
	parameter [9:0] path53_V2 = 10'd290;
	parameter [9:0] path53_H2 = 10'd390;
	
	parameter [9:0] path54_V2 = 10'd290;
	parameter [9:0] path54_H2 = 10'd410;
	
	parameter [9:0] path55_V2 = 10'd290; //9,19
	parameter [9:0] path55_H2 = 10'd430;
	
	parameter [9:0] path56_V2 = 10'd270;
	parameter [9:0] path56_H2 = 10'd430;
	
	parameter [9:0] path57_V2 = 10'd250;
	parameter [9:0] path57_H2 = 10'd430;
	
	parameter [9:0] path58_V2 = 10'd230;
	parameter [9:0] path58_H2 = 10'd430;
	
	parameter [9:0] path59_V2 = 10'd210; //5,19
	parameter [9:0] path59_H2 = 10'd430;
	/*
	parameter [9:0] path60_V2 = 10'd230;
	parameter [9:0] path60_H2 = 10'd430;
	
	parameter [9:0] path61_V2 = 10'd250;
	parameter [9:0] path61_H2 = 10'd430;
	
	parameter [9:0] path62_V2 = 10'd270;
	parameter [9:0] path62_H2 = 10'd430;
	
	parameter [9:0] path63_V2 = 10'd290;
	parameter [9:0] path63_H2 = 10'd430;
	*/
	parameter [9:0] path64_V2 = 10'd310;
	parameter [9:0] path64_H2 = 10'd430;
	
	parameter [9:0] path65_V2 = 10'd330;
	parameter [9:0] path65_H2 = 10'd430;
	
	parameter [9:0] path66_V2 = 10'd350;
	parameter [9:0] path66_H2 = 10'd430;
	
	parameter [9:0] path67_V2 = 10'd370;
	parameter [9:0] path67_H2 = 10'd430;
	
	parameter [9:0] path68_V2 = 10'd390;
	parameter [9:0] path68_H2 = 10'd430;
	
	parameter [9:0] path69_V2 = 10'd410;
	parameter [9:0] path69_H2 = 10'd430;
	
	parameter [9:0] path70_V2 = 10'd430;
	parameter [9:0] path70_H2 = 10'd430;
	
	parameter [9:0] path71_V2 = 10'd450; //17,19
	parameter [9:0] path71_H2 = 10'd430;
	
	parameter [9:0] path72_V2 = 10'd450;
	parameter [9:0] path72_H2 = 10'd410;
	
	parameter [9:0] path73_V2 = 10'd450;
	parameter [9:0] path73_H2 = 10'd390;
	
	parameter [9:0] path74_V2 = 10'd450;
	parameter [9:0] path74_H2 = 10'd370;
	
	parameter [9:0] path75_V2 = 10'd450; //17,15
	parameter [9:0] path75_H2 = 10'd350;
	
	parameter [9:0] path76_V2 = 10'd470;
	parameter [9:0] path76_H2 = 10'd350;
	
	parameter [9:0] path77_V2 = 10'd490; //19,15
	parameter [9:0] path77_H2 = 10'd350;
	
	parameter [9:0] path78_V2 = 10'd490;
	parameter [9:0] path78_H2 = 10'd370;
	
	parameter [9:0] path79_V2 = 10'd490;
	parameter [9:0] path79_H2 = 10'd390;
	
	parameter [9:0] path80_V2 = 10'd490;
	parameter [9:0] path80_H2 = 10'd410;
	
	parameter [9:0] path81_V2 = 10'd490; //19,19
	parameter [9:0] path81_H2 = 10'd430;
	
	always_comb
	begin
	is_maze = 1'b0;
	is_goal = 1'b0;
	is_path = 1'b0;
	
	if(maze2out == 1'b1)
	begin
	
	// Left Wall
		if(DrawX >= left_wall_idx3 && DrawX <= left_wall_idx3 + wall_thickness3
			&& DrawY >= top_wall_idx3 - wall_thickness3 && DrawY <= bottom_wall_idx3)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Right Wall
		else if(DrawX >= right_wall_idx3 && DrawX <= right_wall_idx3 + wall_thickness3
					&& DrawY >= top_wall_idx3 - wall_thickness3 && DrawY <= bottom_wall_idx3)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Top Wall
		else if(DrawX >= left_wall_idx3 && DrawX <= right_wall_idx3 + wall_thickness3
					&& DrawY >= top_wall_idx3 - wall_thickness3 && DrawY <= top_wall_idx3)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Bottom Wall
		else if(DrawX >= left_wall_idx3 && DrawX <= right_wall_idx3 + wall_thickness3
					&& DrawY >= bottom_wall_idx3 - wall_thickness3 && DrawY <= bottom_wall_idx3)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Goal Cell
		else if(DrawX >= maze3_goalV && DrawX <= maze3_goalV + wall_thickness3
					&& DrawY >= maze3_goalH - wall_thickness3 && DrawY <= maze3_goalH)
			begin
				is_maze = 1'b0;
				is_goal = 1'b1;
				is_path = 1'b0;
			end
		// Vertical walls
		else if((DrawX >= wall_1V3 && DrawX <= wall_1V3 + wall_thickness3 && DrawY >= 10'd70 && DrawY <= wall_1H3)
					|| (DrawX >= wall_2V3 && DrawX <= wall_2V3 + wall_thickness3 && DrawY >= 10'd230 && DrawY <= wall_2H3)
					|| (DrawX >= wall_3V3 && DrawX <= wall_3V3 + wall_thickness3 && DrawY >= 10'd350 && DrawY <= wall_3H3)
					|| (DrawX >= wall_4V3 && DrawX <= wall_4V3 + wall_thickness3 && DrawY >= 10'd70 && DrawY <= wall_4H3)
					|| (DrawX >= wall_5V3 && DrawX <= wall_5V3 + wall_thickness3 && DrawY >= 10'd190 && DrawY <= wall_5H3)
					|| (DrawX >= wall_6V3 && DrawX <= wall_6V3 + wall_thickness3 && DrawY >= 10'd390 && DrawY <= wall_6H3)
					|| (DrawX >= wall_7V3 && DrawX <= wall_7V3 + wall_thickness3 && DrawY >= 10'd50 && DrawY <= wall_7H3)
					|| (DrawX >= wall_8V3 && DrawX <= wall_8V3 + wall_thickness3 && DrawY >= 10'd150 && DrawY <= wall_8H3)
					|| (DrawX >= wall_9V3 && DrawX <= wall_9V3 + wall_thickness3 && DrawY >= 10'd270 && DrawY <= wall_9H3)
					|| (DrawX >= wall_10V3 && DrawX <= wall_10V3 + wall_thickness3 && DrawY >= 10'd350 && DrawY <= wall_10H3)
					|| (DrawX >= wall_11V3 && DrawX <= wall_11V3 + wall_thickness3 && DrawY >= 10'd110 && DrawY <= wall_11H3)
					|| (DrawX >= wall_12V3 && DrawX <= wall_12V3 + wall_thickness3 && DrawY >= 10'd70 && DrawY <= wall_12H3)
					|| (DrawX >= wall_13V3 && DrawX <= wall_13V3 + wall_thickness3 && DrawY >= 10'd350 && DrawY <= wall_13H3)
					|| (DrawX >= wall_14V3 && DrawX <= wall_14V3 + wall_thickness3 && DrawY >= 10'd50 && DrawY <= wall_14H3)
					|| (DrawX >= wall_15V3 && DrawX <= wall_15V3 + wall_thickness3 && DrawY >= 10'd190 && DrawY <= wall_15H3)
					|| (DrawX >= wall_16V3 && DrawX <= wall_16V3 + wall_thickness3 && DrawY >= 10'd270 && DrawY <= wall_16H3)
					|| (DrawX >= wall_17V3 && DrawX <= wall_17V3 + wall_thickness3 && DrawY >= 10'd70 && DrawY <= wall_17H3)
					|| (DrawX >= wall_18V3 && DrawX <= wall_18V3 + wall_thickness3 && DrawY >= 10'd230 && DrawY <= wall_18H3)
					|| (DrawX >= wall_19V3 && DrawX <= wall_19V3 + wall_thickness3 && DrawY >= 10'd70 && DrawY <= wall_19H3)
					|| (DrawX >= wall_20V3 && DrawX <= wall_20V3 + wall_thickness3 && DrawY >= 10'd190 && DrawY <= wall_20H3)
					|| (DrawX >= wall_21V3 && DrawX <= wall_21V3 + wall_thickness3 && DrawY >= 10'd50 && DrawY <= wall_21H3)
					|| (DrawX >= wall_22V3 && DrawX <= wall_22V3 + wall_thickness3 && DrawY >= 10'd190 && DrawY <= wall_22H3)
					|| (DrawX >= wall_23V3 && DrawX <= wall_23V3 + wall_thickness3 && DrawY >= 10'd350 && DrawY <= wall_23H3))
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		//Horizontal walls
		else if((DrawX >= wall_24V3 && DrawX <= 10'd210 && DrawY <= wall_24H3 && DrawY >= wall_24H3 - wall_thickness3)
					|| (DrawX >= wall_25V3 && DrawX <= 10'd330 && DrawY <= wall_25H3 && DrawY >= wall_25H3 - wall_thickness3)
					|| (DrawX >= wall_26V3 && DrawX <= 10'd290 && DrawY <= wall_26H3 && DrawY >= wall_26H3 - wall_thickness3)
					|| (DrawX >= wall_27V3 && DrawX <= 10'd410 && DrawY <= wall_27H3 && DrawY >= wall_27H3 - wall_thickness3)
					|| (DrawX >= wall_28V3 && DrawX <= 10'd490 && DrawY <= wall_28H3 && DrawY >= wall_28H3 - wall_thickness3)
					|| (DrawX >= wall_29V3 && DrawX <= 10'd510 && DrawY <= wall_29H3 && DrawY >= wall_29H3 - wall_thickness3)
					|| (DrawX >= wall_30V3 && DrawX <= 10'd250 && DrawY <= wall_30H3 && DrawY >= wall_30H3 - wall_thickness3)
					|| (DrawX >= wall_31V3 && DrawX <= 10'd450 && DrawY <= wall_31H3 && DrawY >= wall_31H3 - wall_thickness3)
					|| (DrawX >= wall_32V3 && DrawX <= 10'd170 && DrawY <= wall_32H3 && DrawY >= wall_32H3 - wall_thickness3)
					|| (DrawX >= wall_33V3 && DrawX <= 10'd290 && DrawY <= wall_33H3 && DrawY >= wall_33H3 - wall_thickness3)
					|| (DrawX >= wall_34V3 && DrawX <= 10'd370 && DrawY <= wall_34H3 && DrawY >= wall_34H3 - wall_thickness3)
					|| (DrawX >= wall_35V3 && DrawX <= 10'd410 && DrawY <= wall_35H3 && DrawY >= wall_35H3 - wall_thickness3)
					|| (DrawX >= wall_36V3 && DrawX <= 10'd250 && DrawY <= wall_36H3 && DrawY >= wall_36H3 - wall_thickness3)
					|| (DrawX >= wall_37V3 && DrawX <= 10'd370 && DrawY <= wall_37H3 && DrawY >= wall_37H3 - wall_thickness3)
					|| (DrawX >= wall_38V3 && DrawX <= 10'd490 && DrawY <= wall_38H3 && DrawY >= wall_38H3 - wall_thickness3)
					|| (DrawX >= wall_39V3 && DrawX <= 10'd250 && DrawY <= wall_39H3 && DrawY >= wall_39H3 - wall_thickness3)
					|| (DrawX >= wall_40V3 && DrawX <= 10'd410 && DrawY <= wall_40H3 && DrawY >= wall_40H3 - wall_thickness3)
					|| (DrawX >= wall_41V3 && DrawX <= 10'd210 && DrawY <= wall_41H3 && DrawY >= wall_41H3 - wall_thickness3)
					|| (DrawX >= wall_42V3 && DrawX <= 10'd290 && DrawY <= wall_42H3 && DrawY >= wall_42H3 - wall_thickness3)
					|| (DrawX >= wall_43V3 && DrawX <= 10'd450 && DrawY <= wall_43H3 && DrawY >= wall_43H3 - wall_thickness3))
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		
		// path1
		else if(DrawX >= path1_V2 && DrawX <= path1_V2 + wall_thickness3
					&& DrawY <= path1_H2 && DrawY >= path1_H2 - wall_thickness3)
			begin
				if (path == 8'b00000001)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path2_V2 && DrawX <= path2_V2 + wall_thickness3
					&& DrawY <= path2_H2 && DrawY >= path2_H2 - wall_thickness3)
			begin
				if (path == 8'b00000010)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path3_V2 && DrawX <= path3_V2 + wall_thickness3
					&& DrawY <= path3_H2 && DrawY >= path3_H2 - wall_thickness3)
			begin
				if (path == 8'b00000011)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path4_V2 && DrawX <= path4_V2 + wall_thickness3
					&& DrawY <= path4_H2 && DrawY >= path4_H2 - wall_thickness3)
			begin
				if (path == 8'b00000100)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path5_V2 && DrawX <= path5_V2 + wall_thickness3
					&& DrawY <= path5_H2 && DrawY >= path5_H2 - wall_thickness3)
			begin
				if (path == 8'b000000101)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path6_V2 && DrawX <= path6_V2 + wall_thickness3
					&& DrawY <= path6_H2 && DrawY >= path6_H2 - wall_thickness3)
			begin
				if (path == 8'b00000110)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path7_V2 && DrawX <= path7_V2 + wall_thickness3
					&& DrawY <= path7_H2 && DrawY >= path7_H2 - wall_thickness3)
			begin
				if (path == 8'b00000111)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path8_V2 && DrawX <= path8_V2 + wall_thickness3
					&& DrawY <= path8_H2 && DrawY >= path8_H2 - wall_thickness3)
			begin
				if (path == 8'b00001000)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path9_V2 && DrawX <= path9_V2 + wall_thickness3
					&& DrawY <= path9_H2 && DrawY >= path9_H2 - wall_thickness3)
			begin
				if (path == 8'b00001001)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path10_V2 && DrawX <= path10_V2 + wall_thickness3
					&& DrawY <= path10_H2 && DrawY >= path10_H2 - wall_thickness3)
			begin
				if (path == 8'b00001010)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path11_V2 && DrawX <= path11_V2 + wall_thickness3
					&& DrawY <= path11_H2 && DrawY >= path11_H2 - wall_thickness3)
			begin
				if (path == 8'b00001011)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path12_V2 && DrawX <= path12_V2 + wall_thickness3
					&& DrawY <= path12_H2 && DrawY >= path12_H2 - wall_thickness3)
			begin
				if (path == 8'b00001100)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path13_V2 && DrawX <= path13_V2 + wall_thickness3
					&& DrawY <= path13_H2 && DrawY >= path13_H2 - wall_thickness3)
			begin
				if (path == 8'b00001101)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path14_V2 && DrawX <= path14_V2 + wall_thickness3
					&& DrawY <= path14_H2 && DrawY >= path14_H2 - wall_thickness3)
			begin
				if (path == 8'b00001110)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path15_V2 && DrawX <= path15_V2 + wall_thickness3
					&& DrawY <= path15_H2 && DrawY >= path15_H2 - wall_thickness3)
			begin
				if (path == 8'b00001111)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path16_V2 && DrawX <= path16_V2 + wall_thickness3
					&& DrawY <= path16_H2 && DrawY >= path16_H2 - wall_thickness3)
			begin
				if (path == 8'b00010000)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path17_V2 && DrawX <= path17_V2 + wall_thickness3
					&& DrawY <= path17_H2 && DrawY >= path17_H2 - wall_thickness3)
			begin
				if (path == 8'b00010001)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path18_V2 && DrawX <= path18_V2 + wall_thickness3
					&& DrawY <= path18_H2 && DrawY >= path18_H2 - wall_thickness3)
			begin
				if (path == 8'b00010010)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path19_V2 && DrawX <= path19_V2 + wall_thickness3
					&& DrawY <= path19_H2 && DrawY >= path19_H2 - wall_thickness3)
			begin
				if (path == 8'b00010011)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path20_V2 && DrawX <= path20_V2 + wall_thickness3
					&& DrawY <= path20_H2 && DrawY >= path20_H2 - wall_thickness3)
			begin
				if (path == 8'b00010100)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path21_V2 && DrawX <= path21_V2 + wall_thickness3
					&& DrawY <= path21_H2 && DrawY >= path21_H2 - wall_thickness3)
			begin
				if (path == 8'b00010101)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path22_V2 && DrawX <= path22_V2 + wall_thickness3
					&& DrawY <= path22_H2 && DrawY >= path22_H2 - wall_thickness3)
			begin
				if (path == 8'b00010110)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path23_V2 && DrawX <= path23_V2 + wall_thickness3
					&& DrawY <= path23_H2 && DrawY >= path23_H2 - wall_thickness3)
			begin
				if (path == 8'b00010111)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path24_V2 && DrawX <= path24_V2 + wall_thickness3
					&& DrawY <= path24_H2 && DrawY >= path24_H2 - wall_thickness3)
			begin
				if (path == 8'b00011000)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path25_V2 && DrawX <= path25_V2 + wall_thickness3
					&& DrawY <= path25_H2 && DrawY >= path25_H2 - wall_thickness3)
			begin
				if (path == 8'b00011001)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path26_V2 && DrawX <= path26_V2 + wall_thickness3
					&& DrawY <= path26_H2 && DrawY >= path26_H2 - wall_thickness3)
			begin
				if (path == 8'b00011010)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path27_V2 && DrawX <= path27_V2 + wall_thickness3
					&& DrawY <= path27_H2 && DrawY >= path27_H2 - wall_thickness3)
			begin
				if (path == 8'b00011011)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path28_V2 && DrawX <= path28_V2 + wall_thickness3
					&& DrawY <= path28_H2 && DrawY >= path28_H2 - wall_thickness3)
			begin
				if (path == 8'b00011100)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path29_V2 && DrawX <= path29_V2 + wall_thickness3
					&& DrawY <= path29_H2 && DrawY >= path29_H2 - wall_thickness3)
			begin
				if (path == 8'b00011101)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path30_V2 && DrawX <= path30_V2 + wall_thickness3
					&& DrawY <= path30_H2 && DrawY >= path30_H2 - wall_thickness3)
			begin
				if (path == 8'b00011110)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path31_V2 && DrawX <= path31_V2 + wall_thickness3
					&& DrawY <= path31_H2 && DrawY >= path31_H2 - wall_thickness3)
			begin
				if (path == 8'b00011111)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path32_V2 && DrawX <= path32_V2 + wall_thickness3
					&& DrawY <= path32_H2 && DrawY >= path32_H2 - wall_thickness3)
			begin
				if (path == 8'b00100000)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path33_V2 && DrawX <= path33_V2 + wall_thickness3
					&& DrawY <= path33_H2 && DrawY >= path33_H2 - wall_thickness3)
			begin
				if (path == 8'b00100001)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
				// path2
		else if(DrawX >= path34_V2 && DrawX <= path34_V2 + wall_thickness3
					&& DrawY <= path34_H2 && DrawY >= path34_H2 - wall_thickness3)
			begin
				if (path == 8'b00100010)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path35_V2 && DrawX <= path35_V2 + wall_thickness3
					&& DrawY <= path35_H2 && DrawY >= path35_H2 - wall_thickness3)
			begin
				if (path == 8'b00100011)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path36_V2 && DrawX <= path36_V2 + wall_thickness3
					&& DrawY <= path36_H2 && DrawY >= path36_H2 - wall_thickness3)
			begin
				if (path == 8'b00100100)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path37_V2 && DrawX <= path37_V2 + wall_thickness3
					&& DrawY <= path37_H2 && DrawY >= path37_H2 - wall_thickness3)
			begin
				if (path == 8'b00100101)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path38_V2 && DrawX <= path38_V2 + wall_thickness3
					&& DrawY <= path38_H2 && DrawY >= path38_H2 - wall_thickness3)
			begin
				if (path == 8'b00100110)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path39_V2 && DrawX <= path39_V2 + wall_thickness3
					&& DrawY <= path39_H2 && DrawY >= path39_H2 - wall_thickness3)
			begin
				if (path == 8'b00100111)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path40_V2 && DrawX <= path40_V2 + wall_thickness3
					&& DrawY <= path40_H2 && DrawY >= path40_H2 - wall_thickness3)
			begin
				if (path == 8'b00101000)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path41_V2 && DrawX <= path41_V2 + wall_thickness3
					&& DrawY <= path41_H2 && DrawY >= path41_H2 - wall_thickness3)
			begin
				if (path == 8'b00101001)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path42_V2 && DrawX <= path42_V2 + wall_thickness3
					&& DrawY <= path42_H2 && DrawY >= path42_H2 - wall_thickness3)
			begin
				if (path == 8'b00101010)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path43_V2 && DrawX <= path43_V2 + wall_thickness3
					&& DrawY <= path43_H2 && DrawY >= path43_H2 - wall_thickness3)
			begin
				if (path == 8'b00101011)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path44_V2 && DrawX <= path44_V2 + wall_thickness3
					&& DrawY <= path44_H2 && DrawY >= path44_H2 - wall_thickness3)
			begin
				if (path == 8'b00101100)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path45_V2 && DrawX <= path45_V2 + wall_thickness3
					&& DrawY <= path45_H2 && DrawY >= path45_H2 - wall_thickness3)
			begin
				if (path == 8'b00101101)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path46_V2 && DrawX <= path46_V2 + wall_thickness3
					&& DrawY <= path46_H2 && DrawY >= path46_H2 - wall_thickness3)
			begin
				if (path == 8'b00101110)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path47_V2 && DrawX <= path47_V2 + wall_thickness3
					&& DrawY <= path47_H2 && DrawY >= path47_H2 - wall_thickness3)
			begin
				if (path == 8'b00101111)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path48_V2 && DrawX <= path48_V2 + wall_thickness3
					&& DrawY <= path48_H2 && DrawY >= path48_H2 - wall_thickness3)
			begin
				if (path == 8'b00110000)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path49_V2 && DrawX <= path49_V2 + wall_thickness3
					&& DrawY <= path49_H2 && DrawY >= path49_H2 - wall_thickness3)
			begin
				if (path == 8'b00110001)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path50_V2 && DrawX <= path50_V2 + wall_thickness3
					&& DrawY <= path50_H2 && DrawY >= path50_H2 - wall_thickness3)
			begin
				if (path == 8'b00110010)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path51_V2 && DrawX <= path51_V2 + wall_thickness3
					&& DrawY <= path51_H2 && DrawY >= path51_H2 - wall_thickness3)
			begin
				if (path == 8'b00110011)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path52_V2 && DrawX <= path52_V2 + wall_thickness3
					&& DrawY <= path52_H2 && DrawY >= path52_H2 - wall_thickness3)
			begin
				if (path == 8'b00110100)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path53_V2 && DrawX <= path53_V2 + wall_thickness3
					&& DrawY <= path53_H2 && DrawY >= path53_H2 - wall_thickness3)
			begin
				if (path == 8'b00110101)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path54_V2 && DrawX <= path54_V2 + wall_thickness3
					&& DrawY <= path54_H2 && DrawY >= path54_H2 - wall_thickness3)
			begin
				if (path == 8'b00110110)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path55_V2 && DrawX <= path55_V2 + wall_thickness3
					&& DrawY <= path55_H2 && DrawY >= path55_H2 - wall_thickness3)
			begin
				if (path == 8'b00110111 || path == 8'b01000000)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path56_V2 && DrawX <= path56_V2 + wall_thickness3
					&& DrawY <= path56_H2 && DrawY >= path56_H2 - wall_thickness3)
			begin
				if (path == 8'b00111000 || path == 8'b00111110)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path57_V2 && DrawX <= path57_V2 + wall_thickness3
					&& DrawY <= path57_H2 && DrawY >= path57_H2 - wall_thickness3)
			begin
				if (path == 8'b00111001 || path == 8'b00111101)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path58_V2 && DrawX <= path58_V2 + wall_thickness3
					&& DrawY <= path58_H2 && DrawY >= path58_H2 - wall_thickness3)
			begin
				if (path == 8'b00111010 || path == 8'b00111100)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path59_V2 && DrawX <= path59_V2 + wall_thickness3
					&& DrawY <= path59_H2 && DrawY >= path59_H2 - wall_thickness3)
			begin
				if (path == 8'b00111011)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path64_V2 && DrawX <= path64_V2 + wall_thickness3
					&& DrawY <= path64_H2 && DrawY >= path64_H2 - wall_thickness3)
			begin
				if (path == 8'b01000000)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path65_V2 && DrawX <= path65_V2 + wall_thickness3
					&& DrawY <= path65_H2 && DrawY >= path65_H2 - wall_thickness3)
			begin
				if (path == 8'b01000001)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path66_V2 && DrawX <= path66_V2 + wall_thickness3
					&& DrawY <= path66_H2 && DrawY >= path66_H2 - wall_thickness3)
			begin
				if (path == 8'b01000010)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path67_V2 && DrawX <= path67_V2 + wall_thickness3
					&& DrawY <= path67_H2 && DrawY >= path67_H2 - wall_thickness3)
			begin
				if (path == 8'b01000011)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path68_V2 && DrawX <= path68_V2 + wall_thickness3
					&& DrawY <= path68_H2 && DrawY >= path68_H2 - wall_thickness3)
			begin
				if (path == 8'b01000100)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path69_V2 && DrawX <= path69_V2 + wall_thickness3
					&& DrawY <= path69_H2 && DrawY >= path69_H2 - wall_thickness3)
			begin
				if (path == 8'b01000101)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path70_V2 && DrawX <= path70_V2 + wall_thickness3
					&& DrawY <= path70_H2 && DrawY >= path70_H2 - wall_thickness3)
			begin
				if (path == 8'b01000110)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path71_V2 && DrawX <= path71_V2 + wall_thickness3
					&& DrawY <= path71_H2 && DrawY >= path71_H2 - wall_thickness3)
			begin
				if (path == 8'b01000111)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path72_V2 && DrawX <= path72_V2 + wall_thickness3
					&& DrawY <= path72_H2 && DrawY >= path72_H2 - wall_thickness3)
			begin
				if (path == 8'b01001000)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path73_V2 && DrawX <= path73_V2 + wall_thickness3
					&& DrawY <= path73_H2 && DrawY >= path73_H2 - wall_thickness3)
			begin
				if (path == 8'b01001001)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path74_V2 && DrawX <= path74_V2 + wall_thickness3
					&& DrawY <= path74_H2 && DrawY >= path74_H2 - wall_thickness3)
			begin
				if (path == 8'b01001010)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path75_V2 && DrawX <= path75_V2 + wall_thickness3
					&& DrawY <= path75_H2 && DrawY >= path75_H2 - wall_thickness3)
			begin
				if (path == 8'b01001011)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path76_V2 && DrawX <= path76_V2 + wall_thickness3
					&& DrawY <= path76_H2 && DrawY >= path76_H2 - wall_thickness3)
			begin
				if (path == 8'b01001100)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path77_V2 && DrawX <= path77_V2 + wall_thickness3
					&& DrawY <= path77_H2 && DrawY >= path77_H2 - wall_thickness3)
			begin
				if (path == 8'b01001101)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path78_V2 && DrawX <= path78_V2 + wall_thickness3
					&& DrawY <= path78_H2 && DrawY >= path78_H2 - wall_thickness3)
			begin
				if (path == 8'b01001110)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path79_V2 && DrawX <= path79_V2 + wall_thickness3
					&& DrawY <= path79_H2 && DrawY >= path79_H2 - wall_thickness3)
			begin
				if (path == 8'b01001111)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path80_V2 && DrawX <= path80_V2 + wall_thickness3
					&& DrawY <= path80_H2 && DrawY >= path80_H2 - wall_thickness3)
			begin
				if (path == 8'b01010000)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path81_V2 && DrawX <= path81_V2 + wall_thickness3
					&& DrawY <= path81_H2 && DrawY >= path81_H2 - wall_thickness3)
			begin
				if (path == 8'b01010001)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
	
	end // for inner if statement
	
	else if(maze3out == 1'b1)
	begin
	
		if(DrawX >= 10'd0 && DrawX <= 10'd640 && DrawY >= 10'd0 && DrawY <= 10'd480)
			begin
				is_maze = 1'b0;
				is_goal = 1'b1;
				is_path = 1'b0;
			end
	
	end // else if end
	
	else
	begin
	
	// Left Wall
		if(DrawX >= left_wall_idx && DrawX <= left_wall_idx + wall_thickness
			&& DrawY >= top_wall_idx - wall_thickness && DrawY <= bottom_wall_idx)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Right Wall
		else if(DrawX >= right_wall_idx && DrawX <= right_wall_idx + wall_thickness
					&& DrawY >= top_wall_idx - wall_thickness && DrawY <= bottom_wall_idx)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Top Wall
		else if(DrawX >= left_wall_idx && DrawX <= right_wall_idx + wall_thickness
					&& DrawY >= top_wall_idx - wall_thickness && DrawY <= top_wall_idx)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Bottom Wall
		else if(DrawX >= left_wall_idx && DrawX <= right_wall_idx + wall_thickness
					&& DrawY >= bottom_wall_idx - wall_thickness && DrawY <= bottom_wall_idx)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Goal Cell
		else if(DrawX >= goal_V && DrawX <= goal_V + wall_thickness
					&& DrawY >= goal_H - wall_thickness && DrawY <= goal_H)
			begin
				is_maze = 1'b0;
				is_goal = 1'b1;
				is_path = 1'b0;
			end
		// Wall 1
		else if(DrawX >= wall_1V && DrawX <= wall_1V + wall_thickness
					&& DrawY <= wall_1H && DrawY >= top_wall_idx)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Wall 2
		else if(DrawX >= wall_2V && DrawX <= wall_2V + wall_thickness
					&& DrawY <= wall_2H && DrawY >= top_wall_idx + wall_thickness)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Wall 3
		else if(DrawX >= wall_3V && DrawX <= wall_3V + wall_thickness
					&& DrawY <= wall_3H && DrawY >= 10'd255)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Wall 4
		else if(DrawX >= wall_4V && DrawX <= wall_4V + wall_thickness
					&& DrawY <= wall_4H && DrawY >= 10'd195)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Wall 5
		else if(DrawX >= wall_5V && DrawX <= wall_5V + wall_thickness
					&& DrawY <= wall_5H && DrawY >= 10'd315)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Wall 6
		else if(DrawX >= wall_6V && DrawX <= wall_6V + wall_thickness
					&& DrawY <= wall_6H && DrawY >= top_wall_idx + wall_thickness)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Wall 7
		else if(DrawX >= wall_7V && DrawX <= 10'd425
					&& DrawY <= wall_7H && DrawY >= wall_7H - wall_thickness)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Wall 8
		else if(DrawX >= wall_8V && DrawX <= 10'd425
					&& DrawY <= wall_8H && DrawY >= wall_8H - wall_thickness)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Wall 9
		else if(DrawX >= wall_9V && DrawX <= right_wall_idx
					&& DrawY <= wall_9H && DrawY >= wall_9H - wall_thickness)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
		// Wall 10
		else if(DrawX >= wall_10V && DrawX <= right_wall_idx
					&& DrawY <= wall_10H && DrawY >= wall_10H - wall_thickness)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
			
		// path1
		else if(DrawX >= path1_V && DrawX <= path1_V + wall_thickness
					&& DrawY <= path1_H && DrawY >= path1_H - wall_thickness)
			begin
				if (path == 8'b00000001)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path2
		else if(DrawX >= path2_V && DrawX <= path2_V + wall_thickness
					&& DrawY <= path2_H && DrawY >= path2_H - wall_thickness)
			begin
				if (path == 8'b000000010)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path3
		else if(DrawX >= path3_V && DrawX <= path3_V + wall_thickness
					&& DrawY <= path3_H && DrawY >= path3_H - wall_thickness)
			begin
				if (path == 8'b00000011)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path4
		else if(DrawX >= path4_V && DrawX <= path4_V + wall_thickness
					&& DrawY <= path4_H && DrawY >= path4_H - wall_thickness)
			begin
				if (path == 8'b000000100)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path5
		else if(DrawX >= path5_V && DrawX <= path5_V + wall_thickness
					&& DrawY <= path5_H && DrawY >= path5_H - wall_thickness)
			begin
				if (path == 8'b00000101)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path6
		else if(DrawX >= path6_V && DrawX <= path6_V + wall_thickness
					&& DrawY <= path6_H && DrawY >= path6_H - wall_thickness)
			begin
				if (path == 8'b00000110)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path7
		else if(DrawX >= path7_V && DrawX <= path7_V + wall_thickness
					&& DrawY <= path7_H && DrawY >= path7_H - wall_thickness)
			begin
				if (path == 8'b00000111)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path8
		else if(DrawX >= path8_V && DrawX <= path8_V + wall_thickness
					&& DrawY <= path8_H && DrawY >= path8_H - wall_thickness)
			begin
				if (path == 8'b00001000)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path9
		else if(DrawX >= path9_V && DrawX <= path9_V + wall_thickness
					&& DrawY <= path9_H && DrawY >= path9_H - wall_thickness)
			begin
				if (path == 8'b00001001)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path10
		else if(DrawX >= path10_V && DrawX <= path10_V + wall_thickness
					&& DrawY <= path10_H && DrawY >= path10_H - wall_thickness)
			begin
				if (path == 8'b00001010)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path11
		else if(DrawX >= path11_V && DrawX <= path11_V + wall_thickness
					&& DrawY <= path11_H && DrawY >= path11_H - wall_thickness)
			begin
				if (path == 8'b00001011)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path12
		else if(DrawX >= path12_V && DrawX <= path12_V + wall_thickness
					&& DrawY <= path12_H && DrawY >= path12_H - wall_thickness)
			begin
				if (path == 8'b00001100)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path13
		else if(DrawX >= path13_V && DrawX <= path13_V + wall_thickness
					&& DrawY <= path13_H && DrawY >= path13_H - wall_thickness)
			begin
				if (path == 8'b00001101)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path14
		else if(DrawX >= path14_V && DrawX <= path14_V + wall_thickness
					&& DrawY <= path14_H && DrawY >= path14_H - wall_thickness)
			begin
				if (path == 8'b00001110)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path15
		else if(DrawX >= path15_V && DrawX <= path15_V + wall_thickness
					&& DrawY <= path15_H && DrawY >= path15_H - wall_thickness)
			begin
				if (path == 8'b00001111)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path16
		else if(DrawX >= path16_V && DrawX <= path16_V + wall_thickness
					&& DrawY <= path16_H && DrawY >= path16_H - wall_thickness)
			begin
				if (path == 8'b00010000)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path17, 69
		else if(DrawX >= path17_V && DrawX <= path17_V + wall_thickness
					&& DrawY <= path17_H && DrawY >= path17_H - wall_thickness)
			begin
				if (path == 8'b00010001 || path == 8'b01000101)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path18, 68
		else if(DrawX >= path18_V && DrawX <= path18_V + wall_thickness
					&& DrawY <= path18_H && DrawY >= path18_H - wall_thickness)
			begin
				if (path == 8'b00010010 || path == 8'b01000100)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path19, 67
		else if(DrawX >= path19_V && DrawX <= path19_V + wall_thickness
					&& DrawY <= path19_H && DrawY >= path19_H - wall_thickness)
			begin
				if (path == 8'b00010011 || path == 8'b01000011)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path20, 66
		else if(DrawX >= path20_V && DrawX <= path20_V + wall_thickness
					&& DrawY <= path20_H && DrawY >= path20_H - wall_thickness)
			begin
				if (path == 8'b00010100 || path == 8'b01000010)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path21, 65
		else if(DrawX >= path21_V && DrawX <= path21_V + wall_thickness
					&& DrawY <= path21_H && DrawY >= path21_H - wall_thickness)
			begin
				if (path == 8'b00010101 || path == 8'b01000001)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path22, 64
		else if(DrawX >= path22_V && DrawX <= path22_V + wall_thickness
					&& DrawY <= path22_H && DrawY >= path22_H - wall_thickness)
			begin
				if (path == 8'b00010110 || path == 8'b01000000)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path23, 63
		else if(DrawX >= path23_V && DrawX <= path23_V + wall_thickness
					&& DrawY <= path23_H && DrawY >= path23_H - wall_thickness)
			begin
				if (path == 8'b00010111 || path == 8'b00111111)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path24,62
		else if(DrawX >= path24_V && DrawX <= path24_V + wall_thickness
					&& DrawY <= path24_H && DrawY >= path24_H - wall_thickness)
			begin
				if (path == 8'b00011000 || path == 8'b00111110)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path25, 61
		else if(DrawX >= path25_V && DrawX <= path25_V + wall_thickness
					&& DrawY <= path25_H && DrawY >= path25_H - wall_thickness)
			begin
				if (path == 8'b00011001 || path == 8'b00111101)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path26, 60
		else if(DrawX >= path26_V && DrawX <= path26_V + wall_thickness
					&& DrawY <= path26_H && DrawY >= path26_H - wall_thickness)
			begin
				if (path == 8'b00011010 || path == 8'b00111100)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path27, 59
		else if(DrawX >= path27_V && DrawX <= path27_V + wall_thickness
					&& DrawY <= path27_H && DrawY >= path27_H - wall_thickness)
			begin
				if (path == 8'b000011011 || path == 8'b00111011)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path28, 58
		else if(DrawX >= path28_V && DrawX <= path28_V + wall_thickness
					&& DrawY <= path28_H && DrawY >= path28_H - wall_thickness)
			begin
				if (path == 8'b00011100 || path == 8'b00111010)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path29, 57
		else if(DrawX >= path29_V && DrawX <= path29_V + wall_thickness
					&& DrawY <= path29_H && DrawY >= path29_H - wall_thickness)
			begin
				if (path == 8'b00011101 || path == 8'b00111001)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path30, 56
		else if(DrawX >= path30_V && DrawX <= path30_V + wall_thickness
					&& DrawY <= path30_H && DrawY >= path30_H - wall_thickness)
			begin
				if (path == 8'b00011110 || path == 8'b00111000)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path31, 55
		else if(DrawX >= path31_V && DrawX <= path31_V + wall_thickness
					&& DrawY <= path31_H && DrawY >= path31_H - wall_thickness)
			begin
				if (path == 8'b00011111 || path == 8'b00110111)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path32, 54
		else if(DrawX >= path32_V && DrawX <= path32_V + wall_thickness
					&& DrawY <= path32_H && DrawY >= path32_H - wall_thickness)
			begin
				if (path == 8'b00100000 || path == 8'b00110110)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path33, 53
		else if(DrawX >= path33_V && DrawX <= path33_V + wall_thickness
					&& DrawY <= path33_H && DrawY >= path33_H - wall_thickness)
			begin
				if (path == 8'b00100001 || path == 8'b00110101)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path34, 52
		else if(DrawX >= path34_V && DrawX <= path34_V + wall_thickness
					&& DrawY <= path34_H && DrawY >= path34_H - wall_thickness)
			begin
				if (path == 8'b00100010 || path == 8'b00110100)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path35, 51
		else if(DrawX >= path35_V && DrawX <= path35_V + wall_thickness
					&& DrawY <= path35_H && DrawY >= path35_H - wall_thickness)
			begin
				if (path == 8'b00100011 || path == 8'b00110011)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path36, 50
		else if(DrawX >= path36_V && DrawX <= path36_V + wall_thickness
					&& DrawY <= path36_H && DrawY >= path36_H - wall_thickness)
			begin
				if (path == 8'b00100100 || path == 8'b00110010)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path37, 49
		else if(DrawX >= path37_V && DrawX <= path37_V + wall_thickness
					&& DrawY <= path37_H && DrawY >= path37_H - wall_thickness)
			begin
				if (path == 8'b00100101 || path == 8'b00110001)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path38, 48
		else if(DrawX >= path38_V && DrawX <= path38_V + wall_thickness
					&& DrawY <= path38_H && DrawY >= path38_H - wall_thickness)
			begin
				if (path == 8'b00100110 || path == 8'b00110000)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path39, 47
		else if(DrawX >= path39_V && DrawX <= path39_V + wall_thickness
					&& DrawY <= path39_H && DrawY >= path39_H - wall_thickness)
			begin
				if (path == 8'b00100111 || path == 8'b00101111)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path40, 46
		else if(DrawX >= path40_V && DrawX <= path40_V + wall_thickness
					&& DrawY <= path40_H && DrawY >= path40_H - wall_thickness)
			begin
				if (path == 8'b00101000 || path == 8'b00101110)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path41, 45
		else if(DrawX >= path41_V && DrawX <= path41_V + wall_thickness
					&& DrawY <= path41_H && DrawY >= path41_H - wall_thickness)
			begin
				if (path == 8'b00101001 || path == 8'b00101101)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path42, 44
		else if(DrawX >= path42_V && DrawX <= path42_V + wall_thickness
					&& DrawY <= path42_H && DrawY >= path42_H - wall_thickness)
			begin
				if (path == 8'b00101010 || path == 8'b00101100)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path43
		else if(DrawX >= path43_V && DrawX <= path43_V + wall_thickness
					&& DrawY <= path43_H && DrawY >= path43_H - wall_thickness)
			begin
				if (path == 8'b00101011)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path70
		else if(DrawX >= path70_V && DrawX <= path70_V + wall_thickness
					&& DrawY <= path70_H && DrawY >= path70_H - wall_thickness)
			begin
				if (path == 8'b01000110)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path71
		else if(DrawX >= path71_V && DrawX <= path71_V + wall_thickness
					&& DrawY <= path71_H && DrawY >= path71_H - wall_thickness)
			begin
				if (path == 8'b01000111)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		// path72
		else if(DrawX >= path72_V && DrawX <= path72_V + wall_thickness
					&& DrawY <= path72_H && DrawY >= path72_H - wall_thickness)
			begin
				if (path == 8'b01001000)
					begin
						is_path = 1'b1;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
				else
					begin
						is_path = 1'b0;
						is_maze = 1'b0;
						is_goal = 1'b0;
					end
			end
		
		else
			begin
				is_maze = 1'b0;
				is_goal = 1'b0;
				is_path = 1'b0;
			end
	
	end // for else
	
	end // for big always comb block
	
endmodule
