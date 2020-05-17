%--------------------------------------------------------------------------
%------------------- INFERENCE SYSTEM , Driving suitability ---------------
%------------------------------ combination #2 ----------------------------

e = newfis('Driving_Suitability');

filename = ('outputTest.xls');

outputTest = xlsread(filename);

e = addvar(e,'input','AtmosphericConditions',[0 100]);

e = addmf(e,'input',1,'Good','trapmf', [0 0 10 40]);
e = addmf(e,'input',1,'Moderate','gaussmf',[12 50]);
e = addmf(e,'input',1,'Bad','trapmf',[60 90 100 100]);

e = addvar(e,'input','Human_Driving_Ability',[0 100]); %good to bad

e = addmf(e,'input',2,'Very_Low_Competence','trapmf',[0 0 10 20]);
e = addmf(e,'input',2,'Low_Competence','gaussmf',[7.5 30]); % need edit
e = addmf(e,'input',2,'Average_Competence','gaussmf', [7.5 50]); % need edit
e = addmf(e,'input',2,'High_Competence','trapmf',[50 80 100 100]); 

e = addvar(e,'output','DrivingSuitability_Good-Bad',[0 100]); %good to bad
e = addmf(e,'output',1,'Good','trapmf', [0 0 10 40]);
e = addmf(e,'output',1,'Moderate','gaussmf',[12 50]);
e = addmf(e,'output',1,'Bad','trapmf',[60 90 100 100]);

% rule base
% Atmospheric(3) | Human(4) | output(3) | weight | operator 

rule88 = [1 4 1 1 1]; % 1. If (Atmospheric_Conditions is Good) and (Human_Driving_Ability is High_Competence) then (driving_suitability is good) (1)           
rule89 = [1 3 1 1 1]; % 2. If (Atmospheric_Conditions is Good) and (Human_Driving_Ability is Average_Competency) then (driving_suitability is good) (1)        
rule90 = [2 4 1 1 1]; % 3. If (Atmospheric_Conditions is Moderate) and (Human_Driving_Ability is High_Competence) then (driving_suitability is good) (1)
rule91 = [2 3 2 1 1]; % 4. If (Atmospheric_Conditions is Moderate) and (Human_Driving_Ability is Average_Competency) then (driving_suitability is moderate) (1)
rule92 = [2 2 2 1 1]; % 5. If (Atmospheric_Conditions is Moderate) and (Human_Driving_Ability is Low_Competence) then (driving_suitability is moderate) (1)    
rule93 = [3 0 3 1 2]; % 6. If (Atmospheric_Conditions is Bad) then (driving_suitability is bad) (1)                                                            
rule94 = [0 1 3 1 2]; % 7. If (Human_Driving_Ability is Very_Low_Competence) then (driving_suitability is bad) (1)                                             


%defuzzification methods   
%e.defuzzMethod = 'centroid'; %default
e.defuzzMethod = 'bisector'; %best
%e.defuzzMethod = 'mom'; %tested
%e.defuzzMethod = 'som'; %tested
%e.defuzzMethod = 'lom'; %tested

%e.andMethod = 'min'; %default and best
e.andMethod = 'prod';

ruleListd = [rule88; rule89; rule90; rule91; rule92; rule93; rule94;];

% Add the rules to the FIS
e = addRule(e,ruleListd);

% Print the rules to the workspace
rule = showrule(e);

%rule viewer
%ruleview(e);


for i=1:size(outputTest,1) 
        EvalAtmospheric = evalfis([outputTest(i, 4), outputTest(i, 6)], e); 
        
        fprintf('%d) In(1): %.2f, In(2) %.2f,   => Out: %.2f \n\n',i,outputTest(i,4)...
            ,outputTest(i, 6), EvalAtmospheric);
        
        xlswrite('Test_DrivingSuitability.xls', EvalAtmospheric, 1, sprintf('H%d',i+1)); 
end