/*
main.c for taking in input mazes
*/

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

void find_start(char** maze, int width, int height, int* x_start, int* y_start);
int dfs_soln(char** maze, char ** maze_printed, int width, int height, int x_pos, int y_pos);
void free_maze(char ** maze, char** maze_printed);

int rnd = 0;

int main() {

  FILE * in;
  system("cd");
  system("pwd");
  in = fopen("/home/umang/Desktop/ai_385/maze2.txt", "r");
  char ** maze = (char **)malloc(sizeof(char*) * 11);
  char ** maze_print = (char **)malloc(sizeof(char*) * 11);
  int i;
  for (i =0; i < 11; i++) {
    maze_print[i] = (char*) malloc(sizeof(char*) * 11);
    maze[i] = (char *) malloc(sizeof(char*) * 11);
  }
  char c;
  int x = 0, y = 0;
  while ((c = fgetc(in)) != EOF){
    if (c == '\n') {
      y++;
      x = 0;
      continue;
    } else {
      maze[y][x] = c;
      maze_print[y][x] = c;
      x++;

    }
  }
  fclose(in);

  int x_start = 0;
  int y_start = 0;
  int check = 0;
  find_start(maze, 11, 11, &x_start, &y_start);
  check = dfs_soln(maze, maze_print, 11, 11, x_start, y_start);
  free_maze(maze, maze_print);
  return 0;

}

void find_start(char** maze, int width, int height, int* x_start, int* y_start) {
  int x, y;
  for (x = 0; x < width; x++){
    for (y = 0; y< height; y++) {
      if (maze[y][x] == 'S') {
        *x_start = x;
        *y_start = y;
        return;
      }
      *x_start = -1;
      *y_start = -1;
    }
  }

  return;
}

int dfs_soln(char** maze, char ** maze_printed, int width, int height, int x_pos, int y_pos) {
    if (maze[y_pos][x_pos] == 'E') {
      int i, j;
      for (i = 0; i < width; i++) {
        for (j = 0; j < height; j++) {
          printf("%c", maze[i][j]);
        }
        printf("\n");
      }
      return 1;
    }

    else if (maze[y_pos][x_pos] == ' ' || maze[y_pos][x_pos] == 'S') {

      FILE * out;
      char filename[sizeof "/home/umang/Desktop/ai_385/maze2.txt"];
      sprintf(filename, "/home/umang/Desktop/ai_385/file%03d.txt", rnd);
      out = fopen(filename, "w");
      if (maze[y_pos][x_pos] != 'S') {
        maze[y_pos][x_pos] = '.';
        maze_printed[y_pos][x_pos] = '.';
        int i, j;
        printf("%d\n", rnd);
        for (i = 0; i < width; i++) {
          for (j = 0; j < height; j++) {
            fputc(maze_printed[i][j], out);
//            printf("%c", maze[i][j]);
            printf("%c", maze_printed[i][j]);
          }
          fputc('\n', out);
          printf("\n");
        }
        printf("\n");
        fclose(out);
      maze_printed[y_pos][x_pos] = ' ';
      rnd++;
    }

      if ((x_pos + 1 < width) && (maze[y_pos][x_pos + 1] != 'S'))  {

       if (dfs_soln(maze, maze_printed, width, height, x_pos + 1, y_pos))
       	return 1;
       	}

       if ((x_pos - 1 >= 0) && (maze[y_pos][x_pos - 1] != 'S')) {

       if (dfs_soln(maze, maze_printed, width, height, x_pos - 1, y_pos))
         return 1;
       }

       if ((y_pos + 1 < height) && (maze[y_pos + 1][x_pos] != 'S')) {

       if (dfs_soln(maze, maze_printed, width, height, x_pos, y_pos + 1))
         return 1;
         }

       if ((y_pos - 1 >= 0) && (maze[y_pos - 1][x_pos] != 'S')) {

       if (dfs_soln(maze, maze_printed, width, height, x_pos, y_pos - 1))
         return 1;
         }


          maze[y_pos][x_pos] = '~';
          rnd++;
          FILE * out_2;
          char filename_2[sizeof "/home/umang/Desktop/ai_385/maze2.txt"];
          sprintf(filename_2, "/home/umang/Desktop/ai_385/file%03d.txt", rnd);
          out_2 = fopen(filename_2, "w");
          maze_printed[y_pos][x_pos] = '.';
          int i, j;
          printf("%d\n", rnd);
          for (i = 0; i < width; i++) {
            for (j = 0; j < height; j++) {
              fputc(maze_printed[i][j], out_2);
              printf("%c", maze_printed[i][j]);
            }
            fputc('\n', out_2);
            printf("\n");
          }
          maze_printed[y_pos][x_pos] = ' ';
          fclose(out_2);



   }
   return 0;
}

void free_maze(char ** maze, char** maze_printed) {
  int i;
  for (i = 0; i < 11; i++) {
    free(maze[i]);
    free(maze_printed[i]);
  }
  free(maze);
  free(maze_printed);
}
