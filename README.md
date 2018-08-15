# AutoCryoPicker
Unsupervised Learning Approach for Fully Automated Single Particle Picking in Cryo-EM Images

cryo-EM Images Dataset:
  - The dataset that has been used in this repository is dowloaded from the cryo-EM data bank "EMPIAR".
  - The dataset name is "EMPIAR-10146"- Apoferritin tutorial dataset for cisTEM.
  - Dataset description is avaliable in https://www.ebi.ac.uk/pdbe/emdb/empiar/entry/10146/#&gid=1&pid=1

This repository has diferent files such as:
   1- The first folder is the "cryo-EM Dataset" which has diferent folders such as:
       a- The first folder is "Apoferritin_cryo-EM_Dataset_after_averaging_EMAN2" which is the cryo-EM after converted to PNG using EMAN2.
       b- The second folder is "Apoferritin_cryo-EM_Dataset_without_averaging" which is the same dataset image without averaging.
   2- The second folder is the "Main File" which has all the matlab code files that is required to run the system.
       a- The first matlab code folder is the "Pre-processing Stage" which is used to preprocessed the whole images dataset and plot the 
          average results of the PSNR, SNR, and MSE, ans well as to the student-t test.
       b- The second folder is the "Signle Particle Detection_Demo" which is the single particle picking without the GUI version.
          - To run this task you have to go to the main matlab file "AutoPicker_Demo1" just you need to update the dataset folder 
             directoty and CLICK run in matlab.
          - In this case the program will as you to select one single image then the program will auotomatically runs and display the 
             single particles detection and picking.
       c- Finally, there is a GUI version called "Guide User Interface_GUI" which is all in one, you need just to go directly to the 
          "AutoCryoPicking" or "AutoCryoPicking" then run it.
          - the system will asks again to upload one single cryo-EM image then there is some other options such as:
              - Load cryo-EM : for load any7 cryo-EM for testing.
              - Pre-processing (cryo-EM) : for doing the preprocessing task for the tested image.
              - Particles Detection and Picking: for detect and picking the particles in the tested image.
              - Performance Results: In this case 
                                      - if you want to get the accuracy results and aother measurement you have to have a GT for
                                        each tested image we have already provide two images.
                                      - in this case, we have to select the GT image and the system will automatically calculate and
                                        display all the performnace results once you click of the "Particles Picking Accuracy"
             - cryo-EM projection: This task is to extract the BOX for each single particle.
             - Export Particles: This task is to extract the box dimension and the particle center information to *.TXT file.
