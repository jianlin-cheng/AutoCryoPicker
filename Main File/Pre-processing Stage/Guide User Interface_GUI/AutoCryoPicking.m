function varargout = AutoCryoPicking(varargin)
% AUTOCRYOPICKING M-file for AutoCryoPicking.fig
%      AUTOCRYOPICKING, by itself, creates a new AUTOCRYOPICKING or raises the existing
%      singleton*.
%
%      H = AUTOCRYOPICKING returns the handle to a new AUTOCRYOPICKING or the handle to
%      the existing singleton*.
%
%      AUTOCRYOPICKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AUTOCRYOPICKING.M with the given input arguments.
%
%      AUTOCRYOPICKING('Property','Value',...) creates a new AUTOCRYOPICKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AutoCryoPicking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AutoCryoPicking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AutoCryoPicking

% Last Modified by GUIDE v2.5 09-Aug-2018 12:00:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AutoCryoPicking_OpeningFcn, ...
                   'gui_OutputFcn',  @AutoCryoPicking_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AutoCryoPicking is made visible.
function AutoCryoPicking_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AutoCryoPicking (see VARARGIN)

% Choose default command line output for AutoCryoPicking
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AutoCryoPicking wait for user response (see UIRESUME)
% uiwait(handles.AutoCryoPicking);
set(handles.preprocessing,'enable','off');
set(handles.clustering,'enable','off');
set(handles.particlespicking,'enable','off');
set(handles.uipanel17,'Visible','off');
set(handles.uipanel16,'Visible','on');
axes(handles.axes21)
logo1=imread('logo2.bmp');
imshow(logo1)
set(gca,'tag','axes21')
axes(handles.axes22)
logo1=imread('logo1.bmp');
imshow(logo1)
set(gca,'tag','axes22')


% --- Outputs from this function are returned to the command line.
function varargout = AutoCryoPicking_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in OriginalImage.
function OriginalImage_Callback(hObject, eventdata, handles)
% hObject    handle to OriginalImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OriginalImage
if get(hObject,'value')==1
    set(handles.WhiteImage,'value',0)
    set(handles.Skeleton,'value',0)
end

% --- Executes on button press in preprocessing.
function preprocessing_Callback(hObject, eventdata, handles)
% hObject    handle to preprocessing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global J2;
global z;
set(handles.clustering,'enable','on');
I=getappdata(handles.FingerPrintGUI,'OriginalImage');
% read the MRI image from the spesific directory
MRC=I;
z=mat2gray(MRC);
axes(handles.axes1)
imshow(MRC);title('Original Cryo-EM')
set(gca,'tag','axes1')
% 
originalImage=MRC;
Inormalized = z;
%
img=double(Inormalized);
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
% figure;imshow(Inormalized);title('Original Cryo-EM Image')
limit=stretchlim(Inormalized);
ad=imadjust(Inormalized,[limit(1) limit(2)]); 
%
axes(handles.axes2)
imshow(ad);title('CTF cryo-EM Image')
set(gca,'tag','axes2')
axes(handles.axes3)
imhist(ad);title('Histogram of Cryo-EM')
set(gca,'tag','axes3')
%
I = histeq(ad);
K = wiener2(I,[5 5]);
axes(handles.axes4)
imshow(K);title('Restored cryo-EM')
set(gca,'tag','axes4')
axes(handles.axes5)
imhist(K);title('Histogram of Cryo-EM')
set(gca,'tag','axes5')
%
I = histeq(K);
% subplot(3,3,3); 
axes(handles.axes6)
imshow(I);title('Cryo-EM Histo-Equalization')
set(gca,'tag','axes6')
axes(handles.axes7)
imhist(K);title('Histogram of Cryo-EM')
set(gca,'tag','axes7')
%
g=adapthisteq(I,'clipLimit',.02,'Distribution','rayleigh');
im=adapthisteq(g,'clipLimit',.99,'Distribution','rayleigh');
axes(handles.axes8)
imshow(im);title('Adaptive Cryo-EM Histo-Equal.')
set(gca,'tag','axes8')
axes(handles.axes9)
imhist(im);title('Histogram of Cryo-EM')
set(gca,'tag','axes9')
% 
im=imguidedfilter(im);im=imguidedfilter(im);
im=imguidedfilter(im);im=imguidedfilter(im);
im=imadjust(im);
axes(handles.axes10)
imshow(im);title('Gaudided Filtering')
set(gca,'tag','axes10')
axes(handles.axes11)
imhist(im);title('Histogram of Cryo-EM')
set(gca,'tag','axes11')
%
imcl=imopen(im,strel('disk',1));
imcl=imopen(imcl,strel('disk',1));
imcl=imopen(imcl,strel('disk',1));
imcl=imopen(imcl,strel('disk',1));
imcl=imopen(imcl,strel('disk',1));
J2=imcl;
axes(handles.axes12)
imshow(J2,[]);title('Cryo-EM Morphological Operation')
set(gca,'tag','axes12')
axes(handles.axes13)
imhist(im);title('Histogram of Cryo-EM')
set(gca,'tag','axes13')
%
im=double(im);
[M,N]=size(im);
signal2=mean(im(:));
noise2=std(im(:));
% Calculate the Mean Sequare Error Ratio (MSE) 
MSE_value2=signal2-noise2;
% Calculate the Peak Signal to Signal Noise Ratio (PSNR)
PSNR_value2=abs(10*log10((M*N)/MSE_value2));
% Calculate the Signal to Noise Ratio (SNR)
SNR_value2=abs(10*log10(signal2/noise));
%
set(handles.edit7,'String',SNR_value1);
set(handles.edit8,'String',PSNR_value2);
set(handles.edit9,'String',MSE_value2);
% display the results
set(handles.edit3,'String',SNR_value2);
set(handles.edit5,'String',PSNR_value1);
set(handles.edit6,'String',MSE_value1);
%
% --- Executes on button press in clustering.
function clustering_Callback(hObject, eventdata, handles)
% hObject    handle to clustering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% I=getappdata(handles.AutoCryoPicking,'J2');
set(handles.particlespicking,'enable','on');

global J2;
global cluster_image;
% Clustering...
img=double(J2);
[row,col,color_mp]= size(img);

% Convert the image from 2D to 1D image space...
img_vector = img(:);

% specify number of clusters
Clusters=4;    
 
Cluster = cell(1,Clusters);
Cluster(:) = {zeros(size(img_vector,1),1);};
    
% Range       
range = max(img_vector) - min(img_vector);
    
% Determine the # of steps
stepv = range/Clusters;
% Cluster initialization
K=stepv:stepv:max(img_vector);

for ii=1:size(img_vector,1)
    difference = abs(K-img_vector(ii));
    [y,ind]=min(difference);
    Cluster{ind}(ii)=img_vector(ii);
end
cluster_1=reshape(Cluster{1,1},[row col]);
C1=cluster_1;C1(cluster_1~=0)=1;
cluster_2=reshape(Cluster{1,2},[row col]);
C2=cluster_2;C2(cluster_2~=0)=2;
cluster_3=reshape(Cluster{1,3},[row col]);
C3=cluster_3;C3(cluster_3~=0)=3;
cluster_4=reshape(Cluster{1,4},[row col]);
C4=cluster_4;C4(cluster_4~=0)=4;
%
figure; imshow(cluster_1);
cluster1=bwareaopen(cluster_1,100);
figure; imshow(cluster1);title('CryoEM-Binary Mask Image');
binIM=cluster1;
SE=strel('disk',1);
cluster2=imerode(binIM,SE);
k=imfill(cluster2,'holes');
BW = imclose(k,SE);imshow(BW,[]);
cluster3=bwareaopen(BW,0);
cluster3=imdilate(cluster3,SE);
figure; imshow(cluster3);title('CryoEM-Binary Mask Image');
cluster_image=cluster3;
%
axes(handles.axes14)
imshow(cluster_image);title('CryoEM-Binary Mask Image');
set(gca,'tag','axes14')


% --- Executes on button press in particlespicking.
function particlespicking_Callback(hObject, eventdata, handles)
% hObject    handle to particlespicking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cluster_image;
global z;
c1=cluster_image;
global cell_BB1;
global a;
global b;
global centers;
global radii;
[centers, radii, metric] = imfindcircles(cluster_image,[13 85]);
axes(handles.axes15)
imshow(z);title('Particles Picking Results');
set(gca,'tag','axes15')
hold on;
viscircles(centers, radii,'EdgeColor','b');
plot(centers(:,1), centers(:,2), 'r+')
set(handles.edit10,'String',length(centers));
hold off;
%
axes(handles.axes19)
imshow(z);title('Particles Picking GT Image');
hold on;
axes(handles.axes18)
imshow(z);title('Particles Picking Results');
set(gca,'tag','axes18')
hold on;
viscircles(centers, radii,'EdgeColor','b');
plot(centers(:,1), centers(:,2), 'r+')


% binReg1=regionprops(c1,'All');
% numb1=size(binReg1,1);
% %
% cell_str1=regionprops(c1,'All');
% cell_tbl1=struct2table(cell_str1);
% %
% p1=prctile(cell_tbl1.FilledArea,[0 100]);
% %
% idxLowCounts1 = cell_tbl1.FilledArea >= p1(1);
% %
% cell_small1 = cell_tbl1(idxLowCounts1,:);
% cell_BB1=cell_small1.BoundingBox;
% w1=round(mean(cell_BB1(:,3)));
% h1=round(mean(cell_BB1(:,4)));
% axes(handles.axes15)
% imshow(z);title('CryoEM-Binary Mask Image');
% set(gca,'tag','axes15')
% hold on;
% for k = 1 : length(cell_BB1)
%   thisBB1 = cell_BB1(k,:);
%   rectangle('Position', [thisBB1(1)-10,thisBB1(2)-10,w1*1.5,h1*1.5],...
%   'EdgeColor','r','LineWidth',1 )
% end
% set(handles.edit10,'String',length(cell_BB1));
% axes(handles.axes18)
% imshow(z);title('Cryo-EM Particles Picking');
% set(gca,'tag','axes18')
% hold on;
% for k = 1 : length(cell_BB1)
%   thisBB1 = cell_BB1(k,:);
%   rectangle('Position', [thisBB1(1)-10,thisBB1(2)-10,w1*1.5,h1*1.5],...
%   'EdgeColor','r','LineWidth',1 )
% end

% --- Executes on button press in Validation.
function Validation_Callback(hObject, eventdata, handles)
% hObject    handle to Validation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% CentroidFinX=getappdata(handles.FingerPrintGUI,'CentroidFinX');
% CentroidFinY=getappdata(handles.FingerPrintGUI,'CentroidFinY');
% CentroidSepX=getappdata(handles.FingerPrintGUI,'CentroidSepX');
% CentroidSepY=getappdata(handles.FingerPrintGUI,'CentroidSepY');
% accuracyFin=getappdata(handles.FingerPrintGUI,'accuracyFin');
% accuracySep=getappdata(handles.FingerPrintGUI,'accuracySep');
I=getappdata(handles.FingerPrintGUI,'OriginalImage');
ValidationGUI(I,CentroidFinX,CentroidFinY,accuracyFin,CentroidSepX,CentroidSepY,accuracySep);

% --------------------------------------------------------------------
function LoadImage_Callback(hObject, eventdata, handles)
% hObject    handle to LoadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% [f,rep]=uigetfile('*.tiff');
% OriginalImage=imread([rep,f]);
% % OriginalImage=imresize(OriginalImage,[300 300]);
% set(handles.OriginalImage,'enable','on');
% set(handles.Display,'enable','on');
% % set(handles.AutomaticBW,'enable','on');
% % set(handles.ManualBW,'enable','on');
% set(handles.preprocessing,'enable','on');
% set(handles.OriginalImage,'value',1);
% setappdata(handles.FingerPrintGUI,'OriginalImage',OriginalImage);
% axes(handles.axes1)
% imshow(handles.axis1,OriginalImage)
% set(gca,'tag','axes1')
%

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_cryo_EM.
function load_cryo_EM_Callback(hObject, eventdata, handles)
% hObject    handle to load_cryo_EM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel16,'Visible','off');
set(handles.uibuttongroup15,'Visible','off');

[f,rep]=uigetfile('*.png');
OriginalImage=imread([rep,f]);
OriginalImage = imresize(OriginalImage,.5);
set(handles.preprocessing,'enable','on');
% set(handles.OriginalImage,'value',1);
setappdata(handles.FingerPrintGUI,'OriginalImage',OriginalImage);
axes(handles.axes1)
imshow(OriginalImage)
set(gca,'tag','axes1')


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Threshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)


% --- Executes on button press in performance_results.
function performance_results_Callback(hObject, eventdata, handles)
% hObject    handle to performance_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel16,'Visible','on');
set(handles.uipanel17,'Visible','on');




% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in export_particles.
function export_particles_Callback(hObject, eventdata, handles)
% hObject    handle to export_particles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global centers;
global radii;

CentroidSepX=centers(:,1);
CentroidSepY=centers(:,2);
r=round(max(radii(:,1)));
%
for k = 1 : length(centers)
  % extract the box diemnsions
    x=round(centers(k,1));
    y=round(centers(k,2));
    x1=x-r;
    y1=y-r;
    x2=2*r;
    y2=2*r;
end
particles_centers=[CentroidSepX CentroidSepY];
particles_BOX_dimenstions=[x1 y1 x2 y2];
prompt = {'Enter File Name:'};
dlg_title = 'Input for Particles Exporting...';
num_lines = 1;
def = {'Adil Al-Azzawi'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
save_particles(answer{1},particles_centers,particles_BOX_dimenstions);


% --- Executes on button press in GT_performance.
function GT_performance_Callback(hObject, eventdata, handles)
% hObject    handle to GT_performance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global centers;
global radii;
global z;
global GT_cryo_EM_image;
axes(handles.axes19)
imshow(z);title('Particles Picking GT Image');
hold on;
% viscircles(centers, radii,'EdgeColor','b');
% plot(centers(:,1), centers(:,2), 'k+')
r=round(max(radii(:,1)));
% imwrite(Inormalized,'DM3.tif');
for k = 1 : length(centers)
  % extract the box diemnsions
    x=round(centers(k,1));
    y=round(centers(k,2));
    x1=x-r;
    y1=y-r;
    rectangle('Position', [x1 y1 2*r 2*r],'EdgeColor','g','LineWidth',1);
end
set(gca,'tag','axes19')
%
% Compute the accuracy
TP=0;FP=0;TN=0;
I1=double(imbinarize(GT_cryo_EM_image(:,:,1)));
% figure;imshow(I1);
[~, NumBlobs] = bwlabel(I1);
for i=1:length(centers)
    x=round(centers(i,1));
    y=round(centers(i,2));
    if I1(y,x)==1
        % Ture Postive Detection
        TP=TP+1;
    else
         % False Postive Detection
        FP=FP+1;
    end
end
% False Nagative Detection
 FN=abs(NumBlobs-TP);
% Total number of particles
total_number_particles=NumBlobs;
% bulid the confusion matrix
confusion_matrix1 = zeros(2, 2);
confusion_matrix1(1)=TP;
confusion_matrix1(4)=TN;
confusion_matrix1(3)=FP;
confusion_matrix1(2)=FN;
[ acc1,sen1,pre1,FP_rate1,TP_rate1,Miss_class1,F_1_score1] = evaluation( confusion_matrix1 );
%
set(handles.edit11,'String',TP);
set(handles.edit13,'String',FP);
set(handles.edit14,'String',FN);
set(handles.edit12,'String',TN);
set(handles.edit16,'String',sen1);
set(handles.edit17,'String',pre1);
set(handles.edit18,'String',acc1);
set(handles.edit19,'String',F_1_score1);
set(handles.edit24,'String',FP_rate1);
set(handles.edit26,'String',TP_rate1);
set(handles.edit27,'String',Miss_class1);
set(handles.edit25,'String',total_number_particles);
% Confusion Matrix
set(handles.edit20,'String',TP);
set(handles.edit21,'String',FN);
set(handles.edit22,'String',FP);
set(handles.edit23,'String',TN);

% --- Executes on button press in pushbutton24.
function pushbutton24_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel17,'Visible','off');
set(handles.uipanel16,'Visible','off');


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in lower_range.
function lower_range_Callback(hObject, eventdata, handles)
% hObject    handle to lower_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lower_range contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lower_range


% --- Executes during object creation, after setting all properties.
function lower_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lower_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');

    global a;
    a=get(handles.lower_range,'value');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    global b;
    b=get(handles.lower_range,'value');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GT_visulization.
function GT_visulization_Callback(hObject, eventdata, handles)
% hObject    handle to GT_visulization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global centers;
global radii;
global GT_cryo_EM_image;
[f,rep]=uigetfile('*.png');
GT_cryo_EM_image=imread([rep,f]);
axes(handles.axes18)
imshow(GT_cryo_EM_image);title('Particles Picking GT Image');
hold on;
viscircles(centers, radii,'EdgeColor','b');
plot(centers(:,1), centers(:,2), 'k+')
