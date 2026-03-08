clc
clear
load("E:\2019-01-24_batchdata_updated_struct_errorcorrect.mat")

num_exp = length(batch);
json_struct = struct();
for j=1:num_exp
    json_struct.(batch(j).barcode) = batch(j).cycle_life;
end

JSONFILE_name= sprintf('Attia.json'); 
fid=fopen(JSONFILE_name,'w');
encodedJSON = jsonencode(json_struct); 
fprintf(fid, encodedJSON); 