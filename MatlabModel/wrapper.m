clear all;
close all;

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

badgerTest(1).name = 'Harambe';
badgerTest(1).initiative = 1;
badgerTest(1).knowledge = 7;
badgerTest(1).humour = 7;
badgerTest(1).logic = 10;
badgerTest(1).agency = 8;
badgerTest(1).hp = 3;

femmeTest(1).name = 'DF';
femmeTest(1).initiative = 4;
femmeTest(1).knowledge = 10;
femmeTest(1).humour = 8;
femmeTest(1).logic = 7;
femmeTest(1).agency = 7;
femmeTest(1).hp = 3;

% setup percentages for counter and special attack, and percentage that badger would succesffully counter attack
CounterAttackChancePercentage = 0;%0:25:100;
CounterAttackChanceSuccessPercentage = 100;
NumRunsPerSetOfInputs = 1000;
results = [];

% enable whether or not badger will choose random attacks or try to special attack each time
% or if badger learns


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
	fprintf (fid,'%s, %s, %f, %f, %f, %f', DataOut{ii,:})
end
fclose (fid);
