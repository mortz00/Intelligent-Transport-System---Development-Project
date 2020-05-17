clc %clear command window

%% *** DISCLAIMER: THIS SINGLE INFERENCE ENGINE 'WEATHER SAFETY' HAS BEEN USED IN PREVIOUS COURSEWORK AND IS BEING USED TO ADD TO THIS SYSTEM ***
%--------------------------------------------------------------------------
%-------------------- INFERENCE SYSTEM ONE, WEATHER SAFETY ----------------
%--------------------------------------------------------------------------

a = newfis('WeatherSafety');

filename = ('SyntheticWeatherForecast.xlsx'); 
WeatherData = xlsread(filename); % function to read from file and writes to WeatherData

a = addvar(a, 'input', 'Precipiatation_(%)', [0 100]); % scale - self explanatory

a = addmf(a,'input',1,'Low','trapmf', [0 0 15 40]); 
a = addmf(a,'input',1,'Medium','gaussmf',  [14.5 50]); 
a = addmf(a,'input',1,'High','trapmf',  [60 85 100 100]);  

a = addvar(a, 'input', 'Temperature °C', [-40 50]); % lowest recorded temp in UK was -27.2, highest was 38.7

a = addmf(a,'input',2,'Freezing','trapmf',  [-40 -40 -20 0]); 
a = addmf(a,'input',2,'Moderate','gaussmf',  [7 16]); 
a = addmf(a,'input',2,'Very_Hot','trapmf',  [25 35 50 50]);

a = addvar(a, 'input', 'Snow_Degree', [0 10]); % detail in report what constitutes LMH etc, somewhat less pellucid that other crisp inputs

a = addmf(a,'input',3,'Light','trapmf',  [0 0 2 4.5]); % edited, mention in report 
a = addmf(a,'input',3,'Moderate','gaussmf',[1 4]); 
a = addmf(a,'input',3,'Heavy','trapmf', [4.5 7 10 10]); 

a = addvar(a, 'input', 'Wind_Speed(Mph)', [0 200]); % see Beaufort wind scale

a = addmf(a,'input',4,'Light','gaussmf', [5 0]); 
a = addmf(a,'input',4,'Moderate','gaussmf',[5 10]); 
a = addmf(a,'input',4,'Heavy','gaussmf', [5 20]);
a = addmf(a,'input',4,'ExtremelyHeavy','trapmf', [30 60 200 200]);

a = addvar(a,'output','Weather_Danger(%)',[0 100]); 

a = addmf(a,'output',1,'Low_Danger','trapmf',[0 0 30 50]); 
a = addmf(a,'output',1,'Moderate_Danger','trimf', [35 50 65]);
a = addmf(a,'output',1,'High_Danger','trimf', [55 70 85]);
a = addmf(a,'output',1,'Extreme_Danger','trapmf', [80 100 100 100]);

%rule base

%------------------------------- LOW DANGER -------------------------------

%prec(3) Temp(3) Snow(3) Wind(4) Danger() weight operator(&1 ||2)

rule1 = [1 2 0 1 1 1 1]; % 1. If (precipitation is Low) and (Temperature is Temperate) and (wind_speed is Low) then (weather_danger is low_danger) (1)      
rule2 = [1 2 0 2 1 1 1]; % 2. If (precipitation is Low) and (Temperature is Temperate) and (wind_speed is Medium) then (weather_danger is low_danger) (1)   
rule3 = [2 2 0 1 1 1 1]; % 3. If (precipitation is Medium) and (Temperature is Temperate) and (wind_speed is Low) then (weather_danger is low_danger) (1)   
rule4 = [2 2 0 2 1 1 1]; % 4. If (precipitation is Medium) and (Temperature is Temperate) and (wind_speed is Medium) then (weather_danger is low_danger) (1)
rule5 = [3 2 0 1 1 1 1]; % 5. If (precipitation is High) and (Temperature is Temperate) and (wind_speed is Low) then (weather_danger is low_danger) (1)     
rule6 = [3 2 1 2 1 1 1]; % 6. If (precipitation is High) and (Temperature is Temperate) and (wind_speed is Medium) then (weather_danger is low_danger) (1)  

%----------------------------- MODERATE DANGER ----------------------------

%prec(3) Temp(3) Snow(3) Wind(4) Danger weight operator(&1 ||2)

rule7 =  [1 3 0 1 2 1 1]; % 7. If (precipitation is Low) and (Temperature is Very_Hot) and (wind_speed is Low) then (weather_danger is moderate_danger) (1)       
rule8 =  [1 3 0 2 2 1 1]; % 8. If (precipitation is Low) and (Temperature is Very_Hot) and (wind_speed is Medium) then (weather_danger is moderate_danger) (1)    
rule9 =  [1 2 0 3 2 1 1]; % 9. If (precipitation is Low) and (Temperature is Temperate) and (wind_speed is High) then (weather_danger is moderate_danger) (1)     
rule10 = [2 3 0 1 2 1 1]; % 10. If (precipitation is Medium) and (Temperature is Very_Hot) and (wind_speed is Low) then (weather_danger is moderate_danger) (1)   
rule11 = [2 3 0 2 2 1 1]; % 11. If (precipitation is Medium) and (Temperature is Very_Hot) and (wind_speed is Medium) then (weather_danger is moderate_danger) (1)
rule12 = [3 3 0 1 2 1 1]; % 12. If (precipitation is High) and (Temperature is Very_Hot) and (wind_speed is Low) then (weather_danger is moderate_danger) (1)     

%------------------------------- HIGH DANGER ------------------------------

%prec(3) Temp(3) Snow(3) Wind(4) Danger() weight operator(&1 ||2)

rule13 = [1 1 0 1 3 1 1]; % 13. If (precipitation is Low) and (Temperature is freezing) and (wind_speed is Low) then (weather_danger is high_danger) (1)          
rule14 = [1 1 0 2 3 1 1]; % 14. If (precipitation is Low) and (Temperature is freezing) and (wind_speed is Medium) then (weather_danger is high_danger) (1)       
rule15 = [1 3 0 3 3 1 1]; % 15. If (precipitation is Low) and (Temperature is Very_Hot) and (wind_speed is High) then (weather_danger is high_danger) (1)         
rule16 = [2 1 0 1 3 1 1]; % 16. If (precipitation is Medium) and (Temperature is freezing) and (wind_speed is Low) then (weather_danger is high_danger) (1)       
rule17 = [2 1 0 2 3 1 1]; % 17. If (precipitation is Medium) and (Temperature is freezing) and (wind_speed is Medium) then (weather_danger is high_danger) (1)    
rule18 = [2 2 0 3 3 1 1]; % 18. If (precipitation is Medium) and (Temperature is Temperate) and (wind_speed is High) then (weather_danger is high_danger) (1)     
rule19 = [3 1 0 1 3 1 1]; % 19. If (precipitation is High) and (Temperature is freezing) and (wind_speed is Low) then (weather_danger is high_danger) (1)         
rule20 = [3 3 0 2 3 1 1]; % 20. If (precipitation is High) and (Temperature is Very_Hot) and (wind_speed is Medium) then (weather_danger is high_danger) (1)      
rule21 = [3 2 0 3 3 1 1]; % 21. If (precipitation is High) and (Temperature is Temperate) and (wind_speed is High) then (weather_danger is high_danger) (1)

rule28 = [0 1 1 1 3 1 1]; % 28. If (Temperature is freezing) and (snow_degree is Light) and (wind_speed is Low) then (weather_danger is high_danger) (1)          
rule29 = [0 1 2 1 3 1 1]; % 29. If (Temperature is freezing) and (snow_degree is Moderate) and (wind_speed is Low) then (weather_danger is high_danger) (1)       
rule30 = [0 1 1 2 3 1 1]; % 30. If (Temperature is freezing) and (snow_degree is Light) and (wind_speed is Medium) then (weather_danger is high_danger) (1)       
rule31 = [0 2 1 1 3 1 1]; % 31. If (Temperature is Temperate) and (snow_degree is Light) and (wind_speed is Low) then (weather_danger is high_danger) (1)         
rule32 = [0 2 2 1 3 1 1]; % 32. If (Temperature is Temperate) and (snow_degree is Moderate) and (wind_speed is Low) then (weather_danger is high_danger) (1)      
rule33 = [0 2 1 2 3 1 1]; % 33. If (Temperature is Temperate) and (snow_degree is Light) and (wind_speed is Medium) then (weather_danger is high_danger) (1)      

%-------------------------------- VERY HIGH -------------------------------

%prec(3) Temp(3) Snow(3) Wind(4) Danger weight operator(&1 ||2)

rule22 = [1 1 0 3 4 1 1]; % 22. If (precipitation is Low) and (Temperature is freezing) and (wind_speed is High) then (weather_danger is extreme_danger) (1)      
rule23 = [2 1 0 3 4 1 1]; % 23. If (precipitation is Medium) and (Temperature is freezing) and (wind_speed is High) then (weather_danger is extreme_danger) (1)   
rule24 = [2 3 0 3 4 1 1]; % 24. If (precipitation is Medium) and (Temperature is Very_Hot) and (wind_speed is High) then (weather_danger is extreme_danger) (1)   
rule25 = [3 1 0 2 4 1 1]; % 25. If (precipitation is High) and (Temperature is freezing) and (wind_speed is Medium) then (weather_danger is extreme_danger) (1)   
rule26 = [3 1 0 3 4 1 1]; % 26. If (precipitation is High) and (Temperature is freezing) and (wind_speed is High) then (weather_danger is extreme_danger) (1)     
rule27 = [3 3 0 3 4 1 1]; % 27. If (precipitation is High) and (Temperature is Very_Hot) and (wind_speed is High) then (weather_danger is extreme_danger) (1)     

rule34 = [0 1 2 2 4 1 1]; % 34. If (Temperature is freezing) and (snow_degree is Moderate) and (wind_speed is Medium) then (weather_danger is extreme_danger) (1) 
rule35 = [0 1 1 3 4 1 1]; % 35. If (Temperature is freezing) and (snow_degree is Light) and (wind_speed is High) then (weather_danger is extreme_danger) (1)      
rule36 = [0 1 2 3 4 1 1]; % 36. If (Temperature is freezing) and (snow_degree is Moderate) and (wind_speed is High) then (weather_danger is extreme_danger) (1)   
rule37 = [0 2 2 2 4 1 1]; % 37. If (Temperature is Temperate) and (snow_degree is Moderate) and (wind_speed is Medium) then (weather_danger is extreme_danger) (1)
rule38 = [0 2 1 3 4 1 1]; % 38. If (Temperature is Temperate) and (snow_degree is Light) and (wind_speed is High) then (weather_danger is extreme_danger) (1)     
rule39 = [0 2 2 3 4 1 1]; % 39. If (Temperature is Temperate) and (snow_degree is Moderate) and (wind_speed is High) then (weather_danger is extreme_danger) (1)  
rule40 = [0 0 0 4 4 1 1]; % 40. If (wind_speed is Extreme) then (weather_danger is extreme_danger) (1)                                                            
rule41 = [0 0 3 0 4 1 1]; % 41. If (snow_degree is Heavy) then (weather_danger is extreme_danger) (1)                                                             

%if snow then !rain && if rain then !snow

% if snow high - always extreme danger
% if wind Extreme - always extreme danger

%defuzzification methods  need to justify which is the best method 
%a.defuzzMethod = 'centroid'; %default
a.defuzzMethod = 'bisector'; %best
%a.defuzzMethod = 'mom'; %tested
%a.defuzzMethod = 'som'; %tested
%a.defuzzMethod = 'lom'; %tested

%a.andMethod = 'min'; %default and best
%a.andMethod = 'prod';

%rule base
ruleListA = [rule1; rule2; rule3; rule4; rule5; rule6; rule7; rule8; rule9; rule10; rule11; rule12; rule13; rule14;
    rule15; rule16; rule17; rule18; rule19; rule20; rule21; rule22; rule23; rule24; rule25; rule26; rule27; rule28;
    rule29; rule30; rule31; rule32; rule33; rule34; rule35; rule36; rule37; rule38; rule39; rule40; rule41;];

% Add the rules to the FIS
a = addRule(a,ruleListA);

% Print the rules to the workspace
rule = showrule(a)
%rule viewer
ruleview(a)

for i=1:size(WeatherData,1) %for creating the output
        evalWeather = evalfis([WeatherData(i, 2), WeatherData(i, 3), WeatherData(i, 4), WeatherData(i, 5)], a);
        fprintf('%d) In(1): %.2f, In(2) %.2f, In(3): %.2f, In(4) %.2f,  => Out: %.2f \n\n',i,WeatherData(i, 2),WeatherData(i, 3),WeatherData(i, 4),WeatherData(i, 5), evalWeather);  
        xlswrite('outputTest.xls', evalWeather, 1, sprintf('A%d',i+1)); %change letter for output column and display test data for defuzz methods
end

%% 
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

ruleListB = [rule42; rule43; rule44; rule45; rule46; rule47; rule48; rule49;
    rule50; rule51; rule52; rule53; rule54; rule54a; rule55a; rule56a; rule57a; rule58a;];

%defuzzification methods   
%b.defuzzMethod = 'centroid'; %default
b.defuzzMethod = 'bisector'; %best
%b.defuzzMethod = 'mom'; %tested
%b.defuzzMethod = 'som'; %tested
%b.defuzzMethod = 'lom'; %tested

%b.andMethod = 'min'; %default and best
%b.andMethod = 'prod';

% Add the rules to the FIS
b = addRule(b,ruleListB);

% Print the rules to the workspace
rule = showrule(b);
%rule viewer
ruleview(b);

for i=1:size(CongestionData,1) %for creating the output - need to change this for loop to read and write correct data
        evalCongest = evalfis([CongestionData(i, 1), CongestionData(i, 2), CongestionData(i, 3)], b); %<- changed from an 'a'
        fprintf('%d) In(1): %.2f, In(2) %.2f, In(3): %.2f,  => Out: %.2f \n\n',i,CongestionData(i,1),CongestionData(i, 2),CongestionData(i, 3), evalCongest);
        xlswrite('outputTest.xls', evalCongest, 1, sprintf('B%d',i+1)); %change letter for output column and display test data for defuzz methods
end

%% 
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

c = addvar(c,'output','AtmosphericConditions_Good-Bad',[0 100]); %good to bad

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

ruleListC = [rule55; rule56; rule57; rule58; rule59; rule60; ...
    rule61; rule62];

%defuzzification methods
%c.defuzzMethod = 'centroid'; default 
c.defuzzMethod = 'bisector';
%c.defuzzMethod = 'mom';
%c.defuzzMethod = 'som';
%c.defuzzMethod = 'lom';

%c.andMethod = 'min'; %default and best
%c.andMethod = 'prod';

% Add the rules to the FIS
c = addRule(c,ruleListC);

% Print the rules to the workspace
rule = showrule(c);

%rule viewer
ruleview(c);

for i=1:size(outputTest,1) 
        EvalAtmospheric = evalfis([outputTest(i, 1), outputTest(i, 2)], c); 
        
        fprintf('%d) In(1): %.2f, In(2) %.2f,   => Out: %.2f \n\n',i,outputTest(i,1)...
            ,outputTest(i, 2), EvalAtmospheric);
        
        xlswrite('outputTest.xls', EvalAtmospheric, 1, sprintf('D%d',i+1)); 
end

%% 
%--------------------------------------------------------------------------
%---------------- INFERENCE SYSTEM FOUR , HUMAN CULPABILITY ---------------
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

%d.andMethod = 'min'; %default and best
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

for i=1:size(HumanData,1) %for creating the output 
        evalHuman = evalfis([HumanData(i, 1), HumanData(i, 2), HumanData(i, 3)], d); 
        
        fprintf('%d) In(1): %.2f, In(2) %.2f, In(3): %.2f,  => Out: %.2f \n\n',i,HumanData(i,1),HumanData(i, 2),HumanData(i, 3), evalHuman);
        
        %xlswrite('outputHuman.xls', evalHuman, 1, sprintf('A%d',i+1)); %change letter for output column and display test data for defuzz methods
        xlswrite('outputTest.xls', evalHuman, 1, sprintf('F%d',i+1)); 
end

%% 
%--------------------------------------------------------------------------
%---------------- INFERENCE SYSTEM FIVE , Driving suitability -------------
%------------------------------ combination #2 ----------------------------

e = newfis('Driving_Suitability');

filename = ('outputTest.xls');

outputTest = xlsread(filename);

e = addvar(e,'input','AtmosphericConditions_Good-Bad',[0 100]);

e = addmf(e,'input',1,'Good','trapmf', [0 0 10 40]);
e = addmf(e,'input',1,'Moderate','gaussmf',[12 50]);
e = addmf(e,'input',1,'Bad','trapmf',[60 90 100 100]);

e = addvar(e,'input','Human_Driving_Ability',[0 100]);

e = addmf(e,'input',2,'Very_Low_Competence','trapmf',[0 0 10 20]);
e = addmf(e,'input',2,'Low_Competence','gaussmf',[7.5 30]); % need edit
e = addmf(e,'input',2,'Average_Competence','gaussmf', [7.5 50]); % need edit
e = addmf(e,'input',2,'High_Competence','trapmf',[50 80 100 100]); 

e = addvar(e,'output','DrivingSuitability_Good-Bad',[0 100]); %bad is higher on the scale

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
%e.defuzzMethod = 'centroid';
e.defuzzMethod = 'bisector';
%e.defuzzMethod = 'mom';
%e.defuzzMethod = 'som';
%e.defuzzMethod = 'lom';

ruleListd = [rule88; rule89; rule90; rule91; rule92; rule93; rule94;];

% Add the rules to the FIS
e = addRule(e,ruleListd);

% Print the rules to the workspace
rule = showrule(e);

%rule viewer
ruleview(e);

for i=1:size(outputTest,1) 
        EvalAtmospheric = evalfis([outputTest(i, 4), outputTest(i, 6)], e); 
        
        fprintf('%d) In(1): %.2f, In(2) %.2f,   => Out: %.2f \n\n',i,outputTest(i,4)...
            ,outputTest(i, 6), EvalAtmospheric);
        
        xlswrite('outputTest.xls', EvalAtmospheric, 1, sprintf('H%d',i+1)); 
end