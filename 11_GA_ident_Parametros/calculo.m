function [out] = calculo(parameters)
system('TASKKILL/IM lsprepost4.8_x64.exe'); %cerrar LSprepost
system('TASKKILL/IM Y.exe')
main(parameters)
execute_file=compose("start  Y.exe   %s.y",'actual');
system(execute_file)
pause(17)
system('TASKKILL/IM Y.exe')
%Leer resultados
POST.NAME=compose("%s.cfile",'actual');         
fileID = fopen(POST.NAME,'w');
fprintf(fileID,'open d3plot "%s%s"\n',...
    'C:\Opt_LS\puente_ident_parametros\','actual');
fprintf(fileID,'genselect target node \n');
fprintf(fileID,'genselect node add node 708/0 \n');
fprintf(fileID,'genselect node add node 709/0 \n');
fprintf(fileID,'genselect node add node 713/0 \n');
fprintf(fileID,'genselect node add node 714/0 \n');
fprintf(fileID,'genselect node add node 718/0 \n');
fprintf(fileID,'genselect node add node 719/0 \n');
fprintf(fileID,'genselect node add node 723/0 \n');
fprintf(fileID,'genselect node add node 724/0 \n');
fprintf(fileID,'genselect node add node 728/0 \n');
fprintf(fileID,'genselect node add node 729/0 \n');
fprintf(fileID,'genselect node add node 733/0 \n');
fprintf(fileID,'genselect node add node 734/0 \n');
fprintf(fileID,'genselect node add node 738/0 \n');
fprintf(fileID,'genselect node add node 739/0 \n');
fprintf(fileID,'genselect node add node 743/0 \n');
fprintf(fileID,'genselect node add node 744/0 \n');
fprintf(fileID,'genselect node add node 748/0 \n');
fprintf(fileID,'genselect node add node 749/0 \n');
fprintf(fileID,'genselect node add node 753/0 \n');
fprintf(fileID,'genselect node add node 754/0 \n');
fprintf(fileID,'genselect node add node 758/0 \n');
fprintf(fileID,'genselect node add node 759/0 \n');
fprintf(fileID,'genselect node add node 763/0 \n');
fprintf(fileID,'genselect node add node 764/0 \n');
fprintf(fileID,'genselect node add node 768/0 \n');
fprintf(fileID,'genselect node add node 769/0 \n');
fprintf(fileID,'genselect node add node 773/0 \n');
fprintf(fileID,'genselect node add node 774/0 \n');
fprintf(fileID,'genselect node add node 778/0 \n');
fprintf(fileID,'genselect node add node 779/0 \n');
fprintf(fileID,'genselect node add node 783/0 \n');
fprintf(fileID,'genselect node add node 784/0 \n');
fprintf(fileID,'genselect node add node 788/0 \n');
fprintf(fileID,'genselect node add node 789/0 \n');
fprintf(fileID,'genselect node add node 793/0 \n');
fprintf(fileID,'genselect node add node 794/0 \n');
fprintf(fileID,'genselect node add node 798/0 \n');
fprintf(fileID,'genselect node add node 799/0 \n');
fprintf(fileID,'genselect node add node 803/0 \n');
fprintf(fileID,'genselect node add node 804/0 \n');
%arco
fprintf(fileID,'genselect node add node 3/0 \n');
fprintf(fileID,'genselect node add node 4/0 \n');
fprintf(fileID,'genselect node add node 8/0 \n');
fprintf(fileID,'genselect node add node 9/0 \n');
fprintf(fileID,'genselect node add node 13/0 \n');
fprintf(fileID,'genselect node add node 14/0 \n');
fprintf(fileID,'genselect node add node 18/0 \n');
fprintf(fileID,'genselect node add node 19/0 \n');
fprintf(fileID,'genselect node add node 23/0 \n');
fprintf(fileID,'genselect node add node 24/0 \n');
fprintf(fileID,'genselect node add node 28/0 \n');
fprintf(fileID,'genselect node add node 29/0 \n');
fprintf(fileID,'genselect node add node 33/0 \n');
fprintf(fileID,'genselect node add node 34/0 \n');
fprintf(fileID,'genselect node add node 38/0 \n');
fprintf(fileID,'genselect node add node 39/0 \n');
fprintf(fileID,'genselect node add node 43/0 \n');
fprintf(fileID,'genselect node add node 44/0 \n');
fprintf(fileID,'genselect node add node 48/0 \n');
fprintf(fileID,'genselect node add node 49/0 \n');
fprintf(fileID,'genselect node add node 53/0 \n');
fprintf(fileID,'genselect node add node 54/0 \n');
fprintf(fileID,'genselect node add node 58/0 \n');
fprintf(fileID,'genselect node add node 59/0 \n');
fprintf(fileID,'genselect node add node 63/0 \n');
fprintf(fileID,'genselect node add node 64/0 \n');
fprintf(fileID,'genselect node add node 68/0 \n');
fprintf(fileID,'genselect node add node 69/0 \n');
fprintf(fileID,'genselect node add node 73/0 \n');
fprintf(fileID,'genselect node add node 74/0 \n');
fprintf(fileID,'genselect node add node 78/0 \n');
fprintf(fileID,'genselect node add node 79/0 \n');
fprintf(fileID,'genselect node add node 83/0 \n');
fprintf(fileID,'genselect node add node 84/0 \n');
fprintf(fileID,'genselect node add node 88/0 \n');
fprintf(fileID,'genselect node add node 89/0 \n');
fprintf(fileID,'genselect node add node 93/0 \n');
fprintf(fileID,'genselect node add node 94/0 \n');
fprintf(fileID,'ntime 6  \n');
fprintf(fileID,'xyplot 1 savefile ms_csv "%s%s.csv" 1 all \n',...
    'C:\Opt_LS\puente_ident_parametros\','actual');
fclose(fileID);
%Exportar resultados de LS-Prepost
execute_file=compose("start LS-PrePost %s.cfile",'actual');
system(execute_file)
pause(7)
system('TASKKILL/IM lsprepost4.8_x64.exe'); %cerrar LSprepost
system('TASKKILL/IM lsprepost4.8_x64.exe'); %cerrar LSprepost
namecsv=compose("%s.csv",'actual');
out=readtable(namecsv);
out=table2array(out(end,2:end-1))';
end