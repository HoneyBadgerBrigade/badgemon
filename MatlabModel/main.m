function [win] = main (badger, femme,CAChance,CASuccessChance)

  win = false;
  
  gameFinished = false;
  
  % badger and femme struct fie
  % name, initiative, knowledge(0), humor(1), logic(2), agency(3), hp  
  
  % check initiative
  % if femme higher, femme attacks first, else badger attacks first
  
  femmeAttack = femme.initiative >= badger.initiative;
	
	femmeAttackCooldown = 0;	
  
  while(~gameFinished)  
		if(femmeAttack) % femme attack
			
			% execute femme attack
			% before each attack, check special
			attack = '';
			% femme selects strongest attack, uses it if femmeAttackCooldown == 0
			attack = getStrongestAttack(femme);
			% if stronget attack is on cooldown, select another attack
			if(femmeAttackCooldown > 0)
				attack = getRandomAttackNotStrongest(attack);
				femmeAttackCooldown = femmeAttackCooldown - 1;
			else
				femmeAttackCooldown = 1 + unidrnd(2); % gets random number between 2-3
			end
			
			% when femme attacks, execute counter check
			wasCounterSuccessful = getCounterSuccess(CAChance,CASuccessChance);
			
			if(wasCounterSuccessful) % attack countered, badger gets to attack now				
				% do nothing
			else % attack was not successful
				attackSuccess = getAttackSuccess(femme,badger,attack);
				if(attackSuccess)
					badger = cardHit(badger);
				end				
			end			
			femmeAttack = ~femmeAttack;
		else % badger attack
		
			% execute badger attack, TODO learn what to attack with or to attempt to special attack
			% before each attack, check special
			attack = getRandomAttack();
			attackSuccess = getAttackSuccess(badger,femme,attack);
			if(attackSuccess)
				femme = cardHit(femme);
				% femme gets stronger against attacks that hit
				femme = femmeDefenseUp(femme,attack);
			end
			
			femmeAttack = ~femmeAttack;
			
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
