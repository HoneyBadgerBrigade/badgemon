function plotMinMeanMaxWinChance (Data, badgerAnalysis)

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



% loop over the unique badgers
for ii = 1:length(uniqueBadgers)
	legendNames = {};
	fig = figure;
	
	% get idxs that match badger namelengthmax
	idxs = [];
	for jj = 1:length(BadgerList)
		if(strcmp(BadgerList{jj},uniqueBadgers{ii}))
			idxs(end+1) = jj;
		end
	end	
	
	XData = [CounterList{idxs}];
	YData = WinChance(idxs);
	
	XDataMax = [];
	YDataMax = [];
	
	XDataMean = [];
	YDataMean = [];
	
	XDataMin = [];
	YDataMin = [];
	
	for jj = 1:length(uniqueCounterList)
		
		idxs = find(XData == uniqueCounterList(jj));
		
		tempYData = YData(idxs);
		
		XDataMax(end+1) = uniqueCounterList(jj);
		YDataMax(end+1) = max(tempYData);
		
		XDataMean(end+1) = uniqueCounterList(jj);
		YDataMean(end+1) = mean(tempYData);
		
		XDataMin(end+1) = uniqueCounterList(jj);
		YDataMin(end+1) = min(tempYData);
		
	end
	
	% plot max
	plot(XDataMax,YDataMax,'LineStyle','-','color','r');
	hold on;
	legendNames{end+1} = 'Max Win Chance';		
	
	% plot mean
	plot(XDataMean,YDataMean,'LineStyle','-','color','b');
	hold on;
	legendNames{end+1} = 'Average Win Chance';		
	
	% plot min
	plot(XDataMin,YDataMin,'LineStyle','-','color','g');
	hold on;
	legendNames{end+1} = 'Min Win Chance';		
	
	BadgerName = uniqueBadgers(ii);
	
	title(uniqueBadgers(ii));
	xlabel('Counter Chance(%)');
	ylabel('Win Chance(%)');
	legend(legendNames,'location','EastOutside');
	
	grid on;
	grid minor on;
	
	fileName = strcat(uniqueBadgers(ii),'.png');

	print(fig,fileName{1});

	close(fig);
end



endfunction
