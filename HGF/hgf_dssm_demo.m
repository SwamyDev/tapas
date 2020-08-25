num_obs = 5000
obs = load('observations.txt')(1:num_obs);

# plot observations
x = 1:num_obs;
plot(x, obs(1:num_obs));
xlabel("Time");
ylabel("Observations");
title("FAM Observations");

model = tapas_fitModel([],...
                       obs,...
                       'tapas_hgf_config',...
                       'tapas_bayes_optimal_config',...
                       'tapas_quasinewton_optim_config');
                       

printf('%d, ', model.p_prc.p);
fp = fopen('model-p_prc-p.txt','w');
fprintf(fp, '%d\n', model.p_prc.p);
fclose(fp);

fp = fopen('model_y.txt','w');
fprintf(fp, '%d\n', model.y);
fclose(fp);

fp = fopen('model_u.txt','w');
fprintf(fp, '%d\n', model.u);
fclose(fp);

tapas_fit_plotCorr(model)
tapas_hgf_plotTraj(model)

sim_2level = tapas_simModel(obs,...
                     'tapas_hgf',...
                     model.p_prc.p,...
                     'tapas_gaussian_obs',...
                     0.00002,...
                     12345);

fp = fopen('sim_fam_2_level_y.txt','w');
fprintf(fp, '%d\n', sim_2level.y);
fclose(fp);

tapas_hgf_plotTraj(sim_2level)

sim_3level = tapas_simModel(obs,...
                       'tapas_hgf',...
                       [1.04 1 1 0.0001 0.1 0.1 0 0 0 1 1 -13  -2 -2 1e4],...
                       'tapas_gaussian_obs',...
                       0.00005,...
                       12345);
tapas_hgf_plotTraj(sim_3level)

figure
plot(sim_3level.traj.wt)
xlim([1, length(sim_3level.traj.wt)])
legend('1st level', '2nd level', '3rd level')
xlabel('Trading days from 1 Jan 2010')
ylabel('Weights')
title('Precision weights')


fp = fopen('sim_fam_3level_y.txt','w');
fprintf(fp, '%d\n', sim_3level.y);
fclose(fp);
