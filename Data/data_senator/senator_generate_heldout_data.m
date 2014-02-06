% Splits the Senator dataset NUM_SETS times into a set of 2 random subgraphs,
% for held-out analysis.

dataFile    = 'senator.mat';
heldoutFile = 'senator_heldout.mat';
SEED        = uint32(sum(100*clock));
NUM_SETS    = 5;

% Load original data
source      = load(dataFile);

% Initialize RNG
RandStream.setDefaultStream(RandStream('mt19937ar','Seed',SEED));

% Perform splitting
E           = source.E;
N           = size(E,1);
N_mid       = ceil(N/2);
data        = cell(1,NUM_SETS);
for iter = 1:NUM_SETS
    p                           = randperm(N);
    data{iter}.E                = E;
    data{iter}.actors_train     = p(1:N_mid);
    data{iter}.actors_test      = p(N_mid+1:end);
    data{iter}.E_train          = E(data{iter}.actors_train,data{iter}.actors_train,:);
    data{iter}.E_test           = E(data{iter}.actors_test,data{iter}.actors_test,:);
end

% Save data
save(heldoutFile,'data');
