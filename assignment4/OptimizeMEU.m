% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeMEU( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  
  % We assume I has a single decision node.
  % You may assume that there is a unique optimal decision.
  D = I.DecisionFactors(1);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  % 
  % Some other information that might be useful for some implementations
  % (note that there are multiple ways to implement this):
  % 1.  It is probably easiest to think of two cases - D has parents and D 
  %     has no parents.
  % 2.  You may find the Matlab/Octave function setdiff useful.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
MEU=0;
OptimalDecisionRule=struct('var', [], 'card', [], 'val', []);
parents_D=cell2mat({I.DecisionFactors(:).var});
cards=cell2mat({I.DecisionFactors(:).card});
%parents_D=parents_D(2:end);
OptimalDecisionRule.var=parents_D;
OptimalDecisionRule.card=cards;
OptimalDecisionRule.val=zeros(prod(OptimalDecisionRule.card),1);


 mu_factor = CalculateExpectedUtilityFactor( I );
 
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
