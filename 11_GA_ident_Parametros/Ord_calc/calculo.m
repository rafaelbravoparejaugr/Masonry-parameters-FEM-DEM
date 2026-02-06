function calculo(lad,name)

main(lad,name)
%% Calculo Y
execute_file=compose("gnome-terminal -e './Y %g.y'",name);
system(execute_file)
%pause(2)
end