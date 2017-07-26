clear all;
close all;

tic;

rowIdx = 1;
DataOut{rowIdx,1} = 'Badger';
DataOut{rowIdx,2} = 'Femme';
DataOut{rowIdx,3} = 'Counter Chance';
DataOut{rowIdx,4} = 'Counter Success Chance';
% DataOut{rowIdx,4} = 'Badger Special Used Percentage';
% DataOut{rowIdx,4} = 'Femme Special Used Percentage';
% DataOut{rowIdx,4} = 'No Special Used Percentage';
DataOut{rowIdx,5} = 'Number of Runs';
DataOut{rowIdx,6} = 'Badger Win Percentage';

rowIdx = rowIdx + 1;

%% this function will call main.m by providing badgemons and femme

% load badgers and femmes
% TODO Replace with list

badgerTest = getBadgers();
femmeTest = getFemmes();

% setup percentages for counter and special attack, and percentage that badger would succesffully counter attack
CounterAttackChancePercentage = 0:25:100;
CounterAttackChanceSuccessPercentage = 100;
NumRunsPerSetOfInputs = 100;
results = [];

% enable whether or not badger will choose random attacks or try to special attack each time
% or if badger learns

waitHan = waitbar(0,'Running Statistical Analysis')
totalRuns = length(badgerTest) * length(femmeTest) * ...
						length(CounterAttackChancePercentage) * ...
						length(CounterAttackChanceSuccessPercentage) * ...
						NumRunsPerSetOfInputs;

runIdx = 0;
%% loop over everything
% badger
for badgerIdx = 1:length(badgerTest)
  % femme
  for femmeIdx = 1:length(femmeTest)
    % percentages
    for caPercIdx = 1:length(CounterAttackChancePercentage)
      for caSuccIdx = 1:length(CounterAttackChanceSuccessPercentage)
				% call main.m    
				for idx = 1:NumRunsPerSetOfInputs
					result = main(badgerTest(badgerIdx),femmeTest(femmeIdx),...
					CounterAttackChancePercentage(caPercIdx), ...
					CounterAttackChanceSuccessPercentage(caSuccIdx));
					results(end+1) = result;
					runIdx = runIdx + 1;
					waitbar(runIdx/totalRuns,waitHan);
					
				end
				
				% Output Row
				DataOut{rowIdx,1} = badgerTest(badgerIdx).name;
				DataOut{rowIdx,2} = femmeTest(femmeIdx).name;
				DataOut{rowIdx,3} = CounterAttackChancePercentage(caPercIdx);
				DataOut{rowIdx,4} = CounterAttackChanceSuccessPercentage(caSuccIdx);
				DataOut{rowIdx,5} = NumRunsPerSetOfInputs;
				DataOut{rowIdx,6} = length(find(results == 1))/length(results) * 100;
				
				rowIdx = rowIdx + 1;
				
      end
    end
  end
end

% write output file
fid = fopen ('TestResults.csv', 'wt');
fprintf (fid,'%s, %s, %s, %s, %s, %s\n', DataOut{1,:})
for ii = 2:rowIdx-1
	fprintf (fid,'%s, %s, %f, %f, %f, %f\n', DataOut{ii,:})
end
fclose (fid);
close(waitHan);
toc;