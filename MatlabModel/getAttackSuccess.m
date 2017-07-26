function [success] = getAttackSuccess (attacker, defender, attack)
	
	success = false;
	if(attacker.(attack) > defender.(attack))
		success = true;
	else
		success = false;
	end
	
endfunction
