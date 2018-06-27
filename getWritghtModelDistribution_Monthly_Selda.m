clear; close all;


numberagents = 1000 ;
averagemoneyperagent = 100;
totalmoney = numberagents*averagemoneyperagent;

years = 100;
minwage = 10;
maxwage = 90;
MoneyPool = 0;

for simulationnumber= 1:1;
    tic
   
   [AgentsMat,NumberCapitalistsVec,NumberWorkerVec,NumberUnemplVec,NumberofemployeesMat,MonthlyfirmsalesMat,TotalmonthlywagesVec,MonthlyIncomeMat,MonthlyWealthMat,MonthlyWagePaidMat,MonthlyStatusMat] = WrightModel_Monthly_Selda(numberagents,years,totalmoney,minwage,maxwage,MoneyPool,simulationnumber);

toc
end


display('Loop done!!!!!!!!!!!!')

