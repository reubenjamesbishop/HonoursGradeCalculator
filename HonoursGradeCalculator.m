%% Setup
close all; clearvars; clc;

% Enter name of transcript PDF
fileName = 'Transcript.pdf';

%% File Reading 
transcript = extractFileText(fileName);
transcript_lines = splitlines(transcript);
tokenized_lines = tokenizedDocument(transcript_lines);

%% Parse .PDF
subject_count = 0; 
results = [];

for i=1:length(tokenized_lines)

    words = string(tokenized_lines(i));
    numbers = str2double(words);
    numbers = numbers(~isnan(numbers));
    
    try 
        vals = numbers(end-2:end);
        vals(1) = floor(vals(1)/1000);
        results = [results; vals];
        subject_count = subject_count+1;
    catch 
        % Not a valid line
    end 
end 

%% Calculate Honours Grade 

N1 = min(sum(results(:,1) == 1), 24);
N2 = min(sum(results(:,1) == 2), 24);
N3 = min(sum(results(:,1) == 3), 24);
N4 = min(sum(results(:,1) == 4), 24);

units_grade_sum_2 = 0; units_grade_sum_3 = 0; units_grade_sum_4 = 0;
units_sum_2 = 0; units_sum_3 = 0; units_sum_4 = 0;

for i=1:length(results)
    
    if(results(i,1) == 2)
        units_grade_sum_2 = units_grade_sum_2 + results(i,2)*results(i,3);
        units_sum_2 = units_sum_2 + results(i,2);
        
    elseif (results(i,1) == 3)
        
        units_grade_sum_3 = units_grade_sum_3 + results(i,2)*results(i,3);
        units_sum_3 = units_sum_3 + results(i,2);
        
    elseif (results(i,1) == 4)
        
        units_grade_sum_4 = units_grade_sum_4 + results(i,2)*results(i,3);
        units_sum_4 = units_sum_4 + results(i,2);
    end
    
end

A2 = units_grade_sum_2/units_sum_2; 
A3 = units_grade_sum_3/units_sum_3; 
A4 = units_grade_sum_4/units_sum_4;

honours_average = (2*N2/24*A2 + 3*N3/24*A3 + 5*N4/24*A4)/(2*N2/24 + 3*N3/24+ 5*N4/24);

%% Perform and display Calculation 
fprintf('Your Honours Average is: %f\n', honours_average);
fprintf('You have completed %d subjects.\n', subject_count);
