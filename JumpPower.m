%% Jeff Patterson - Independent Study with Patrick Rider - Spring 2016

%% Code will import vertical and standing long jump data from .txt files, calculate vertical and horizontal power production, and export data in a readable format.

%%
clear all;
close all;

%% Imports file into MATLAB and creates a char variable of just the name of the file
[FileSelectionPrompt, FilePathName] = uigetfile('.txt','Select Text File to Import');
% Concatenates the file path name and the file selection prompt names
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
FrameNumbers = [str2double(FileSelectionPrompt(FrameNumberFind(1)-1)); str2double(FileSelectionPrompt(FrameNumberFind(1)+1)); str2double(FileSelectionPrompt(FrameNumberFind(2)+1))];

% SubjectWeightFind1 finds the semi-colon in the filename, Find2 finds the
% l in "lbs", then SubjectWeightLbs is what is in between those values.
% Should always work as long as filename is correct everytime
SubjectWeightFind1 = find(FileSelectionPrompt == ';');
SubjectWeightFind2 = find(FileSelectionPrompt == 'l');
SubjectWeightLbs = str2double(FileSelectionPrompt(SubjectWeightFind1(1)+1:SubjectWeightFind2(1)-1));


%% Calculate mass (kgs) and force (N) of subject
% Calculate mass (kgs) from weight (lbs). Conversion factor: 1 lb = .453592 kg 
SubjectMass = SubjectWeightLbs*.453592;
% Convert mass (kgs) to force (N). Conversion factor: g
SubjectForce = SubjectMass*9.80665;



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


%% NOT USING BECAUSE BELOW IS MORE ACCURATE. 
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
% Multiplies Time by 1000 to make ginput (below) work appropriately
Time1000 = Time*1000;

%% for loop that finds baseline values for the subject's Z force on the forceplate. Will be subtracted out when calculating impulse

Baseline = zeros(3,1);


for i=1:3;
    

    %% Make Plots
    
    % Make FrameNumber1 plot of Fz_Force vs Time
    fig = figure(i);
    set (fig, 'Units', 'normalized', 'Position', [0,0,1,1]);
    plot(Time1000((12000*(FrameNumbers(i)-1)+FrameNumbers(i)):(12000*(FrameNumbers(i))+(FrameNumbers(i)-1))),Fz_Force((12000*(FrameNumbers(i)-1)+FrameNumbers(i)):(12000*(FrameNumbers(i))+(FrameNumbers(i)-1))));
    title(['\fontsize{16}PICK TWO POINTS (LEFT TO RIGHT) THAT REPRESENT A GOOD BASELINE VALUE OF THE PERSON ON THE FORCEPLATE']);
    
    % Get input for calculations
    [xFrameBaseline] = int64(ginput(2));
    StartStopBaseline(:,i) = xFrameBaseline(:,1);
    
    % defining start and stop frames based off person's clicks
    start = (12000*(FrameNumbers(i)-1))+FrameNumbers(i)+StartStopBaseline(1,i);
    stop = start+StartStopBaseline(2,i)-StartStopBaseline(1,i);
    
    % Calculate average body weight from user input
    Baseline(i,1) = mean(Fz_Force(start:stop),'omitnan');
    close all;
    
    
end;


%% for loop that gets beginning and end of jump, works same as above

for j=1:3;
    fig = figure(j);
    set (fig,'Units', 'normalized', 'Position', [0,0,1,1]);
    plot(Time1000((12000*(FrameNumbers(j)-1)+FrameNumbers(j)):(12000*(FrameNumbers(j))+(FrameNumbers(j)-1))),Fz_Force((12000*(FrameNumbers(j)-1)+FrameNumbers(j)):(12000*(FrameNumbers(j))+(FrameNumbers(j)-1))));
    title(['\fontsize{16}CLICK RIGHT AT THE BEGINNING OF THE JUMP AND RIGHT AS THE PERSON LEAVES THE FORCEPLATE']);
    
    [xJumpTimes] = int64(ginput(2));
    JumpStartStop(:,j) = xJumpTimes(:,1);
    
    close all;
    
    
end;




