function [attack] = getRandomAttackNotStrongest (strongestAttack)

	attacksToSelectFrom = [];
	if(strcmp(strongestAttack, 'knowledge'))
		attacksToSelectFrom = [2 3 4];
	elseif(strcmp(strongestAttack ,'humour'))
		attacksToSelectFrom = [1 3 4];
	elseif(strcmp(strongestAttack,'logic'))
		attacksToSelectFrom = [1 2 4];
	elseif(strcmp(strongestAttack,'agency'))
		attacksToSelectFrom = [1 2 3];
	end
	
	randIdx = unidrnd(3);
	
	attack = attacksToSelectFrom(randIdx);
	
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
