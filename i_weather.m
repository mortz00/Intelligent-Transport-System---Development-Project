%% 
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

% figure(1) % figure handler (creates figure for plot)
% subplot(5,1,1), plotmf(a,'input',1); % subplot rows, columns, position  
% subplot(5,1,2), plotmf(a,'input',2);
% subplot(5,1,3), plotmf(a,'input',3);
% subplot(5,1,4), plotmf(a,'input',4);
% subplot(5,1,5), plotmf(a,'output',1);

for i=1:size(WeatherData,1) %for creating the output
        evalWeather = evalfis([WeatherData(i, 2), WeatherData(i, 3), WeatherData(i, 4), WeatherData(i, 5)], a);
        fprintf('%d) In(1): %.2f, In(2) %.2f, In(3): %.2f, In(4) %.2f,  => Out: %.2f \n\n',i,WeatherData(i, 2),WeatherData(i, 3),WeatherData(i, 4),WeatherData(i, 5), evalWeather);  
        xlswrite('Test_Weather.xls', evalWeather, 1, sprintf('A%d',i+1)); %change letter for output column and display test data for defuzz methods
end
