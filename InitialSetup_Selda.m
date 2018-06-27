function[AgentsMat] = InitialSetup_Selda(numberagents,totalmoney)
    %Description

    %AgentsMat Rows:
    %1: Number of Agent
    %2: Amount of money he has
    %3: Number of employer: 0 if he is boss or unemplyed
    %4: Number of employees if he is boss, otherwise =0
    %5: Amount of Money earned this year(!) from sales
    %6: Yearly(!) income from both wages and firm revenue
    %7: Yearely wage paied to the empolyees from the frim(it is be
    %refreshed very year)
    AgentsMat = zeros(7,numberagents);

    % Randomly distribute the money
    moneyVec= randn(1,numberagents) + totalmoney/numberagents;
    multiplicator = totalmoney/sum(moneyVec);
    moneyVec = moneyVec * multiplicator;

    AgentsMat(1,:) = 1:numberagents;
    AgentsMat(2,:) = moneyVec;
% Equally Distribute the Money
%AgentsMat(2,:)=totalmoney/numberagents;
end
    
