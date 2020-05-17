%--------------------------------------------------------------------------
%------------------- INFERENCE SYSTEM, HUMAN CULPABILITY ------------------
%--------------------------------------------------------------------------

d = newfis('Human_Driving_Ability');

filename = ('SyntheticHumanData.xlsx');  
HumanData = xlsread(filename);

d = addvar(d, 'input', 'Age', [17 100]); % driver age // self evident

d = addmf(d,'input',1,'Young','trapmf', [17 17 20 25]);
d = addmf(d,'input',1,'Mid_Twenties','gaussmf',[1.2 25]);
d = addmf(d,'input',1,'Mature_Adult','gaussmf', [8 45]);
d = addmf(d,'input',1,'Elderly', 'gaussmf', [4 70]);
d = addmf(d,'input',1,'Very_Old', 'trapmf', [75 85 100 100]);

d = addvar(d,'input','Operator_Experience',[0 100]); % how it this defined and determined - must talk about correlation with age, professional driver? licesnses held?

d = addmf(d,'input',2,'Low','trapmf', [0 0 20 40]);
d = addmf(d,'input',2,'Medium','gaussmf', [10 50]);
d = addmf(d,'input',2,'High','gaussmf', [10 70]);
d = addmf(d,'input',2,'Expert','trapmf', [80 90 100 100]);

d = addvar(d,'input','Tiredness',[0 100]); % self-explanatory

d = addmf(d,'input',3,'low','trapmf',[0 0 20 40]);
d = addmf(d,'input',3,'moderate','gaussmf',[15 70]);
d = addmf(d,'input',3,'high','trapmf',[75 85 100 100]);

d = addvar(d,'output','Human_Driving_Ability',[0 100]); % This is to produce warnings to drivers, alert other users of immaturity IE. just passed. cease operation if intox, cease operation if dangerously tired

d = addmf(d,'output',1,'Very_Low_Competence','trapmf',[0 0 10 20]);
d = addmf(d,'output',1,'Low_Competence','gaussmf',[7.5 30]); % need edit
d = addmf(d,'output',1,'Average_Competence','gaussmf', [7.5 50]); % need edit
d = addmf(d,'output',1,'High_Competence','trapmf',[50 80 100 100]); 

% rule base

%------------------------ Very Low Competence -----------------------------

%age(5) | experience(4) | tiredness(3) | output(4) | weight | operator 

rule63 = [0 0 3 1 1 1]; % 1. If (Tiredness is High) then (Human_Driving_Ability is Incompetent) (1)                                                                       
rule64 = [1 1 2 1 1 1]; % 2. If (Age is Young) and (Operator_Experience is Low) and (Tiredness is Moderate) then (Human_Driving_Ability is Incompetent) (1)               
rule65 = [4 1 1 1 1 1]; % 3. If (Age is Elderly) and (Operator_Experience is Low) and (Tiredness is Moderate) then (Human_Driving_Ability is Incompetent) (1)             
rule66 = [5 1 2 2 1 1]; % 4. If (Age is Very_Old) and (Operator_Experience is Low) and (Tiredness is Moderate) then (Human_Driving_Ability is Incompetent) (1)            
rule67 = [5 2 2 2 1 1]; % 5. If (Age is Very_Old) and (Operator_Experience is Medium) and (Tiredness is Moderate) then (Human_Driving_Ability is Incompetent) (1)         
rule68 = [5 3 2 2 1 1]; % 6. If (Age is Very_Old) and (Operator_Experience is HIgh) and (Tiredness is Moderate) then (Human_Driving_Ability is Incompetent) (1)           

%-------------------------- Low Competence --------------------------------

%age(5) | experience(4) | tiredness(3) | output(4) | weight | operator 


rule69 = [5 4 2 2 1 1]; % 7. If (Age is Very_Old) and (Operator_Experience is Expert) and (Tiredness is Moderate) then (Human_Driving_Ability is Low_Competence) (1)      
rule70 = [1 2 2 2 1 1]; % 8. If (Age is Young) and (Operator_Experience is Medium) and (Tiredness is Moderate) then (Human_Driving_Ability is Low_Competence) (1)         
rule71 = [5 1 1 2 1 1]; % 9. If (Age is Very_Old) and (Operator_Experience is Low) and (Tiredness is Low) then (Human_Driving_Ability is Low_Competence) (1)              
rule72 = [5 2 1 2 1 1]; % 10. If (Age is Very_Old) and (Operator_Experience is Medium) and (Tiredness is Low) then (Human_Driving_Ability is Low_Competence) (1)          
rule73 = [5 3 1 2 1 1]; % 11. If (Age is Very_Old) and (Operator_Experience is HIgh) and (Tiredness is Low) then (Human_Driving_Ability is Low_Competence) (1)            
rule74 = [1 1 1 2 1 1]; % 12. If (Age is Young) and (Operator_Experience is Low) and (Tiredness is Low) then (Human_Driving_Ability is Low_Competence) (1)                
rule75 = [1 2 2 2 1 1]; % 13. If (Age is Young) and (Operator_Experience is Medium) and (Tiredness is Moderate) then (Human_Driving_Ability is Low_Competence) (1)

%-------------------------- Average Competence ----------------------------

%age(5) | experience(4) | tiredness(3) | output(4) | weight | operator 

rule76 = [1 2 1 3 1 1]; % 14. If (Age is Young) and (Operator_Experience is Medium) and (Tiredness is Low) then (Human_Driving_Ability is Average_Competence) (1)         
rule77 = [2 1 2 3 1 1]; % 15. If (Age is Mid_Twenties) and (Operator_Experience is Low) and (Tiredness is Moderate) then (Human_Driving_Ability is Average_Competence) (1)
rule78 = [3 1 2 3 1 1]; % 16. If (Age is Mature_Adult) and (Operator_Experience is Low) and (Tiredness is Moderate) then (Human_Driving_Ability is Average_Competence) (1)
rule79 = [4 1 2 3 1 1]; % 17. If (Age is Elderly) and (Operator_Experience is Low) and (Tiredness is Moderate) then (Human_Driving_Ability is Average_Competence) (1)     


%--------------------------- High Competence ------------------------------

rule80 = [2 2 1 4 1 1]; % 18. If (Age is Mid_Twenties) and (Operator_Experience is Medium) and (Tiredness is Low) then (Human_Driving_Ability is High_Competence) (1)     
rule81 = [2 3 1 4 1 1]; % 19. If (Age is Mid_Twenties) and (Operator_Experience is HIgh) and (Tiredness is Low) then (Human_Driving_Ability is High_Competence) (1)       
rule82 = [3 2 1 4 1 1]; % 20. If (Age is Mature_Adult) and (Operator_Experience is Medium) and (Tiredness is Low) then (Human_Driving_Ability is High_Competence) (1)     
rule83 = [3 4 1 4 1 1]; % 21. If (Age is Mature_Adult) and (Operator_Experience is HIgh) and (Tiredness is Low) then (Human_Driving_Ability is High_Competence) (1)       
rule84 = [4 4 1 4 1 1]; % 22. If (Age is Elderly) and (Operator_Experience is Expert) and (Tiredness is Low) then (Human_Driving_Ability is High_Competence) (1)          
rule85 = [2 4 1 4 1 1]; % 23. If (Age is Mid_Twenties) and (Operator_Experience is Expert) and (Tiredness is Low) then (Human_Driving_Ability is High_Competence) (1)     
rule86 = [3 4 1 4 1 1]; % 24. If (Age is Mature_Adult) and (Operator_Experience is Expert) and (Tiredness is Low) then (Human_Driving_Ability is High_Competence) (1)     
rule87 = [4 4 1 4 1 1]; % 25. If (Age is Elderly) and (Operator_Experience is Expert) and (Tiredness is Low) then (Human_Driving_Ability is High_Competence) (1)          
     
%defuzzification methods   
%d.defuzzMethod = 'centroid'; %default
d.defuzzMethod = 'bisector'; %best
%d.defuzzMethod = 'mom'; %tested
%d.defuzzMethod = 'som'; %tested
%d.defuzzMethod = 'lom'; %tested

d.andMethod = 'min'; %default and best
%d.andMethod = 'prod';

ruleListd = [rule63; rule64; rule65; rule66; rule67; rule68; rule69; rule70;
    rule71; rule72; rule73; rule74; rule75; rule76; rule77; rule78; rule79; rule80; rule81; rule82; 
    rule83; rule84; rule85; rule86; rule87;]; %add more rules

% Add the rules to the FIS
d = addRule(d,ruleListd);

% Print the rules to the workspade
rule = showrule(d);
%rule viewer
ruleview(d);

figure(1) % figure handler (creates figure for plot)
subplot(4,1,1), plotmf(d,'input',1); % subplot rows, columns, position  
subplot(4,1,2), plotmf(d,'input',2);
subplot(4,1,3), plotmf(d,'input',3);
subplot(4,1,4), plotmf(d,'output',1);



for i=1:size(HumanData,1) %for creating the output 
        evalHuman = evalfis([HumanData(i, 1), HumanData(i, 2), HumanData(i, 3)], d); 
        
        fprintf('%d) In(1): %.2f, In(2) %.2f, In(3): %.2f,  => Out: %.2f \n\n',i,HumanData(i,1),HumanData(i, 2),HumanData(i, 3), evalHuman);
        
        xlswrite('Test_Human.xls', evalHuman, 1, sprintf('B%d',i+1)); %change letter for output column and display test data for defuzz methods
end

