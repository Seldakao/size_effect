getWrightModelDistribution_Monthly_Selda.m sets up the meta-parameters of the simulation, including the number of repeated rounds. It activates WrightModel_Monthly_Selda.m

2.  WrightModel_Monthly_Selda.m is in charge of the running one round of simulation and saving the results, it first calls InitialSetup_Selda.m and then calls MonthlyInteractions_Selda_201503.m

3. InitialSetup_Selda.m takes the meta-parameters as input and prepared a matrix for containing the agents’ essential data, in particular, it distributes the money to the agents in the system.

4. MonthlyInteractions_Selda_201503 carries the core model of Wright2005