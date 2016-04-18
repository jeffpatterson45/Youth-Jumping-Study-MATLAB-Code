%% Jeff Patterson - Independent Study with Patrick Rider - Spring 2016

%% Code will import vertical and standing long jump data from .txt files, calculate vertical and horizontal power production, and export data to Excel

%%
clear all;
close all;

%% Imports file into MATLAB and creates a char variable of just the name of the file
[FileSelectionPrompt, FilePathName] = uigetfile('.txt','Select Text File to Import');

% Concatenates the file path name and the file selection prompt names
ImportFileName = strcat(FilePathName,FileSelectionPrompt);

% displays to user the name of the file they chose
disp(['User selected ', FileSelectionPrompt]);



%% Get Frame #s and Subject Weight from filename

% FrameNumberFind finds the commas in the file name and creates a matrix
% that has the character # where commas are found
FrameNumberFind = find(FileSelectionPrompt == ',');

% First frame number is always right before the first comma [(1)-1], second
% frame number is always right after first comma [(1)+1], and third frame
% number is always right after second comma [(2)+1].
FrameNumbers = [str2double(FileSelectionPrompt(FrameNumberFind(1)-1)); str2double(FileSelectionPrompt(FrameNumberFind(1)+1)); str2double(FileSelectionPrompt(FrameNumberFind(2)+1))];

% SubjectWeightFind1 finds the semi-colon in the filename, Find2 finds the
% l in "lbs", then SubjectWeightLbs is what is in between those values.
% Should always work as long as filename is correct everytime
SubjectWeightFind1 = find(FileSelectionPrompt == ';');
SubjectWeightFind2 = find(FileSelectionPrompt == 'l');
SubjectWeightLbs = str2double(FileSelectionPrompt(SubjectWeightFind1(1)+1:SubjectWeightFind2(1)-1));

% same thing for Subject #
SubjectNumberFind1 = find(FileSelectionPrompt == 'P');
SubjectNumberFind2 = find(FileSelectionPrompt == ' ');
SubjectNumber = str2double(FileSelectionPrompt(SubjectNumberFind1(1)+1:SubjectNumberFind2(1)-1));


%% Calculate mass (kgs) and force (N) of subject
% Calculate mass (kgs) from weight (lbs). Conversion factor: 1 lb = .453592 kg 
SubjectMass = SubjectWeightLbs*.453592;
% Convert mass (kgs) to force (N). Conversion factor: g
SubjectForce = SubjectMass*9.80665;

    
%% Calls importfile.m function, creates variables Time, Fx, Fy, and Fz
[Time, Fx, Fy, Fz] = importfile(ImportFileName);



%% if condition to separate code for vert/horizontal jumps

   
if strfind(ImportFileName, 'VJ')
     [avgPower, peakPower] = VerticalJump(Time, Fz, FrameNumbers);
     % writes to sheet #1 for vertical jumps
     sheet = 1;
else 
    [avgPower, peakPower, peakPower2] = LongJump(Time, Fy, Fz, FrameNumbers);
    % writes to sheet #2 for standing long jumps
    sheet = 2;
end


%% Write to excel file

% need to convert Subject Number to a string, added 1 so there's 1 line at
% the top of the excel sheet for column headers
SubNum = num2str(SubjectNumber+1);

% xlrange sets the range for the cells needed
xlrangeSubNum = strcat('A',SubNum);

% %writes to Excel. (filename, data I want to send, sheet #, cell range);

if (sheet == 1)
    output = [SubjectNumber, SubjectMass, peakPower(1,1), peakPower(2,1), peakPower(3,1), avgPower(1,1), avgPower(2,1), avgPower(3,1)];
else 
   output = [SubjectNumber, SubjectMass, peakPower(1,1), peakPower(2,1), peakPower(3,1), peakPower2(1,1), peakPower2(2,1), peakPower2(3,1),avgPower(1,1), avgPower(2,1), avgPower(3,1)];
end
    
xlswrite('X:\Research\Youth Jumping Study\Patterson\JumpingResults.xlsx', output, sheet, xlrangeSubNum);
    
% %% EXPORT FILE TO MAT
% % m = matfile('X:\Research\Youth Jumping Study\Patterson\Youth-Jumping-Study-MATLAB-Code\JumpResults.mat', 'Writable',true);
% % 
% % m.avgPower = horzcat(m.avgPower, avgPower);
% % m.peakPower = horzcat(m.peakPower, peakPower);






