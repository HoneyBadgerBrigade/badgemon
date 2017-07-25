clear all;
close all;

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
CounterAttackChancePercentage = 0:25:100;
CounterAttackChanceSuccessPercentage = 100;

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
        result = main(badgerTest(badgerIdx),femmeTest(femmeIdx),...
        CounterAttackChancePercentage(caPercIdx), ...
        CounterAttackChanceSuccessPercentage(caSuccIdx))
      end
    end
  end
end
