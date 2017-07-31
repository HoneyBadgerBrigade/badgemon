function plotScatterCounterWinChance (Data)

% loop over each case
% skip first row which is header

fig = figure;%('units','normalized','Postion',[0 0 1 1]);

% get all the unique badgers, exclude header
uniqueBadgers = unique({Data{2:length(Data),1}});
BadgerList = {Data{2:length(Data),1}};
CounterList = {Data{2:length(Data),3}};
WinChance = {Data{2:length(Data),6}};

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
	YData = [WinChance{idxs}];
	plot(XData,YData,'LineStyle','none','Marker','*','markerSize',10,'color',colors(ii,:));
	hold on;
	
	legendNames{end+1} = uniqueBadgers{ii};		

end

title('BadgeMon Test Results');
xlabel('Counter Chance(%)');
ylabel('Win Chance(%)');
legend(legendNames,'location','EastOutside');

grid on;

print(fig,'TestResults.png');

close(fig);

endfunction
