
testPhi = load('./test1/phifile_comp');
testCurr = load('./test1/dataCur_T_NF2.txt');

trainPhi = load('./train1/phifile_comp');
trainCurr = load('./train1/dataCur_NF.txt');

betaVec = load('./betaVec.txt');
%%
betaVec = betaVec';

testTau = testPhi*betaVec;
trainTau = trainPhi*betaVec;

testTau = reshape(testTau,[length(testTau)/7,7]);
trainTau = reshape(trainTau,[length(trainTau)/7,7]);

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

for i=1:dof
    MSE_joints(i) = compute_MSE(onlineQ_pred(:,i), onlineQ_ref(:,i));
    MSEreal_joints(i) = compute_MSE(onlineQ_rbd(:,i), onlineQ_ref(:,i));
end
fprintf('nMSE between predicted torque and actual torque:\n');
disp(MSE_joints);


fprintf('nMSE between rbd torque and actual torque:\n');
disp(MSEreal_joints);

%%
fprintf('Order of improvement in prediction:\n');
disp((MSEreal_joints./MSE_joints))