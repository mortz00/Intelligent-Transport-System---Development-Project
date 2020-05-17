% %% 
% %--------------------------------------------------------------------------
% %--------------- INFERENCE SYSTEM THREE, Atmostpheric ---------------------
% %------------------------------ combination #1 ----------------------------
% 
% c = newfis('AtmosphericDrivingAnalysis');
% 
% filename = ('outputTest.xls');
% outputTest = xlsread(filename);
% 
% 
% c = addvar(c,'input','Weather_Danger',[0 100]);
% 
% c = addmf(c,'input',1,'Low_Danger','trapmf',[0 0 30 50]); 
% c = addmf(c,'input',1,'Moderate_Danger','trimf', [35 50 65]);
% c = addmf(c,'input',1,'High_Danger','trimf', [55 70 85]);
% c = addmf(c,'input',1,'Extreme_Danger','trapmf', [80 100 100 100]);
% 
% c = addvar(c,'input','Congestion',[0 10]);
% 
% c = addmf(c,'input',2,'Low','trapmf', [0 0 2 4]); 
% c = addmf(c,'input',2,'Average','gaussmf', [1.25 5]); 
% c = addmf(c,'input',2,'High','trapmf', [6 8 10 10]);
% 
% c = addvar(c,'output','AtmosphericConditions',[0 100]);
% 
% c = addmf(c,'output',1,'Good','trapmf', [0 0 10 40]);
% c = addmf(c,'output',1,'Moderate','gaussmf',[12 50]);
% c = addmf(c,'output',1,'Bad','trapmf',[60 90 100 100]);
% 
% %rule base
% %Low | Medium | High | output | weight | operator 
% rule55 = [1 1 1 1 1];
% rule56 = [0 1 1 1 1];
% 
% ruleListC = [rule55; rule56;];
% 
% % Add the rules to the FIS
% c = addRule(c,ruleListC);
% 
% % Print the rules to the workspace
% rule = showrule(c);
% 
% %defuzzification methods
% %c.defuzzMethod = 'centroid';
% %c.defuzzMethod = 'bisector';
% %c.defuzzMethod = 'mom';
% %c.defuzzMethod = 'som';
% %c.defuzzMethod = 'lom';
% 
% for i=1:size(outputTest,1) %for creating the output - need to change this for loop to read and write correct data
%         EvalAtmospheric = evalfis([outputTest(i, 1), outputTest(i, 2)], c); 
%         
%         fprintf('%d) In(1): %.2f, In(2) %.2f,   => Out: %.2f \n\n',i,outputTest(i,1)...
%             ,outputTest(i, 2), EvalAtmospheric);
%         
%         xlswrite('outputAtmospheric.xls', EvalAtmospheric, 1, sprintf('D%d',i+1)); 
% end
%--------------------------------------------------------------------------
%-------------- INFERENCE SYSTEM THREE, Atmostpheric ----------------------
%------------------------------ combination #1 ----------------------------

c = newfis('AtmosphericDrivingAnalysis');

filename = ('outputTest.xls');
outputTest = xlsread(filename);

c = addvar(c,'input','Weather_Danger',[0 100]);

c = addmf(c,'input',1,'Low_Danger','trapmf',[0 0 30 50]); 
c = addmf(c,'input',1,'Moderate_Danger','trimf', [35 50 65]);
c = addmf(c,'input',1,'High_Danger','trimf', [55 70 85]);
c = addmf(c,'input',1,'Extreme_Danger','trapmf', [80 100 100 100]);

c = addvar(c,'input','Congestion',[0 100]);

c = addmf(c,'input',2,'Low','trapmf', [0 0 20 40]); 
c = addmf(c,'input',2,'Average','gaussmf', [12.5 50]); 
c = addmf(c,'input',2,'High','trapmf', [60 80 100 100]);

c = addvar(c,'output','AtmosphericConditions',[0 100]); % good to bad

c = addmf(c,'output',1,'Good','trapmf', [0 0 10 40]);
c = addmf(c,'output',1,'Moderate','gaussmf',[12 50]);
c = addmf(c,'output',1,'Bad','trapmf',[60 90 100 100]);

% rule base
% WthrDngr(4) | congestion(3) | output(3) | weight | operator 

rule55 = [1 1 1 1 1];
rule56 = [1 2 1 1 1];
rule57 = [1 3 2 1 1];

rule58 = [2 1 1 1 1];
rule59 = [2 2 2 1 1];
rule60 = [2 3 3 1 1];

rule61 = [3 0 3 1 1];
rule62 = [4 0 3 1 1];

%defuzzification methods
%c.defuzzMethod = 'centroid';
c.defuzzMethod = 'bisector';
%c.defuzzMethod = 'mom';
%c.defuzzMethod = 'som';
%c.defuzzMethod = 'lom';

%c.andMethod = 'min'; %default and best
%c.andMethod = 'prod';

ruleListC = [rule55; rule56; rule57; rule58; rule59; rule60; ...
    rule61; rule62];

% Add the rules to the FIS
c = addRule(c,ruleListC);

% Print the rules to the workspace
rule = showrule(c);

%rule viewer
ruleview(c);

figure(1) % figure handler (creates figure for plot)
subplot(3,1,1), plotmf(c,'input',1); % subplot rows, columns, position  
subplot(3,1,2), plotmf(c,'input',2);
subplot(3,1,3), plotmf(c,'output',1);


for i=1:size(outputTest,1) 
        EvalAtmospheric = evalfis([outputTest(i, 1), outputTest(i, 2)], c); 
        
        fprintf('%d) In(1): %.2f, In(2) %.2f,   => Out: %.2f \n\n',i,outputTest(i,1)...
            ,outputTest(i, 2), EvalAtmospheric);
        
        xlswrite('Test_Atmospheric.xls', EvalAtmospheric, 1, sprintf('A%d',i+1)); 
end
