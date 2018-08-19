clear;

betaFull = load('../../20c-RidgeRegression_arm/betaConsistent/betaConsistent.txt');
betaFullNoCoulomb = betaFull;
betaFullNoCoulomb(13:13:91) = 0;

trainPhi = load('../../20-ParametricIdentification-7DOF/trainOutput/phi.txt');
trainPhiCoulombRef = trainPhi;
dqreftrain = load('../../29-ArmDataCollection/trainData/dataDQref.txt');
sqreftrain = 2./(1 + exp(-2*dqreftrain(2:end,:))) - 1;
sqreftrainDiag = zeros(7*size(sqreftrain, 1), 7);
for row = 0:length(sqreftrain)-1
    sqreftrainDiag(7*row+1:7*row+7, :) = diag(sqreftrain(row+1,:));
end
trainPhiCoulombRef(:,13:13:91) = sqreftrainDiag;
trainCurr = load('../../29-ArmDataCollection/trainData/dataCur.txt');
qtrain = load('../../29-ArmDataCollection/trainData/dataQ.txt');
dqtrain = load('../../29-ArmDataCollection/trainData/dataDotQ.txt');
ddqtrain = load('../../29-ArmDataCollection/trainData/dataDDotQ.txt');
trainTime = load('../../29-ArmDataCollection/trainData/dataTimeStamp.txt');
trainTime(1) = [];

testPhi = load('../../20-ParametricIdentification-7DOF/testOutput/phi.txt');
testPhiCoulombRef = testPhi;
dqreftest = load('../../29-ArmDataCollection/testData/dataDQref.txt');
sqreftest = 2./(1 + exp(-2*dqreftest(2:end,:))) - 1;
sqreftestDiag = zeros(7*size(sqreftest, 1), 7);
for row = 0:length(sqreftest)-1
    sqreftestDiag(7*row+1:7*row+7, :) = diag(sqreftest(row+1,:));
end
testPhiCoulombRef(:,13:13:91) = sqreftestDiag;
testCurr = load('../../29-ArmDataCollection/testData/dataCur.txt');
qtest = load('../../29-ArmDataCollection/testData/dataQ.txt');
dqtest = load('../../29-ArmDataCollection/testData/dataDotQ.txt');
ddqtest = load('../../29-ArmDataCollection/testData/dataDDotQ.txt');
testTime = load('../../29-ArmDataCollection/testData/dataTimeStamp.txt');
testTime(1) = [];

km = [31.4e-3, 31.4e-3, 38e-3, 38e-3, 16e-3, 16e-3, 16e-3]';
G_R = [596, 596, 625, 625, 552, 552, 552]';

%%
trainCurrPredictFull = transpose(reshape(trainPhi*betaFull,[7,length(trainPhi)/7]))/diag(km)/diag(G_R);
trainCurrPredictFullCoulombRef = transpose(reshape(trainPhiCoulombRef*betaFull,[7,length(trainPhiCoulombRef)/7]))/diag(km)/diag(G_R);
trainCurrPredictFullNoCoulomb = transpose(reshape(trainPhi*betaFullNoCoulomb,[7,length(trainPhi)/7]))/diag(km)/diag(G_R);
testCurrPredictFull = transpose(reshape(testPhi*betaFull,[7,length(testPhi)/7]))/diag(km)/diag(G_R);
testCurrPredictFullCoulombRef = transpose(reshape(testPhiCoulombRef*betaFull,[7,length(testPhiCoulombRef)/7]))/diag(km)/diag(G_R);
testCurrPredictFullNoCoulomb = transpose(reshape(testPhi*betaFullNoCoulomb,[7,length(testPhi)/7]))/diag(km)/diag(G_R);

%%
fig1 = figure('Name','Train Plots','NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
for i=1:7
   if(i==7); subplot(2,4,[7 8]);
   else; subplot(2,4,i);
   end
   plot(trainTime, qtrain(2:end, i), ...
        trainTime, dqtrain(2:end, i), ...
        trainTime, dqreftrain(2:end, i), ...
        trainTime, ddqtrain(:, i));
   hold on
   plot(trainTime, trainCurr(2:end, i), ...
        trainTime, trainCurrPredictFull(:, i), ...trainTime, trainCurrPredictFullCoulombRef(:, i), ... % .. trainTime, trainCurrPredictFullNoCoulomb(:, i), ... 
        'LineWidth', 2);
   xlabel('time (s)');
   if(i==7)
        legend({'q','$$\dot{q}$$', '$$\dot{q}_{ref}$$', '$$\ddot{q}$$', '$$i_{measured}$$', ...
            '$$i_{predicted} (\beta_{full})$$', ...'$$i_{predicted} (\beta_{full}, \Gamma_{couloumb} q_{ref})$$',...
            },'Interpreter', 'latex', 'Location', 'eastoutside');
   end
   grid on
   title(['Joint ' num2str(i)]);
end
saveas(fig1, 'trainPlots_CoulombRef.png');

fig2 = figure('Name','Test Plots','NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
for i=1:7
   if(i==7); subplot(2,4,[7 8]);
   else; subplot(2,4,i);
   end
   plot(testTime, qtest(2:end, i), ...
        testTime, dqtest(2:end, i), ...
        testTime, dqreftest(2:end, i), ...
        testTime, ddqtest(:, i));
   hold on
   plot(testTime, testCurr(2:end, i), ...
        testTime, testCurrPredictFull(:, i), ...testTime, testCurrPredictFullCoulombRef(:, i), ...%testTime, testCurrPredictFullNoCoulomb(:, i), ...
        'LineWidth', 2);
   xlabel('time (s)');
   if(i==7)
        legend({'q','$$\dot{q}$$', '$$\dot{q}_{ref}$$', '$$\ddot{q}$$', '$$i_{measured}$$', ...
            '$$i_{predicted} (\beta_{full})$$', ...'$$i_{predicted} (\beta_{full}, \Gamma_{couloumb} q_{ref})$$',...
            },'Interpreter', 'latex', 'Location', 'eastoutside');
   end
   grid on
   title(['Joint ' num2str(i)]);
end
saveas(fig2, 'testPlots_CoulombRef.png');

%%
% for i=1:dof
%     MSE_joints(i) = compute_MSE(onlineQ_pred(:,i), onlineQ_ref(:,i));
%     MSEreal_joints(i) = compute_MSE(onlineQ_rbd(:,i), onlineQ_ref(:,i));
% end
% fprintf('nMSE between predicted torque and actual torque:\n');
% disp(MSE_joints);
% 
% 
% fprintf('nMSE between rbd torque and actual torque:\n');
% disp(MSEreal_joints);
% 
% %%
% fprintf('Order of improvement in prediction:\n');
% disp((MSEreal_joints./MSE_joints))