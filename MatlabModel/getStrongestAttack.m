function [attack] = getStrongestAttack (card)
	
	attack = '';
	
	stats = [card.knowledge, card.humour, card.logic, card.agency];
	[max_val, max_stat] = max(stats);
	
	if(max_stat == 1)
		attack = 'knowledge';
	elseif(max_stat == 2)
		attack = 'humour';
	elseif(max_stat == 3)
		attack = 'logic';
	elseif(max_stat == 4)
		attack = 'agency';
	end
	
endfunction
