% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeLinearExpectations( I )
  % Inputs: An influence diagram I with a single decision node and one or more utility nodes.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  % You may assume that there is a unique optimal decision.
  %
  % This is similar to OptimizeMEU except that we will have to account for
  % multiple utility factors.  We will do this by calculating the expected
  % utility factors and combining them, then optimizing with respect to that
  % combined expected utility factor.  
MEU=0;
OptimalDecisionRule=struct('var', [], 'card', [], 'val', []);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  % A decision rule for D assigns, for each joint assignment to D's parents, 
  % probability 1 to the best option from the EUF for that joint assignment 
  % to D's parents, and 0 otherwise.  Note that when D has no parents, it is
  % a degenerate case we can handle separately for convenience.
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  parents_D=cell2mat({I.DecisionFactors(:).var});
cards=cell2mat({I.DecisionFactors(:).card});
%parents_D=parents_D(2:end);
OptimalDecisionRule.var=parents_D;
OptimalDecisionRule.card=cards;
OptimalDecisionRule.val=zeros(prod(OptimalDecisionRule.card),1);


  for i=1:length(I.UtilityFactors)
      F_tmp=I;
      F_tmp.UtilityFactors=I.UtilityFactors(i);
      mu_factors(i)=CalculateExpectedUtilityFactor(F_tmp);
  end
  
  
  f_utility_total=mu_factors(1);
  for idutiliy=2:length(mu_factors)
    f_utility_total= FactorAddition(f_utility_total, mu_factors(idutiliy));  
  end
  
  mu_factor=f_utility_total;
  
  [dummy, mapA] = ismember(OptimalDecisionRule.var, mu_factor.var);
 
 assignments = IndexToAssignment(1:prod(OptimalDecisionRule.card), OptimalDecisionRule.card);
 indxA = AssignmentToIndex(assignments(:, mapA), mu_factor.card);
 
 
 for i=1:mu_factor.card(1):length(mu_factor.val)
      max_tmp=-1e6;
      idx_max=0;
      for j=0:mu_factor.card(1)-1%for every possible decision
          if mu_factor.val(indxA(i+j))>max_tmp
              max_tmp=mu_factor.val(indxA(i+j));
              idx_max=i+j;
          end          
      end
      MEU=MEU+max_tmp;
      OptimalDecisionRule.val(idx_max)=1;
      
  end


end
