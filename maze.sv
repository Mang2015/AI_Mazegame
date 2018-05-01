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
	
	parameter [9:0] path60_V2 = 10'd230;
	parameter [9:0] path60_H2 = 10'd430;
	
	parameter [9:0] path61_V2 = 10'd250;
	parameter [9:0] path61_H2 = 10'd430;
	
	parameter [9:0] path62_V2 = 10'd270;
	parameter [9:0] path62_H2 = 10'd430;
	
	parameter [9:0] path63_V2 = 10'd290;
	parameter [9:0] path63_H2 = 10'd430;
	
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
				
	// MAZE 3
	parameter [9:0] left_wall_idx2 = 10'd15;
	parameter [9:0] right_wall_idx2 = 10'd615;
	parameter [9:0] top_wall_idx2 = 10'd135;
	parameter [9:0] bottom_wall_idx2 = 10'd355;
	parameter [9:0] wall_thickness2 = 10'd10;
	
	parameter [9:0] maze2_goalV = 10'd605;
	parameter [9:0] maze2_goalH = 10'd345;
	
	// Walls
	// Row 2
	// (0,2) --> (2,2)
	parameter [9:0] wall_1_V2 = 10'd015;
	parameter [9:0] wall_1_H2 = 10'd155;
	
	// (4,2) --> (6,2)
	parameter [9:0] wall_2_V2 = 10'd055;
	parameter [9:0] wall_2_H2 = 10'd155;
	
	// (8,2)
	parameter [9:0] wall_14_V2 = 10'd095;
	parameter [9:0] wall_14_H2 = 10'd155;
	
	// (10,2) --> (14,2)
	parameter [9:0] wall_3_V2 = 10'd115;
	parameter [9:0] wall_3_H2 = 10'd155;
	
	// (16,2) --> (20,2)
	parameter [9:0] wall_4_V2 = 10'd175;
	parameter [9:0] wall_4_H2 = 10'd155;
	
	// (22,2) --> (26,2)
	parameter [9:0] wall_5_V2 = 10'd235;
	parameter [9:0] wall_5_H2 = 10'd155;
	
	// (28,2) --> (30,2)
	parameter [9:0] wall_6_V2 = 10'd295;
	parameter [9:0] wall_6_H2 = 10'd155;
	
	// (32,2) --> (38,2)
	parameter [9:0] wall_7_V2 = 10'd335;
	parameter [9:0] wall_7_H2 = 10'd155;
	
	// (40, 2)
	parameter [9:0] wall_8_V2 = 10'd415;
	parameter [9:0] wall_8_H2 = 10'd155;
	
	// (42,2) --> (44,2)
	parameter [9:0] wall_9_V2 = 10'd435;
	parameter [9:0] wall_9_H2 = 10'd155;
	
	// (46,2)
	parameter [9:0] wall_10_V2 = 10'd475;
	parameter [9:0] wall_10_H2 = 10'd155;
	
	// (48,2) --> (54,2)
	parameter [9:0] wall_11_V2 = 10'd495;
	parameter [9:0] wall_11_H2 = 10'd155;
	
	// (56,2)
	parameter [9:0] wall_12_V2 = 10'd575;
	parameter [9:0] wall_12_H2 = 10'd155;
	
	// (58,2) --> (60,2)
	parameter [9:0] wall_13_V2 = 10'd595;
	parameter [9:0] wall_13_H2 = 10'd155;
	
	// Row 1
	// (6,1)
	parameter [9:0] wall_15_V2 = 10'd075;
	parameter [9:0] wall_15_H2 = 10'd145;
	
	// (14,1)
	parameter [9:0] wall_16_V2 = 10'd155;
	parameter [9:0] wall_16_H2 = 10'd145;
	
	// (28, 1)
	parameter [9:0] wall_17_V2 = 10'd295;
	parameter [9:0] wall_17_H2 = 10'd145;
	
	// (38, 1)
	parameter [9:0] wall_18_V2 = 10'd395;
	parameter [9:0] wall_18_H2 = 10'd145;
	
	// (44,1)
	parameter [9:0] wall_19_V2 = 10'd455;
	parameter [9:0] wall_19_H2 = 10'd145;
	
	// (56,1)
	parameter [9:0] wall_20_V2 = 10'd575;
	parameter [9:0] wall_20_H2 = 10'd145;
	
	// (60,1)
	parameter [9:0] wall_21_V2 = 10'd615;
	parameter [9:0] wall_21_H2 = 10'd145;
	
	// Row 3
	// (4,3)
	parameter [9:0] wall_22_V2 = 10'd055;
	parameter [9:0] wall_22_H2 = 10'd165;
	
	// (14,3)
	parameter [9:0] wall_23_V2 = 10'd155;
	parameter [9:0] wall_23_H2 = 10'd165;
	
	// (18,3)
	parameter [9:0] wall_24_V2 = 10'd115;
	parameter [9:0] wall_24_H2 = 10'd165;
	
	// (20,3)
	parameter [9:0] wall_25_V2 = 10'd215;
	parameter [9:0] wall_25_H2 = 10'd165;
	
	// (26,3)
	parameter [9:0] wall_26_V2 = 10'd275;
	parameter [9:0] wall_26_H2 = 10'd165;

	// (30,3)
	parameter [9:0] wall_27_V2 = 10'd315;
	parameter [9:0] wall_27_H2 = 10'd165;
	
	// (40,3)
	parameter [9:0] wall_28_V2 = 10'd415;
	parameter [9:0] wall_28_H2 = 10'd165;
	
	// (44,3)
	parameter [9:0] wall_29_V2 = 10'd455;
	parameter [9:0] wall_29_H2 = 10'd165;
	
	// (46,3)
	parameter [9:0] wall_30_V2 = 10'd475;
	parameter [9:0] wall_30_H2 = 10'd165;
	
	// (52,3)
	parameter [9:0] wall_31_V2 = 10'd535;
	parameter [9:0] wall_31_H2 = 10'd165;
	
	// (54,3)
	parameter [9:0] wall_32_V2 = 10'd555;
	parameter [9:0] wall_32_H2 = 10'd165;
	
	// (56,3)
	parameter [9:0] wall_33_V2 = 10'd575;
	parameter [9:0] wall_33_H2 = 10'd165;
	
	// (60,3)
	parameter [9:0] wall_34_V2 = 10'd615;
	parameter [9:0] wall_34_H2 = 10'd165;
	
	/*
	// Row 4
	// (2,4) --> (4,4)
	parameter [9:0] wall_35_V2 = 10'd035;
	parameter [9:0] wall_35_H2 = 10'd175;
	
	// (6,4) --> (8,4)
	parameter [9:0] wall_36_V2 = 10'd075;
	parameter [9:0] wall_36_H2 = 10'd175;
	
	// (10,4) --> (12,4)
	parameter [9:0] wall_37_V2 = 10'd115;
	parameter [9:0] wall_37_H2 = 10'd175;
	
	// (14,4) --> (16,4)
	parameter [9:0] wall_38_V2 = 10'd155;
	parameter [9:0] wall_38_H2 = 10'd175;
	
	// (18,4)
	parameter [9:0] wall_39_V2 = 10'd195;
	parameter [9:0] wall_39_H2 = 10'd175;
	
	// (20,4) --> (22,4)
	parameter [9:0] wall_40_V2 = 10'd215;
	parameter [9:0] wall_40_H2 = 10'd175;
	
	// (24,4)
	parameter [9:0] wall_41_V2 = 10'd255;
	parameter [9:0] wall_41_H2 = 10'd175;
	
	// (26,4) --> (28,4)
	parameter [9:0] wall_42_V2 = 10'd275;
	parameter [9:0] wall_42_H2 = 10'd175;
	
	// (30,4)
	parameter [9:0] wall_43_V2 = 10'd315;
	parameter [9:0] wall_43_H2 = 10'd175;
	
	// (32,4) --> (37,4)
	parameter [9:0] wall_44_V2 = 10'd335;
	parameter [9:0] wall_44_H2 = 10'd175;
	
	// (39,4) --> (42,4)
	parameter [9:0] wall_45_V2 = 10'd405;
	parameter [9:0] wall_45_H2 = 10'd175;
	
	// (44,4)
	parameter [9:0] wall_46_V2 = 10'd455;
	parameter [9:0] wall_46_H2 = 10'd175;
	
	// (46, 4) --> (50,4)
	parameter [9:0] wall_47_V2 = 10'd475;
	parameter [9:0] wall_47_H2 = 10'd175;
	
	// (52, 4)
	parameter [9:0] wall_48_V2 = 10'd535;
	parameter [9:0] wall_48_H2 = 10'd175;
	
	// (54, 4)
	parameter [9:0] wall_49_V2 = 10'd555;
	parameter [9:0] wall_49_H2 = 10'd175;
	
	// (56,4) --> (58, 4)
	parameter [9:0] wall_50_V2 = 10'd575;
	parameter [9:0] wall_50_H2 = 10'd175;
	
	// (60,4)
	parameter [9:0] wall_51_V2 = 10'd615;
	parameter [9:0] wall_51_H2 = 10'd175;
	*/
	// Row 5
	// (2,5)
	parameter [9:0] wall_52_V2 = 10'd035;
	parameter [9:0] wall_52_H2 = 10'd185;
	
	// (6,5)
	parameter [9:0] wall_53_V2 = 10'd075;
	parameter [9:0] wall_53_H2 = 10'd185;
	
	// (8,5)
	parameter [9:0] wall_54_V2 = 10'd095;
	parameter [9:0] wall_54_H2 = 10'd185;
	
	// (12,5)
	parameter [9:0] wall_55_V2 = 10'd135;
	parameter [9:0] wall_55_H2 = 10'd185;
	
	// (14,5)
	parameter [9:0] wall_56_V2 = 10'd155;
	parameter [9:0] wall_56_H2 = 10'd185;
	
	// (18,5)
	parameter [9:0] wall_57_V2 = 10'd195;
	parameter [9:0] wall_57_H2 = 10'd185;

	// (22,5)
	parameter [9:0] wall_58_V2 = 10'd235;
	parameter [9:0] wall_58_H2 = 10'd185;
	
	// (24,5)
	parameter [9:0] wall_59_V2 = 10'd255;
	parameter [9:0] wall_59_H2 = 10'd185;
	
	// (42,5)
	parameter [9:0] wall_60_V2 = 10'd435;
	parameter [9:0] wall_60_H2 = 10'd185;
	
	// (44,5)
	parameter [9:0] wall_61_V2 = 10'd455;
	parameter [9:0] wall_61_H2 = 10'd185;
	
	// (48,5)
	parameter [9:0] wall_62_V2 = 10'd495;
	parameter [9:0] wall_62_H2 = 10'd185;
	
	// (50,5)
	parameter [9:0] wall_63_V2 = 10'd515;
	parameter [9:0] wall_63_H2 = 10'd185;
	
	// (52,5)
	parameter [9:0] wall_64_V2 = 10'd535;
	parameter [9:0] wall_64_H2 = 10'd185;
	
	// (60,5)
	parameter [9:0] wall_65_V2 = 10'd615;
	parameter [9:0] wall_65_H2 = 10'd185;
	
	// Row 6
	// (4,6) --> (6,6)
	parameter [9:0] wall_66_V2 = 10'd055;
	parameter [9:0] wall_66_H2 = 10'd195;
	
	// (8,6)
	parameter [9:0] wall_67_V2 = 10'd095;
	parameter [9:0] wall_67_H2 = 10'd195;
	
	// (10,6)
	parameter [9:0] wall_68_V2 = 10'd155;
	parameter [9:0] wall_68_H2 = 10'd195;
	
	// (12,6)
	parameter [9:0] wall_69_V2 = 10'd135;
	parameter [9:0] wall_69_H2 = 10'd195;
	
	// (14,6)
	parameter [9:0] wall_70_V2 = 10'd155;
	parameter [9:0] wall_70_H2 = 10'd195;
	
	// (16,6)
	parameter [9:0] wall_71_V2 = 10'd175;
	parameter [9:0] wall_71_H2 = 10'd195;
	
	// (18,6)
	parameter [9:0] wall_72_V2 = 10'd195;
	parameter [9:0] wall_72_H2 = 10'd195;
	
	// (20,6)
	parameter [9:0] wall_73_V2 = 10'd215;
	parameter [9:0] wall_73_H2 = 10'd195;
	
	// (22,6)
	parameter [9:0] wall_74_V2 = 10'd235;
	parameter [9:0] wall_74_H2 = 10'd195;
	
	// (24,6) --> (26,6)
	parameter [9:0] wall_75_V2 = 10'd255;
	parameter [9:0] wall_75_H2 = 10'd195;
	
	// (28,6)
	parameter [9:0] wall_76_V2 = 10'd295;
	parameter [9:0] wall_76_H2 = 10'd195;
	
	// (30,6) --> (36,6)
	parameter [9:0] wall_77_V2 = 10'd315;
	parameter [9:0] wall_77_H2 = 10'd195;
	
	// (38,6) --> (40,6)
	parameter [9:0] wall_78_V2 = 10'd395;
	parameter [9:0] wall_78_H2 = 10'd195;
	
	// (42,6)
	parameter [9:0] wall_79_V2 = 10'd435;
	parameter [9:0] wall_79_H2 = 10'd195;
	
	// (44,6) --> (46,6)
	parameter [9:0] wall_80_V2 = 10'd455;
	parameter [9:0] wall_80_H2 = 10'd195;
	
	// (48,6)
	parameter [9:0] wall_81_V2 = 10'd495;
	parameter [9:0] wall_81_H2 = 10'd195;
	
	// (50,6)
	parameter [9:0] wall_82_V2 = 10'd515;
	parameter [9:0] wall_82_H2 = 10'd195;
	
	// (52,6) --> (58,6)
	parameter [9:0] wall_83_V2 = 10'd535;
	parameter [9:0] wall_83_H2 = 10'd195;
	
	// (60,6)
	parameter [9:0] wall_84_V2 = 10'd615;
	parameter [9:0] wall_84_H2 = 10'd195;
	
	// Row 7
	// (2,7)
	parameter [9:0] wall_85_V2 = 10'd035;
	parameter [9:0] wall_85_H2 = 10'd205;
	
	// (6,7)
	parameter [9:0] wall_86_V2 = 10'd075;
	parameter [9:0] wall_86_H2 = 10'd205;
	
	// (10,7)
	parameter [9:0] wall_87_V2 = 10'd115;
	parameter [9:0] wall_87_H2 = 10'd205;
	
	// (12,7)
	parameter [9:0] wall_88_V2 = 10'd135;
	parameter [9:0] wall_88_H2 = 10'd205;
	
	// (16,7)
	parameter [9:0] wall_89_V2 = 10'd175;
	parameter [9:0] wall_89_H2 = 10'd205;
	
	// (20,7)
	parameter [9:0] wall_90_V2 = 10'd215;
	parameter [9:0] wall_90_H2 = 10'd205;
	
	// (22,7)
	parameter [9:0] wall_91_V2 = 10'd235;
	parameter [9:0] wall_91_H2 = 10'd205;
	
	// (26,7)
	parameter [9:0] wall_92_V2 = 10'd275;
	parameter [9:0] wall_92_H2 = 10'd205;
	
	// (28,7)
	parameter [9:0] wall_93_V2 = 10'd295;
	parameter [9:0] wall_93_H2 = 10'd205;
	
	// (34,7)
	parameter [9:0] wall_94_V2 = 10'd355;
	parameter [9:0] wall_94_H2 = 10'd205;
	
	// (38,7)
	parameter [9:0] wall_95_V2 = 10'd395;
	parameter [9:0] wall_95_H2 = 10'd205;
	
	// (42,7)
	parameter [9:0] wall_96_V2 = 10'd435;
	parameter [9:0] wall_96_H2 = 10'd205;
	
	// (48,7)
	parameter [9:0] wall_97_V2 = 10'd495;
	parameter [9:0] wall_97_H2 = 10'd205;
	
	// (50,7)
	parameter [9:0] wall_98_V2 = 10'd515;
	parameter [9:0] wall_98_H2 = 10'd205;
	
	// (54,7)
	parameter [9:0] wall_99_V2 = 10'd555;
	parameter [9:0] wall_99_H2 = 10'd205;
	
	// (58,7)
	parameter [9:0] wall_100_V2 = 10'd595;
	parameter [9:0] wall_100_H2 = 10'd205;
	
	// (60,7)
	parameter [9:0] wall_101_V2 = 10'd615;
	parameter [9:0] wall_101_H2 = 10'd205;
	
	// Row 8
	// (2,8) --> (8,8)
	parameter [9:0] wall_102_V2 = 10'd035;
	parameter [9:0] wall_102_H2 = 10'd215;
	
	// (10,8)
	parameter [9:0] wall_103_V2 = 10'd115;
	parameter [9:0] wall_103_H2 = 10'd215;
	
	// (12,8)
	parameter [9:0] wall_104_V2 = 10'd135;
	parameter [9:0] wall_104_H2 = 10'd215;
	
	// (14,8) --> (16,8)
	parameter [9:0] wall_105_V2 = 10'd155;
	parameter [9:0] wall_105_H2 = 10'd215;
	
	// (18,8) --> (20,8)
	parameter [9:0] wall_106_V2 = 10'd195;
	parameter [9:0] wall_106_H2 = 10'd215;
	
	// (22,8) --> (24,8)
	parameter [9:0] wall_107_V2 = 10'd235;
	parameter [9:0] wall_107_H2 = 10'd215;
	
	// (26, 8)
	parameter [9:0] wall_108_V2 = 10'd275;
	parameter [9:0] wall_108_H2 = 10'd215;
	
	// (28,8) --> (30,8)
	parameter [9:0] wall_109_V2 = 10'd295;
	parameter [9:0] wall_109_H2 = 10'd215;
	
	// (32,8) --> (34,8)
	parameter [9:0] wall_110_V2 = 10'd335;
	parameter [9:0] wall_110_H2 = 10'd215;
	
	// (36,8)
	parameter [9:0] wall_111_V2 = 10'd375;
	parameter [9:0] wall_111_H2 = 10'd215;
	
	// (38,8)
	parameter [9:0] wall_112_V2 = 10'd395;
	parameter [9:0] wall_112_H2 = 10'd215;
	
	// (40,8) --> (48,8)
	parameter [9:0] wall_113_V2 = 10'd415;
	parameter [9:0] wall_113_H2 = 10'd215;
	
	// (50,8) --> (52,8)
	parameter [9:0] wall_114_V2 = 10'd515;
	parameter [9:0] wall_114_H2 = 10'd215;
	
	// (54, 8)
	parameter [9:0] wall_115_V2 = 10'd555;
	parameter [9:0] wall_115_H2 = 10'd215;
	
	// (56,8)
	parameter [9:0] wall_116_V2 = 10'd575;
	parameter [9:0] wall_116_H2 = 10'd215;
	
	// (58,8)
	parameter [9:0] wall_117_V2 = 10'd595;
	parameter [9:0] wall_117_H2 = 10'd215;
	
	// (60,8)
	parameter [9:0] wall_118_V2 = 10'd615;
	parameter [9:0] wall_118_H2 = 10'd215;
	
	// Row 9
	// (4,9)
	parameter [9:0] wall_119_V2 = 10'd055;
	parameter [9:0] wall_119_H2 = 10'd225;
	
	// (8,9)
	parameter [9:0] wall_120_V2 = 10'd095;
	parameter [9:0] wall_120_H2 = 10'd225;
	
	// (10,9)
	parameter [9:0] wall_121_V2 = 10'd115;
	parameter [9:0] wall_121_H2 = 10'd225;
	
	// (18,9)
	parameter [9:0] wall_122_V2 = 10'd195;
	parameter [9:0] wall_122_H2 = 10'd225;
	
	// (20,9)
	parameter [9:0] wall_123_V2 = 10'd215;
	parameter [9:0] wall_123_H2 = 10'd225;
	
	// (22,9)
	parameter [9:0] wall_124_V2 = 10'd235;
	parameter [9:0] wall_124_H2 = 10'd225;
	
	// (26,9)
	parameter [9:0] wall_125_V2 = 10'd275;
	parameter [9:0] wall_125_H2 = 10'd225;
	
	// (30,9)
	parameter [9:0] wall_126_V2 = 10'd315;
	parameter [9:0] wall_126_H2 = 10'd225;
	
	// (32,9)
	parameter [9:0] wall_127_V2 = 10'd335;
	parameter [9:0] wall_127_H2 = 10'd225;
	
	// (36,9)
	parameter [9:0] wall_128_V2 = 10'd375;
	parameter [9:0] wall_128_H2 = 10'd225;
	
	// (38,9)
	parameter [9:0] wall_129_V2 = 10'd395;
	parameter [9:0] wall_129_H2 = 10'd225;
	
	// (40,9)
	parameter [9:0] wall_130_V2 = 10'd415;
	parameter [9:0] wall_130_H2 = 10'd225;
	
	// (46,9)
	parameter [9:0] wall_131_V2 = 10'd475;
	parameter [9:0] wall_131_H2 = 10'd225;
	
	// (52,9)
	parameter [9:0] wall_132_V2 = 10'd515;
	parameter [9:0] wall_132_H2 = 10'd225;
	
	// (56,9)
	parameter [9:0] wall_133_V2 = 10'd575;
	parameter [9:0] wall_133_H2 = 10'd225;
	
	// (58,9)
	parameter [9:0] wall_134_V2 = 10'd595;
	parameter [9:0] wall_134_H2 = 10'd225;
	
	// (60,9)
	parameter [9:0] wall_135_V2 = 10'd615;
	parameter [9:0] wall_135_H2 = 10'd225;
	
	// Row 10
	// (2,10)
	parameter [9:0] wall_136_V2 = 10'd035;
	parameter [9:0] wall_136_H2 = 10'd235;
	
	// (4,10) --> (6,10)
	parameter [9:0] wall_137_V2 = 10'd055;
	parameter [9:0] wall_137_H2 = 10'd235;
	
	// (8,10)
	parameter [9:0] wall_138_V2 = 10'd095;
	parameter [9:0] wall_138_H2 = 10'd235;
	
	// (10,10) --> (12,10)
	parameter [9:0] wall_139_V2 = 10'd115;
	parameter [9:0] wall_139_H2 = 10'd235;
	
	// (14,10) --> (18,10)
	parameter [9:0] wall_140_V2 = 10'd155;
	parameter [9:0] wall_140_H2 = 10'd235;
	
	// (20,10)
	parameter [9:0] wall_141_V2 = 10'd215;
	parameter [9:0] wall_141_H2 = 10'd235;
	
	// (22,10)
	parameter [9:0] wall_142_V2 = 10'd235;
	parameter [9:0] wall_142_H2 = 10'd235;
	
	// (24,10) --> (28,10)
	parameter [9:0] wall_143_V2 = 10'd255;
	parameter [9:0] wall_143_H2 = 10'd235;
	
	// (30,10)
	parameter [9:0] wall_144_V2 = 10'd315;
	parameter [9:0] wall_144_H2 = 10'd235;
	
	// (32,10)
	parameter [9:0] wall_145_V2 = 10'd335;
	parameter [9:0] wall_145_H2 = 10'd235;
	
	// (34,10) --> (36,10)
	parameter [9:0] wall_146_V2 = 10'd355;
	parameter [9:0] wall_146_H2 = 10'd235;
	
	// (38,10)
	parameter [9:0] wall_147_V2 = 10'd395;
	parameter [9:0] wall_147_H2 = 10'd235;
	
	// (40,10)
	parameter [9:0] wall_148_V2 = 10'd415;
	parameter [9:0] wall_148_H2 = 10'd235;
	
	// (42,10) --> (44,10)
	parameter [9:0] wall_149_V2 = 10'd435;
	parameter [9:0] wall_149_H2 = 10'd235;
	
	// (46,10) --> (50, 10)
	parameter [9:0] wall_150_V2 = 10'd475;
	parameter [9:0] wall_150_H2 = 10'd235;
	
	// (52,10) --> (56, 10)
	parameter [9:0] wall_151_V2 = 10'd535;
	parameter [9:0] wall_151_H2 = 10'd235;
	
	// (58,10) --> (60,10)
	parameter [9:0] wall_152_V2 = 10'd595;
	parameter [9:0] wall_152_H2 = 10'd235;
	
	//Row 11
	// (2,11)
	parameter [9:0] wall_153_V2 = 10'd035;
	parameter [9:0] wall_153_H2 = 10'd245;
	
	// (6,11)
	parameter [9:0] wall_154_V2 = 10'd075;
	parameter [9:0] wall_154_H2 = 10'd245;
	
	// (8,11)
	parameter [9:0] wall_155_V2 = 10'd095;
	parameter [9:0] wall_155_H2 = 10'd245;
	
	// (12,11)
	parameter [9:0] wall_156_V2 = 10'd135;
	parameter [9:0] wall_156_H2 = 10'd245;
	
	// (22,11)
	parameter [9:0] wall_157_V2 = 10'd235;
	parameter [9:0] wall_157_H2 = 10'd245;
	
	// (24,11)
	parameter [9:0] wall_158_V2 = 10'd255;
	parameter [9:0] wall_158_H2 = 10'd245;
	
	// (28,11)
	parameter [9:0] wall_159_V2 = 10'd295;
	parameter [9:0] wall_159_H2 = 10'd245;
	
	// (30,11)
	parameter [9:0] wall_160_V2 = 10'd315;
	parameter [9:0] wall_160_H2 = 10'd245;
	
	// (36,11)
	parameter [9:0] wall_161_V2 = 10'd375;
	parameter [9:0] wall_161_H2 = 10'd245;
	
	// (40,11)
	parameter [9:0] wall_162_V2 = 10'd415;
	parameter [9:0] wall_162_H2 = 10'd245;
	
	// (42,11)
	parameter [9:0] wall_163_V2 = 10'd435;
	parameter [9:0] wall_163_H2 = 10'd245;
	
	// (44,11)
	parameter [9:0] wall_164_V2 = 10'd455;
	parameter [9:0] wall_164_H2 = 10'd245;
	
	// (56,11)
	parameter [9:0] wall_165_V2 = 10'd575;
	parameter [9:0] wall_165_H2 = 10'd245;
	
	// (60,11)
	parameter [9:0] wall_166_V2 = 10'd615;
	parameter [9:0] wall_166_H2 = 10'd245;
	
	// Row 12
	// (2,12) --> (6,12)
	parameter [9:0] wall_167_V2 = 10'd035;
	parameter [9:0] wall_167_H2 = 10'd255;
	
	// (8,12) --> (12,12)
	parameter [9:0] wall_168_V2 = 10'd095;
	parameter [9:0] wall_168_H2 = 10'd255;
	
	// (14,12) --> (18,12)
	parameter [9:0] wall_169_V2 = 10'd155;
	parameter [9:0] wall_169_H2 = 10'd255;
	
	// (20,12) --> (22,12)
	parameter [9:0] wall_170_V2 = 10'd215;
	parameter [9:0] wall_170_H2 = 10'd255;
	
	// (24,12)
	parameter [9:0] wall_171_V2 = 10'd255;
	parameter [9:0] wall_171_H2 = 10'd255;
	
	// (26,12)
	parameter [9:0] wall_172_V2 = 10'd275;
	parameter [9:0] wall_172_H2 = 10'd255;
	
	// (28,12)
	parameter [9:0] wall_173_V2 = 10'd295;
	parameter [9:0] wall_173_H2 = 10'd255;
	
	// (30,12) --> (38,12)
	parameter [9:0] wall_174_V2 = 10'd315;
	parameter [9:0] wall_174_H2 = 10'd255;
	
	// (40,12)
	parameter [9:0] wall_175_V2 = 10'd415;
	parameter [9:0] wall_175_H2 = 10'd255;
	
	// (42,12)
	parameter [9:0] wall_176_V2 = 10'd435;
	parameter [9:0] wall_176_H2 = 10'd255;
	
	// (44,12) --> (46,12)
	parameter [9:0] wall_177_V2 = 10'd455;
	parameter [9:0] wall_177_H2 = 10'd255;
	
	// (48,12) --> (50,12)
	parameter [9:0] wall_178_V2 = 10'd495;
	parameter [9:0] wall_178_H2 = 10'd255;
	
	// (52,12) --> (54,12)
	parameter [9:0] wall_179_V2 = 10'd535;
	parameter [9:0] wall_179_H2 = 10'd255;
	
	// (56,12) --> (58,12)
	parameter [9:0] wall_180_V2 = 10'd575;
	parameter [9:0] wall_180_H2 = 10'd255;
	
	// (60,12)
	parameter [9:0] wall_181_V2 = 10'd615;
	parameter [9:0] wall_181_H2 = 10'd255;
	
	//Row 13
	// (6,13)
	parameter [9:0] wall_182_V2 = 10'd075;
	parameter [9:0] wall_182_H2 = 10'd265;
	
	// (14,13)
	parameter [9:0] wall_183_V2 = 10'd155;
	parameter [9:0] wall_183_H2 = 10'd265;
	
	// (24,13)
	parameter [9:0] wall_184_V2 = 10'd255;
	parameter [9:0] wall_184_H2 = 10'd265;
	
	// (26,13)
	parameter [9:0] wall_185_V2 = 10'd275;
	parameter [9:0] wall_185_H2 = 10'd265;
	
	// (28,13)
	parameter [9:0] wall_186_V2 = 10'd295;
	parameter [9:0] wall_186_H2 = 10'd265;
	
	// (38,13)
	parameter [9:0] wall_187_V2 = 10'd395;
	parameter [9:0] wall_187_H2 = 10'd265;
	
	// (42,13)
	parameter [9:0] wall_188_V2 = 10'd435;
	parameter [9:0] wall_188_H2 = 10'd265;
	
	// (48,13)
	parameter [9:0] wall_189_V2 = 10'd495;
	parameter [9:0] wall_189_H2 = 10'd265;
	
	// (54,13)
	parameter [9:0] wall_190_V2 = 10'd555;
	parameter [9:0] wall_190_H2 = 10'd265;
	
	// (58,13)
	parameter [9:0] wall_191_V2 = 10'd595;
	parameter [9:0] wall_191_H2 = 10'd265;
	
	// (60,13)
	parameter [9:0] wall_192_V2 = 10'd615;
	parameter [9:0] wall_192_H2 = 10'd265;

	// Row 14
	// (2,14) --> (4,14)
	parameter [9:0] wall_193_V2 = 10'd035;
	parameter [9:0] wall_193_H2 = 10'd275;
	
	// (6,14) --> (8,14)
	parameter [9:0] wall_194_V2 = 10'd075;
	parameter [9:0] wall_194_H2 = 10'd275;
	
	// (10,14) --> (14,14)
	parameter [9:0] wall_195_V2 = 10'd115;
	parameter [9:0] wall_195_H2 = 10'd275;
	
	// (16,14) --> (20,14)
	parameter [9:0] wall_196_V2 = 10'd175;
	parameter [9:0] wall_196_H2 = 10'd275;

	// (22,14)
	parameter [9:0] wall_197_V2 = 10'd235;
	parameter [9:0] wall_197_H2 = 10'd275;
	
	// (24,14) --> (26,14)
	parameter [9:0] wall_198_V2 = 10'd245;
	parameter [9:0] wall_198_H2 = 10'd275;
	
	// (28,14) --> (30,14)
	parameter [9:0] wall_199_V2 = 10'd295;
	parameter [9:0] wall_199_H2 = 10'd275;
	
	// (32,14) --> (36,14)
	parameter [9:0] wall_200_V2 = 10'd335;
	parameter [9:0] wall_200_H2 = 10'd275;
	
	// (38,14) --> (43,14)
	parameter [9:0] wall_201_V2 = 10'd395;
	parameter [9:0] wall_201_H2 = 10'd275;
	
	// (45,14) --> (48,14)
	parameter [9:0] wall_202_V2 = 10'd465;
	parameter [9:0] wall_202_H2 = 10'd275;
	
	// (50,14) --> (52,14)
	parameter [9:0] wall_203_V2 = 10'd515;
	parameter [9:0] wall_203_H2 = 10'd275;
	
	// (54,14) --> (56,14)
	parameter [9:0] wall_204_V2 = 10'd555;
	parameter [9:0] wall_204_H2 = 10'd275;
	
	// (58, 14)
	parameter [9:0] wall_205_V2 = 10'd595;
	parameter [9:0] wall_205_H2 = 10'd275;
	
	// (60,14)
	parameter [9:0] wall_206_V2 = 10'd615;
	parameter [9:0] wall_206_H2 = 10'd275;
	
	// Row 15
	// (4,15)
	parameter [9:0] wall_207_V2 = 10'd055;
	parameter [9:0] wall_207_H2 = 10'd285;
	
	// (10,15)
	parameter [9:0] wall_208_V2 = 10'd115;
	parameter [9:0] wall_208_H2 = 10'd285;
	
	// (16,15)
	parameter [9:0] wall_209_V2 = 10'd175;
	parameter [9:0] wall_209_H2 = 10'd285;
	
	// (20,15)
	parameter [9:0] wall_210_V2 = 10'd215;
	parameter [9:0] wall_210_H2 = 10'd285;
	
	// (22,15)
	parameter [9:0] wall_211_V2 = 10'd235;
	parameter [9:0] wall_211_H2 = 10'd285;
	
	// (32,15)
	parameter [9:0] wall_212_V2 = 10'd335;
	parameter [9:0] wall_212_H2 = 10'd285;
	
	// (34,15)
	parameter [9:0] wall_213_V2 = 10'd355;
	parameter [9:0] wall_213_H2 = 10'd285;
	
	// (36,15)
	parameter [9:0] wall_214_V2 = 10'd375;
	parameter [9:0] wall_214_H2 = 10'd285;
	
	// (40,15)
	parameter [9:0] wall_215_V2 = 10'd415;
	parameter [9:0] wall_215_H2 = 10'd285;
	
	// (46,15)
	parameter [9:0] wall_216_V2 = 10'd475;
	parameter [9:0] wall_216_H2 = 10'd285;
	
	// (50,15)
	parameter [9:0] wall_217_V2 = 10'd515;
	parameter [9:0] wall_217_H2 = 10'd285;
	
	// (56,15)
	parameter [9:0] wall_218_V2 = 10'd575;
	parameter [9:0] wall_218_H2 = 10'd285;
	
	// (58,15)
	parameter [9:0] wall_219_V2 = 10'd595;
	parameter [9:0] wall_219_H2 = 10'd285;
	
	// (60,15)
	parameter [9:0] wall_220_V2 = 10'd615;
	parameter [9:0] wall_220_H2 = 10'd285;
	
	//Row 16
	
	// (2,16)
	parameter [9:0] wall_221_V2 = 10'd035;
	parameter [9:0] wall_221_H2 = 10'd295;
	
	// (4,16) --> (6,16)
	parameter [9:0] wall_222_V2 = 10'd055;
	parameter [9:0] wall_222_H2 = 10'd295;
	
	// (8,16) --> (10,16)
	parameter [9:0] wall_223_V2 = 10'd095;
	parameter [9:0] wall_223_H2 = 10'd295;
	
	// (12,16) --> (14,16)
	parameter [9:0] wall_224_V2 = 10'd135;
	parameter [9:0] wall_224_H2 = 10'd295;
	
	// (16,16) --> (18, 16)
	parameter [9:0] wall_225_V2 = 10'd175;
	parameter [9:0] wall_225_H2 = 10'd295;
	
	// (20,16)
	parameter [9:0] wall_226_V2 = 10'd215;
	parameter [9:0] wall_226_H2 = 10'd295;
	
	// (22,16) --> (24,16)
	parameter [9:0] wall_227_V2 = 10'd235;
	parameter [9:0] wall_227_H2 = 10'd295;
	
	// (26,16) --> (29,16)
	parameter [9:0] wall_228_V2 = 10'd275;
	parameter [9:0] wall_228_H2 = 10'd295;
	
	// (31,16) --> (32, 16)
	parameter [9:0] wall_229_V2 = 10'd325;
	parameter [9:0] wall_229_H2 = 10'd295;
	
	// (34,16)
	parameter [9:0] wall_230_V2 = 10'd355;
	parameter [9:0] wall_230_H2 = 10'd295;
	
	// (36,16) --> (38,16)
	parameter [9:0] wall_231_V2 = 10'd375;
	parameter [9:0] wall_231_H2 = 10'd295;
	
	// (40,16)
	parameter [9:0] wall_232_V2 = 10'd415;
	parameter [9:0] wall_232_H2 = 10'd295;
	
	// (42,16) --> (44,16)
	parameter [9:0] wall_233_V2 = 10'd435;
	parameter [9:0] wall_233_H2 = 10'd295;
	
	// (46,16)
	parameter [9:0] wall_234_V2 = 10'd475;
	parameter [9:0] wall_234_H2 = 10'd295;
	
	// (48,16) --> (50, 16)
	parameter [9:0] wall_235_V2 = 10'd495;
	parameter [9:0] wall_235_H2 = 10'd295;
	
	// (52,16) --> (54, 16)
	parameter [9:0] wall_236_V2 = 10'd535;
	parameter [9:0] wall_236_H2 = 10'd295;
	
	// (56,16) --> (58,16)
	parameter [9:0] wall_237_V2 = 10'd575;
	parameter [9:0] wall_237_H2 = 10'd295;
	
	// (60,16)
	parameter [9:0] wall_238_V2 = 10'd615;
	parameter [9:0] wall_238_H2 = 10'd295;
	
	// Row 17
	
	// (2,17)
	parameter [9:0] wall_239_V2 = 10'd035;
	parameter [9:0] wall_239_H2 = 10'd305;
	
	// (6,17)
	parameter [9:0] wall_240_V2 = 10'd075;
	parameter [9:0] wall_240_H2 = 10'd305;
	
	// (10,17)
	parameter [9:0] wall_241_V2 = 10'd115;
	parameter [9:0] wall_241_H2 = 10'd305;
	
	// (18,17)
	parameter [9:0] wall_242_V2 = 10'd195;
	parameter [9:0] wall_242_H2 = 10'd305;
	
	// (26,17)
	parameter [9:0] wall_243_V2 = 10'd275;
	parameter [9:0] wall_243_H2 = 10'd305;
	
	// (34,17)
	parameter [9:0] wall_244_V2 = 10'd355;
	parameter [9:0] wall_244_H2 = 10'd305;
	
	// (38,17)
	parameter [9:0] wall_245_V2 = 10'd395;
	parameter [9:0] wall_245_H2 = 10'd305;
	
	// (42,17)
	parameter [9:0] wall_246_V2 = 10'd435;
	parameter [9:0] wall_246_H2 = 10'd305;
	
	// (44,17)
	parameter [9:0] wall_247_V2 = 10'd455;
	parameter [9:0] wall_247_H2 = 10'd305;
	
	// (46,17)
	parameter [9:0] wall_248_V2 = 10'd475;
	parameter [9:0] wall_248_H2 = 10'd305;
	
	// (48,17)
	parameter [9:0] wall_249_V2 = 10'd495;
	parameter [9:0] wall_249_H2 = 10'd305;
	
	// (54,17)
	parameter [9:0] wall_250_V2 = 10'd555;
	parameter [9:0] wall_250_H2 = 10'd305;
	
	// (58,17)
	parameter [9:0] wall_251_V2 = 10'd595;
	parameter [9:0] wall_251_H2 = 10'd305;
	
	// (60,17)
	parameter [9:0] wall_252_V2 = 10'd615;
	parameter [9:0] wall_252_H2 = 10'd305;
	
	// Row 18
	
	// (2,18)
	parameter [9:0] wall_253_V2 = 10'd035;
	parameter [9:0] wall_253_H2 = 10'd315;
	
	// (4,18) --> (6,18)
	parameter [9:0] wall_254_V2 = 10'd055;
	parameter [9:0] wall_254_H2 = 10'd315;
	
	// (8,18)
	parameter [9:0] wall_255_V2 = 10'd095;
	parameter [9:0] wall_255_H2 = 10'd315;
	
	// (10,18) --> (13,18)
	parameter [9:0] wall_256_V2 = 10'd115;
	parameter [9:0] wall_256_H2 = 10'd315;
	
	// (15,18) --> (16,18)
	parameter [9:0] wall_257_V2 = 10'd165;
	parameter [9:0] wall_257_H2 = 10'd315;
	
	// (18,18) --> (26,18)
	parameter [9:0] wall_258_V2 = 10'd195;
	parameter [9:0] wall_258_H2 = 10'd315;
	
	// (28,18) --> (32,18)
	parameter [9:0] wall_259_V2 = 10'd295;
	parameter [9:0] wall_259_H2 = 10'd315;
	
	// (34,18) --> (36,18)
	parameter [9:0] wall_260_V2 = 10'd355;
	parameter [9:0] wall_260_H2 = 10'd315;
	
	// (38,18)
	parameter [9:0] wall_261_V2 = 10'd395;
	parameter [9:0] wall_261_H2 = 10'd315;
	
	// (40,18) --> (42,18)
	parameter [9:0] wall_262_V2 = 10'd415;
	parameter [9:0] wall_262_H2 = 10'd315;
	
	// (44,18)
	parameter [9:0] wall_263_V2 = 10'd455;
	parameter [9:0] wall_263_H2 = 10'd315;
	
	// (46,18)
	parameter [9:0] wall_264_V2 = 10'd475;
	parameter [9:0] wall_264_H2 = 10'd315;
	
	// (48,18)
	parameter [9:0] wall_265_V2 = 10'd495;
	parameter [9:0] wall_265_H2 = 10'd315;
	
	// (50,18)
	parameter [9:0] wall_266_V2 = 10'd515;
	parameter [9:0] wall_266_H2 = 10'd315;
	
	// (52,18) -- > (56,18)
	parameter [9:0] wall_267_V2 = 10'd535;
	parameter [9:0] wall_267_H2 = 10'd315;
	
	// (58,18)
	parameter [9:0] wall_268_V2 = 10'd595;
	parameter [9:0] wall_268_H2 = 10'd315;
	
	// Row 19
	
	// (2,19)
	parameter [9:0] wall_269_V2 = 10'd035;
	parameter [9:0] wall_269_H2 = 10'd325;
	
	// (8,19)
	parameter [9:0] wall_270_V2 = 10'd095;
	parameter [9:0] wall_270_H2 = 10'd325;
	
	// (12,19)
	parameter [9:0] wall_271_V2 = 10'd135;
	parameter [9:0] wall_271_H2 = 10'd325;
	
	// (18,19)
	parameter [9:0] wall_272_V2 = 10'd195;
	parameter [9:0] wall_272_H2 = 10'd325;
	
	// (26,19)
	parameter [9:0] wall_273_V2 = 10'd275;
	parameter [9:0] wall_273_H2 = 10'd325;
	
	// (30,19)
	parameter [9:0] wall_274_V2 = 10'd315;
	parameter [9:0] wall_274_H2 = 10'd325;
	
	// (38,19)
	parameter [9:0] wall_275_V2 = 10'd395;
	parameter [9:0] wall_275_H2 = 10'd325;
	
	// (44,19)
	parameter [9:0] wall_276_V2 = 10'd455;
	parameter [9:0] wall_276_H2 = 10'd325;
	
	// (48,19)
	parameter [9:0] wall_277_V2 = 10'd495;
	parameter [9:0] wall_277_H2 = 10'd325;
	
	// (50,19)
	parameter [9:0] wall_278_V2 = 10'd515;
	parameter [9:0] wall_278_H2 = 10'd325;
	
	// (52,19)
	parameter [9:0] wall_279_V2 = 10'd535;
	parameter [9:0] wall_279_H2 = 10'd325;
	
	// (56,19)
	parameter [9:0] wall_280_V2 = 10'd575;
	parameter [9:0] wall_280_H2 = 10'd325;
	
	// (58,19)
	parameter [9:0] wall_281_V2 = 10'd595;
	parameter [9:0] wall_281_H2 = 10'd325;
	
	// Row 20
	// (2,20) --> (5,20)
	parameter [9:0] wall_282_V2 = 10'd035;
	parameter [9:0] wall_282_H2 = 10'd335;
	
	// (7,20) --> (8,20)
	parameter [9:0] wall_283_V2 = 10'd085;
	parameter [9:0] wall_283_H2 = 10'd335;
	
	// (10,20)
	parameter [9:0] wall_284_V2 = 10'd115;
	parameter [9:0] wall_284_H2 = 10'd335;
	
	// (12,20)
	parameter [9:0] wall_285_V2 = 10'd135;
	parameter [9:0] wall_285_H2 = 10'd335;
	
	// (14,20)
	parameter [9:0] wall_286_V2 = 10'd155;
	parameter [9:0] wall_286_H2 = 10'd335;
	
	// (15,20) --> (18,20)
	parameter [9:0] wall_287_V2 = 10'd165;
	parameter [9:0] wall_287_H2 = 10'd335;
	
	// (20,20) --> (24,20)
	parameter [9:0] wall_288_V2 = 10'd215;
	parameter [9:0] wall_288_H2 = 10'd335;
	
	// (26,20) --> (28, 20)
	parameter [9:0] wall_289_V2 = 10'd275;
	parameter [9:0] wall_289_H2 = 10'd335;
	
	// (30,20)
	parameter [9:0] wall_290_V2 = 10'd315;
	parameter [9:0] wall_290_H2 = 10'd335;
	
	// (32,20) --> (35, 20)
	parameter [9:0] wall_291_V2 = 10'd335;
	parameter [9:0] wall_291_H2 = 10'd335;
	
	// (37,20) --> (38,20)
	parameter [9:0] wall_292_V2 = 10'd385;
	parameter [9:0] wall_292_H2 = 10'd335;
	
	// (40,20) --> (42, 20)
	parameter [9:0] wall_293_V2 = 10'd415;
	parameter [9:0] wall_293_H2 = 10'd335;
	
	// (47,20) --> (48, 20)
	parameter [9:0] wall_294_V2 = 10'd485;
	parameter [9:0] wall_294_H2 = 10'd335;
	
	// (50,20) --> (52,20)
	parameter [9:0] wall_295_V2 = 10'd515;
	parameter [9:0] wall_295_H2 = 10'd335;
	
	// (54,20)
	parameter [9:0] wall_296_V2 = 10'd555;
	parameter [9:0] wall_296_H2 = 10'd335;
	
	// (56,20)
	parameter [9:0] wall_297_V2 = 10'd575;
	parameter [9:0] wall_297_H2 = 10'd335;
	
	// (58,20)
	parameter [9:0] wall_298_V2 = 10'd595;
	parameter [9:0] wall_298_H2 = 10'd335;
	
	// Row 21
	
	// (10,21)
	parameter [9:0] wall_299_V2 = 10'd115;
	parameter [9:0] wall_299_H2 = 10'd345;
	
	// (12,21)
	parameter [9:0] wall_300_V2 = 10'd135;
	parameter [9:0] wall_300_H2 = 10'd345;
	
	// (24,21)
	parameter [9:0] wall_301_V2 = 10'd255;
	parameter [9:0] wall_301_H2 = 10'd345;
	
	// (30,21)
	parameter [9:0] wall_302_V2 = 10'd315;
	parameter [9:0] wall_302_H2 = 10'd345;
	
	// (42,21)
	parameter [9:0] wall_303_V2 = 10'd435;
	parameter [9:0] wall_303_H2 = 10'd345;

	// (54,21)
	parameter [9:0] wall_304_V2 = 10'd555;
	parameter [9:0] wall_304_H2 = 10'd345;
	// (56,21)
	parameter [9:0] wall_305_V2 = 10'd575;
	parameter [9:0] wall_305_H2 = 10'd345;
	
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
			end
		// Right Wall
		else if(DrawX >= right_wall_idx3 && DrawX <= right_wall_idx3 + wall_thickness3
					&& DrawY >= top_wall_idx3 - wall_thickness3 && DrawY <= bottom_wall_idx3)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Top Wall
		else if(DrawX >= left_wall_idx3 && DrawX <= right_wall_idx3 + wall_thickness3
					&& DrawY >= top_wall_idx3 - wall_thickness3 && DrawY <= top_wall_idx3)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Bottom Wall
		else if(DrawX >= left_wall_idx3 && DrawX <= right_wall_idx3 + wall_thickness3
					&& DrawY >= bottom_wall_idx3 - wall_thickness3 && DrawY <= bottom_wall_idx3)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Goal Cell
		else if(DrawX >= maze3_goalV && DrawX <= maze3_goalV + wall_thickness3
					&& DrawY >= maze3_goalH - wall_thickness3 && DrawY <= maze3_goalH)
			begin
				is_maze = 1'b0;
				is_goal = 1'b1;
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
			end
	
	end // for inner if statement
	
	else if(maze3out == 1'b1)
	begin
	
	// Left Wall
		if(DrawX >= left_wall_idx2 && DrawX <= left_wall_idx2 + wall_thickness2
			&& DrawY >= top_wall_idx2 - wall_thickness2 && DrawY <= bottom_wall_idx2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Right Wall
		else if(DrawX >= right_wall_idx2 && DrawX <= right_wall_idx2 + wall_thickness2
					&& DrawY >= top_wall_idx2 - wall_thickness2 && DrawY <= bottom_wall_idx2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Top Wall
		else if(DrawX >= left_wall_idx2 && DrawX <= right_wall_idx2 + wall_thickness2
					&& DrawY >= top_wall_idx2 - wall_thickness2 && DrawY <= top_wall_idx2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Bottom Wall
		else if(DrawX >= left_wall_idx2 && DrawX <= right_wall_idx2 + wall_thickness2
					&& DrawY >= bottom_wall_idx2 - wall_thickness2 && DrawY <= bottom_wall_idx2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 1 (0,2) --> (2,2)
		else if(DrawX >= wall_1_V2 && DrawX <= 10'd035 + wall_thickness2
					&& DrawY >= wall_1_H2 - wall_thickness2 && DrawY <= wall_1_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 2 (4,2) --> (6,2)
		else if(DrawX >= wall_2_V2 && DrawX <= 10'd075 + wall_thickness2
					&& DrawY >= wall_2_H2 - wall_thickness2 && DrawY <= wall_2_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 3 (10,2) --> (14,2)
		else if(DrawX >= wall_3_V2 && DrawX <= 10'd155 + wall_thickness2
					&& DrawY >= wall_3_H2 - wall_thickness2 && DrawY <= wall_3_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 4 (16,2) --> (20,2)
		else if(DrawX >= wall_4_V2 && DrawX <= 10'd215 + wall_thickness2
					&& DrawY >= wall_4_H2 - wall_thickness2 && DrawY <= wall_4_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 5 (22,2) --> (26,2)
		else if(DrawX >= wall_5_V2 && DrawX <= 10'd275 + wall_thickness2
					&& DrawY >= wall_5_H2 - wall_thickness2 && DrawY <= wall_5_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 6 (28,2) --> (30,2)
		else if(DrawX >= wall_6_V2 && DrawX <= 10'd315 + wall_thickness2
					&& DrawY >= wall_6_H2 - wall_thickness2 && DrawY <= wall_6_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 7 (32,2) --> (38,2)
		else if(DrawX >= wall_7_V2 && DrawX <= 10'd395 + wall_thickness2
					&& DrawY >= wall_7_H2 - wall_thickness2 && DrawY <= wall_7_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 8 (40,2)
		else if(DrawX >= wall_8_V2 && DrawX <= wall_8_V2 + wall_thickness2
					&& DrawY >= wall_8_H2 - wall_thickness2 && DrawY <= wall_8_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 9 (42,2) --> (44,2)
		else if(DrawX >= wall_9_V2 && DrawX <= 10'd455 + wall_thickness2
					&& DrawY >= wall_9_H2 - wall_thickness2 && DrawY <= wall_9_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 10 (46,2)
		else if(DrawX >= wall_10_V2 && DrawX <= wall_10_V2 + wall_thickness2
					&& DrawY >= wall_10_H2 - wall_thickness2 && DrawY <= wall_10_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 11 (48,2) --> (54,2)
		else if(DrawX >= wall_11_V2 && DrawX <= 10'd555 + wall_thickness2
					&& DrawY >= wall_11_H2 - wall_thickness2 && DrawY <= wall_11_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 12 (56,2)
		else if(DrawX >= wall_12_V2 && DrawX <= wall_12_V2 + wall_thickness2
					&& DrawY >= wall_12_H2 - wall_thickness2 && DrawY <= wall_12_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 13 (58,2) --> (60,2)
		else if(DrawX >= wall_13_V2 && DrawX <= 10'd615 + wall_thickness2
					&& DrawY >= wall_13_H2 - wall_thickness2 && DrawY <= wall_13_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 14 (8,2)
		else if(DrawX >= wall_14_V2 && DrawX <= wall_14_V2 + wall_thickness2
					&& DrawY >= wall_14_H2 - wall_thickness2 && DrawY <= wall_14_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 15 (6,1)
		else if(DrawX >= wall_15_V2 && DrawX <= wall_15_V2 + wall_thickness2
					&& DrawY >= wall_15_H2 - wall_thickness2 && DrawY <= wall_15_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 16 (14,1)
		else if(DrawX >= wall_16_V2 && DrawX <= wall_16_V2 + wall_thickness2
					&& DrawY >= wall_16_H2 - wall_thickness2 && DrawY <= wall_16_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 17 (28,1)
		else if(DrawX >= wall_17_V2 && DrawX <= wall_17_V2 + wall_thickness2
					&& DrawY >= wall_17_H2 - wall_thickness2 && DrawY <= wall_17_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 18 (38,1)
		else if(DrawX >= wall_18_V2 && DrawX <= wall_18_V2 + wall_thickness2
					&& DrawY >= wall_18_H2 - wall_thickness2 && DrawY <= wall_18_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 19 (44,1)
		else if(DrawX >= wall_19_V2 && DrawX <= wall_19_V2 + wall_thickness2
					&& DrawY >= wall_19_H2 - wall_thickness2 && DrawY <= wall_19_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 20 (56,1)
		else if(DrawX >= wall_20_V2 && DrawX <= wall_20_V2 + wall_thickness2
					&& DrawY >= wall_20_H2 - wall_thickness2 && DrawY <= wall_20_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 21 (60,1)
		else if(DrawX >= wall_21_V2 && DrawX <= wall_21_V2 + wall_thickness2
					&& DrawY >= wall_21_H2 - wall_thickness2 && DrawY <= wall_21_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 22 (4,3)
		else if(DrawX >= wall_22_V2 && DrawX <= wall_22_V2 + wall_thickness2
					&& DrawY >= wall_22_H2 - wall_thickness2 && DrawY <= wall_22_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 23 (14,3)
		else if(DrawX >= wall_23_V2 && DrawX <= wall_23_V2 + wall_thickness2
					&& DrawY >= wall_23_H2 - wall_thickness2 && DrawY <= wall_23_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 24 (18,3)
		else if(DrawX >= wall_24_V2 && DrawX <= wall_24_V2 + wall_thickness2
					&& DrawY >= wall_24_H2 - wall_thickness2 && DrawY <= wall_24_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 25 (20,3)
		else if(DrawX >= wall_25_V2 && DrawX <= wall_25_V2 + wall_thickness2
					&& DrawY >= wall_25_H2 - wall_thickness2 && DrawY <= wall_25_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 26 (26,3)
		else if(DrawX >= wall_26_V2 && DrawX <= wall_26_V2 + wall_thickness2
					&& DrawY >= wall_26_H2 - wall_thickness2 && DrawY <= wall_26_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 27 (30,3)
		else if(DrawX >= wall_27_V2 && DrawX <= wall_27_V2 + wall_thickness2
					&& DrawY >= wall_27_H2 - wall_thickness2 && DrawY <= wall_27_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 28 (40,3)
		else if(DrawX >= wall_28_V2 && DrawX <= wall_28_V2 + wall_thickness2
					&& DrawY >= wall_28_H2 - wall_thickness2 && DrawY <= wall_28_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 29 (44,3)
		else if(DrawX >= wall_29_V2 && DrawX <= wall_29_V2 + wall_thickness2
					&& DrawY >= wall_29_H2 - wall_thickness2 && DrawY <= wall_29_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 30 (46,3)
		else if(DrawX >= wall_30_V2 && DrawX <= wall_30_V2 + wall_thickness2
					&& DrawY >= wall_30_H2 - wall_thickness2 && DrawY <= wall_30_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 31 (52,3)
		else if(DrawX >= wall_31_V2 && DrawX <= wall_31_V2 + wall_thickness2
					&& DrawY >= wall_31_H2 - wall_thickness2 && DrawY <= wall_31_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 32 (54,3)
		else if(DrawX >= wall_32_V2 && DrawX <= wall_32_V2 + wall_thickness2
					&& DrawY >= wall_32_H2 - wall_thickness2 && DrawY <= wall_32_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 33 (56,3)
		else if(DrawX >= wall_33_V2 && DrawX <= wall_33_V2 + wall_thickness2
					&& DrawY >= wall_33_H2 - wall_thickness2 && DrawY <= wall_33_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 34 (60,3)
		else if(DrawX >= wall_34_V2 && DrawX <= wall_34_V2 + wall_thickness2
					&& DrawY >= wall_34_H2 - wall_thickness2 && DrawY <= wall_34_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		/*
		// Wall 35 (2,4) --> (4,4)
		else if(DrawX >= wall_35_V2 && DrawX <= 10'd055 + wall_thickness2
					&& DrawY >= wall_35_H2 - wall_thickness2 && DrawY <= wall_35_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 36 (6,4) --> (8,4)
		else if(DrawX >= wall_36_V2 && DrawX <= 10'd095 + wall_thickness2
					&& DrawY >= wall_36_H2 - wall_thickness2 && DrawY <= wall_36_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 37 (10,4) --> (12,4)
		else if(DrawX >= wall_37_V2 && DrawX <= 10'd135 + wall_thickness2
					&& DrawY >= wall_37_H2 - wall_thickness2 && DrawY <= wall_37_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 38 (14,4) --> (16,4)
		else if(DrawX >= wall_38_V2 && DrawX <= 10'd175 + wall_thickness2
					&& DrawY >= wall_38_H2 - wall_thickness2 && DrawY <= wall_38_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 39 (18,4)
		else if(DrawX >= wall_39_V2 && DrawX <= wall_39_V2 + wall_thickness2
					&& DrawY >= wall_39_H2 - wall_thickness2 && DrawY <= wall_39_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 40 (20,4) --> (22,4)
		else if(DrawX >= wall_40_V2 && DrawX <= 10'd235 + wall_thickness2
					&& DrawY >= wall_40_H2 - wall_thickness2 && DrawY <= wall_40_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 41 (24,4)
		else if(DrawX >= wall_41_V2 && DrawX <= wall_41_V2 + wall_thickness2
					&& DrawY >= wall_41_H2 - wall_thickness2 && DrawY <= wall_41_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 42 (26,4) --> (28,4)
		else if(DrawX >= wall_42_V2 && DrawX <= 10'd295 + wall_thickness2
					&& DrawY >= wall_42_H2 - wall_thickness2 && DrawY <= wall_42_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 43 (30,4)
		else if(DrawX >= wall_43_V2 && DrawX <= wall_43_V2 + wall_thickness2
					&& DrawY >= wall_43_H2 - wall_thickness2 && DrawY <= wall_43_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 44 (32,4) --> (37,4)
		else if(DrawX >= wall_44_V2 && DrawX <= 10'd385 + wall_thickness2
					&& DrawY >= wall_44_H2 - wall_thickness2 && DrawY <= wall_44_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 45 (39,4) --> (42,4)
		else if(DrawX >= wall_45_V2 && DrawX <= 10'd435 + wall_thickness2
					&& DrawY >= wall_45_H2 - wall_thickness2 && DrawY <= wall_45_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 46 (44,4)
		else if(DrawX >= wall_46_V2 && DrawX <= wall_46_V2 + wall_thickness2
					&& DrawY >= wall_46_H2 - wall_thickness2 && DrawY <= wall_46_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 47 (46,4) --> (50,4)
		else if(DrawX >= wall_47_V2 && DrawX <= 10'd515 + wall_thickness2
					&& DrawY >= wall_47_H2 - wall_thickness2 && DrawY <= wall_47_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 48 (52, 4)
		else if(DrawX >= wall_48_V2 && DrawX <= wall_48_V2 + wall_thickness2
					&& DrawY >= wall_48_H2 - wall_thickness2 && DrawY <= wall_48_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 49 (54,4)
		else if(DrawX >= wall_49_V2 && DrawX <= wall_49_V2 + wall_thickness2
					&& DrawY >= wall_49_H2 - wall_thickness2 && DrawY <= wall_49_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 50 (56,4) --> (58,4)
		else if(DrawX >= wall_50_V2 && DrawX <= 10'd595 + wall_thickness2
					&& DrawY >= wall_50_H2 - wall_thickness2 && DrawY <= wall_50_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 51 (60,4)
		else if(DrawX >= wall_51_V2 && DrawX <= wall_51_V2 + wall_thickness2
					&& DrawY >= wall_51_H2 - wall_thickness2 && DrawY <= wall_51_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		*/
		// Wall 52 (2,5)
		else if(DrawX >= wall_52_V2 && DrawX <= wall_52_V2 + wall_thickness2
					&& DrawY >= wall_52_H2 - wall_thickness2 && DrawY <= wall_52_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 53 (6,5)
		else if(DrawX >= wall_53_V2 && DrawX <= wall_53_V2 + wall_thickness2
					&& DrawY >= wall_53_H2 - wall_thickness2 && DrawY <= wall_53_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 54 (8,5)
		else if(DrawX >= wall_54_V2 && DrawX <= wall_54_V2 + wall_thickness2
					&& DrawY >= wall_54_H2 - wall_thickness2 && DrawY <= wall_54_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 55 (12,5)
		else if(DrawX >= wall_55_V2 && DrawX <= wall_55_V2 + wall_thickness2
					&& DrawY >= wall_55_H2 - wall_thickness2 && DrawY <= wall_55_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 56 (14,5)
		else if(DrawX >= wall_56_V2 && DrawX <= wall_56_V2 + wall_thickness2
					&& DrawY >= wall_56_H2 - wall_thickness2 && DrawY <= wall_56_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 57 (18,5)
		else if(DrawX >= wall_57_V2 && DrawX <= wall_57_V2 + wall_thickness2
					&& DrawY >= wall_57_H2 - wall_thickness2 && DrawY <= wall_57_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 58 (22,5)
		else if(DrawX >= wall_58_V2 && DrawX <= wall_58_V2 + wall_thickness2
					&& DrawY >= wall_58_H2 - wall_thickness2 && DrawY <= wall_58_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 59 (24,5)
		else if(DrawX >= wall_59_V2 && DrawX <= wall_59_V2 + wall_thickness2
					&& DrawY >= wall_59_H2 - wall_thickness2 && DrawY <= wall_59_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 60 (42,5)
		else if(DrawX >= wall_60_V2 && DrawX <= wall_60_V2 + wall_thickness2
					&& DrawY >= wall_60_H2 - wall_thickness2 && DrawY <= wall_60_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 61 (44,5)
		else if(DrawX >= wall_61_V2 && DrawX <= wall_61_V2 + wall_thickness2
					&& DrawY >= wall_61_H2 - wall_thickness2 && DrawY <= wall_61_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 62 (48,5)
		else if(DrawX >= wall_62_V2 && DrawX <= wall_62_V2 + wall_thickness2
					&& DrawY >= wall_62_H2 - wall_thickness2 && DrawY <= wall_62_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 63 (50,5)
		else if(DrawX >= wall_63_V2 && DrawX <= wall_63_V2 + wall_thickness2
					&& DrawY >= wall_63_H2 - wall_thickness2 && DrawY <= wall_63_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 64 (52,5)
		else if(DrawX >= wall_64_V2 && DrawX <= wall_64_V2 + wall_thickness2
					&& DrawY >= wall_64_H2 - wall_thickness2 && DrawY <= wall_64_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 65 (60,5)
		else if(DrawX >= wall_65_V2 && DrawX <= wall_65_V2 + wall_thickness2
					&& DrawY >= wall_65_H2 - wall_thickness2 && DrawY <= wall_65_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 66 (4,6) -> (6,6)
		else if(DrawX >= wall_66_V2 && DrawX <= 10'd075 + wall_thickness2
					&& DrawY >= wall_66_H2 - wall_thickness2 && DrawY <= wall_66_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 67 (8,6)
		else if(DrawX >= wall_67_V2 && DrawX <= wall_67_V2 + wall_thickness2
					&& DrawY >= wall_67_H2 - wall_thickness2 && DrawY <= wall_67_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 68 (10,6)
		else if(DrawX >= wall_68_V2 && DrawX <= wall_68_V2 + wall_thickness2
					&& DrawY >= wall_68_H2 - wall_thickness2 && DrawY <= wall_68_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 69 (12,6)
		else if(DrawX >= wall_69_V2 && DrawX <= wall_69_V2 + wall_thickness2
					&& DrawY >= wall_69_H2 - wall_thickness2 && DrawY <= wall_69_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 70 (14,6)
		else if(DrawX >= wall_70_V2 && DrawX <= wall_70_V2 + wall_thickness2
					&& DrawY >= wall_70_H2 - wall_thickness2 && DrawY <= wall_70_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 71 (16,6)
		else if(DrawX >= wall_71_V2 && DrawX <= wall_71_V2 + wall_thickness2
					&& DrawY >= wall_71_H2 - wall_thickness2 && DrawY <= wall_71_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 72 (18,6)
		else if(DrawX >= wall_72_V2 && DrawX <= wall_72_V2 + wall_thickness2
					&& DrawY >= wall_72_H2 - wall_thickness2 && DrawY <= wall_72_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 73 (20,6)
		else if(DrawX >= wall_73_V2 && DrawX <= wall_73_V2 + wall_thickness2
					&& DrawY >= wall_73_H2 - wall_thickness2 && DrawY <= wall_73_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 74 (22,6)
		else if(DrawX >= wall_74_V2 && DrawX <= wall_74_V2 + wall_thickness2
					&& DrawY >= wall_74_H2 - wall_thickness2 && DrawY <= wall_74_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 75 (24,6) --> (26,6)
		else if(DrawX >= wall_75_V2 && DrawX <= 10'd275 + wall_thickness2
					&& DrawY >= wall_75_H2 - wall_thickness2 && DrawY <= wall_75_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 76 (28,6)
		else if(DrawX >= wall_76_V2 && DrawX <= wall_76_V2 + wall_thickness2
					&& DrawY >= wall_76_H2 - wall_thickness2 && DrawY <= wall_76_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 77 (30,6) --> (36,6)
		else if(DrawX >= wall_77_V2 && DrawX <= 10'd375 + wall_thickness2
					&& DrawY >= wall_77_H2 - wall_thickness2 && DrawY <= wall_77_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 78 (38,6) --> (40,6)
		else if(DrawX >= wall_78_V2 && DrawX <= 10'd415 + wall_thickness2
					&& DrawY >= wall_78_H2 - wall_thickness2 && DrawY <= wall_78_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 79 (42,6)
		else if(DrawX >= wall_79_V2 && DrawX <= wall_79_V2 + wall_thickness2
					&& DrawY >= wall_79_H2 - wall_thickness2 && DrawY <= wall_79_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 80 (44,6) --> (46,6)
		else if(DrawX >= wall_80_V2 && DrawX <= 10'd475 + wall_thickness2
					&& DrawY >= wall_80_H2 - wall_thickness2 && DrawY <= wall_80_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 81 (48,6)
		else if(DrawX >= wall_81_V2 && DrawX <= wall_81_V2 + wall_thickness2
					&& DrawY >= wall_81_H2 - wall_thickness2 && DrawY <= wall_81_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 82 (50,6)
		else if(DrawX >= wall_82_V2 && DrawX <= wall_82_V2 + wall_thickness2
					&& DrawY >= wall_82_H2 - wall_thickness2 && DrawY <= wall_82_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 83 (52,6) --> (58,6)
		else if(DrawX >= wall_83_V2 && DrawX <= 10'd595 + wall_thickness2
					&& DrawY >= wall_83_H2 - wall_thickness2 && DrawY <= wall_83_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 84 (60,6)
		else if(DrawX >= wall_84_V2 && DrawX <= wall_84_V2 + wall_thickness2
					&& DrawY >= wall_84_H2 - wall_thickness2 && DrawY <= wall_84_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 85 (2,7)
		else if(DrawX >= wall_85_V2 && DrawX <= wall_85_V2 + wall_thickness2
					&& DrawY >= wall_85_H2 - wall_thickness2 && DrawY <= wall_85_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 86 (6,7)
		else if(DrawX >= wall_86_V2 && DrawX <= wall_86_V2 + wall_thickness2
					&& DrawY >= wall_86_H2 - wall_thickness2 && DrawY <= wall_86_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 87 (10,6)
		else if(DrawX >= wall_87_V2 && DrawX <= wall_87_V2 + wall_thickness2
					&& DrawY >= wall_87_H2 - wall_thickness2 && DrawY <= wall_87_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 88 (12,7)
		else if(DrawX >= wall_88_V2 && DrawX <= wall_88_V2 + wall_thickness2
					&& DrawY >= wall_88_H2 - wall_thickness2 && DrawY <= wall_88_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 89 (16,7)
		else if(DrawX >= wall_89_V2 && DrawX <= wall_89_V2 + wall_thickness2
					&& DrawY >= wall_89_H2 - wall_thickness2 && DrawY <= wall_89_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 90 (20,7)
		else if(DrawX >= wall_90_V2 && DrawX <= wall_90_V2 + wall_thickness2
					&& DrawY >= wall_90_H2 - wall_thickness2 && DrawY <= wall_90_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 91 (22,7)
		else if(DrawX >= wall_91_V2 && DrawX <= wall_91_V2 + wall_thickness2
					&& DrawY >= wall_91_H2 - wall_thickness2 && DrawY <= wall_91_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 92 (26,7)
		else if(DrawX >= wall_92_V2 && DrawX <= wall_92_V2 + wall_thickness2
					&& DrawY >= wall_92_H2 - wall_thickness2 && DrawY <= wall_92_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 93 (28,7)
		else if(DrawX >= wall_93_V2 && DrawX <= wall_93_V2 + wall_thickness2
					&& DrawY >= wall_93_H2 - wall_thickness2 && DrawY <= wall_93_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 94 (34,7)
		else if(DrawX >= wall_94_V2 && DrawX <= wall_94_V2 + wall_thickness2
					&& DrawY >= wall_94_H2 - wall_thickness2 && DrawY <= wall_94_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 95 (38,7)
		else if(DrawX >= wall_95_V2 && DrawX <= wall_95_V2 + wall_thickness2
					&& DrawY >= wall_95_H2 - wall_thickness2 && DrawY <= wall_95_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 96 (42,7)
		else if(DrawX >= wall_96_V2 && DrawX <= wall_96_V2 + wall_thickness2
					&& DrawY >= wall_96_H2 - wall_thickness2 && DrawY <= wall_96_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 97 (48,7)
		else if(DrawX >= wall_97_V2 && DrawX <= wall_97_V2 + wall_thickness2
					&& DrawY >= wall_97_H2 - wall_thickness2 && DrawY <= wall_97_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 98 (50,7)
		else if(DrawX >= wall_98_V2 && DrawX <= wall_98_V2 + wall_thickness2
					&& DrawY >= wall_98_H2 - wall_thickness2 && DrawY <= wall_98_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 99 (54,7)
		else if(DrawX >= wall_99_V2 && DrawX <= wall_99_V2 + wall_thickness2
					&& DrawY >= wall_99_H2 - wall_thickness2 && DrawY <= wall_99_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 100 (58,7)
		else if(DrawX >= wall_100_V2 && DrawX <= wall_100_V2 + wall_thickness2
					&& DrawY >= wall_100_H2 - wall_thickness2 && DrawY <= wall_100_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 101 (60,7)
		else if(DrawX >= wall_101_V2 && DrawX <= wall_101_V2 + wall_thickness2
					&& DrawY >= wall_101_H2 - wall_thickness2 && DrawY <= wall_101_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 102 (2,8) --> (8,8)
		else if(DrawX >= wall_102_V2 && DrawX <= 10'd095 + wall_thickness2
					&& DrawY >= wall_102_H2 - wall_thickness2 && DrawY <= wall_102_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 103 (10,8)
		else if(DrawX >= wall_103_V2 && DrawX <= wall_103_V2 + wall_thickness2
					&& DrawY >= wall_103_H2 - wall_thickness2 && DrawY <= wall_103_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 104 (12,8)
		else if(DrawX >= wall_104_V2 && DrawX <= wall_104_V2 + wall_thickness2
					&& DrawY >= wall_104_H2 - wall_thickness2 && DrawY <= wall_104_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 105 (14,8) --> (16,8)
		else if(DrawX >= wall_105_V2 && DrawX <= 10'd175 + wall_thickness2
					&& DrawY >= wall_105_H2 - wall_thickness2 && DrawY <= wall_105_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 106 (18,8) --> (20,8)
		else if(DrawX >= wall_106_V2 && DrawX <= 10'd215 + wall_thickness2
					&& DrawY >= wall_106_H2 - wall_thickness2 && DrawY <= wall_106_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 107 (22,8) --> (24,8)
		else if(DrawX >= wall_107_V2 && DrawX <= 10'd255 + wall_thickness2
					&& DrawY >= wall_107_H2 - wall_thickness2 && DrawY <= wall_107_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 108 (26,8)
		else if(DrawX >= wall_108_V2 && DrawX <= wall_108_V2 + wall_thickness2
					&& DrawY >= wall_108_H2 - wall_thickness2 && DrawY <= wall_108_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 109 (28,8) --> (30,8)
		else if(DrawX >= wall_109_V2 && DrawX <= wall_109_V2 + wall_thickness2
					&& DrawY >= wall_109_H2 - wall_thickness2 && DrawY <= wall_109_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 110 (32,8) --> (34,8)
		else if(DrawX >= wall_110_V2 && DrawX <= 10'd355 + wall_thickness2
					&& DrawY >= wall_110_H2 - wall_thickness2 && DrawY <= wall_110_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 111 (36,8)
		else if(DrawX >= wall_111_V2 && DrawX <= wall_111_V2 + wall_thickness2
					&& DrawY >= wall_111_H2 - wall_thickness2 && DrawY <= wall_111_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 112 (38,8)
		else if(DrawX >= wall_112_V2 && DrawX <= wall_112_V2 + wall_thickness2
					&& DrawY >= wall_112_H2 - wall_thickness2 && DrawY <= wall_112_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 113 (40,8) --> (48,8)
		else if(DrawX >= wall_113_V2 && DrawX <= 10'd495 + wall_thickness2
					&& DrawY >= wall_113_H2 - wall_thickness2 && DrawY <= wall_113_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 114 (50,8) --> (52,8)
		else if(DrawX >= wall_114_V2 && DrawX <= 10'd535 + wall_thickness2
					&& DrawY >= wall_114_H2 - wall_thickness2 && DrawY <= wall_114_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 115 (54, 8)
		else if(DrawX >= wall_115_V2 && DrawX <= wall_115_V2 + wall_thickness2
					&& DrawY >= wall_115_H2 - wall_thickness2 && DrawY <= wall_115_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 116 (56,8)
		else if(DrawX >= wall_116_V2 && DrawX <= wall_116_V2 + wall_thickness2
					&& DrawY >= wall_116_H2 - wall_thickness2 && DrawY <= wall_116_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 117 (58,8)
		else if(DrawX >= wall_117_V2 && DrawX <= wall_117_V2 + wall_thickness2
					&& DrawY >= wall_117_H2 - wall_thickness2 && DrawY <= wall_117_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 118 (60,8)
		else if(DrawX >= wall_118_V2 && DrawX <= wall_118_V2 + wall_thickness2
					&& DrawY >= wall_118_H2 - wall_thickness2 && DrawY <= wall_118_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 119 (4,9)
		else if(DrawX >= wall_119_V2 && DrawX <= wall_119_V2 + wall_thickness2
					&& DrawY >= wall_119_H2 - wall_thickness2 && DrawY <= wall_119_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 120 (8,9)
		else if(DrawX >= wall_120_V2 && DrawX <= wall_120_V2 + wall_thickness2
					&& DrawY >= wall_120_H2 - wall_thickness2 && DrawY <= wall_120_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 121 (10,9)
		else if(DrawX >= wall_121_V2 && DrawX <= wall_121_V2 + wall_thickness2
					&& DrawY >= wall_121_H2 - wall_thickness2 && DrawY <= wall_121_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 122 (18,9)
		else if(DrawX >= wall_122_V2 && DrawX <= wall_122_V2 + wall_thickness2
					&& DrawY >= wall_122_H2 - wall_thickness2 && DrawY <= wall_122_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 123 (20,9)
		else if(DrawX >= wall_123_V2 && DrawX <= wall_123_V2 + wall_thickness2
					&& DrawY >= wall_123_H2 - wall_thickness2 && DrawY <= wall_123_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 124 (22,9)
		else if(DrawX >= wall_124_V2 && DrawX <= wall_124_V2 + wall_thickness2
					&& DrawY >= wall_124_H2 - wall_thickness2 && DrawY <= wall_124_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 125 (26,9)
		else if(DrawX >= wall_125_V2 && DrawX <= wall_125_V2 + wall_thickness2
					&& DrawY >= wall_125_H2 - wall_thickness2 && DrawY <= wall_125_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 126 (30,9)
		else if(DrawX >= wall_126_V2 && DrawX <= wall_126_V2 + wall_thickness2
					&& DrawY >= wall_126_H2 - wall_thickness2 && DrawY <= wall_126_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 127 (32,9)
		else if(DrawX >= wall_127_V2 && DrawX <= wall_127_V2 + wall_thickness2
					&& DrawY >= wall_127_H2 - wall_thickness2 && DrawY <= wall_127_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 128 (36,9)
		else if(DrawX >= wall_128_V2 && DrawX <= wall_128_V2 + wall_thickness2
					&& DrawY >= wall_128_H2 - wall_thickness2 && DrawY <= wall_128_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 129 (38, 9)
		else if(DrawX >= wall_129_V2 && DrawX <= wall_129_V2 + wall_thickness2
					&& DrawY >= wall_129_H2 - wall_thickness2 && DrawY <= wall_129_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 130 (40,9)
		else if(DrawX >= wall_130_V2 && DrawX <= wall_130_V2 + wall_thickness2
					&& DrawY >= wall_130_H2 - wall_thickness2 && DrawY <= wall_130_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 131 (46,9)
		else if(DrawX >= wall_131_V2 && DrawX <= wall_131_V2 + wall_thickness2
					&& DrawY >= wall_131_H2 - wall_thickness2 && DrawY <= wall_131_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 132 (52,9)
		else if(DrawX >= wall_132_V2 && DrawX <= wall_132_V2 + wall_thickness2
					&& DrawY >= wall_132_H2 - wall_thickness2 && DrawY <= wall_132_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 133 (56,9)
		else if(DrawX >= wall_133_V2 && DrawX <= wall_133_V2 + wall_thickness2
					&& DrawY >= wall_133_H2 - wall_thickness2 && DrawY <= wall_133_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 134 (58,9)
		else if(DrawX >= wall_134_V2 && DrawX <= wall_134_V2 + wall_thickness2
					&& DrawY >= wall_134_H2 - wall_thickness2 && DrawY <= wall_134_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 135 (60,9)
		else if(DrawX >= wall_135_V2 && DrawX <= wall_135_V2 + wall_thickness2
					&& DrawY >= wall_135_H2 - wall_thickness2 && DrawY <= wall_135_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 136 (2,10)
		else if(DrawX >= wall_136_V2 && DrawX <= wall_136_V2 + wall_thickness2
					&& DrawY >= wall_136_H2 - wall_thickness2 && DrawY <= wall_136_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 137 (4,10) --> (6,10)
		else if(DrawX >= wall_137_V2 && DrawX <= 10'd075 + wall_thickness2
					&& DrawY >= wall_137_H2 - wall_thickness2 && DrawY <= wall_137_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 138 (8,10)
		else if(DrawX >= wall_138_V2 && DrawX <= wall_138_V2 + wall_thickness2
					&& DrawY >= wall_138_H2 - wall_thickness2 && DrawY <= wall_138_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 139 (10,10) --> (12,10)
		else if(DrawX >= wall_139_V2 && DrawX <= 10'd135 + wall_thickness2
					&& DrawY >= wall_139_H2 - wall_thickness2 && DrawY <= wall_139_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 140 (14,10) --> (18,10)
		else if(DrawX >= wall_140_V2 && DrawX <= 10'd195 + wall_thickness2
					&& DrawY >= wall_140_H2 - wall_thickness2 && DrawY <= wall_140_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 141 (20,10)
		else if(DrawX >= wall_141_V2 && DrawX <= wall_141_V2 + wall_thickness2
					&& DrawY >= wall_141_H2 - wall_thickness2 && DrawY <= wall_141_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 142 (22,10)
		else if(DrawX >= wall_142_V2 && DrawX <= wall_142_V2 + wall_thickness2
					&& DrawY >= wall_142_H2 - wall_thickness2 && DrawY <= wall_142_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 143 (24,10) --> (28,10)
		else if(DrawX >= wall_143_V2 && DrawX <= 10'd295 + wall_thickness2
					&& DrawY >= wall_143_H2 - wall_thickness2 && DrawY <= wall_143_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 144 (30,10)
		else if(DrawX >= wall_144_V2 && DrawX <= wall_144_V2 + wall_thickness2
					&& DrawY >= wall_144_H2 - wall_thickness2 && DrawY <= wall_144_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 145 (32,10)
		else if(DrawX >= wall_145_V2 && DrawX <= wall_145_V2 + wall_thickness2
					&& DrawY >= wall_145_H2 - wall_thickness2 && DrawY <= wall_145_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 146 (34,10) --> (36,10)
		else if(DrawX >= wall_146_V2 && DrawX <= 10'd375 + wall_thickness2
					&& DrawY >= wall_146_H2 - wall_thickness2 && DrawY <= wall_146_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 147 (38,10)
		else if(DrawX >= wall_147_V2 && DrawX <= wall_147_V2 + wall_thickness2
					&& DrawY >= wall_147_H2 - wall_thickness2 && DrawY <= wall_147_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 148 (40,10)
		else if(DrawX >= wall_148_V2 && DrawX <= wall_148_V2 + wall_thickness2
					&& DrawY >= wall_148_H2 - wall_thickness2 && DrawY <= wall_148_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 149 (42,10) --> (44,10)
		else if(DrawX >= wall_149_V2 && DrawX <= 10'd455 + wall_thickness2
					&& DrawY >= wall_149_H2 - wall_thickness2 && DrawY <= wall_149_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 150 (46,10) --> (50,10)
		else if(DrawX >= wall_150_V2 && DrawX <= 10'd515 + wall_thickness2
					&& DrawY >= wall_150_H2 - wall_thickness2 && DrawY <= wall_150_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 151 (52,10) --> (56,10)
		else if(DrawX >= wall_151_V2 && DrawX <= 10'd575 + wall_thickness2
					&& DrawY >= wall_151_H2 - wall_thickness2 && DrawY <= wall_151_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 152 (58,10) --> (60,10)
		else if(DrawX >= wall_152_V2 && DrawX <= 10'd615 + wall_thickness2
					&& DrawY >= wall_152_H2 - wall_thickness2 && DrawY <= wall_152_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 153 (2,11)
		else if(DrawX >= wall_153_V2 && DrawX <= wall_153_V2 + wall_thickness2
					&& DrawY >= wall_153_H2 - wall_thickness2 && DrawY <= wall_153_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 154 (6,11)
		else if(DrawX >= wall_154_V2 && DrawX <= wall_154_V2 + wall_thickness2
					&& DrawY >= wall_154_H2 - wall_thickness2 && DrawY <= wall_154_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 155 (8,11)
		else if(DrawX >= wall_155_V2 && DrawX <= wall_155_V2 + wall_thickness2
					&& DrawY >= wall_155_H2 - wall_thickness2 && DrawY <= wall_155_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 156 (12,11)
		else if(DrawX >= wall_156_V2 && DrawX <= wall_156_V2 + wall_thickness2
					&& DrawY >= wall_156_H2 - wall_thickness2 && DrawY <= wall_156_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 157 (22,11)
		else if(DrawX >= wall_157_V2 && DrawX <= wall_157_V2 + wall_thickness2
					&& DrawY >= wall_157_H2 - wall_thickness2 && DrawY <= wall_157_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 158 (24,11)
		else if(DrawX >= wall_158_V2 && DrawX <= wall_158_V2 + wall_thickness2
					&& DrawY >= wall_158_H2 - wall_thickness2 && DrawY <= wall_158_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 159 (28,11)
		else if(DrawX >= wall_159_V2 && DrawX <= wall_159_V2 + wall_thickness2
					&& DrawY >= wall_159_H2 - wall_thickness2 && DrawY <= wall_159_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 160 (30,11)
		else if(DrawX >= wall_160_V2 && DrawX <= wall_160_V2 + wall_thickness2
					&& DrawY >= wall_160_H2 - wall_thickness2 && DrawY <= wall_160_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 161 (36,1)
		else if(DrawX >= wall_161_V2 && DrawX <= wall_161_V2 + wall_thickness2
					&& DrawY >= wall_161_H2 - wall_thickness2 && DrawY <= wall_161_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 162 (40,11)
		else if(DrawX >= wall_162_V2 && DrawX <= wall_162_V2 + wall_thickness2
					&& DrawY >= wall_162_H2 - wall_thickness2 && DrawY <= wall_162_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 163 (42,11)
		else if(DrawX >= wall_163_V2 && DrawX <= wall_163_V2 + wall_thickness2
					&& DrawY >= wall_163_H2 - wall_thickness2 && DrawY <= wall_163_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 164 (44,11)
		else if(DrawX >= wall_164_V2 && DrawX <= wall_164_V2 + wall_thickness2
					&& DrawY >= wall_164_H2 - wall_thickness2 && DrawY <= wall_164_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		
		// Wall 165 (56,11)
		else if(DrawX >= wall_165_V2 && DrawX <= wall_165_V2 + wall_thickness2
					&& DrawY >= wall_165_H2 - wall_thickness2 && DrawY <= wall_165_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 166 (60,11)
		else if(DrawX >= wall_166_V2 && DrawX <= wall_166_V2 + wall_thickness2
					&& DrawY >= wall_166_H2 - wall_thickness2 && DrawY <= wall_166_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 167 (2,12) --> (6,12)
		else if(DrawX >= wall_167_V2 && DrawX <= 10'd075 + wall_thickness2
					&& DrawY >= wall_167_H2 - wall_thickness2 && DrawY <= wall_167_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 168 (8,12) --> (10,12)
		else if(DrawX >= wall_168_V2 && DrawX <= 10'd115 + wall_thickness2
					&& DrawY >= wall_168_H2 - wall_thickness2 && DrawY <= wall_168_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 169 (14,12) --> (18,12)
		else if(DrawX >= wall_169_V2 && DrawX <= 10'd195 + wall_thickness2
					&& DrawY >= wall_169_H2 - wall_thickness2 && DrawY <= wall_169_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 170 (20,12) --> (22,12)
		else if(DrawX >= wall_170_V2 && DrawX <= 10'd235 + wall_thickness2
					&& DrawY >= wall_170_H2 - wall_thickness2 && DrawY <= wall_170_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 171 (24,12)
		else if(DrawX >= wall_171_V2 && DrawX <= wall_171_V2 + wall_thickness2
					&& DrawY >= wall_171_H2 - wall_thickness2 && DrawY <= wall_171_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 172 (26,12)
		else if(DrawX >= wall_172_V2 && DrawX <= wall_172_V2 + wall_thickness2
					&& DrawY >= wall_172_H2 - wall_thickness2 && DrawY <= wall_172_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 173 (28,12)
		else if(DrawX >= wall_173_V2 && DrawX <= wall_173_V2 + wall_thickness2
					&& DrawY >= wall_173_H2 - wall_thickness2 && DrawY <= wall_173_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 174 (30,12) --> (38,12)
		else if(DrawX >= wall_174_V2 && DrawX <= 10'd395 + wall_thickness2
					&& DrawY >= wall_174_H2 - wall_thickness2 && DrawY <= wall_174_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 175 (40,12)
		else if(DrawX >= wall_175_V2 && DrawX <= wall_175_V2 + wall_thickness2
					&& DrawY >= wall_175_H2 - wall_thickness2 && DrawY <= wall_175_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 176 (42,12)
		else if(DrawX >= wall_176_V2 && DrawX <= wall_176_V2 + wall_thickness2
					&& DrawY >= wall_176_H2 - wall_thickness2 && DrawY <= wall_176_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 177 (44,12) --> (46,12)
		else if(DrawX >= wall_177_V2 && DrawX <= 10'd475 + wall_thickness2
					&& DrawY >= wall_177_H2 - wall_thickness2 && DrawY <= wall_177_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 178 (48,12) --> (50,12)
		else if(DrawX >= wall_178_V2 && DrawX <= 10'd515 + wall_thickness2
					&& DrawY >= wall_178_H2 - wall_thickness2 && DrawY <= wall_178_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 179 (52,12) --> (54,12)
		else if(DrawX >= wall_179_V2 && DrawX <= 10'd555 + wall_thickness2
					&& DrawY >= wall_179_H2 - wall_thickness2 && DrawY <= wall_179_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 180 (56,12) --> (58,12)
		else if(DrawX >= wall_180_V2 && DrawX <= 10'd595 + wall_thickness2
					&& DrawY >= wall_180_H2 - wall_thickness2 && DrawY <= wall_180_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 181 (60,12)
		else if(DrawX >= wall_181_V2 && DrawX <= wall_181_V2 + wall_thickness2
					&& DrawY >= wall_181_H2 - wall_thickness2 && DrawY <= wall_181_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 182 (6,13)
		else if(DrawX >= wall_182_V2 && DrawX <= wall_182_V2 + wall_thickness2
					&& DrawY >= wall_182_H2 - wall_thickness2 && DrawY <= wall_182_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 183 (14,13)
		else if(DrawX >= wall_183_V2 && DrawX <= wall_183_V2 + wall_thickness2
					&& DrawY >= wall_183_H2 - wall_thickness2 && DrawY <= wall_183_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 184 (24,13)
		else if(DrawX >= wall_184_V2 && DrawX <= wall_184_V2 + wall_thickness2
					&& DrawY >= wall_184_H2 - wall_thickness2 && DrawY <= wall_184_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 185 (26,13)
		else if(DrawX >= wall_185_V2 && DrawX <= wall_185_V2 + wall_thickness2
					&& DrawY >= wall_185_H2 - wall_thickness2 && DrawY <= wall_185_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 186 (28,13)
		else if(DrawX >= wall_186_V2 && DrawX <= wall_186_V2 + wall_thickness2
					&& DrawY >= wall_186_H2 - wall_thickness2 && DrawY <= wall_186_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 187 (38,13)
		else if(DrawX >= wall_187_V2 && DrawX <= wall_187_V2 + wall_thickness2
					&& DrawY >= wall_187_H2 - wall_thickness2 && DrawY <= wall_187_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 188 (42,13)
		else if(DrawX >= wall_188_V2 && DrawX <= wall_188_V2 + wall_thickness2
					&& DrawY >= wall_188_H2 - wall_thickness2 && DrawY <= wall_188_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 189 (48,13)
		else if(DrawX >= wall_189_V2 && DrawX <= wall_189_V2 + wall_thickness2
					&& DrawY >= wall_189_H2 - wall_thickness2 && DrawY <= wall_189_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 190 (54,13)
		else if(DrawX >= wall_190_V2 && DrawX <= wall_190_V2 + wall_thickness2
					&& DrawY >= wall_190_H2 - wall_thickness2 && DrawY <= wall_190_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 191 (58,13)
		else if(DrawX >= wall_191_V2 && DrawX <= wall_191_V2 + wall_thickness2
					&& DrawY >= wall_191_H2 - wall_thickness2 && DrawY <= wall_191_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 192 (60,13)
		else if(DrawX >= wall_192_V2 && DrawX <= wall_192_V2 + wall_thickness2
					&& DrawY >= wall_192_H2 - wall_thickness2 && DrawY <= wall_192_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 193 (2,14) --> (4,14)
		else if(DrawX >= wall_193_V2 && DrawX <= 10'd055 + wall_thickness2
					&& DrawY >= wall_193_H2 - wall_thickness2 && DrawY <= wall_193_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 194 (6,14) --> (8,14)
		else if(DrawX >= wall_194_V2 && DrawX <= 10'd095 + wall_thickness2
					&& DrawY >= wall_194_H2 - wall_thickness2 && DrawY <= wall_194_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 195 (10,14) --> (14,14)
		else if(DrawX >= wall_195_V2 && DrawX <= 10'd155 + wall_thickness2
					&& DrawY >= wall_195_H2 - wall_thickness2 && DrawY <= wall_195_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 196 (16,14) --> (20,14)
		else if(DrawX >= wall_196_V2 && DrawX <= 10'd215 + wall_thickness2
					&& DrawY >= wall_196_H2 - wall_thickness2 && DrawY <= wall_196_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 197 (22,14)
		else if(DrawX >= wall_197_V2 && DrawX <= wall_197_V2 + wall_thickness2
					&& DrawY >= wall_197_H2 - wall_thickness2 && DrawY <= wall_197_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 198 (24,14) --> (26,14)
		else if(DrawX >= wall_198_V2 && DrawX <= 10'd275 + wall_thickness2
					&& DrawY >= wall_198_H2 - wall_thickness2 && DrawY <= wall_198_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 199 (28,14) --> (30,14)
		else if(DrawX >= wall_199_V2 && DrawX <= 10'd315 + wall_thickness2
					&& DrawY >= wall_199_H2 - wall_thickness2 && DrawY <= wall_199_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 200 (32,14) --> (36,14)
		else if(DrawX >= wall_200_V2 && DrawX <= 10'd375 + wall_thickness2
					&& DrawY >= wall_200_H2 - wall_thickness2 && DrawY <= wall_200_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 201 (38,14) --> (43,14)
		else if(DrawX >= wall_201_V2 && DrawX <= 10'd445 + wall_thickness2
					&& DrawY >= wall_201_H2 - wall_thickness2 && DrawY <= wall_201_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 202 (45,14) --> (48,14)
		else if(DrawX >= wall_202_V2 && DrawX <= 10'd495 + wall_thickness2
					&& DrawY >= wall_202_H2 - wall_thickness2 && DrawY <= wall_202_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 203 (50,14) --> (52,14)
		else if(DrawX >= wall_203_V2 && DrawX <= 10'd535 + wall_thickness2
					&& DrawY >= wall_203_H2 - wall_thickness2 && DrawY <= wall_203_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 204 (54,14) --> (56,14)
		else if(DrawX >= wall_204_V2 && DrawX <= 10'd575 + wall_thickness2
					&& DrawY >= wall_204_H2 - wall_thickness2 && DrawY <= wall_204_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 205 (58,14)
		else if(DrawX >= wall_205_V2 && DrawX <= wall_205_V2 + wall_thickness2
					&& DrawY >= wall_205_H2 - wall_thickness2 && DrawY <= wall_205_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 206 (60,14)
		else if(DrawX >= wall_206_V2 && DrawX <= wall_206_V2 + wall_thickness2
					&& DrawY >= wall_206_H2 - wall_thickness2 && DrawY <= wall_206_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 207 (4,15)
		else if(DrawX >= wall_207_V2 && DrawX <= wall_207_V2 + wall_thickness2
					&& DrawY >= wall_207_H2 - wall_thickness2 && DrawY <= wall_207_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 208 (10,15)
		else if(DrawX >= wall_208_V2 && DrawX <= wall_208_V2 + wall_thickness2
					&& DrawY >= wall_208_H2 - wall_thickness2 && DrawY <= wall_208_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 209 (16,15)
		else if(DrawX >= wall_209_V2 && DrawX <= wall_209_V2 + wall_thickness2
					&& DrawY >= wall_209_H2 - wall_thickness2 && DrawY <= wall_209_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 210 (20,15)
		else if(DrawX >= wall_210_V2 && DrawX <= wall_210_V2 + wall_thickness2
					&& DrawY >= wall_210_H2 - wall_thickness2 && DrawY <= wall_210_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 211 (22,15)
		else if(DrawX >= wall_211_V2 && DrawX <= wall_211_V2 + wall_thickness2
					&& DrawY >= wall_211_H2 - wall_thickness2 && DrawY <= wall_211_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 212 (32,15)
		else if(DrawX >= wall_212_V2 && DrawX <= wall_212_V2 + wall_thickness2
					&& DrawY >= wall_212_H2 - wall_thickness2 && DrawY <= wall_212_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 213 (34,15)
		else if(DrawX >= wall_213_V2 && DrawX <= wall_213_V2 + wall_thickness2
					&& DrawY >= wall_213_H2 - wall_thickness2 && DrawY <= wall_213_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 214 (36,15)
		else if(DrawX >= wall_214_V2 && DrawX <= wall_214_V2 + wall_thickness2
					&& DrawY >= wall_214_H2 - wall_thickness2 && DrawY <= wall_214_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 215 (40,15)
		else if(DrawX >= wall_215_V2 && DrawX <= wall_215_V2 + wall_thickness2
					&& DrawY >= wall_215_H2 - wall_thickness2 && DrawY <= wall_215_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 216 (46,15)
		else if(DrawX >= wall_216_V2 && DrawX <= wall_216_V2 + wall_thickness2
					&& DrawY >= wall_216_H2 - wall_thickness2 && DrawY <= wall_216_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 217 (50,15)
		else if(DrawX >= wall_217_V2 && DrawX <= wall_217_V2 + wall_thickness2
					&& DrawY >= wall_217_H2 - wall_thickness2 && DrawY <= wall_217_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 218 (56,15)
		else if(DrawX >= wall_218_V2 && DrawX <= wall_218_V2 + wall_thickness2
					&& DrawY >= wall_218_H2 - wall_thickness2 && DrawY <= wall_218_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 219 (58,15)
		else if(DrawX >= wall_219_V2 && DrawX <= wall_219_V2 + wall_thickness2
					&& DrawY >= wall_219_H2 - wall_thickness2 && DrawY <= wall_219_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 220 (60,15)
		else if(DrawX >= wall_220_V2 && DrawX <= wall_220_V2 + wall_thickness2
					&& DrawY >= wall_220_H2 - wall_thickness2 && DrawY <= wall_220_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 221 (2,16)
		else if(DrawX >= wall_221_V2 && DrawX <= wall_221_V2 + wall_thickness2
					&& DrawY >= wall_221_H2 - wall_thickness2 && DrawY <= wall_221_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 222 (4,16) --> (6,16)
		else if(DrawX >= wall_222_V2 && DrawX <= 10'd075 + wall_thickness2
					&& DrawY >= wall_222_H2 - wall_thickness2 && DrawY <= wall_222_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 223 (8,16) --> (10,16)
		else if(DrawX >= wall_223_V2 && DrawX <= 10'd115 + wall_thickness2
					&& DrawY >= wall_223_H2 - wall_thickness2 && DrawY <= wall_223_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 224 (12,16) --> (14,16)
		else if(DrawX >= wall_224_V2 && DrawX <= 10'd155 + wall_thickness2
					&& DrawY >= wall_224_H2 - wall_thickness2 && DrawY <= wall_224_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 225 (16,16) --> (18,16)
		else if(DrawX >= wall_225_V2 && DrawX <= 10'd195 + wall_thickness2
					&& DrawY >= wall_225_H2 - wall_thickness2 && DrawY <= wall_225_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 226 (20,16)
		else if(DrawX >= wall_226_V2 && DrawX <= wall_226_V2 + wall_thickness2
					&& DrawY >= wall_226_H2 - wall_thickness2 && DrawY <= wall_226_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 227 (22,16) --> (24,16)
		else if(DrawX >= wall_227_V2 && DrawX <= 10'd255 + wall_thickness2
					&& DrawY >= wall_227_H2 - wall_thickness2 && DrawY <= wall_227_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 228 (26,16) --> (29,16)
		else if(DrawX >= wall_228_V2 && DrawX <= 10'd305 + wall_thickness2
					&& DrawY >= wall_228_H2 - wall_thickness2 && DrawY <= wall_228_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 229 (31,16) --> (32,16)
		else if(DrawX >= wall_229_V2 && DrawX <= 10'd335 + wall_thickness2
					&& DrawY >= wall_229_H2 - wall_thickness2 && DrawY <= wall_229_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 230 (34,16)
		else if(DrawX >= wall_230_V2 && DrawX <= wall_230_V2 + wall_thickness2
					&& DrawY >= wall_230_H2 - wall_thickness2 && DrawY <= wall_230_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 231 (36,16) --> (38,16)
		else if(DrawX >= wall_231_V2 && DrawX <= 10'd395 + wall_thickness2
					&& DrawY >= wall_231_H2 - wall_thickness2 && DrawY <= wall_231_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 232 (40,16)
		else if(DrawX >= wall_232_V2 && DrawX <= wall_232_V2 + wall_thickness2
					&& DrawY >= wall_232_H2 - wall_thickness2 && DrawY <= wall_232_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 233 (42,16) --> (44,16)
		else if(DrawX >= wall_233_V2 && DrawX <= 10'd455 + wall_thickness2
					&& DrawY >= wall_233_H2 - wall_thickness2 && DrawY <= wall_233_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 234 (46,14)
		else if(DrawX >= wall_234_V2 && DrawX <= wall_234_V2 + wall_thickness2
					&& DrawY >= wall_234_H2 - wall_thickness2 && DrawY <= wall_234_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 235 (48,16) --> (50,16)
		else if(DrawX >= wall_235_V2 && DrawX <= 10'd515 + wall_thickness2
					&& DrawY >= wall_235_H2 - wall_thickness2 && DrawY <= wall_235_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 236 (52, 16) --> (54,16)
		else if(DrawX >= wall_236_V2 && DrawX <= 10'd555 + wall_thickness2
					&& DrawY >= wall_236_H2 - wall_thickness2 && DrawY <= wall_236_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 237 (56,14) --> (58,16)
		else if(DrawX >= wall_237_V2 && DrawX <= 10'd595 + wall_thickness2
					&& DrawY >= wall_237_H2 - wall_thickness2 && DrawY <= wall_237_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 238 (60,16)
		else if(DrawX >= wall_238_V2 && DrawX <= wall_238_V2 + wall_thickness2
					&& DrawY >= wall_238_H2 - wall_thickness2 && DrawY <= wall_238_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 239 (2,17)
		else if(DrawX >= wall_239_V2 && DrawX <= wall_239_V2 + wall_thickness2
					&& DrawY >= wall_239_H2 - wall_thickness2 && DrawY <= wall_239_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 240 (6,17)
		else if(DrawX >= wall_240_V2 && DrawX <= wall_240_V2 + wall_thickness2
					&& DrawY >= wall_240_H2 - wall_thickness2 && DrawY <= wall_240_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 241 (10,17)
		else if(DrawX >= wall_241_V2 && DrawX <= wall_241_V2 + wall_thickness2
					&& DrawY >= wall_241_H2 - wall_thickness2 && DrawY <= wall_241_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 242 (18,17)
		else if(DrawX >= wall_242_V2 && DrawX <= wall_242_V2 + wall_thickness2
					&& DrawY >= wall_242_H2 - wall_thickness2 && DrawY <= wall_242_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 243 (26,17)
		else if(DrawX >= wall_243_V2 && DrawX <= wall_243_V2 + wall_thickness2
					&& DrawY >= wall_243_H2 - wall_thickness2 && DrawY <= wall_243_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 244 (34,17)
		else if(DrawX >= wall_244_V2 && DrawX <= wall_244_V2 + wall_thickness2
					&& DrawY >= wall_244_H2 - wall_thickness2 && DrawY <= wall_244_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 245 (38,17)
		else if(DrawX >= wall_245_V2 && DrawX <= wall_245_V2 + wall_thickness2
					&& DrawY >= wall_245_H2 - wall_thickness2 && DrawY <= wall_245_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 246 (42,17)
		else if(DrawX >= wall_246_V2 && DrawX <= wall_246_V2 + wall_thickness2
					&& DrawY >= wall_246_H2 - wall_thickness2 && DrawY <= wall_246_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 247 (44,17)
		else if(DrawX >= wall_247_V2 && DrawX <= wall_247_V2 + wall_thickness2
					&& DrawY >= wall_247_H2 - wall_thickness2 && DrawY <= wall_247_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 248 (46,17)
		else if(DrawX >= wall_248_V2 && DrawX <= wall_248_V2 + wall_thickness2
					&& DrawY >= wall_248_H2 - wall_thickness2 && DrawY <= wall_248_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 249 (48,17)
		else if(DrawX >= wall_249_V2 && DrawX <= wall_249_V2 + wall_thickness2
					&& DrawY >= wall_249_H2 - wall_thickness2 && DrawY <= wall_249_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 250 (54,17)
		else if(DrawX >= wall_250_V2 && DrawX <= wall_250_V2 + wall_thickness2
					&& DrawY >= wall_250_H2 - wall_thickness2 && DrawY <= wall_250_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 251 (58,17)
		else if(DrawX >= wall_251_V2 && DrawX <= wall_251_V2 + wall_thickness2
					&& DrawY >= wall_251_H2 - wall_thickness2 && DrawY <= wall_251_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 252 (60,17)
		else if(DrawX >= wall_252_V2 && DrawX <= wall_252_V2 + wall_thickness2
					&& DrawY >= wall_252_H2 - wall_thickness2 && DrawY <= wall_252_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 253 (2,18)
		else if(DrawX >= wall_253_V2 && DrawX <= wall_253_V2 + wall_thickness2
					&& DrawY >= wall_253_H2 - wall_thickness2 && DrawY <= wall_253_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 254 (4,18) --> (6,18)
		else if(DrawX >= wall_254_V2 && DrawX <= 10'd075 + wall_thickness2
					&& DrawY >= wall_254_H2 - wall_thickness2 && DrawY <= wall_254_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 255 (8,18)
		else if(DrawX >= wall_255_V2 && DrawX <= wall_255_V2 + wall_thickness2
					&& DrawY >= wall_255_H2 - wall_thickness2 && DrawY <= wall_255_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 256 (10,18) --> (13,18)
		else if(DrawX >= wall_256_V2 && DrawX <= 10'd145 + wall_thickness2
					&& DrawY >= wall_256_H2 - wall_thickness2 && DrawY <= wall_256_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 257 (15,18) --> (16,18)
		else if(DrawX >= wall_257_V2 && DrawX <= 10'd175 + wall_thickness2
					&& DrawY >= wall_257_H2 - wall_thickness2 && DrawY <= wall_257_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 258 (18,18) --> (26,18)
		else if(DrawX >= wall_258_V2 && DrawX <= 10'd275 + wall_thickness2
					&& DrawY >= wall_258_H2 - wall_thickness2 && DrawY <= wall_258_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 259 (28,18) --> (32,18)
		else if(DrawX >= wall_259_V2 && DrawX <= 10'd335 + wall_thickness2
					&& DrawY >= wall_259_H2 - wall_thickness2 && DrawY <= wall_259_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 260 (34,18) --> (36,18)
		else if(DrawX >= wall_260_V2 && DrawX <= 10'd375 + wall_thickness2
					&& DrawY >= wall_260_H2 - wall_thickness2 && DrawY <= wall_260_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 261 (38,18)
		else if(DrawX >= wall_261_V2 && DrawX <= wall_261_V2 + wall_thickness2
					&& DrawY >= wall_261_H2 - wall_thickness2 && DrawY <= wall_261_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 262 (40,18) --> (42,18)
		else if(DrawX >= wall_262_V2 && DrawX <= 10'd435 + wall_thickness2
					&& DrawY >= wall_262_H2 - wall_thickness2 && DrawY <= wall_262_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 263 (44,18)
		else if(DrawX >= wall_263_V2 && DrawX <= wall_263_V2 + wall_thickness2
					&& DrawY >= wall_263_H2 - wall_thickness2 && DrawY <= wall_263_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 264 (46,18)
		else if(DrawX >= wall_264_V2 && DrawX <= wall_264_V2 + wall_thickness2
					&& DrawY >= wall_264_H2 - wall_thickness2 && DrawY <= wall_264_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 265 (48,18)
		else if(DrawX >= wall_265_V2 && DrawX <= wall_265_V2 + wall_thickness2
					&& DrawY >= wall_265_H2 - wall_thickness2 && DrawY <= wall_265_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 266 (50,18)
		else if(DrawX >= wall_266_V2 && DrawX <= wall_266_V2 + wall_thickness2
					&& DrawY >= wall_266_H2 - wall_thickness2 && DrawY <= wall_266_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 267 (52,18) --> (56,18)
		else if(DrawX >= wall_267_V2 && DrawX <= 10'd575 + wall_thickness2
					&& DrawY >= wall_267_H2 - wall_thickness2 && DrawY <= wall_267_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 268 (58,18)
		else if(DrawX >= wall_268_V2 && DrawX <= wall_268_V2 + wall_thickness2
					&& DrawY >= wall_268_H2 - wall_thickness2 && DrawY <= wall_268_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 269 (2,19)
		else if(DrawX >= wall_269_V2 && DrawX <= wall_269_V2 + wall_thickness2
					&& DrawY >= wall_269_H2 - wall_thickness2 && DrawY <= wall_269_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 270 (8,19)
		else if(DrawX >= wall_270_V2 && DrawX <= wall_270_V2 + wall_thickness2
					&& DrawY >= wall_270_H2 - wall_thickness2 && DrawY <= wall_270_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 271 (12,19)
		else if(DrawX >= wall_271_V2 && DrawX <= wall_271_V2 + wall_thickness2
					&& DrawY >= wall_271_H2 - wall_thickness2 && DrawY <= wall_271_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 272 (18,19)
		else if(DrawX >= wall_272_V2 && DrawX <= wall_272_V2 + wall_thickness2
					&& DrawY >= wall_272_H2 - wall_thickness2 && DrawY <= wall_272_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 273 (26,19)
		else if(DrawX >= wall_273_V2 && DrawX <= wall_273_V2 + wall_thickness2
					&& DrawY >= wall_273_H2 - wall_thickness2 && DrawY <= wall_273_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 274 (30,19)
		else if(DrawX >= wall_274_V2 && DrawX <= wall_274_V2 + wall_thickness2
					&& DrawY >= wall_274_H2 - wall_thickness2 && DrawY <= wall_274_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 275 (38,19)
		else if(DrawX >= wall_275_V2 && DrawX <= wall_275_V2 + wall_thickness2
					&& DrawY >= wall_275_H2 - wall_thickness2 && DrawY <= wall_275_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 276 (44,19)
		else if(DrawX >= wall_276_V2 && DrawX <= wall_276_V2 + wall_thickness2
					&& DrawY >= wall_276_H2 - wall_thickness2 && DrawY <= wall_276_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 277 (48,19)
		else if(DrawX >= wall_277_V2 && DrawX <= wall_277_V2 + wall_thickness2
					&& DrawY >= wall_277_H2 - wall_thickness2 && DrawY <= wall_277_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 278 (50,19)
		else if(DrawX >= wall_278_V2 && DrawX <= wall_278_V2 + wall_thickness2
					&& DrawY >= wall_278_H2 - wall_thickness2 && DrawY <= wall_278_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 279 (52,19)
		else if(DrawX >= wall_279_V2 && DrawX <= wall_279_V2 + wall_thickness2
					&& DrawY >= wall_279_H2 - wall_thickness2 && DrawY <= wall_279_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 280 (56,19)
		else if(DrawX >= wall_280_V2 && DrawX <= wall_280_V2 + wall_thickness2
					&& DrawY >= wall_280_H2 - wall_thickness2 && DrawY <= wall_280_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 281 (58,19)
		else if(DrawX >= wall_281_V2 && DrawX <= wall_281_V2 + wall_thickness2
					&& DrawY >= wall_281_H2 - wall_thickness2 && DrawY <= wall_281_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 282 (2,20) --> (8,20)
		else if(DrawX >= wall_282_V2 && DrawX <= 10'd095 + wall_thickness2
					&& DrawY >= wall_282_H2 - wall_thickness2 && DrawY <= wall_282_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 283 (7,20) --> (8,20)
		else if(DrawX >= wall_283_V2 && DrawX <= 10'd095 + wall_thickness2
					&& DrawY >= wall_283_H2 - wall_thickness2 && DrawY <= wall_283_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 284 (10,20)
		else if(DrawX >= wall_284_V2 && DrawX <= wall_284_V2 + wall_thickness2
					&& DrawY >= wall_284_H2 - wall_thickness2 && DrawY <= wall_284_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 285 (12,20)
		else if(DrawX >= wall_285_V2 && DrawX <= wall_285_V2 + wall_thickness2
					&& DrawY >= wall_285_H2 - wall_thickness2 && DrawY <= wall_285_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 286 (14,20)
		else if(DrawX >= wall_286_V2 && DrawX <= wall_286_V2 + wall_thickness2
					&& DrawY >= wall_286_H2 - wall_thickness2 && DrawY <= wall_286_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 287 (15,20) --> (18,20)
		else if(DrawX >= wall_287_V2 && DrawX <= 10'd195 + wall_thickness2
					&& DrawY >= wall_287_H2 - wall_thickness2 && DrawY <= wall_287_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 288 (20,20) --> (24,20)
		else if(DrawX >= wall_288_V2 && DrawX <= 10'd255 + wall_thickness2
					&& DrawY >= wall_288_H2 - wall_thickness2 && DrawY <= wall_288_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 289 (26,20) --> (28,20)
		else if(DrawX >= wall_289_V2 && DrawX <= 10'd295 + wall_thickness2
					&& DrawY >= wall_289_H2 - wall_thickness2 && DrawY <= wall_289_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 290 (30,20)
		else if(DrawX >= wall_290_V2 && DrawX <= wall_290_V2 + wall_thickness2
					&& DrawY >= wall_290_H2 - wall_thickness2 && DrawY <= wall_290_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 291 (32,20) --> (35,20)
		else if(DrawX >= wall_291_V2 && DrawX <= 10'd365 + wall_thickness2
					&& DrawY >= wall_291_H2 - wall_thickness2 && DrawY <= wall_291_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 292 (37,20) --> (38,20)
		else if(DrawX >= wall_292_V2 && DrawX <= 10'd395 + wall_thickness2
					&& DrawY >= wall_292_H2 - wall_thickness2 && DrawY <= wall_292_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 293 (40,20) --> (42,20)
		else if(DrawX >= wall_293_V2 && DrawX <= 10'd435 + wall_thickness2
					&& DrawY >= wall_293_H2 - wall_thickness2 && DrawY <= wall_293_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 294 (47,20) -->(48,20)
		else if(DrawX >= wall_294_V2 && DrawX <= 10'd495 + wall_thickness2
					&& DrawY >= wall_294_H2 - wall_thickness2 && DrawY <= wall_294_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 295 (50,20) --> (52,20)
		else if(DrawX >= wall_295_V2 && DrawX <= 10'd535 + wall_thickness2
					&& DrawY >= wall_295_H2 - wall_thickness2 && DrawY <= wall_295_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 296 (54, 20)
		else if(DrawX >= wall_296_V2 && DrawX <= wall_296_V2 + wall_thickness2
					&& DrawY >= wall_296_H2 - wall_thickness2 && DrawY <= wall_296_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 297 (56,20)
		else if(DrawX >= wall_297_V2 && DrawX <= wall_297_V2 + wall_thickness2
					&& DrawY >= wall_297_H2 - wall_thickness2 && DrawY <= wall_297_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 298 (58,20)
		else if(DrawX >= wall_298_V2 && DrawX <= wall_298_V2 + wall_thickness2
					&& DrawY >= wall_298_H2 - wall_thickness2 && DrawY <= wall_298_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 299 (10,21)
		else if(DrawX >= wall_299_V2 && DrawX <= wall_299_V2 + wall_thickness2
					&& DrawY >= wall_299_H2 - wall_thickness2 && DrawY <= wall_299_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 300 (12,21)
		else if(DrawX >= wall_300_V2 && DrawX <= wall_300_V2 + wall_thickness2
					&& DrawY >= wall_300_H2 - wall_thickness2 && DrawY <= wall_300_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 301 (24,21)
		else if(DrawX >= wall_301_V2 && DrawX <= wall_301_V2 + wall_thickness2
					&& DrawY >= wall_301_H2 - wall_thickness2 && DrawY <= wall_301_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 302 (30,21)
		else if(DrawX >= wall_302_V2 && DrawX <= wall_302_V2 + wall_thickness2
					&& DrawY >= wall_302_H2 - wall_thickness2 && DrawY <= wall_302_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 303 (42,21)
		else if(DrawX >= wall_303_V2 && DrawX <= wall_303_V2 + wall_thickness2
					&& DrawY >= wall_303_H2 - wall_thickness2 && DrawY <= wall_303_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 304 (54,21)
		else if(DrawX >= wall_304_V2 && DrawX <= wall_304_V2 + wall_thickness2
					&& DrawY >= wall_304_H2 - wall_thickness2 && DrawY <= wall_304_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
			end
		// Wall 305 (56,21)
		else if(DrawX >= wall_305_V2 && DrawX <= wall_305_V2 + wall_thickness2
					&& DrawY >= wall_305_H2 - wall_thickness2 && DrawY <= wall_305_H2)
			begin
				is_maze = 1'b1;
				is_goal = 1'b0;
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
						is_maze = 1'b1;
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
				if (path == 8'b0010100 || path == 8'b00110010)
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
