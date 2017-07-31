function TransposeDataOutTable (Data)

% for each counter attack percentage
BadgerList = {Data{2:length(Data),1}};
FemmeList = {Data{2:length(Data),2}};
CounterList = {Data{2:length(Data),3}};
WinChance = {Data{2:length(Data),6}};

uniqueBadgers = unique({Data{2:length(Data),1}});
uniqueFemmes = unique({Data{2:length(Data),2}});
uniqueCounterList = [unique(cell2mat(CounterList))];

% header will be unique femmes
% columns will be unique badgers

for counterListIdx = 1:length(uniqueCounterList)
	
	% new file
	DataOut{1,1} = num2str(uniqueCounterList(counterListIdx));
	
	idxs = find(cell2mat(CounterList) == uniqueCounterList(counterListIdx));
	
	TempBadgerList = BadgerList(idxs);
	TempFemmeList = FemmeList(idxs);
	TempCounterList = CounterList(idxs);
	TempWinChance = WinChance(idxs);
	
	% create header
	for ii = 1:length(uniqueBadgers)
		DataOut{1,ii+1} = uniqueBadgers{ii};
	end
	
	for ii = 1:length(uniqueFemmes)
		DataOut{ii+1,1} = uniqueFemmes{ii};
	end
	
	% for each badger 
	for ii = 1:length(uniqueBadgers)
		for jj = 1:length(uniqueFemmes)
			
			femme = uniqueFemmes{jj};
			badger = uniqueBadgers{ii};
			
			idx = 0;
			
			% find the win chance
			for kk = 1:length(TempCounterList)
				
				if(strcmp(femme,TempFemmeList{kk}) && strcmp(badger,TempBadgerList{kk}))
					idx = kk;
					break;
				end
				
			end
			
			DataOut{jj+1,ii+1} = cell2mat(TempWinChance(idx));
			
		end
	end
	
	% write output file
	
	% write output file
	fileName = strcat('TestResultsTransposed', DataOut{1,1},'.csv');
	fid = fopen (fileName, 'wt');
	fprintf (fid,'%s, %s, %s, %s, %s, %s, %s, %s\n', DataOut{1,:})
	for ii = 2:size(DataOut,1)
		fprintf (fid,'%s, %f, %f, %f, %f, %f, %f, %f\n', DataOut{ii,:})
	end
	fclose (fid);
	
	
end

endfunction
