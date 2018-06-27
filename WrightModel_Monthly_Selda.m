function [AgentsMat,NumberCapitalistsVec,NumberWorkerVec,NumberUnemplVec,NumberofemployeesMat,MonthlyfirmsalesMat,TotalmonthlywagesVec,MonthlyIncomeMat,MonthlyWealthMat,MonthlyWagePaidMat,MonthlyStatusMat] = WrightModel_Monthly_Selda(numberagents,years,totalmoney,minwage,maxwage,MoneyPool,simulationnumber)
%This function simulates the the model introduced bei Ian Wright in his
%paper published in 2005 "The social architecture of capitalism".
% INPUT is
% (numberagents,years,totalmoney,minwage,maxwage,MoneyPool,dontaskjustsimulate):
%
%   numberagents: Number of agents in the economy
%   years:  length of this simulation in years. It has monthly actions that
%           are carried out 12 times for one year.
%   totalmoney: total amount of money in the system
%   min/maxwage:    minimum and maximum wage in the economy.
%   MoneyPool:  the money that is in the moneypool in the beginning
%               (usually 0)
%   dontaskjustsimulate:    can be 1 or 0, meaning:
%                           1: skip the dialogue that asks if you want to
%                           load an existing saved simulation or if you
%                           want to resimulate the things
%                           0: if there is already a simulation with the parameters that 
%                               you have entered, the program will start a dialogue asking 
%                               you wether you'd like to just load the existing data or would like to redo the simulation.
%
%
% OUTPUT:
%[AgentsMat,NumberCapitalistsVec,NumberWorkerVec,NumberUnemplVec,YearlyStatusMat,RichestguyVec,NumberpoorpeopleVec,WhoistherichestVec,NumberofemployeesMat,YearlyfirmsalesMat,TotalyearlywagesVec,YearlyIncomeMat,YearlyWealthMat]
%
%AgentsMat: size= 6 x numberagents, data of individual agents; this can be initialized with "InitialSetup.m":
%           col1: number of agent
%           col2: amount of money that the agent 
%           3: Number of employer: 0 if he is boss or unemplyed
%           4: Number of employees if he is boss, otherwise =0
%           5: Amount of Money earned this year(!) from sales
%           6: Yearly(!) income from both wages and firm revenue
%           7: Yearly wage paid as a firm
%NumberCapitalistsVec: A Vector that stores the number of capitalists for
%                       each year.
%NumberWorkerVec/NumberUnemplVec: Same with employees and unemployed.
%YearlyStatusMat:   size: years x numberagents; each row stores the status of
%                   each agent for that year.
%deleted R0000000000ichestguyVec: Reports the amount of money the richest guy has, every year
%deleted NumberpoorpeopleVec:   Reports the number of people the have less than 1 m
%deleted WhoistherichestVec: WHO is the richest guy at the end of each year
%NumberofemployeesMat: number of employees employed by each agent (0= no
%                       emplyer) every year
%YearlyfirmsalesMat: the profit that each agent makes each year through
%                       capitalist revenue
%TotalyearlywagesVec: amount of wages that every agent pays out each year
%YearlyIncomeMat:   income of every agent each row = one year
%YearlyWealthMat:   amount of money that every agent has at the end of the
%                   year



% Initialize measurement variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Most important matrix
AgentsMat = InitialSetup_Selda(numberagents,totalmoney);


%monthly Matrices
NumberofemployeesMat = zeros(years*12,numberagents);

%monthly scalars
totalmonthlywages = 0;


%monthly Vectors
NumberCapitalistsVec = zeros(1,years*12);
NumberWorkerVec = zeros(1,years*12);
NumberUnemplVec = zeros(1,years*12);
%RichestguyVec = zeros(1,years*12);
%WhoistherichestVec = zeros(1,years*12);
%NumberpoorpeopleVec = zeros(1,years*12);
TotalmonthlywagesVec = zeros(1,years*12);


%Monthly matrices
MonthlyfirmsalesMat = zeros(years*12,numberagents);
MonthlyIncomeMat = zeros(years*12,numberagents);
MonthlyWealthMat = zeros(years*12,numberagents);
MonthlyStatusMat = zeros(years*12,numberagents);
MonthlyWagePaidMat =zeros(years*12,numberagents);


    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
%%%% ONLY TEST IF SIMULATION WITH THESE PARA ALREADY EXIST -> LOAD/SIMULATE

nameofthissimulation = [num2str(numberagents) 'agents_' num2str(years) 'years_' num2str(totalmoney) 'totalmoney_' num2str(minwage) 'wage' num2str(maxwage) '_' num2str(simulationnumber) '.mat'];
%nameofthissimulation = ['savedsimulations/' num2str(numberagents) 'agents_' num2str(years) 'years_' num2str(totalmoney) 'totalmoney_' num2str(minwage) 'wage' num2str(maxwage) '.mat'];
%disp(['This simulation is called: ' nameofthissimulation])

% I would like to discard this part in this version
% if dontaskjustsimulate == 0
%     whattodo = 0;
%     while whattodo ==0
%         if exist(nameofthissimulation,'file') > 0
%             disp('This simulation name already exists in the saved folder')
%             SimulationorLoad = input('Do you want to load the old version (1)? Or simulate again and save under different name. (0)');
%             if SimulationorLoad == 1
%                 load(nameofthissimulation);
%                 whattodo = 'done';
%             elseif SimulationorLoad == 0
%                 simnumber = 1;
%                 while exist(nameofthissimulation,'file') > 0
%                     simnumber = simnumber + 1;
%                     nameofthissimulation = ['savedsimulations/' num2str(numberagents) 'agents_' num2str(years) 'years_' num2str(totalmoney) 'totalmoney_' num2str(minwage) 'wage' num2str(maxwage) '_' num2str(simnumber) '.mat'];
%                 end
%                 clear simnumber
%                 whattodo = 'simulate';
%             else 
%                 disp('Incorrect input: Choose between 1 and 0')
%             end
%         elseif exist(nameofthissimulation,'file') == 0
%             whattodo = 'simulate';
%         end
%     end
% elseif dontaskjustsimulate == 1
%     simnumber = 1;
%     while exist(nameofthissimulation,'file') > 0
%         simnumber = simnumber + 1;
%         nameofthissimulation = ['savedsimulations/' num2str(numberagents) 'agents_' num2str(years) 'years_' num2str(totalmoney) 'totalmoney_' num2str(minwage) 'wage' num2str(maxwage) '_' num2str(simnumber) '.mat'];
%     end
%         whattodo = 'simulate';
% end
%
% if strcmp(whattodo,'simulate') == 1 

%HERE STARTS THE ACTUAL SIMULATION 
    simulationcounter = 0;
    for i = 1:years
%         if rem(i,2) == 1
%            tic 
%         end


        %MONTHLY MEASUREMENT and SIMULATION:
        for j = 1:12
            [AgentsMat,MoneyPool,totalmonthlywages] = MonthlyInteractions_Selda_201503(AgentsMat,minwage,maxwage,MoneyPool,totalmonthlywages);
            simulationcounter = simulationcounter + 1;
            %get number of employees
            for m = 1:size(AgentsMat,2) % number of agents
                AgentsMat(4,m) = length(find(AgentsMat(3,:)== m));
                
                % this can be controled after we get all the raw data
%                 if AgentsMat(4,m)==0
%                     AgentsMat(5,m)=0;AgentsMat(7,m)=0;  % only record those trading at the end of the year
%                 end

            end
            NumberofemployeesMat(simulationcounter,:) = AgentsMat(4,:);
               %number of different types of agents
        NumberCapitalistsVec(simulationcounter) = length(find(AgentsMat(4,:) > 0));
        NumberWorkerVec(simulationcounter) = length(find(AgentsMat(3,:) > 0 ));
        NumberUnemplVec(simulationcounter) = numberagents-NumberCapitalistsVec(simulationcounter)-NumberWorkerVec(simulationcounter);

            %IDONT NEED THIS RIGHT?
            %firmdemise 
            %if simulationcounter > 1
            %    firmdemiseMat(simulationcounter-1,:) = NumberofemployeesMat(simulationcounter-1,:)>0 & NumberofemployeesMat(simulationcounter,:) ==0;
            %end

        


        %make monthlywagesVector and reset the yearly wages counter
        TotalmonthlywagesVec(simulationcounter) = totalmonthlywages;
        totalmonthlywages = 0;

     

%         %money of richest guy each year number of people with money<1
% 
%         WhoistherichestVec(i) = (find(AgentsMat(2,:) == max(AgentsMat(2,:))));
%         RichestguyVec(i) = max(AgentsMat(2,:));
%         NumberpoorpeopleVec(i) = length(find(AgentsMat(2,:)<1));



        %yearly firm sales
        MonthlyfirmsalesMat(simulationcounter,:) = AgentsMat(5,:);
        AgentsMat(5,:) = zeros(1,numberagents);

        %yearly income
       MonthlyIncomeMat(simulationcounter,:) = AgentsMat(6,:);
        AgentsMat(6,:) = zeros(1,numberagents);

        %yearly wealth data
        MonthlyWealthMat(simulationcounter,:) = AgentsMat(2,:);
        
        %yearly wage paied data
        MonthlyWagePaidMat(simulationcounter,:) = AgentsMat(7,:);
        AgentsMat(7,:) = zeros(1,numberagents);
        
        %monthly status of agents 
            %0 -> employer 
            %1 -> employee
            %2 -> unemployed
            MonthlyStatusMat(simulationcounter,:) = 2;
            MonthlyStatusMat(simulationcounter,AgentsMat(4,:)>0) = 0;
            MonthlyStatusMat(simulationcounter,AgentsMat(3,:)>0) = 1;

 % I don't really need this.       
%             %yearly status of agents 
%             %0 -> employer 
%             %1 -> employee
%             %2 -> unemployed
%             YearlyStatusMat(i,:) = 2;
%             YearlyStatusMat(i,AgentsMat(4,:)>0) = 0;
%             YearlyStatusMat(i,AgentsMat(3,:)>0) = 1;

%          if rem(i,2) == 0
%            disp([num2str(i) ' of ' num2str(years) ' years simulated']);
%            toc 
%          end
    end
% Can be controlled after we get the row data
%     RateofProfit=[];
%     RoP=[];
%     for x=1:years;
%         for y=1:numberagents;
%             if YearlyWagePaidMat(x,y)~=0
%                 RoP(1,1)=100*(YearlyfirmsalesMat(x,y)/YearlyWagePaidMat(x,y) -1);
%                 RoP(1,2)=YearlyWagePaidMat(x,y);
%                  RateofProfit=[RateofProfit;RoP];
%             end
%            
%         end;
%     end;
    
    %disp('Simulation done!')
    
    save(nameofthissimulation)
    %disp(['Saved results of simulation to ' nameofthissimulation])
end
clear i


end