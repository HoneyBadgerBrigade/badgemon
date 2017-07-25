function [win] = main (badger, femme,CAChance,CASuccessChance)

  win = false;
  
  gameFinished = false;
  
  % badger and femme struct fie
  % name, initiative, knowledge(0), humor(1), logic(2), agency(3), hp  
  
  % check initiative
  % if femme higher, femme attacks first, else badger attacks first
  
  femmeAttack = femme.initiative >= badger.initiative;
  
  while(~gameFinished)
  
		if(femmeAttack)
			
			% execute femme attack
			% before each attack, check special
			% when femme attacks, execute counter check
			
		else
		
			% execute badger attack
			% before each attack, check special
		
		end  
		
		% once badger or femme reaches 0 hp, check who wins   
		if(badger.hp <= 0)
			win = false;
			return;
		elseif(femme.hp <= 0)
			win = true;
			return;
		end
		
	end
endfunction
