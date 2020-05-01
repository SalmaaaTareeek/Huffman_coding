clear all;
clc;
input_image= imread('project_image.png'); %%reading input image
imshow(input_image);
[x,y] = size(input_image); %%returning size of the image
%%the following two lines is when the image is not gray scale%%
% %J = imresize(input_image,[256 1]); %%already gray image  
% %I = rgb2gray(map);
total_size = x*y;
[Count, grayLevels] = imhist(input_image); %%return each symbol and no of pixel
%%%FOR MAKING PROBABILITY FOR EACH SYMBOL%%%
index =1;
for i=0:length(Count)
    if i == length(Count)
        break;
    end
    sum1=input_image == i;
    %Count(index)=sum(sum1(:));
    %%prop_matrix include the probabilties including zeros but not in descending
    %%order
    prop_matrix(index) = Count(index)/total_size;  
    index=index+1;
end
ascending_matrix = sort(prop_matrix , 'descend'); %sorted matrix but with zeros
for j=1:length(ascending_matrix)
    if ascending_matrix(j) ~= 0
    remain_ascending_matrix(j) = ascending_matrix(j);
    end
end
index = 10;
m = 1;
collection_matrix(:,m) = remain_ascending_matrix;
for k=1:9
    m=m+1;
    huffman_matrix = remain_ascending_matrix(index)+remain_ascending_matrix(index-1);
    remain_ascending_matrix(index) = [];
    remain_ascending_matrix(index-1) =  huffman_matrix;
    remain_ascending_matrix = sort(remain_ascending_matrix,'descend' );
    collection_matrix(:,m) =[remain_ascending_matrix,zeros(1,10-length(remain_ascending_matrix))];
    index = index -1;
    if index == 2
        break
    end
end
col = 9;
row = 1;
%encoding matrix willcontain the places of zeros and ones in huffman code that I will map with collection_matrix
encoding_matrix = []; 
for z=1:9
    col1 = col;
    row1 = row+2;
    encoding_matrix(row,col) = 0;
    encoding_matrix(row+1,col)=1;
    for z1 = 1:8
        if row1 == 11
            break
        else
            encoding_matrix(row1,col1) = NaN;
            row1 = row1+1;
        end
    end
    col = col -1;
    row = row +1;
end
 row_before = 1;
 row_before1 = 9;
 col_before = 1;
for before=1:8
    for before1=1:8
        if row_before < row_before1
            encoding_matrix(row_before,col_before) = NaN;
            row_before = row_before +1;
        else
             break
        end
    end
    row_before = 1;
    col_before = col_before +1;
    row_before1 = row_before1 - 1;
end
%%%For CodeWord %%%
%%to bring first code word%%
flagrow = 1;
flagcol =1;
codeword_matrix = [];
original_one = 1;
for check=1:9
     if flagcol == 9
        codeword_matrix(original_one,flagcol) = NaN;
        break;
     end
 if collection_matrix(flagrow,flagcol) == collection_matrix(flagrow,flagcol+1)
     codeword_matrix(original_one,flagcol) = encoding_matrix(flagrow,flagcol);
     flagcol = flagcol+1;
 else
     codeword_matrix(original_one,flagcol) = encoding_matrix(flagrow,flagcol+1);
     for flagrows=1:9
         if collection_matrix(flagrow,flagcol) == collection_matrix(flagrow+1,flagcol+1)
             codeword_matrix(original_one,flagcol) = encoding_matrix(flagrow+1,flagcol+1);
         end
     end
 end
end
%%to bring second codeword%%
sec_row = 2;
sec_col = 1;
original_two = 2;
for a=1:9
    if collection_matrix(sec_row,sec_col) == collection_matrix(sec_row,sec_col+1)
         codeword_matrix(original_two,sec_col) = encoding_matrix(sec_row,sec_col);
         sec_col = sec_col+1;
    else
         codeword_matrix(original_two,sec_col) = encoding_matrix(sec_row,sec_col+1);
         for sec_rows=1:9
             if collection_matrix(sec_row,sec_col) == collection_matrix(sec_row+1,sec_col+1)
                 codeword_matrix(original_two,sec_col) = encoding_matrix(sec_row+1,sec_col+1);
         end
     end
    end
end
%%to bring third code word%%
th_row = 2;  %%for third row
th_col = 0;  %%for third coloumn
original_row = 3;
num=1;
for i=1:8
    th_row = th_row+1;
    th_col = th_col+1;
    if th_row == 7
        th_row = th_row-num;
        num = 5;
    end
    if th_col == 7
        codeword_matrix(original_row,th_col) = encoding_matrix(th_row,th_col);
        codeword_matrix(original_row,th_col+1) = encoding_matrix(th_row-1,th_col+1);
        th_row = 1;
        continue;
    end
    if th_col == 8
        codeword_matrix(original_row,th_col+1) = encoding_matrix(th_row-1,th_col+1);
    end
    if collection_matrix(th_row,th_col) == collection_matrix(th_row,th_col+1)
        codeword_matrix(original_row , th_col) = encoding_matrix(th_row, th_col);
    elseif collection_matrix(th_row,th_col+1) == collection_matrix(th_row,th_col) + collection_matrix(th_row+1,th_col)
        codeword_matrix(original_row,th_col) = encoding_matrix(th_row,th_col);
        codeword_matrix(original_row,th_col +1) = encoding_matrix(th_row,th_col+1);
    else
        codeword_matrix(original_row,th_col+1) = encoding_matrix(th_row-3,th_col+1);
    end
     
end
%%to fourth codeword %%
original_four = 4;
f_row = 3; %for forth row
f_col = 0;
f_num = 2;
for i = 1:8
    f_row = f_row+1;
    f_col = f_col+1;
    if f_col == 1
        codeword_matrix(original_four,f_col) = encoding_matrix(f_row,f_col);
        continue;
    end
    if f_col == 2
        codeword_matrix(original_four,f_col) = encoding_matrix(f_row,f_col);
        continue;
    end
    if f_col == 3
        codeword_matrix(original_four,f_col) = encoding_matrix(f_row,f_col);
        continue;
    end
    if f_col == 4
        codeword_matrix(original_four,f_col) = encoding_matrix(f_row,f_col);
        f_row = f_row - f_num;
        f_num = 4;
        continue;
    end
    if f_col == 5
        codeword_matrix(original_four,f_col) = encoding_matrix(f_row,f_col);
        f_row = f_row -f_num;
        f_num = 1;
        continue;
    end
    if f_col == 6
        codeword_matrix(original_four,f_col) = encoding_matrix(f_row,f_col);
        f_row = f_row - f_num;
        f_num = 2;
        continue;
    end
    if f_col == 7
        codeword_matrix(original_four,f_col) = encoding_matrix(f_row,f_col);
        f_row = f_row - 2;
        continue;
    end
    if f_col == 8
        codeword_matrix(original_four,f_col) = encoding_matrix(f_row,f_col);
        codeword_matrix(original_four,f_col+1) = encoding_matrix(f_row-1,f_col+1);
        continue;
    end
    if f_col == 9
        break;
    end
   
end
%%to bring fifth symbol%%
original_five = 5;
five_row = 4;
five_col = 0;
for i = 1:8
    five_row = five_row+1;
    five_col = five_col+1;
    if five_col == 1
        codeword_matrix(original_five,five_col) = encoding_matrix(five_row,five_col);
        continue;
    end
    if five_col == 2
        codeword_matrix(original_five,five_col) = encoding_matrix(five_row,five_col);
        continue;
    end
    if five_col == 3
        codeword_matrix(original_five,five_col) = encoding_matrix(five_row,five_col);
        five_row = five_row - 3;
        continue;
    end
    if five_col == 4
        codeword_matrix(original_five,five_col) = encoding_matrix(five_row,five_col);
        five_row = five_row-1;
        continue;
    end
    if five_col == 5
        codeword_matrix(original_five,five_col) = encoding_matrix(five_row,five_col);
        five_row = five_row -3;
        continue;
    end
    if five_col == 6
        codeword_matrix(original_five,five_col) = encoding_matrix(five_row,five_col);
        five_row = five_row - 1;
        continue;
    end
    if five_col == 7
        codeword_matrix(original_five,five_col) = encoding_matrix(five_row,five_col);
        five_row = five_row -2;
        continue;
    end
    if five_col == 8
        codeword_matrix(original_five,five_col) = encoding_matrix(five_row,five_col);
        codeword_matrix(original_five,five_col+1) = encoding_matrix(five_row-1,five_col+1);
        continue;
    end
    if five_col == 9
        break;
    end
   
end
%%to bring six codeword%%
original_six = 6;
six_row = 5;
six_col = 0;
for i = 1:8
    six_row = six_row+1;
    six_col = six_col+1;
    if six_col == 1
        codeword_matrix(original_six,six_col) = encoding_matrix(six_row,six_col);
        continue;
    end
    if six_col == 2
        codeword_matrix(original_six,six_col) = encoding_matrix(six_row,six_col);
        continue;
    end
    if six_col == 3
        codeword_matrix(original_six,six_col) = encoding_matrix(six_row,six_col);
        six_row = six_row - 4;
        continue;
    end
    if six_col == 4
        codeword_matrix(original_six,six_col) = encoding_matrix(six_row,six_col);
        six_row = six_row-1;
        continue;
    end
    if six_col == 5
        codeword_matrix(original_six,six_col) = encoding_matrix(six_row,six_col);
        six_row = six_row -3;
        continue;
    end
    if six_col == 6
        codeword_matrix(original_six,six_col) = encoding_matrix(six_row,six_col);
        six_row = six_row - 1;
        continue;
    end
    if six_col == 7
        codeword_matrix(original_six,six_col) = encoding_matrix(six_row,six_col);
        six_row = six_row -2;
        continue;
    end
    if six_col == 8
        codeword_matrix(original_six,six_col) = encoding_matrix(six_row,six_col);
        codeword_matrix(original_six,six_col+1) = encoding_matrix(six_row-1,six_col+1);
        continue;
    end
    if six_col == 9
        break;
    end
   
end
codeword_matrix(1,9) = NaN;
codeword_matrix(2,9) = NaN;
%to bring seventh code word%
original_seven = 7;
seven_col = 0;
seven_row = 6;
for i = 1:8
    seven_row = seven_row+1;
    seven_col = seven_col+1;
    if seven_col == 1
        codeword_matrix(original_seven,seven_col) = encoding_matrix(seven_row,seven_col);
        continue;
    end
    if seven_col == 2
        codeword_matrix(original_seven,seven_col) = encoding_matrix(seven_row,seven_col);
        seven_row = seven_row -5;
       continue;
    end
    if seven_col == 3
        codeword_matrix(original_seven,seven_col) = encoding_matrix(seven_row,seven_col);
        seven_row = seven_row - 1;
        continue;
    end
    if seven_col == 4
        codeword_matrix(original_seven,seven_col) = encoding_matrix(seven_row,seven_col);
        seven_row = seven_row-1;
        continue;
    end
    if seven_col == 5
        codeword_matrix(original_seven,seven_col) = encoding_matrix(seven_row,seven_col);
        seven_row = 4;
        continue;
    end
    if seven_col == 6
        codeword_matrix(original_seven,seven_col) = encoding_matrix(seven_row,seven_col);
        seven_row = seven_row - 2;
        continue;
    end
    if seven_col == 7
        codeword_matrix(original_seven,seven_col) = encoding_matrix(seven_row,seven_col);
        seven_row = seven_row -3;
        continue;
    end
    if seven_col == 8
        codeword_matrix(original_seven,seven_col) = encoding_matrix(seven_row,seven_col);
        codeword_matrix(original_seven,seven_col+1) = encoding_matrix(seven_row-1,seven_col+1);
        continue;
    end
    if seven_col == 9
        break;
    end
   
end
%%to bring eighth codeword%%
original_eight = 8;
eight_row = 7;
eight_col = 0;
for i = 1:8
    eight_row = eight_row+1;
    eight_col = eight_col+1;
    if eight_col == 1
        codeword_matrix(original_eight,eight_col) = encoding_matrix(eight_row,eight_col);
        continue;
    end
    if eight_col == 2
        codeword_matrix(original_eight,eight_col) = encoding_matrix(eight_row,eight_col);
        eight_row = eight_row -6;
       continue;
    end
    if eight_col == 3
        codeword_matrix(original_eight,eight_col) = encoding_matrix(eight_row,eight_col);
        eight_row = eight_row - 1;
        continue;
    end
    if eight_col == 4
        codeword_matrix(original_eight,eight_col) = encoding_matrix(eight_row,eight_col);
        eight_row = eight_row-1;
        continue;
    end
    if eight_col == 5
        codeword_matrix(original_eight,eight_col) = encoding_matrix(eight_row,eight_col);
        eight_row = 4;
        continue;
    end
    if eight_col == 6
        codeword_matrix(original_eight,eight_col) = encoding_matrix(eight_row,eight_col);
        eight_row = eight_row - 2;
        continue;
    end
    if eight_col == 7
        codeword_matrix(original_eight,eight_col) = encoding_matrix(eight_row,eight_col);
        eight_row = eight_row -3;
        continue;
    end
    if eight_col == 8
        codeword_matrix(original_eight,eight_col) = encoding_matrix(eight_row,eight_col);
        codeword_matrix(original_eight,eight_col+1) = encoding_matrix(eight_row-1,eight_col+1);
        continue;
    end
    if eight_col == 9
        break;
    end
   
end
%to bring ninth codeword%
original_nine = 9;
nine_row = 8;
nine_col = 0;
for i = 1:8
    nine_row = nine_row+1;
    nine_col = nine_col+1;
    if nine_col == 1
        codeword_matrix(original_nine,nine_col) = encoding_matrix(nine_row,nine_col);
        nine_row = nine_row - 7;
        continue;
    end
    if nine_col == 2
        codeword_matrix(original_nine,nine_col) = encoding_matrix(nine_row,nine_col);
        nine_row = nine_row -1;
       continue;
    end
    if nine_col == 3
        codeword_matrix(original_nine,nine_col) = encoding_matrix(nine_row,nine_col);
        nine_row = nine_row - 1;
        continue;
    end
    if nine_col == 4
        codeword_matrix(original_nine,nine_col) = encoding_matrix(nine_row,nine_col);
        nine_row = nine_row-1;
        continue;
    end
    if nine_col == 5
        codeword_matrix(original_nine,nine_col) = encoding_matrix(nine_row,nine_col);
        nine_row = 3;
        continue;
    end
    if nine_col == 6
        codeword_matrix(original_nine,nine_col) = encoding_matrix(nine_row,nine_col);
        nine_row = nine_row - 1;
        continue;
    end
    if nine_col == 7
        codeword_matrix(original_nine,nine_col) = encoding_matrix(nine_row,nine_col);
        nine_row = nine_row -3;
        continue;
    end
    if nine_col == 8
        codeword_matrix(original_nine,nine_col) = encoding_matrix(nine_row,nine_col);
        codeword_matrix(original_nine,nine_col+1) = encoding_matrix(nine_row-1,nine_col+1);
        continue;
    end
    if nine_col == 9
        break;
    end
   
end
%to bring tenth codeword%
original_ten = 10;
ten_row = 9;
ten_col = 0;
for i = 1:8
    ten_row = ten_row+1;
    ten_col = ten_col+1;
    if ten_col == 1
        codeword_matrix(original_ten,ten_col) = encoding_matrix(ten_row,ten_col);
        ten_row = ten_row -8;
        continue;
    end
    if ten_col == 2
        codeword_matrix(original_ten,ten_col) = encoding_matrix(ten_row,ten_col);
        ten_row = ten_row -1;
       continue;
    end
    if ten_col == 3
        codeword_matrix(original_ten,ten_col) = encoding_matrix(ten_row,ten_col);
        ten_row = ten_row - 1;
        continue;
    end
    if ten_col == 4
        codeword_matrix(original_ten,ten_col) = encoding_matrix(ten_row,ten_col);
        ten_row = ten_row-1;
        continue;
    end
    if ten_col == 5
        codeword_matrix(original_ten,ten_col) = encoding_matrix(ten_row,ten_col);
        ten_row = 3;
        continue;
    end
    if ten_col == 6
        codeword_matrix(original_ten,ten_col) = encoding_matrix(ten_row,ten_col);
        ten_row = ten_row - 1;
        continue;
    end
    if ten_col == 7
        codeword_matrix(original_ten,ten_col) = encoding_matrix(ten_row,ten_col);
        ten_row = ten_row -3;
        continue;
    end
    if ten_col == 8
        codeword_matrix(original_ten,ten_col) = encoding_matrix(ten_row,ten_col);
        codeword_matrix(original_ten,ten_col+1) = encoding_matrix(ten_row-1,ten_col+1);
        continue;
    end
    if ten_col == 9
        break;
    end
   
end
% FOR FINAL CODEWORD %
final_codeword = []; %%for bringing the codeword swapped
%dict = {};
%swaping first column with 9th column%
swap1 = codeword_matrix(:,1);
codeword_matrix(:,1) = codeword_matrix(:,9);
codeword_matrix(:,9) = swap1;
% %swaping second column with 8th column%
swap2 = codeword_matrix(:,2);
codeword_matrix(:,2) = codeword_matrix(:,8);
codeword_matrix(:,8) = swap2;
% %swaping third column with 7th column%
swap3 = codeword_matrix(:,3);
codeword_matrix(:,3) = codeword_matrix(:,7);
codeword_matrix(:,7) = swap3;
% %swap forth coloumn with 6th column%
swap4 = codeword_matrix(:,4);
codeword_matrix(:,4) = codeword_matrix(:,6);
codeword_matrix(:,6) = swap4;
%making everysymbol goes to their codeword%
 codeword_matrix = num2cell(codeword_matrix);
 for i=1:size(codeword_matrix,1)
     for j=1:9
         if codeword_matrix{i,j} == 1 || codeword_matrix{i,j} == 0 
             continue;
         else
             codeword_matrix{i,j} = [];
         end
     end
 end
dict = {}; %%will contain symbol and the coresponding codeword
for i=1:size(grayLevels)
    dict{i,1} = grayLevels(i);
end
for i=1:size(grayLevels)
    if grayLevels(i,1) == 0
        dict{i,2} = [1];
   elseif grayLevels(i,1) == 80
            dict{i,2} = [0,1];
   elseif grayLevels(i,1) == 100
            dict{i,2} = [0,0,0,1,0];
   elseif grayLevels(i,1) == 125
            dict{i,2} = [0,0,0,1,1];
   elseif grayLevels(i,1) == 150
            dict{i,2} = [0,0,0,0,0];
   elseif grayLevels(i,1) == 175
            dict{i,2} =[0,0,0,0,1];
   elseif grayLevels(i,1) == 200
            dict{i,2} = [0,0,1,1,0];
   elseif grayLevels(i,1) == 215
            dict{i,2} = [0,0,1,1,1];
   elseif grayLevels(i,1) == 232
            dict{i,2} = [0,0,1,0,0];
   elseif grayLevels(i,1) == 255
            dict{i,2} = [0,0,1,0,1];
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
%%making input image 1 x 10000 to encode 
vector_size = 1;
for input_rows = 1:x
for input_cols = 1:y
input_image_array(vector_size) = input_image(input_rows,input_cols);
vector_size = vector_size+1;
end
end
count0 = 0;
count80 = 0;
count100=0;
count125 = 0;
count150 = 0;
count175 = 0;
count200 = 0;
count215 = 0;
count232 = 0;
count255 = 0;
%%Bringing the no of rep of each symbol%%
for i=1:length(input_image_array)
    if input_image_array(1,i) == 0
        count0 = count0 +1;
    elseif input_image_array(1,i) == 80
        count80 = count80+1;
    elseif input_image_array(1,i) == 100
        count100 = count100+1;
    elseif input_image_array(1,i) == 125
        count125 = count125+1;
    elseif input_image_array(1,i) == 150
        count150 = count150+1;
    elseif input_image_array(1,i) == 175
        count175 = count175+1;
    elseif input_image_array(1,i) == 200
        count200 = count200+1;
    elseif input_image_array(1,i) == 215
        count215 = count215+1;
    elseif input_image_array(1,i) == 232
        count232 = count232+1;
    else
        count255 = count255+1;
    end
end
%%map each codeword to their symbol%%
final_enco = [];
final_s1(1,:) = dict{1,2};
final_s2(1,:) = dict{81,2}; 
final_s3(1,:) = dict{101,2}; 
final_s4(1,:) = dict{126,2}; 
final_s5(1,:) = dict{151,2}; 
final_s6(1,:) = dict{176,2}; 
final_s7(1,:) = dict{201,2}; 
final_s8(1,:) = dict{216,2}; 
final_s9(1,:) = dict{233,2}; 
final_s10(1,:) = dict{256,2}; 
%Encoding Part%
for i =1:length(input_image_array)
    if input_image_array(1,i) == 0
        final_enco(1,i) = final_s1(1,1);
    end
end
 count_80 = 1;
 i = count0+1;
 sim = 0;
 for j=1:count80
     final_enco(1,i) = final_s2(1,count_80);
     final_enco(1,i+1) = final_s2(1,count_80+1);
     count_80 = 1;
     i = i+2;
 end
i = (count0 + length(final_s2) * count80)+1;
count_100 = 1;
 for j=1:count100
     final_enco(1,i) = final_s3(1,count_100);
      final_enco(1,i+1) = final_s3(1,count_100+1);
       final_enco(1,i+2) = final_s3(1,count_100+2);
        final_enco(1,i+3) = final_s3(1,count_100+3);
         final_enco(1,i+4) = final_s3(1,count_100+4);
         count_100 = 1;
         i = i+5;
 end
i = (count0 + length(final_s2) * count80 + length(final_s3)*count100)+1;
count_125 = 1;
 for j=1:count125
     final_enco(1,i) = final_s4(1,count_125);
     final_enco(1,i+1) = final_s4(1,count_125+1);
     final_enco(1,i+2) = final_s4(1,count_125+2);
     final_enco(1,i+3) = final_s4(1,count_125+3);
     final_enco(1,i+4) = final_s4(1,count_125+4);
     count_125 = 1;
     i = i+5;
 end
  i = (count0 + length(final_s2) * count80 + length(final_s3)*count100*2)+1;
 count_150 = 1;
 for j=1:count150
     final_enco(1,i) = final_s5(1,count_150);
     final_enco(1,i+1) = final_s5(1,count_150+1);
     final_enco(1,i+2) = final_s5(1,count_150+2);
     final_enco(1,i+3) = final_s5(1,count_150+3);
     final_enco(1,i+4) = final_s5(1,count_150+4);
     count_150 = 1;
     i = i+5;
 end
 i = (count0 + length(final_s2) * count80 + length(final_s3)*count100*3)+1;
 count_175 = 1;
 for j=1:count175
     final_enco(1,i) = final_s6(1,count_175);
     final_enco(1,i+1) = final_s6(1,count_175+1);
     final_enco(1,i+2) = final_s6(1,count_175+2);
     final_enco(1,i+3) = final_s6(1,count_175+3);
     final_enco(1,i+4) = final_s6(1,count_175+4);
     count_175 = 1;
     i = i+5;
 end
  i = (count0 + length(final_s2) * count80 + length(final_s3)*count100*4)+1;
 count_200 = 1;
 for j=1:count200
     final_enco(1,i) = final_s7(1,count_200);
     final_enco(1,i+1) = final_s7(1,count_200+1);
     final_enco(1,i+2) = final_s7(1,count_200+2);
     final_enco(1,i+3) = final_s7(1,count_200+3);
     final_enco(1,i+4) = final_s7(1,count_200+4);
     count_200 = 1;
     i = i+5;
 end
 i = (count0 + length(final_s2) * count80 + length(final_s3)*count100*5)+1;
 count_215 = 1;
 for j=1:count215
     final_enco(1,i) = final_s8(1,count_215);
     final_enco(1,i+1) = final_s8(1,count_215+1);
     final_enco(1,i+2) = final_s8(1,count_215+2);
     final_enco(1,i+3) = final_s8(1,count_215+3);
     final_enco(1,i+4) = final_s8(1,count_215+4);
     count_215 = 1;
     i = i+5;
 end
  i = (count0 + length(final_s2) * count80 + length(final_s3)*count100*6)+1;
 count_232 = 1;
 for j=1:count232
     final_enco(1,i) = final_s9(1,count_232);
     final_enco(1,i+1) = final_s9(1,count_232+1);
     final_enco(1,i+2) = final_s9(1,count_232+2);
     final_enco(1,i+3) = final_s9(1,count_232+3);
     final_enco(1,i+4) = final_s9(1,count_232+4);
     count_232 = 1;
     i = i+5;
 end
  i = (count0 + length(final_s2) * count80 + length(final_s3)*count100*7)+1;
 count_255 = 1;
 for j=1:count232
     final_enco(1,i) = final_s10(1,count_255);
     final_enco(1,i+1) = final_s10(1,count_255+1);
     final_enco(1,i+2) = final_s10(1,count_255+2);
     final_enco(1,i+3) = final_s10(1,count_255+3);
     final_enco(1,i+4) = final_s10(1,count_255+4);
     count_255 = 1;
     i = i+5;
 end
 %%% end of encoding%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

%% start of Decoding%%
summ2 = 0;
summ1 = 0;
final_dec = [];
%%%start of symbol 1%%%
for i = 1:count0
    if final_enco(1,i) == 1
        final_dec(1,i) = dict{1,1};
        summ1 = summ1 +1;
        if summ1 == count0
            break;
        end
    end
end
%%%end of symbol 1%%%

%%%start of symbol 2%%%
counts = 0;
summ2 = 0;
for i = 1:length(final_enco)
    if summ2 == count80
            break;
    end
    if final_enco(1,i) == 0 && final_enco(1,i+1) == 1
        %final_dec(1,i) = dict{81,1};
        counts = counts +1;
        if counts > 0
            final_dec(1,i-counts+1) = dict{81,1};
            summ2 = summ2 +1;
        end
    end
end
%%%end of symbol 2%%%
%%start of symbol 3 %%
summ3 = 0;
counts3 = 0;
for i = 1:length(final_enco)
    if final_enco(1,i) == 0 && final_enco(1,i+1) ==0 && final_enco(1,i+2) ==0 ...
            && final_enco(1,i+3) == 1 && final_enco(1,i+4) == 0
      counts3 =counts3+ 4 ;
      if counts3 > 0
          final_dec(1,i-counts3+4-2000) = dict{101,1};
          summ3 = summ3 +1;
      end
      if summ3 == count100
            break;
      end
    end
end
%%end of symbol 3 %%
%%start of symbol 4%%
counts4 = 0;
summ4 = 0;
 for i = 1:length(final_enco)
    if final_enco(1,i) == 0 && final_enco(1,i+1) ==0 && final_enco(1,i+2) ==0 ...
             && final_enco(1,i+3) == 1 && final_enco(1,i+4) == 1
       counts4 =counts4+ 4 ;
       if counts4> 0
             final_dec(1,i-counts4+4-4000) = dict{126,1};
             summ4 = summ4 +1;
       end
         if summ4 == count125
             break;
         end
    end
 end
 %%end of symbol 4%%
 %%start of symbol 5%%
 counts5 = 0;
summ5 = 0;
 for i = 1:5:length(final_enco)
     if final_enco(1,i) == 0 && final_enco(1,i+1) ==0 && final_enco(1,i+2) ==0 ...
             && final_enco(1,i+3) == 0 && final_enco(1,i+4) == 0
       counts5 =counts5+ 4 ;
       if counts5> 0
             final_dec(1,i-counts5+4-6000) = dict{151,1};
             summ5 = summ5 +1;
         end
         if summ5 == count150
              break;
         end
     end
 end
 %%end of symbol 5%%
 %%start of symbol 6%%
 counts6= 0;
summ6 = 0;
 for i = 1:5:length(final_enco)
     if final_enco(1,i) == 0 && final_enco(1,i+1) ==0 && final_enco(1,i+2) ==0 ...
             && final_enco(1,i+3) == 0 && final_enco(1,i+4) == 1
       counts6 =counts6+ 4 ;
       if counts6> 0
             final_dec(1,i-counts6+4-8000) = dict{176,1};
             summ6 = summ6 +1;
       end
       if summ6 == count175
           break;
       end    
     end      
 end
%%end of symbol 6%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %%start of stmbol 7%%
 counts7= 0;
 summ7 = 0;
  for i = 1:5:length(final_enco)
      if final_enco(1,i) == 0 && final_enco(1,i+1) ==0 && final_enco(1,i+2) ==1 ...
              && final_enco(1,i+3) == 1&& final_enco(1,i+4) == 0
        counts7 =counts7+ 4 ;
        if counts7> 0
              final_dec(1,i-counts7+4-10000) = dict{201,1};
              summ7 = summ7 +1;
        end
        if summ7 == count200
            break;
        end          
      end         
  end
  %%end of symbol 7%%
  %%start of symbol 8%%
 counts8= 0;
 summ8 = 0;
  for i = 1:5:length(final_enco)
      if final_enco(1,i) == 0 && final_enco(1,i+1) ==0 && final_enco(1,i+2) ==1 ...
              && final_enco(1,i+3) == 1 && final_enco(1,i+4) == 1
        counts8 =counts8+ 4 ;
        if counts8> 0
              final_dec(1,i-counts8+4-12000) = dict{216,1};
              summ8 = summ8 +1;
        end
        if summ8 == count215
            break;
        end
      end
  end
  %%end of symbol 8%%
  %%start of symbol 9 %%
  counts9= 0;
 summ9 = 0;
  for i = 1:5:length(final_enco)
      if final_enco(1,i) == 0 && final_enco(1,i+1) ==0 && final_enco(1,i+2) ==1 ...
              && final_enco(1,i+3) == 0 && final_enco(1,i+4) == 0
        counts9 =counts9+ 4 ;
        if counts9> 0
              final_dec(1,i-counts9+4-14000) = dict{233,1};
              summ9 = summ9 +1;
        end
         if summ9 == count232
             break;
         end
      end
  end
  %%end of symbol 9%%
  %%start of symbol 10%%
  counts10= 0;
 summ10 = 0;
  for i = 1:5:length(final_enco)
      if final_enco(1,i) == 0 && final_enco(1,i+1) ==0 && final_enco(1,i+2) ==1 ...
              && final_enco(1,i+3) == 0 && final_enco(1,i+4) == 1
        counts10 =counts10+ 4 ;         
          if counts10> 0
              final_dec(1,i-counts10+4-16000) = dict{256,1};
              summ10 = summ10 +1;
          end
          if summ10 == count255
              break;
          end
      end
  end
  %%converting the 1 x 10000 matrix to 100 x 100 to write the image
dec_row = 1;
dec_col = 1;
array_size = 1;
for i = 1:x
 for j = 1:y
final_matrix(i,j)=final_dec(array_size);
dec_col = dec_col+1;
array_size = array_size + 1;
 end
dec_row = dec_row+1;
end
final_matrix = uint8(final_matrix); %%from double to uint8%%
%folder = 'C:\Users\High LInk\Desktop\IT project';  %%change the path wherever you save the file
%imwrite(final_matrix,fullfile(folder,'project_image1.png'));
figure;
imshow(final_matrix);
%%end of decoding%%