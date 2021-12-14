%% Variables
w = linspace(0,0,72)
for i = 1:length(w)
V_inf = 118
beta = [1.1159 , 1.0858 , 1.0566 ,1.0282 ,
1.0008 , 0.9742 , 0.9486 , 0.9238 , 0.8999 ,
0.8769 , 0.8547 , 0.8332 , 0.8126 , 0.7927 , 0.7735
, 0.7550 , 0.7372 , 0.7201 , 0.7035 , 0.6876 ,
0.6722 , 0.6574 , 0.6432 , 0.6294, 0.6161 , 0.6033
, 0.5909 , 0.5790 , 0.5674 , 0.5563 , 0.5455 ,
0.5350 , 0.5249 , 0.5152 , 0.5057 , 0.4966, 0.4877
0.4791 0.4708 0.4627 0.4549 0.4473 0.4399
0.4328 0.4258 0.4191 0.4125 , 0.4061,0.3999 ,
0.3939 , 0.3880 , 0.3823 , 0.3767, 0.3713 ,
0.3660 , 0.3608 , 0.3558 , 0.3509 , 0.3461 ,
0.3415, 0.3369 , 0.3325 , 0.3282 , 0.3239 , 0.3198
, 0.3158 , 0.3118 , 0.3080 , 0.3042 , 0.3005 ,
0.2969 , 0.2934]
del_beta = linspace(-0.26,.26,72)
delta_beta1 = del_beta(i)
beta = delta_beta1 + beta
x = linspace(0.15,1.0,72)
B = 2;
P_avalible = 110; %BHP
n = (2550/60); %rev/s
cd_min = 0.01;
k = 0.004;
cl_min = 0.10;
alpha_zero_lift = (-1) * (pi/180);
K = 0.94;
D = (72/12); % ft
r = x .* (D/2);
v0 = .0714* V_inf;
rho = 0.001873; % slugs / ft^3
Temp = 490.17; %R
MDD = 0.8;
%% 1. Determine Maximum Engine Power Output at the design
Condition
% Design condition: 2550 [rev/min]; 8000 ft
% According to Figure 2 from EAE-130B_project-1_2020.pdf
P = 83; %hp
Percent_max_rated = P/P_avalible;
n1 = n * Percent_max_rated;
n = n1
%% 2. Design
t_c = 0.04 ./ (x.^(1.2));
V = sqrt((V_inf.^2) + ((2 .* pi .* n .* r)).^2);
a_inf = sqrt(1.4 * 53.35 * Temp * 32.17);
M = V./a_inf;
% Vary c(x)
J = (V_inf ) ./ (D .* n1);
phi = atan(J./(pi.*x));
c = linspace(.5,.5,72)
sigma = (B .* c) ./ (pi .* D .* .5);
V_R = V_inf ./ (sin(phi))
mo = (2 * pi) ./ sqrt(1- (M.^2))
A0 = -(beta - phi - alpha_zero_lift) .* ((sigma .* mo)
./ (8 .* x))
A1 = (V_inf ./ V_R) + (((beta - phi -
alpha_zero_lift).*tan(phi)) +1) .* ((sigma .* mo) ./ (8 .*
x))
A2 = cos(phi) - (((sigma .* mo) ./ (8 .* x)) .*
tan(phi))
theta_test = ((((-A1 + sqrt((A1.^2) - (4.*A0.*A2))) ./
(2 .* A2)))) + .02
alpha_test = ((beta - phi - theta_test ))
cl_test =(8 .* x .* theta_test .* cos(phi) .*
tan(theta_test + phi)) ./ (sigma)
cd_test = cd_min + k.*(((cl_test)-cl_min).^2)
MDD = (K - t_c) - (cl./10);
lambaT=(1 ./ cos(phi).^2) .* (cl_test .* cos(betaalpha_
test) - cd_test .* sin(beta-alpha_test))
lambaQ=(1 ./ cos(phi).^2) .* (cl_test .* sin(betaalpha_
test) + cd_test .* cos(beta-alpha_test))
Y = (((pi.^3) .* (x.^2))./ (8)) .* (lambaT) .*
(sigma)
CT_test(i) = trapz(x, Y)
Y = (((pi.^3) .* (x.^3))./ (16)) .* (lambaQ) .*
(sigma)
CQ_test(i) = trapz(x, Y)
CP_test(i) = 2 * pi * CQ_test(i);
P_produced_test(i) = (CP_test(i) * rho * (n1^3) *
(D^5)) * ((32.17 * (1)) / 17740);
T_produced_test(i) = CT_test(i) * rho * (n1^2) * (D^4)
* (1);
Prop_eff_test(i) = ((CT_test(i)./CP_test(i)).*J);
c =.5
end
%% Plots
h = linspace(-50,1000,100)
z = linspace(-2.9,-2.9, 100)
figure(1)
plot((del_beta .*
(180./pi)),P_produced_test,'r','LineWidth',2,'LineStyle','-
-')
title('Power')
xlabel('Delta Degree [deg]')
ylabel('Power [hp]')
hold on
figure(1)
yyaxis left
plot(z, h)
ylim([-30,320])
hold on
figure(1)
yyaxis right
plot((del_beta .*
(180./pi)),T_produced_test,'b','LineWidth',2,'LineStyle','-
')
title('Thrust and Power vs. Beta')
xlabel('Delta Degree [deg]')
ylabel('Thrust Produced [lb]')
hold off
figure(2)
plot((del_beta .*
(180./pi)),CP_test,'b','LineWidth',2,'LineStyle',':')
title('Power Coefficient')
xlabel('Advanced Ratio J [1/rev]')
ylabel('Power Coefficient')
hold off
figure(4)
plot((del_beta .*
(180./pi)),CT_test,'b','LineWidth',2,'LineStyle',':')
title('Coefficient of Thrust')
xlabel('Delta Degree [deg]')
ylabel('Coefficient of Thrust')
hold off
figure(5)
plot((del_beta .*
(180./pi)),Prop_eff_test,'b','LineWidth',2,'LineStyle',':')
title('Prop Efficiency')
xlabel('Delta Degree [deg]')
ylabel('Prop Efficiency')
xlim([-5,15])
hold off
