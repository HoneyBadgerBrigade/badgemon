function [attack] = getRandomAttack ()

	attack = unidrnd(4);	
	
	if(attack == 1)
		attack = 'knowledge';
	elseif(attack == 2)
		attack = 'humour';
	elseif(attack == 3)
		attack = 'logic';
	elseif(attack == 4)
		attack = 'agency';
	end
	
endfunction
