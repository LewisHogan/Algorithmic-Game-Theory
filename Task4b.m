ctr = [1, 0.55071, 0.4704];
values_per_click = [1000000, 555710, 470400];

% Each of the possible bids are the boundary values for which a player
% could theoretically bid, it would be preferrable to run through every
% single combination but in practice it would take so long as to be
% meaningless.
p1_possible_bids = [1, 470399, 470400, 470401, 55709, 55710, 55711, 999999, 1000000];
p2_possible_bids = [1, 470399, 470400, 470401, 555709, 555710];
p3_possible_bids = [1, 470399, 470400];

% As the players are already ranked in value order, we can just sum and dot
% multiply here.
optimal_social_welfare = sum(values_per_click .* ctr);
welfare_with_highest_anarchy = 0;
equil_with_highest_anarchy = [];
price_of_anarchy = -Inf;

alternate_bids = [p1_possible_bids, p2_possible_bids, p3_possible_bids];

for p1_bid = p1_possible_bids
   for p2_bid = p2_possible_bids
      for p3_bid = p3_possible_bids
         % Assume player's cannot bid the same value
         if p1_bid == p2_bid || p2_bid == p3_bid || p1_bid == p3_bid
            continue; 
         end
         
         bid = [p1_bid, p2_bid, p3_bid];
         % If the current combination is an equilibrium, append it to the
         % vector, we will consider it's price of anarchy and social
         % welfare
         if (is_optimized_equilibrium(bid, values_per_click, ctr, alternate_bids)) == 1
            bid_social_welfare = sum([
                calculate_welfare(bid, values_per_click, ctr, 1);
                calculate_welfare(bid, values_per_click, ctr, 2);
                calculate_welfare(bid, values_per_click, ctr, 3);
            ]);
        
            current_price_of_anarchy = optimal_social_welfare / bid_social_welfare;
            
            % Price of anarchy is OPTsw/SW(b)
            if (current_price_of_anarchy > price_of_anarchy)
                welfare_with_highest_anarchy = bid_social_welfare;
                price_of_anarchy = current_price_of_anarchy;
                equil_with_highest_anarchy = bid;
            end
         end
      end
   end
end

disp("Optimal Social Welfare");
disp(optimal_social_welfare);
disp("Social Welfare of highest price of anarchy bid");
disp(welfare_with_highest_anarchy);
disp("Equilibrium with highest price of anarchy");
disp(equil_with_highest_anarchy);
disp("Price of anarchy");
disp(price_of_anarchy);

% This function is a modified variant of calculate_is_equilibrium that only
% considers possible bids from the provided array, rather then considering
% all values from 1:true_value_of_player
function is_equil = is_optimized_equilibrium(bid, values_per_click, ctr, alternate_bids)
    is_equil = 1;
    original_payoff = zeros(1, length(bid));
    
    for player_index = 1:length(bid)
       original_payoff(player_index) = calculate_payoff(bid, values_per_click, ctr, player_index);
    end
    
    for player_index = 1:length(bid)
       new_bid = bid;
       for alternate_player_bid = alternate_bids(player_index)
           new_bid(player_index) = alternate_player_bid;
           
           new_payoff = calculate_payoff(new_bid, values_per_click, ctr, player_index);
           
           if new_payoff > original_payoff(player_index)
              is_equil = 0;
              return;
           end
       end
    end
end

% This is the actual function that should be used to calculate if the
% current bid is an equilibrium. In practice the execution time was too
% high due to the large number of possible values for each player to bid,
% in combination with the terrible scaling performance of this algorithm.
function is_equil = calculate_is_equilibrium(bid, values_per_click, ctr)
    is_equil = 1;
    original_payoff = zeros(1, length(bid));
    
    for player_index = 1:length(bid)
       original_payoff(player_index) = calculate_payoff(bid, values_per_click, ctr, player_index);
    end
    
    for player_index = 1:length(bid)
       new_bid = bid;
       for alternate_player_bid = 1:values_per_click(player_index)
           new_bid(player_index) = alternate_player_bid;
           
           new_payoff = calculate_payoff(new_bid, values_per_click, ctr, player_index);
           
           if new_payoff > original_payoff(player_index)
              is_equil = 0;
              return;
           end
       end
    end
end

% Calculates the payoff given to a specific player given a specific set of
% bids and costs
function payoff = calculate_payoff(bid, value_per_click, ctr, player_index)
    cost = calculate_cost(bid, player_index);
    value = value_per_click(player_index);
    ctr_slot = calculate_ctr_slot(bid, player_index);
    
    payoff = ctr(ctr_slot) * (value - cost);
end

function welfare = calculate_welfare(bid, value_per_click, ctr, player_index)
    value = value_per_click(player_index);
    ctr_slot = calculate_ctr_slot(bid, player_index);
    
    welfare = ctr(ctr_slot) * value;
end

function cost = calculate_cost(bid, player_index)
    [sorted_bid, indicies] = sort(bid, "descend");
    % Look for the index that matches the player_index, then we use the
    % next one as the true cost that player pays (GSP second price)
    for position = 1:length(indicies)-1
       if indicies(position) == player_index
           cost = sorted_bid(position+1);
           return;
       end
    end
    % The last bidder always pays nothing
    cost = 0;
end

function ctr_slot = calculate_ctr_slot(bid, player_index)
    [~, indicies] = sort(bid, "descend");

    % Ranks the bids in order to figure out which click through rating the
    % specified player should be gettting
     for position = 1:length(indicies)-1
       if indicies(position) == player_index
           ctr_slot = position;
           return;
       end
     end
    
     ctr_slot = length(bid);
end