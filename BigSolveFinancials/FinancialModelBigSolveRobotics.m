% Financial Model -- Big Solve Robotics

numMonths = 72;
revenue = zeros(numMonths, 1);
expenses = zeros(numMonths, 1);

% Assume 12 months pass before revenue starts from first sale
revenueMask = ones(numMonths,1);
numMonthsNoRevenue = 12;
numMonthsNoHiring = 12;
for i=1:numMonthsNoRevenue
   revenueMask(i) = 0; 
end

% Revenue from events -- PER ROBOT
revenue_events_mean_monthly = 300; % based on earning 300/event, averaging 1.5 events monthly
events_volatility = 100; % sigma for our event revenue distribution
% so 68% of revenues will be between about (mean-200, mean+200)
revenue_events_flow = normrnd(zeros(numMonths,1)+revenue_events_mean_monthly, events_volatility).*revenueMask;

% Revenue from offices -- PER ROBOT
revenue_offices_monthly = 600;
revenue_offices_flow = revenueMask*revenue_offices_monthly;

% Expenses: salaries per employee
expense_engineer_monthly = 5833; % based on ~70k/year cost (8k above Toronto average according to payscale.com)
expense_salesperson_monthly = 5000; % based on ~60k/year cost (11k above Toronto average according to payscale.com)

% Expenses: office space
expense_office_space_sub10 = 2000; % when we are sub 10 people using a ~1000sqft office
expense_office_space_gte10 = 7000; % when we upgrade to a ~3500 sqft office for up to 20 ppl
% Cash flow from office expenses: assume after year 1 we get starting
% office, and 12 months thereafter we move to bigger office
expenses_office_flow = zeros(numMonths,1);
expenses_office_flow(12:24) = expense_office_space_sub10;
expenses_office_flow(24:numMonths) = expense_office_space_gte10;

% Growth variables: number of employees
hiring_engineer_frequency = 4; % every X months bring on a new engineer 
hiring_salesperson_frequency = 1; % every X months bring on a new salesperson 
hiring_engineer_flow_indicator = zeros(numMonths,1); % == 1 if we hire a new eng that month, else 0
hiring_salesperson_flow_indicator = zeros(numMonths,1); % == 1 if we hire a new sales that month, else 0
for i=numMonthsNoHiring:numMonths
   if mod(i,hiring_engineer_frequency)==0
       hiring_engineer_flow_indicator(i) = 1;
   end
   if mod(i,hiring_salesperson_frequency)==0
       hiring_salesperson_flow_indicator(i) = 1;
   end
end

% Expenses: salary cash flow
expenses_salaries_flow = zeros(numMonths,1);
for i=1:numMonths
   engineering_costs = sum(hiring_engineer_flow_indicator(1:i))*expense_engineer_monthly;
   salesperson_costs = sum(hiring_salesperson_flow_indicator(1:i))*expense_salesperson_monthly;
   expenses_salaries_flow(i) = engineering_costs + salesperson_costs;
end

% Growth variable: number of robots sold as a function of salespeople
% Formula: at each month, take the total number of salespeople, and assume
% each salesperson will close a constant amount of deals per month
robots_sold_per_salesperson_monthly = 3; %2
robots_sold_flow = zeros(numMonths,1); % in each month, how many do we sell?
for i=numMonthsNoRevenue:numMonths
   num_salespeople = sum(hiring_salesperson_flow_indicator(1:i));
   robots_sold_flow(i) = num_salespeople * robots_sold_per_salesperson_monthly;
end

% Expenses: new robot and new sale
cost_per_robot_hardware = 1000; %1000 
cost_per_robot_sale = 1000; % plane tickets for sales engineer + robot shipping costs for demo
cost_per_robot_installation = 500; % plane ticket for engineer to configure (or view as robot shipping cost) 
total_cost_per_new_robot = cost_per_robot_hardware + cost_per_robot_sale + cost_per_robot_installation;
expenses_new_robots_flow = zeros(numMonths,1);
for i=1:numMonths
   expenses_new_robots_flow(i) = robots_sold_flow(i)*total_cost_per_new_robot; 
end

% Number of deployed robots earning us $$$
robots_deployed_flow = zeros(numMonths,1); % cumulative each month
attritionFactor = 0.2;
for i=2:numMonths
    attrition = attritionFactor * robots_deployed_flow(i-1);
    robots_deployed_flow(i) = sum(robots_sold_flow(1:i)) - attrition;
end

%%%%%%%%%%% REVENUES %%%%%%%%%%%
percent_robots_events = 0.1;
percent_robots_office = 0.9; % sum to 1
robots_deployed_events_flow = round(robots_deployed_flow * percent_robots_events);
robots_deployed_office_flow = round(robots_deployed_flow * percent_robots_office);
revenue_robots_deployed_events = revenue_events_flow .* robots_deployed_events_flow;
revenue_robots_deployed_offices = revenue_offices_flow .* robots_deployed_office_flow;

TOTAL_REVENUE_FLOW = revenue_robots_deployed_events + revenue_robots_deployed_offices;

%%%%%%%%%%% EXPENSES %%%%%%%%%%%
TOTAL_EXPENSE_FLOW = expenses_new_robots_flow + expenses_salaries_flow + expenses_office_flow;

%%%%%%%%%%% NET CASH FLOW %%%%%%
NET_CASH_FLOW = TOTAL_REVENUE_FLOW - TOTAL_EXPENSE_FLOW;

%figure; plot(TOTAL_REVENUE_FLOW);
%figure; plot(TOTAL_EXPENSE_FLOW);
figure; plot(NET_CASH_FLOW);

