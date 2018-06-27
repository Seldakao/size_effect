function [AgentsMat,MoneyPool,totalyearlywages] = MonthlyInteractions_Selda_201503(AgentsMat,minwage,maxwage,MoneyPool,totalyearlywages)
    

numberagents = size(AgentsMat,2);    % get number of agents

for i = 1:numberagents
    
    selectedagent = randi(numberagents); % generate random integer
        
%HIRING RULE: if selected agent unemployed --> get emplyed by
    %if selected agent has no boss and is no one's boss
    if (AgentsMat(3,selectedagent) == 0 && isempty(find(AgentsMat(3,:)==selectedagent, 1))) % return at most one in the find
            
             
        %Possible employer: everyone who is unemployed or already
        %employer --> somebody who is not a worker
        PossibleEmployers_Unemplyed_Mat = AgentsMat(:,(AgentsMat(3,:) == 0)); % extract the whole matrix of those people
       PossibleEmployers_Unemplyed_Mat(:,PossibleEmployers_Unemplyed_Mat(1,:)==selectedagent)=[]; % remove the selectedagent itself from the candidate list
        %pick a possible employer randomly weighted by amount of his
        %money. If clause for the case that there is only one possible
        %employer (in that case randsample does not work)
        if size(PossibleEmployers_Unemplyed_Mat,2) > 1% if there are more than one candidate
            newemployer = randsample(PossibleEmployers_Unemplyed_Mat(1,:),1,true,PossibleEmployers_Unemplyed_Mat(2,:));
            % sample 'one' number from the candidates' number with
            % replacement, with the money holding as weights
        else
            newemployer = PossibleEmployers_Unemplyed_Mat(1); % the number of that agent
        end
        
        
        %hire agent if possible employer has enough money:
        if AgentsMat(2,newemployer) >= (minwage + maxwage)/2
            AgentsMat(3,selectedagent) = newemployer; % revise the selectedagent's CV
        end
    end
    clear PossibleEmployers_Unemplyed_Mat newemployer;

        
% EXPENDITURE: 

    %select another agent != first one (dangerous with while!!!)
    selectedagent2 = selectedagent;
    while selectedagent2 == selectedagent
        selectedagent2 = randi(numberagents);
    end

    %And let the agent consume money -> give it to the MoneyPool

    consumption = rand * AgentsMat(2,selectedagent2);

    AgentsMat(2,selectedagent2) = AgentsMat(2,selectedagent2) - consumption;
    MoneyPool = MoneyPool + consumption;

    clear consumption selectedagent2;
    
% MARKET SAMPLE RULE

    %if agent a is not unemployed generate profit for the firm (own or
    %employers)
    %employed:
    if AgentsMat(3,selectedagent) ~= 0
        
        %select random profit from Pool
        profit = rand * MoneyPool; 
        MoneyPool = MoneyPool - profit;
        
        % Give money to employer (=firm)
        AgentsMat(2,AgentsMat(3,selectedagent)) = AgentsMat(2,AgentsMat(3,selectedagent)) + profit;
        
        %Also increase yearly firm profits
        AgentsMat(5,AgentsMat(3,selectedagent)) = AgentsMat(5,AgentsMat(3,selectedagent)) + profit;
        
        %Increase employers yearly income (=firm income + wages)
        AgentsMat(6,AgentsMat(3,selectedagent)) = AgentsMat(6,AgentsMat(3,selectedagent)) + profit;

        clear profit;
    %or capitalist
    elseif ~isempty(find(AgentsMat(3,:)==selectedagent, 1)) 
        
        %select random profit from Pool
        profit = rand * MoneyPool;
        MoneyPool = MoneyPool - profit;
        
        %give money to firm (his own) --> money to himself
        AgentsMat(2,selectedagent) = AgentsMat(2,selectedagent) + profit;
        
        %Also increase yearly firm profits
        AgentsMat(5,selectedagent) = AgentsMat(5,selectedagent) + profit;
        
        %Increase employers yearly income (=firm income + wages)
        AgentsMat(6,selectedagent) = AgentsMat(6,selectedagent) + profit;


        clear profit;
    end
    
    
% FIRING RULE (if selected agent is employer
    if ~isempty(find(AgentsMat(3,:)==selectedagent, 1)) % if the selected agent is a capitalist
       numberemployeescannotbepaid = ceil(length(find(AgentsMat(3,:)==selectedagent)) - AgentsMat(2,selectedagent)/mean([minwage maxwage])); 
       if numberemployeescannotbepaid > 0
           employeesVec = find(AgentsMat(3,:)==selectedagent);
           %take numberemployeescannotbepaid randomly and fire them
           firinglist = randsample(employeesVec,numberemployeescannotbepaid);
           AgentsMat(3,firinglist) = 0;
       end
       clear employeesVec firinglist numberemployeescannotbepaid
       
    end
    
 % WAGEPAYMET (if agent is employer)
    if ~isempty(find(AgentsMat(3,:)==selectedagent, 1))
        %vector with numbers of employees:
        employeesVec = find(AgentsMat(3,:)==selectedagent);
        
        %create a vector with random values in [minwage maxwage] to pay
        %these random wages
        wagerateVec = minwage + rand(1,length(employeesVec)) * (maxwage-minwage);
        
        %check how many employees can be paid with these wages:
        cumwagerateVec = cumsum(wagerateVec);
        payableemployees = find(cumwagerateVec <= AgentsMat(2,selectedagent));
        
        %only pay those who you can be payed with this random payment method
        if ~isempty(payableemployees)
            %pay the employees:
            AgentsMat(2,employeesVec(payableemployees)) =  AgentsMat(2,employeesVec(payableemployees)) + wagerateVec(payableemployees);

            %count the yearly income:
            AgentsMat(6,employeesVec(payableemployees)) =  AgentsMat(6,employeesVec(payableemployees)) + wagerateVec(payableemployees);
           % remove the money from the employer
            AgentsMat(2,selectedagent) = AgentsMat(2,selectedagent) - sum(wagerateVec(payableemployees));
            % record the culmulative money paid to the workers within a year
            AgentsMat(7,selectedagent) = AgentsMat(7,selectedagent) + sum(wagerateVec(payableemployees));
            
            totalyearlywages = totalyearlywages + sum(wagerateVec(payableemployees)); 
            %after each year totalyearlywages goes back to 0 in
            %WrightModelScript.
        end
        
        %pay the rest one by one with what you've got. (still randomly amount)
        if length(payableemployees) < length(employeesVec)
            for j = 1:(length(employeesVec) - length(payableemployees))
                
                %select payable wage:
                wagerate = rand * AgentsMat(2,selectedagent);
                
                %pay the wage:
                AgentsMat(2,employeesVec(length(payableemployees)+j)) = AgentsMat(2,employeesVec(length(payableemployees)+j)) + wagerate;
                
                %count the yearly income:
                AgentsMat(6,employeesVec(length(payableemployees)+j)) = AgentsMat(6,employeesVec(length(payableemployees)+j)) + wagerate;
                
                %remove money from employer:
                AgentsMat(2,selectedagent) = AgentsMat(2,selectedagent) - wagerate;
                
                %
                AgentsMat(7,selectedagent) = AgentsMat(7,selectedagent) + wagerate;
                
                totalyearlywages = totalyearlywages + wagerate; 
                %after each year totalyearlywages goes back to 0 in
                %WrightModelScript.
            end
        end
        
        
        clear j wagerate wagerateVec employeesVec cumwagerateVec payableemployees;
        
        
    end
    
    
    clear selectedagent;
end

clear i
    
end
