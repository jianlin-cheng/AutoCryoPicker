function save_particles(name,particles_centers,particles_BOX_dimenstions)
name=strrep(name,' ','_');
date=datestr(now,29);
FileName=[name '_' date '.txt'];

file=fopen(FileName,'wt');
fprintf(file,'%s \n','-------------------------------------------------------------------');
fprintf(file,'%s \n','© Bioinformatics, Data Mining, and Machine Learning Lab (BDM) ');
fprintf(file,'%s \n','University of Missouri-Columbia, MO, USA ');
fprintf(file,'%s \n','Contact: Dr.Jianlin Cheng ');
fprintf(file,'%s \n','         chengji@missouri.edu ');
fprintf(file,'%s \n','-------------------------------------------------------------------');
fprintf(file,'%s \n','-------------------------------------------------------------------');
fprintf(file,'%s \n',['Name: ' name]);
fprintf(file,'%s \n',['Date: ' date]);
fprintf(file,'%s','Number of Particles: ');
fprintf(file,'%2.0f \n',size(particles_centers,1));
fprintf(file,'%s \n','-------------------------------------------------------------------');
fprintf(file,'%s \n','-------------------------------------------------------------------');
fprintf(file,'%s \n','Particles Positions :');
fprintf(file,'%s \n','-------------------------------------------------------------------');
fprintf(file,'%s \n','Center(X)  Center(Y)     Box(X1)      Box(Y1)     Box(X2)     Box(Y2)  ');
fprintf(file,'  %3.0f \t     %3.0f \t   %3.0f \t       %3.0f \t    %3.0f \t%3.0f \t\n',particles_centers,particles_BOX_dimenstions);
fprintf(file,'%s \n','-------------------------------------------------------------------');
fclose(file);


