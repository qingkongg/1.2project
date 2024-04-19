#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc,char ** argv){
  if(argc<3){
    printf("Usage:\n");
    printf("./main <input file> <output file>\n");
    exit(0);
  }

  char * input_file_name = argv[1];
  char * output_file_name = argv[2];

  FILE * input_file = fopen(input_file_name,"r");
  FILE * output_file = fopen(output_file_name,"w");
  
  if(input_file == NULL){
    printf("Error: unable to open input file %s\n",input_file_name);
    exit(0);
  }

  if(output_file == NULL){
    printf("Error: unable to open output file %s\n",output_file_name);
    fclose(input_file);
    exit(0);
  }

  /* YOUR CODE HERE */
  int length;
  int width;
  fscanf(input_file,"%d",&length);
  fscanf(input_file,"%d",&width);
  int* image = (int*)malloc(length * width * sizeof(int));
  int num;
  fgetc(input_file);
  for(int i = 0;i < width;i++){
    for(int l = 0;l < length;l++){
      fscanf(input_file,"%d",&num);
      image[i*length + l] = num;
      fgetc(input_file);
    }
  }

  int length1;
  int width1;
  fscanf(input_file,"%d",&length1);
  fscanf(input_file,"%d",&width1);
  int* sub = (int*)malloc(length1 * width1 * sizeof(int));
  fgetc(input_file);
  for(int i = 0;i < width1;i++){
    for(int l = 0;l < length1;l++){
      fscanf(input_file,"%d",&num);
      sub[i*length1 + l] = num;
      fgetc(input_file);
      printf("%d",num);
    }
  }
  int nownum = 0;
  for(int line = 0;line < width-width1 + 1;line++){
    for(int row = 0;row < length-length1 + 1;row++){
      for(int subline = 0;subline < width1;subline++){
        for(int subrow = 0;subrow < length1;subrow++){
          nownum += sub[length1*subline + subrow] * image[(line + subline)*length + row + subrow];
          printf("%d %d %d\n",sub[length1*subline + subrow],image[(line + subline)*length + row + subrow],nownum);
        }
      }
      fprintf(output_file,"%d",nownum);
      fputs(" ",output_file);
      
      nownum = 0;
    }
    fputs("\n",output_file);
  }
  fclose(input_file);
  fclose(output_file);

  return 0;
}
