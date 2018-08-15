%% CryoEm Pre-processing Step...
%==========================================================================
% Adil Al-Azzawi & Jianlin Cheng
% University of Missouri-Columbia 
% aaadn5@mail.missouri.edu
%==========================================================================
% Issue: 
% Sine our CryoEm dataset in raw format which have not been pre-processed 
% before, ijn this case those images have CTF problem.
%
% Tool description: 
% in this step we are trying to solve the Constrast Transfer Function 
% (CTF) issue based on the the constrast function to create an Adjust Contrast 
% tool. 
% The Adjust Contrast tool is an interactive contrast and brightness adjustment
% tool that you can use to adjust the black-to-white mapping used to display 
% a grayscale image. For more information about using the tool
%__________________________________________________________________________
clc;
disp('___________________________________________________________');
disp('                                                           ');
disp('D  E  E  P  -  C  R  Y  O  -  E  M  -  P  R  O  J  E  C  T ');
disp('         P R E - P R O C E S S I N G - S T E P             ');
disp('___________________________________________________________');
disp(' ');
%
%% Step(1): Initalization... 
%CryoEm folder
CryoEM_images_dir='C:\Users\Adil Al-Azzawi\Desktop\Fully Auotomated Single Particles Picking in cryo-EM\apoferritin_after_averaging';
%code folder
code_dir='C:\Users\Adil Al-Azzawi\Desktop\Protein Project\Matlab Code\Pre-processing Stage';
%output folder
CryoEm_output_dir='C:\Users\Adil Al-Azzawi\Desktop\Protein Project\Pre_processed CryoEM\';
%
consuming_time=zeros(1,30);
%change the directory to the skin cancer images...
cd(CryoEM_images_dir);
D = dir('*.png');
    for n = 1:numel(D)
        close all;
        fprintf('The CryoEm Image No. : %d\n',n');
        tic;
        %% Step(1): CryoEm images Reading... 
        % Cryo-EM reading
        cd(CryoEM_images_dir);
        originalImage = imread(D(n).name);
        subplot(4,4,1); imshow(originalImage);title('Original CryoEm Image')
        % Compute the original image histogram
        subplot(4,4,2); imhist(originalImage);title('Histogram of the Original Cryo-Image');
        normalized_CryoEm = double(originalImage)./double(max(originalImage(:)));
        %
        %% Step(2): CryoEm images Quality Measurment... 
        img=double(normalized_CryoEm);
        [M,N]=size(img);
        signal=mean(img(:));
        noise=std(img(:));
        % Calculate the Mean Sequare Error Ratio (MSE) 
        MSE_value1=signal-noise;
        % Calculate the Peak Signal to Signal Noise Ratio (PSNR)
        PSNR_value1=abs(10*log10((M*N)/MSE_value1)); 
        % Calculate the Signal to Noise Ratio (SNR)
        SNR_value1=abs(10*log10(signal/noise));
        %
        %% Step(2): CryoEm images Processing... 
        %
        % Image Normalization
        cd(CryoEM_images_dir);
        originalImage = imread(D(n).name);
        normalized_CryoEm = double(originalImage)./double(max(originalImage(:)));
        %
        subplot(4,4,3); imshow(normalized_CryoEm);title('Normalized CryoEm Image')
        % Compute the normalized image histogram
        subplot(4,4,4); imhist(normalized_CryoEm);title('Histogram of the Normalized Cryo-Image');
        % Image adjusment
        limit=stretchlim(normalized_CryoEm);
        ad=imadjust(normalized_CryoEm,[limit(1) limit(2)]);  
        subplot(4,4,5);imshow(ad);title('CTF Image Adjusment')
        subplot(4,4,6); imhist(ad);title('Histogram of the CTF Image Adjusment');
        % Image Restoration
        I = histeq(ad);
        K = wiener2(I,[5 5]);
        subplot(4,4,7); imshow(K);title('Restored Image');
        subplot(4,4,8); imhist(K);title('Histogram of the Restored Image');
        % Cryo-EM Histo-Equalization
        I = histeq(K);
        subplot(4,4,9); imshow(I);title('Cryo-EM Histo-Equalization')
        subplot(4,4,10); imhist(I);title('Histogram of the Cryo-EM Histo-Equalization');
        % Adaptive Cryo-EM Histo-Equal.
        g=adapthisteq(I,'clipLimit',.02,'Distribution','rayleigh');
        % Adaptive Cryo-EM Histo-Equal.
        im=adapthisteq(g,'clipLimit',.99,'Distribution','rayleigh');
        subplot(4,4,11);imshow(im);title('Adaptive Histo-Equal.')
        subplot(4,4,12); imhist(im);title('Histogram of the Adaptive Cryo-EM Histo-Equal.');
        % Gaudided Filtering
        im=imguidedfilter(im);im=imguidedfilter(im);
        im=imguidedfilter(im);im=imguidedfilter(im);
        im=imadjust(im);
        subplot(4,4,13);imshow(im);title('Gaudided Filtering');
        subplot(4,4,14); imhist(im);title('Histogram of the Gaudided Filtering');
        % Morphological Operation
        SE=strel('disk',5);J = imclose(im,SE);J2=imadjust(J,[.1,.9]);
        subplot(4,4,15);imshow(J2);title('Post-processing Morphological Operation')
        subplot(4,4,16); imhist(J2);title('Histogram of the Post-processing CryoEM');
        % Save the processed CryoEm image ...
        imwrite(im, [CryoEm_output_dir D(n).name],'tif');   
        % Change the Code direction
        cd(code_dir);
        %
        %% Step(3): CryoEm Images Quality estimation... 
        % 
        normalized_CryoEm=double(normalized_CryoEm);
        im=double(im);
        [M,N]=size(img);
        signal2=mean(im(:));
        noise2=std(normalized_CryoEm(:));
        % Calculate the Mean Sequare Error Ratio (MSE) 
        MSE_value2=signal2-noise2;
        % Calculate the Peak Signal to Signal Noise Ratio (PSNR)
        PSNR_value2=abs(10*log10((M*N)/MSE_value2));
        % Calculate the Signal to Noise Ratio (SNR)
        SNR_value2=abs(10*log10(signal2/noise2));
        % Display the Results
        disp('________________________________________________________________');
        disp(' ');
        disp('    C R Y O - E M - I M A G E - Q U A L I T Y - M E A S U R E   ');
        disp('                 O R I G I N A L - I M A G E S                  ');
        disp('                     P S N R - and - M S E                      ');
        disp('________________________________________________________________');
        disp(' ');
        fprintf(' 1:Peak Signal to Noise Ratio (PSNR) is : %5.5f\n', PSNR_value1);
        fprintf(' 3:Mean Squared Error (MSE)          is : %5.8f \n', MSE_value1);
        fprintf(' 5:Signal to Noise Ratio (SNR)       is : %5.5f dB \n', SNR_value2);
        disp('________________________________________________________________');
        %
        PSNR_values1(n)=abs(PSNR_value1);
        MSE_values1(n)=abs(MSE_value1);
        SNR_values1(n)=abs(SNR_value1);
        % Display the Results
        disp('________________________________________________________________');
        disp(' ');
        disp('    C R Y O - E M - I M A G E - Q U A L I T Y - M E A S U R E   ');
        disp('           P R E - P R O C E S S E D - I M A G E S              ');
        disp('                     P S N R - and - M S E                      ');
        disp('________________________________________________________________');
        disp(' ');
        fprintf(' 1:Peak Signal to Noise Ratio (PSNR) is : %5.5f\n', abs(PSNR_value2));
        fprintf(' 3:Mean Squared Error (MSE)          is : %5.8f \n', MSE_value2);
        fprintf(' 5:Signal to Noise Ratio (SNR)       is : %5.5f dB \n', SNR_value1);
        disp('________________________________________________________________');
        %
        % get the the Average time consuming
        consuming_time(n)=toc;
        PSNR_values2(n)=abs(PSNR_value2);
        MSE_values2(n)=abs(MSE_value2);
        SNR_values2(n)=abs(SNR_value2);
        %%
%         pause;
        cd(CryoEM_images_dir);
        close all;
    end
disp('All The CryoEm images pre-processing have been done ...');
disp('________________________________________________________________');
disp(' ');
disp('    C R Y O - E M - I M A G E - Q U A L I T Y - M E A S U R E   ');
disp('                     P S N R - and - M S E                      ');
disp('________________________________________________________________');
disp(' ');
fprintf(' Average Peak Signal to Noise Ratio (PSNR) for the Original CryoEM is : %5.5f\n', mean(PSNR_value1));
fprintf(' Average Mean Squared Error (MSE) for the Original CryoEM is : %5.5f\n', mean(MSE_value1));
fprintf(' Average Signal to Noise Ratio (SNR) for the Original CryoEM is : %5.5f\n', mean(SNR_values2));
disp(' ');
fprintf(' Average Peak Signal to Noise Ratio (PSNR) for the Pre-processed CryoEM is : %5.5f\n', mean(PSNR_value2));
fprintf(' Average Mean Squared Error (MSE) for the Pre-processed CryoEM is : %5.5f\n', mean(MSE_value2));
fprintf(' Average Signal to Noise Ratio (SNR) for the Pre-processed CryoEM is : %5.5f\n', mean(SNR_values1));
%
figure;
plot(PSNR_values1);
title('CryoEM Images PSNR Quality Estimation')
xlabel('No. of CryoEm Images')
ylabel('Peak Signal to Signal Noise Ratio (PSNR)');

figure;
plot(PSNR_values2);
title('Pre-processing CryoEM Images PSNR Quality Estimation')
xlabel('No. of CryoEm Images')
ylabel('Peak Signal to Signal Noise Ratio (PSNR)');

figure;
plot(SNR_values2);
title('CryoEM Images SNR Quality Estimation')
xlabel('No. of CryoEm Images')
ylabel('Mean Sequare Error Ratio (MSE)');

figure;
plot(SNR_values1);
title('Pre-processing CryoEM Images SNR Quality Estimation')
xlabel('No. of CryoEm Images')
ylabel('Mean Sequare Error Ratio (MSE)');

figure;
plot(PSNR_values1);
title('CryoEM Images MSE Quality Estimation')
xlabel('No. of CryoEm Images')
ylabel('Signal to Noise Ratio (PSNR)');

figure;
plot(PSNR_values2);
title('Pre-processing CryoEM Images MSE Quality Estimation')
xlabel('No. of CryoEm Images')
ylabel('Signal to Noise Ratio (PSNR)');

%
average_time=mean(consuming_time);
fprintf('The Average Consuming time t is : %f\n',average_time);

%%
clc;
disp('________________________________________________________________');
disp(' ');
disp('    C R Y O - E M - I M A G E - Q U A L I T Y - M E A S U R E   ');
disp('   PAIRED  SAMPLE OF  T-TEST  PEAK SIGNAL TO NOISE RATIO (PSNR) ');
disp('________________________________________________________________');
disp(' ');
[h,p,ci,stats]  = ttest(PSNR_values2,PSNR_values1);
fprintf(' The Hypothesis test result (h) is : %d\n', h);
fprintf(' The  p-value (probability of observing a test statistic) is : %d\n', p);
fprintf(' The Confidence interval for the true population mean (ci) is : \n');
fprintf('     The lower boundaries of the 100�(1�Alpha) %% confidence interval (ci) is : %5.5f\n', ci(1));
fprintf('     The upper boundaries of the 100�(1�Alpha) %% confidence interval (ci) is : %5.5f\n', ci(2));
fprintf(' The test statistics (value of the test statistic) is : %5.5f\n', stats.tstat);
fprintf(' Test statistics (the degrees of freedom of the test) is : %d\n', stats.df);
fprintf(' Test statistics (the estimated population standard deviation) is : %5.4f\n', stats.sd);
%
disp('________________________________________________________________');
disp(' ');
disp('    C R Y O - E M - I M A G E - Q U A L I T Y - M E A S U R E   ');
disp('      PAIRED  SAMPLE OF  T-TEST  SIGNAL TO SOIZE RATION (SNR)   ');
disp('________________________________________________________________');
disp(' ');
[h,p,ci,stats]  = ttest(SNR_values1,SNR_values2);
fprintf(' The Hypothesis test result (h) is : %d\n', h);
fprintf(' The probability of observing a test statistic (p) is : %d\n', p);
fprintf('     The lower boundaries of the 100�(1�Alpha) %% confidence interval (ci) is : %5.5f\n', ci(1));
fprintf('     The upper boundaries of the 100�(1�Alpha) %% confidence interval (ci) is : %5.5f\n', ci(2));
fprintf(' The test statistics (value of the test statistic) is : %5.5f\n', stats.tstat);
fprintf(' Test statistics (the egrees of freedom of the test) is : %d\n', stats.df);
fprintf(' Test statistics (the estimated population standard deviation) is : %5.4f\n', stats.sd);
%
disp('________________________________________________________________');
disp(' ');
disp('    C R Y O - E M - I M A G E - Q U A L I T Y - M E A S U R E   ');
disp('       PAIRED  SAMPLE OF  T-TEST MEAN SQUARE ERROR (MSE)        ');
disp('________________________________________________________________');
disp(' ');
[h,p,ci,stats]  = ttest(MSE_values1,MSE_values2);
fprintf(' The Hypothesis test result (h) is : %d\n', h);
fprintf(' The probability of observing a test statistic (p) is : %d\n', p);
fprintf('     The lower boundaries of the 100�(1�Alpha) %% confidence interval (ci) is : %5.5f\n', ci(1));
fprintf('     The upper boundaries of the 100�(1�Alpha) %% confidence interval (ci) is : %5.5f\n', ci(2));
fprintf(' The test statistics (value of the test statistic) is : %5.5f\n', stats.tstat);
fprintf(' Test statistics (the egrees of freedom of the test) is : %d\n', stats.df);
fprintf(' Test statistics (the estimated population standard deviation) is : %5.4f\n', stats.sd);
%%
% PSNR
rng default; % For reproducibility
histfit(PSNR_values1,10,'normal')
title('PSNR Distribution for the Original CryoEM Images');

figure
rng default; % For reproducibility
histfit(PSNR_values2,10,'normal')
title('PSNR Distribution for the Pre-processed CryoEM Images');

% SNR
figure
rng default; % For reproducibility
histfit(SNR_values2,10,'normal')
title('SNR Distribution for the Original CryoEM Images');
figure
rng default; % For reproducibility
histfit(SNR_values1,10,'normal')
title('SNR Distribution for the Pre-processed CryoEM Images');

% MSE
figure
rng default; % For reproducibility
histfit(MSE_values1,10,'normal')
title('MSE Distribution for the Original CryoEM Images');
figure
rng default; % For reproducibility
histfit(MSE_values2,10,'normal')
title('MSE Distribution for the Pre-processed CryoEM Images');
