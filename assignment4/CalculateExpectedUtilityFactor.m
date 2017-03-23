% Copyright (C) Daphne Koller, Stanford University, 2012

function EUF = CalculateExpectedUtilityFactor( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: A factor over the scope of the decision rule D from I that
  % gives the conditional utility given each assignment for D.var
  %
  % Note - We assume I has a single decision node and utility node.
  EUF = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  
  F = [I.RandomFactors I.DecisionFactors I.UtilityFactors];
  
  parents_D=cell2mat({I.DecisionFactors(:).var});
  %parents_D=parents_D(2:end);
  W_vars=setdiff(cell2mat({F(:).var}),parents_D);
  
  F_sub=[I.RandomFactors I.UtilityFactors];%without decision factors
  F_tmp=F_sub(1);
  
  for idfactor=2:length(F_sub)
      F_tmp=FactorProduct(F_tmp,F_sub(idfactor));
      
  end
  
  EUF = VariableElimination(F_tmp, W_vars);%sum up w_vars
%   PrintFactor(mu_factor)
%   
%   for i=1:mu_factor.card(1):length(mu_factor.val)
%       max_tmp=-1e6
%       for j=0:mu_factor.card(1)-1%for every possible decision
%           if mu_factor.val(i+j)>max_tmp
%               max_tmp=mu_factor.val(i)
%           end          
%       end
%       EUF=EUF+max_tmp;
%       
%   end
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  


  
end  
