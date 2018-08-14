clear;
clc;
testPhi = load('../20-ParametricIdentification-7DOF/testOutput/phi.txt');
testCurr = load('../29-ArmDataCollection/testData/dataCur.txt');

trainPhi = load('../20-ParametricIdentification-7DOF/trainOutput/phi.txt');
trainCurr = load('../29-ArmDataCollection/trainData/dataCur.txt');

beta = load('../20c-RidgeRegression_arm/beta.txt');
%%

testTau = testPhi*beta;
trainTautemp = trainPhi*beta;

testTau = transpose(reshape(testTau,[7,length(testTau)/7]));
trainTau = transpose(reshape(trainTautemp,[7,length(trainTautemp)/7]));

km(1) = 31.4e-3;
km(2) = 31.4e-3;
km(3) = 38e-3;
km(4) = 38e-3;
km(5) = 16e-3;
km(6) = 16e-3;
km(7) = 16e-3;

G_R(1) = 596;
G_R(2) = 596;
G_R(3) = 625;
G_R(4) = 625;
G_R(5) = 552;
G_R(6) = 552;
G_R(7) = 552;

testCurrPredict = testTau/diag(km)/diag(G_R);
trainCurrPredict = trainTau/diag(km)/diag(G_R);

%%
figure;
for i=1:7
   subplot(2,4,i);
   plot(testCurrPredict(:,i));
   hold on
   plot(testCurr(:,i));  
   legend({'pred','meas'});
end


figure;
for i=1:7
   subplot(2,4,i);
   plot(trainCurrPredict(:,i));
   hold on
   plot(trainCurr(:,i)); 
   legend({'pred','meas'});
end

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