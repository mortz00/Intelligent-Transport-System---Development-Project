%--------------------------------------------------------------------------
%------------- INFERENCE SYSTEM TWO, CONGESTION PREDICTION ----------------
%--------------------------------------------------------------------------

b = newfis('Congestion');

filename = ('SyntheticCongestionData.xlsx');  
CongestionData = xlsread(filename);

b = addvar(b, 'input', 'Time_of_Day(%)', [0 24]); % hours in the day

b = addmf(b,'input',1,'Early_Morning','trapmf', [0 0 3 6.5]);
b = addmf(b,'input',1,'Morning_Rush','gaussmf', [1 8]);
b = addmf(b,'input',1,'Midday','gaussmf', [1.5 12]);
b = addmf(b,'input',1,'Evening_Rush','gaussmf', [1 17]);
b = addmf(b,'input',1,'Late_Night', 'trapmf',  [19 23 24 24]);

b = addvar(b,'input','Degree_of_Incident',[0 10]); % how it this defined and determined

b = addmf(b,'input',2,'low','trapmf',[0 0 1 3.5]);
b = addmf(b,'input',2,'medium','gaussmf',[1 5]);
b = addmf(b,'input',2,'severe','trapmf',[6.5 9 10 10]);

b = addvar(b,'input','Degree_of_Utility_Work',[0 10]); % schedules/unscheduled - minor to major self-expplanatory

b = addmf(b,'input',3,'low','trapmf',[0 0 1 3.5]);
b = addmf(b,'input',3,'moderate','gaussmf',[1 5]);
b = addmf(b,'input',3,'high','trapmf',[6.5 9 10 10]);

b = addvar(b,'output','Congestion',[0 100]); % scalable to severity of incident

b = addmf(b,'output',1,'Low','trapmf',[0 0 20 40]); % need edit
b = addmf(b,'output',1,'Average','gaussmf', [12 50]); % need edit
b = addmf(b,'output',1,'High','trapmf', [60 80 100 100]); % need edit

% rule base

%--------------------------- low congestion -------------------------------

%time | incident | work | output | weight | operator 

rule42 = [1 1 1 1 1 1];
rule43 = [3 1 1 1 1 1];
rule44 = [5 1 1 1 1 1];

%------------------------ average congestion ------------------------------

%time | incident | work | output | weight | operator 

rule45 = [1 2 0 2 1 1];
rule46 = [1 0 2 2 1 1];
rule47 = [3 2 0 2 1 1];
rule48 = [3 0 2 2 1 1];
rule49 = [5 2 0 2 1 1];
rule50 = [5 0 2 2 1 1];

%-------------------------- high congestion -------------------------------

%time | incident | work | output | weight | operator 

rule51 = [0 3 0 3 1 1];
rule52 = [0 0 3 3 1 1];

% rule53 = [2 0 0 3 1 1];
% rule54 = [4 0 0 3 1 1];

rule53 =  [2 1 2 3 1 1];
rule54 =  [2 2 1 3 1 1];
rule54a = [2 0 0 2 1 1];

rule55a = [4 1 2 3 1 1];
rule56a = [4 2 1 3 1 1];
rule57a = [4 0 0 2 1 1];

rule58a = [0 2 2 3 1 1]; 

%defuzzification methods   
%b.defuzzMethod = 'centroid'; %default
b.defuzzMethod = 'bisector'; %best
%b.defuzzMethod = 'mom'; %tested
%b.defuzzMethod = 'som'; %tested
%b.defuzzMethod = 'lom'; %tested

%b.andMethod = 'min'; %default and best
%b.andMethod = 'prod';

ruleListB = [rule42; rule43; rule44; rule45; rule46; rule47; rule48; rule49;
    rule50; rule51; rule52; rule53; rule54; rule54a; rule55a; rule56a; rule57a; rule58a;]; %add more rules

% Add the rules to the FIS
b = addRule(b,ruleListB);

% Print the rules to the workspace
rule = showrule(b);
%rule viewer
%ruleview(b);

%plotting membership function

%figure(1) % figure handler (creates figure for plot)
%subplot(4,1,1), plotmf(b,'input',1); % subplot rows, columns, position  
%subplot(4,1,2), plotmf(b,'input',2);
%subplot(4,1,3), plotmf(b,'input',3);
%subplot(4,1,4), plotmf(b,'output',1);


%subplot(5,1,5), plotmf(b, 'output', 1);

for i=1:size(CongestionData,1) %for creating the output - need to change this for loop to read and write correct data
        evalCongest = evalfis([CongestionData(i, 1), CongestionData(i, 2), CongestionData(i, 3)], b); 
        
        fprintf('%d) In(1): %.2f, In(2) %.2f, In(3): %.2f,  => Out: %.2f \n\n',i,CongestionData(i,1),CongestionData(i, 2),...
            CongestionData(i, 3), evalCongest);
        
        xlswrite('Test_Congestion.xls', evalCongest, 1, sprintf('B%d',i+1)); 
        
end