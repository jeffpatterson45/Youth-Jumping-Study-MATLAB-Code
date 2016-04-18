function [ avgPower, peakPower, peakPower2 ] = LongJump(Time, Fy, Fz, FrameNumbers)
%LongJump Power Calculator
%   Created by Jeff Patterson, 4-18-16

% INPUT:

% OUTPUT:



%% Calibration from AMTI Manual, gains were 2000, sensitivity from calibration matrix
% Force = (output voltage) / (10^-6 * Vo * S * Gain)
% where Vo is 10, S is  sensitivity, and Gains were 2000
% Fx sensitivity is .34752522, Fy sensitivity is .34516216, Fz sensitivity is .08814228

% Don't need Fx for SLJ
% Fx_Force = Fx / (.000001*10*.34752522*2000);


Fy_Force = Fy / (.000001*10*.34516216*2000);
Fz_Force = Fz / (.000001*10*.08814228*2000);

% Multiplies Time by 1000 to make ginput (below) work appropriately
Time1000 = Time*1000;


%% for loop that finds baseline values for the subject's Z force on the forceplate. Will be subtracted out when calculating impulse

% Defining variables
Baseline = zeros(3,1);
StartBaseline = zeros(3,1);
StopBaseline = zeros(3,1);


for i=1:3;
    
    
    %% Make Plots
    
    % Make FrameNumber1 plot of Fz_Force vs Time
    fig = figure(i);
    set (fig, 'Units', 'normalized', 'Position', [0,0,1,1]);
    plot(Time1000((12000*(FrameNumbers(i)-1)+FrameNumbers(i)):(12000*(FrameNumbers(i))+(FrameNumbers(i)-1))),Fz_Force((12000*(FrameNumbers(i)-1)+FrameNumbers(i)):(12000*(FrameNumbers(i))+(FrameNumbers(i)-1))));
    title('\fontsize{16}PICK TWO POINTS (LEFT TO RIGHT) THAT REPRESENT A GOOD BASELINE VALUE OF THE PERSON ON THE FORCEPLATE');
    
    % Get input for calculations
    [xFrameBaseline] = int64(ginput(2));
    StartStopBaseline(:,i) = xFrameBaseline(:,1);
    
    % defining start and stop frames based off person's clicks
    StartBaseline(i,1) = (12000*(FrameNumbers(i)-1))+FrameNumbers(i)+StartStopBaseline(1,i);
    StopBaseline(i,1) = StartBaseline(i,1)+StartStopBaseline(2,i)-StartStopBaseline(1,i);
    
    % Calculate average body weight from user input
    Baseline(i,1) = mean(Fz_Force(StartBaseline(i,1):StopBaseline(i,1)),'omitnan');
    close all;
    
    
end;


%% for loop that gets beginning and end of jump, works same as above

%Defining variables
Impulse = zeros(3,1);
StartJump = zeros(3,1);
StopJump = zeros(3,1);

for j=1:3;
    fig = figure(j);
    set (fig,'Units', 'normalized', 'Position', [0,0,1,1]);
    plot(Time1000((12000*(FrameNumbers(j)-1)+FrameNumbers(j)):(12000*(FrameNumbers(j))+(FrameNumbers(j)-1))),Fz_Force((12000*(FrameNumbers(j)-1)+FrameNumbers(j)):(12000*(FrameNumbers(j))+(FrameNumbers(j)-1))));
    %adds reference line of baseline for that jump trial to give user more
    %accurate placing of start/end jump
    refline(0,Baseline(j,1));
    title('\fontsize{16}CLICK RIGHT AT THE BEGINNING OF THE JUMP AND RIGHT AS THE PERSON LEAVES THE FORCEPLATE (Horizontal line = baseline)');
    
    % Gets user input to determine where jump starts and ends
    [xJumpTimes] = int64(ginput(2));
    JumpStartStop(:,j) = xJumpTimes(:,1);
    
    % Defines start and stop of jumps within large files
    StartJump(j,1) = (12000*(FrameNumbers(j)-1))+FrameNumbers(j)+JumpStartStop(1,j);
    StopJump(j,1) = (12000*(FrameNumbers(j)-1))+FrameNumbers(j)+JumpStartStop(2,j);
    
    % Subtract out baseline values from Fz_Force for impulse calc. below
    Fz_Force_Offset = Fz_Force - Baseline(j,1);
    
    % Calculates impulse based off start and stop times chosen above,
    % subtracts out impulse from bodyweight, need to divide by 1000 because
    % Time1000 is 1000x larger than normal
    Impulse(j,1) = trapz(Fz_Force_Offset(StartJump(j,1):StopJump(j,1)))/1000;
    
    close all;
    
end;



%%for and while loops that calculate instantaneous velocity in two
%%different ways (Domire's uses trapz which is more accurate), then uses
%%the Fz_Force_Offset to calculate power at each moment in time. Peak and
%%Average power can then be found by doing max() and mean(), respectively

avgPower = zeros(3,1);
peakPower = zeros(3,1);
JumpTime = zeros(3,1);


for i = 1:3
    
    Start = StartJump(i,1);
    Stop = StopJump(i,1);
    JumpTime(i,1) = StopJump(i,1)-StartJump(i,1);
    % VelocityMe = zeros(JumpTime(i,1),1);
    VelocityZ = zeros(JumpTime(i,1),1);
    VelocityY = zeros(JumpTime(i,1),1);
    PowerZ = zeros(JumpTime(i,1),1);
    PowerY = zeros(JumpTime(i,1),1);
    ResultantPower = zeros(JumpTime(i,1),1);
    
    Begin = 1;
    
    while Start < Stop;
        
        % Not using because it's slightly less accurate than below
        % VelocityMe(Begin+1) = VelocityMe(Begin) + Fz_Force_Offset(Start)*.001/(Baseline(i,1)*.10197162129);
        
        VelocityZ(Begin+1) = trapz(Fz_Force_Offset(StartJump(i,1):(StartJump(i,1)+Begin)))/1000/(Baseline(i,1)*.10197162129);
        VelocityY(Begin+1) = trapz(Fy_Force(StartJump(i,1):(StartJump(i,1)+Begin)))/1000/(Baseline(i,1)*.10197162129);
        PowerZ(Begin) = Fz_Force_Offset(Start)*VelocityZ(Begin);
        PowerY(Begin) = Fy_Force(Start)*VelocityY(Begin);
        
        
        
        
        Begin = Begin + 1;
        Start = Start + 1;
        
    end
    
    
    AvgPowerZ = mean(PowerZ);
    AvgPowerY = mean(PowerY);
    avgPower(i,1) = sqrt(AvgPowerZ^2 + AvgPowerY^2);
    
    peakPowerZ = max(PowerZ);
    peakPowerY = max(PowerY);
    peakPower(i,1) = sqrt(peakPowerZ^2 + peakPowerY^2);
    temp = (PowerZ.^2 + PowerY.^2);
    peakPower2(i,1) = sqrt(max(temp));
end

end



