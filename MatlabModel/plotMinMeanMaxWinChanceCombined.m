function plotMinMeanMaxWinChanceCombined (Data, badgerAnalysis)

% loop over each case
% skip first row which is header

% get all the unique badgers, exclude header
if(badgerAnalysis == true)
	uniqueBadgers = unique({Data{2:length(Data),1}});
	BadgerList = {Data{2:length(Data),1}};
	WinChance = cell2mat({Data{2:length(Data),6}});
else % get the femmes
	uniqueBadgers = unique({Data{2:length(Data),2}});
	BadgerList = {Data{2:length(Data),2}};
	% inverse the win chance
	WinChance = 100 .- cell2mat({Data{2:length(Data),6}});
end

CounterList = {Data{2:length(Data),3}};
uniqueCounterList = [unique(cell2mat(CounterList))];

fig = figure;

colors = jet(length(uniqueBadgers));

legendNames = {};

% loop over the unique badgers
for ii = 1:length(uniqueBadgers)
		
	% get idxs that match badger namelengthmax
	idxs = [];
	for jj = 1:length(BadgerList)
		if(strcmp(BadgerList{jj},uniqueBadgers{ii}))
			idxs(end+1) = jj;
		end
	end	
	
	XData = [CounterList{idxs}];
	YData = WinChance(idxs);
	
	XDataMean = [];
	YDataMean = [];
	
	for jj = 1:length(uniqueCounterList)
		
		idxs = find(XData == uniqueCounterList(jj));
		
		tempYData = YData(idxs);
		
		XDataMean(end+1) = uniqueCounterList(jj);
		YDataMean(end+1) = mean(tempYData);
		
	end	
	
	% plot mean
	plot(XDataMean,YDataMean,'LineStyle','-','color',colors(ii,:));
	hold on;
	legendNames{end+1} = char(uniqueBadgers(ii));		
	
	
end

title('Average Win Rate');
xlabel('Counter Chance(%)');
ylabel('Win Chance(%)');
legend(legendNames,'location','EastOutside');

grid on;
grid minor on;

if(badgerAnalysis)
	fileName = strcat('AllBadgersAverage','.png');
else
	fileName = strcat('AllFemmeAverage','.png');
end

print(fig,fileName);

close(fig);


endfunction
