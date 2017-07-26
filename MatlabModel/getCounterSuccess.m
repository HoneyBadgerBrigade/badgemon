function [success] = getCounterSuccess (CAChance,CASuccessChance)
	success = false;
	
	% if we get the chance to execute the counter attack
	if(CAChance >= unifrnd(0,100))
		% if the badger successfull counter attacks
		if(CASuccessChance >= unifrnd(0,100))
			success = true;
		end
	end
	
endfunction
