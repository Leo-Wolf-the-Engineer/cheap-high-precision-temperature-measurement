%%% Setup
close all
clear
%pkg install -forge signal
pkg load signal
%pkg install -forge statistics
pkg load statistics
%set(0, "defaulttextfontsize", 16)  % title of plots
set(0, "defaultaxesfontsize", 16)  % axes labels

% with large data quantities it might take a while to execute
correction = false;
filename_sios = "SIOS_3.dat";
filename_diy = "20240730_5.txt";

%set time bounds in which the correction constants are claculated
lowerBound = 0.25;  %hours
upperBound = 7;     %hours

%Sios data
%expected format: hh:mm:ss value.fraction  value.fraction
replaceColonAndSpaceWithComma(filename_sios);
data_sios = load(filename_sios);
data_sios = data_sios(19400:length(data_sios)(1),:);
data_sios(:,1) = data_sios(:,1) + data_sios(:,2)/60 + data_sios(:,3)/3600;

%DIY data
%expected format: dayssince1900,fractiondayssince1900,value.fraction (6times);
replaceCommaWithDot(filename_diy);
removeInvalidLines(filename_diy);
data_diy = load(filename_diy,"-ascii");
data_diy = data_diy(24100:length(data_diy)(1),:);
data_diy(:,1) = mod(data_diy(:,1),1);
data_diy(:,1) = data_diy(:,1)*24;

figure(1)
hold on
plot(data_diy(:,1),data_diy(:,2))
plot(data_diy(:,1),data_diy(:,5))
plot(data_diy(:,1),data_diy(:,3))
plot(data_diy(:,1),data_diy(:,6))
plot(data_diy(:,1),data_diy(:,4))
plot(data_diy(:,1),data_diy(:,7))
title("sensor values & their filters")
legend("T1 Raw", "T2 Raw", "T1 MA", "T2 MA", "T1 EWMA", "T2 EWMA")
%plot settings
xlabel("time [h]")
ylabel("temperature [K]")
axis("tight")
grid on

figure(2);
subplot(1,2,1)
hold on
plot(data_diy(:,1),data_diy(:,4))
plot(data_diy(:,1),data_diy(:,7))
plot(data_sios(:,1),data_sios(:,4))
plot(data_sios(:,1),data_sios(:,5))
title("Uncorrected Values")
legend("T1 EWMA", "T2 EWMA", "Reference T1", "Reference T2")
%plot settings
xlabel("time [h]")
ylabel("temperature [K]")
axis("tight")
grid on

%find average temperature of the two reference sensors
data_sios = extractValues_Sios(data_sios,upperBound,lowerBound);
average_sios = mean(data_sios);
%set as ground truth
true_temp = mean(average_sios(4:5)); %%4:5 %%4 is Air sensor, 5 is Material

%calculate averages of both sensors and find the offset
%from the ground truth
data_diy = extractValues_Diy(data_diy,upperBound,lowerBound);
average_diy = mean(data_diy);
correction_factors = average_diy(2:7)-true_temp;
data_diy(:,2:7) = data_diy(:,2:7) - correction_factors;
korrekturfaktor_T1 = correction_factors(2);
korrekturfaktor_T2 = correction_factors(5);
format("long");
disp(korrekturfaktor_T1);
disp(korrekturfaktor_T2);

subplot(1,2,2)
hold on
plot(data_diy(:,1),data_diy(:,4))
plot(data_diy(:,1),data_diy(:,7))
plot(data_sios(:,1),data_sios(:,4))
plot(data_sios(:,1),data_sios(:,5))
title("corrected Values")
legend("T1 EWMA", "T2 EWMA", "Reference T1", "Reference T2")
%plot settings
xlabel("time [h]")
ylabel("temperature [K]")
axis("tight")
grid on
