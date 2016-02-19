for i=1;
    

    %% Make Plots
    
    % Make FrameNumber1 plot of Fz_Force vs Time
    fig = figure(i);
    set (fig, 'Units', 'normalized', 'Position', [0,0,1,1]);
    plot(Time1000((12000*(FrameNumbers(i)-1)+FrameNumbers(i)):(12000*(FrameNumbers(i))+(FrameNumbers(i)-1))),Fz_Force((12000*(FrameNumbers(i)-1)+FrameNumbers(i)):(12000*(FrameNumbers(i))+(FrameNumbers(i)-1))));
    title(['\fontsize{16}PICK TWO POINTS (LEFT TO RIGHT) THAT REPRESENT A GOOD BASELINE VALUE OF THE PERSON ON THE FORCEPLATE']);
    
    %% Get input for calculations
    [xFrameBaseline] = int64(ginput(2));
    StartStopBaseline(:,i) = xFrameBaseline(:,1);
    start = (12000*(FrameNumbers(i)-1))+FrameNumbers(i)+StartStopBaseline(1,i);
    stop = start+StartStopBaseline(2,i)-StartStopBaseline(1,i);
    % Calculate impulse from body weight
    Baseline = zeros(3,1);
    %Baseline(i,1) = mean(Fz_Force(((12000*(FrameNumbers(i)-1))+FrameNumbers(i)+StartStopBaseline(1,i)):(12000*(FrameNumbers(i))+(FrameNumbers(i)-1)+StartStopBaseline(2,i))),'omitnan');
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