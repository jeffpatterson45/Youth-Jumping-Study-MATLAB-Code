%% Jeff Patterson - Independent Study with Patrick Rider - Spring 2016

%% Code will import vertical and standing long jump data from .txt (csv) files, calculate vertical and horizontal power production, and export data in a readable format.

%
clear all;


%% Imports file into MATLAB and creates a char variable of just the name of the file
[FileSelectionPrompt, FilePathName] = uigetfile('.txt','Select Text File to Import');
ImportFileName = strcat(FilePathName,FileSelectionPrompt);
% displays to user the name of the file they chose so they can see frame #s
% and weight of subject in command window
disp(['User selected ', FileSelectionPrompt]);


%% Get Frame #s and Subject Weight from filename

% FrameNumberFind finds the commas in the file name and creates a matrix
% that has the character # where commas are found
FrameNumberFind = find(FileSelectionPrompt == ',');

% First frame number is always right before the first comma [(1)-1], second
% frame number is always right after first comma [(1)+1], and third frame
% number is always right after second comma [(2)+1].
FrameNumber1 = str2double(FileSelectionPrompt(FrameNumberFind(1)-1));
FrameNumber2 = str2double(FileSelectionPrompt(FrameNumberFind(1)+1));
FrameNumber3 = str2double(FileSelectionPrompt(FrameNumberFind(2)+1));

% SubjectWeightFind1 finds the semi-colon in the filename, Find2 finds the
% l in "lbs", then SubjectWeightLbs is what is in between those values.
% Should always work as long as filename is correct everytime
SubjectWeightFind1 = find(FileSelectionPrompt == ';');
SubjectWeightFind2 = find(FileSelectionPrompt == 'l');
SubjectWeightLbs = str2double(FileSelectionPrompt(SubjectWeightFind1(1)+1:SubjectWeightFind2(1)-1));

    
%% NOT USING ANYMORE, PRONE TO USER ERROR. Prompts user to enter in frame numbers/weight for subject
% FrameNumbers = inputdlg({'Enter First Frame Number', 'Enter Second Frame Number', 'Enter Third Frame Number'}, 'Frame Numbers');
% % sets FrameNumber1, 2, and 3 equal to the first, second, and third #s
% FrameNumber1 = FrameNumbers(1,1);
% FrameNumber2 = FrameNumbers(2,1);
% FrameNumber3 = FrameNumbers(3,1);
% % prompts for weight in lbs
% SubjectWeightLbs = inputdlg('Enter in subject weight in lbs: ', 'Subject Weight');


    
%% Calls importfile.m function, creates variables Time, Fx, Fy, and Fz
[Time, Fx, Fy, Fz] = importfile(ImportFileName);


%% NOT USING BECAUSE BELOW IS BETTER. 
% Equation from calibration curve is y = 11.423x - 11.513 where y is mass
% % kg) and x is analog voltage. Turns analog data from imported file into
% % mass, then into force by multiplying by g (9.81m/s^2), multipled by 2
% % because gains were 2000. 

% Fx_Force = (Fx*11.423)*9.81*4;
% Fy_Force = (Fy*11.423)*9.81*4;
% Fz_Force = (Fz*11.423)*9.81*4;


%% Calibration from AMTI Manual, gains were 2000, sensitivity from calibration matrix
% Force = (output voltage) / (10^-6 * Vo * S * Gain)
% where Vo is 10, S is  sensitivity, and Gains were 2000
% Fx sensitivity is .34752522, Fy sensitivity is .34516216, Fz sensitivity is .08814228 
Fx_Force = Fx / (.000001*10*.34752522*2000);
Fy_Force = Fy / (.000001*10*.34516216*2000);
Fz_Force = Fz / (.000001*10*.08814228*2000);


