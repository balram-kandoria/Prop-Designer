clear all
%% Variables
V_inf = 180.596; %ft/s
x = linspace(0.15,1.0,72); % Propeller Blade Radial
Sections
B = 2;
P_avalible = 110; %BHP
n = (2550/60); %rev/s
cd_min = 0.01;
k = 0.004;
cl_min = 0.10;
alpha_zero_lift = -1;
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
%% 2. Design
t_c = 0.04 ./ (x.^(1.2));
V = sqrt((V_inf^2) + ((2 .* pi .* Percent_max_rated .* n .* r)).^2);
a_inf = sqrt(1.4 * 53.35 * Temp * 32.17);
M = V./a_inf;
% Vary c(x)
J = (V_inf ) / (D * n1);
phi = atan(J./(pi.*x));

theta = atan(((V_inf + v0)) ./ (2 .* pi .* ((Percent_max_rated*n)) .* r)) - phi;
c = [linspace(.5,.5,72)]
sigma = (B .* c) ./ (pi .* (D./2));
cl = (8 .* x .* theta .* cos(phi) .* tan(theta + phi)) ./ (sigma);
MDD = (K - t_c) - (cl./10);
mo = (2 * pi) ./ sqrt(1- (M.^2));
alpha = ((cl./mo) + alpha_zero_lift) .* (pi ./ 180);
beta = alpha + theta + phi;
cd = cd_min + k.*(((cl)-cl_min).^2);
n = n1;
c = .5
%dCT = (((pi.^3) .* (x.^2))./ (8)) .* (lambaT) .* (sigma)
dCT = @(x, V_inf, v0, n, D, cl, cd, c, B) ((((pi.^3) .* (x.^2))./ (8)) .* ((1 ./ (cos(V_inf ./ (n .* D .* pi .* x))).^2) .* (((((8 .* x .* (atan((V_inf + v0) ./ (pi .* n .* x .* D)) - atan((V_inf) ./ (pi .* n .* x .* D))) .* cos(atan(V_inf ./ (n .* D .* pi .* x))) .* tan(atan((V_inf + v0) ./ (pi .* n .* x .* D)))) ./ ((B .* c) ./ (pi .* (D./2))))) .* cos(atan((V_inf + v0) ./ (pi .* n .* x .* D)))) - (((cd_min + k.*(((((8 .* x .* (atan((V_inf + v0) ./ (pi .* n .* x .* D)) - atan((V_inf) ./ (pi .* n .* x .* D))) .* cos(atan(V_inf ./ (n .* D .* pi .* x))) .* tan(atan((V_inf + v0) ./ (pi .* n .* x .* D)))) ./ ((B .* c) ./ (pi .* (D./2)))))-cl_min).^2)) .* sin(atan((V_inf + v0) ./ (pi .* n .* x .* D))))))) .* (B .* c) ./ (pi .* (D./2)));
CT = integral( @(x) dCT(x, V_inf, v0, n, D, cl, cd, c, B), .2, 1);
%dCQ = (((pi.^3) .* (x.^3))./ (16)) .* (lambaQ) .* (sigma)
dCQ = @(x, V_inf, v0, n, D, cl, cd, c, B) (((pi.^3) .* (x.^3))./ (16)) .* (((1 ./ (cos(V_inf ./ (n .* D .* pi .* x))).^2) .* (((((8 .* x .* (atan((V_inf + v0) ./ (pi .* n .* x .* D)) - atan((V_inf) ./ (pi .* n .* x .* D))) .* cos(atan(V_inf ./ (n .* D .* pi .* x))) .* tan(atan((V_inf + v0) ./ (pi .* n .* x .* D)))) ./ ((B .* c) ./ (pi .* (D./2))))) .* sin(atan((V_inf + v0) ./ (pi .* n .* x .* D)))) + (((cd_min + k.*(((((8 .* x .* (atan((V_inf + v0) ./ (pi .* n .* x .* D)) - atan((V_inf) ./ (pi .* n .* x .* D))) .* cos(atan(V_inf ./ (n .* D .* pi .* x))) .* tan(atan((V_inf + v0) ./ (pi .* n .* x .* D)))) ./ ((B .* c) ./ (pi .* (D./2)))))-cl_min).^2)) .* cos(atan((V_inf + v0) ./ (pi .* n .* x .* D)))))))) .* ((B .* c) ./ (pi .* (D./2)))
CQ = integral( @(x) dCQ(x, V_inf, v0, n, D, cl, cd, c, B), .2, 1);
CP = 2 * pi * CQ;
P_produced = (CP * rho * (n1^3) * (D^5)) * ((32.17 * (1)) / 17740);
T_produced = CT * rho * (n1^2) * (D^4) * (1);
Prop_eff = ((CT/CP)*J);
dAF = @(x, V_inf, v0, n, D, cl, cd, B) (((x.^3)./D) .* (((((8 .* x .* (atan((V_inf + v0) ./ (pi .* n .* x .* D)) - atan((V_inf) ./ (pi .* n .* x .* D))) .* cos(atan(V_inf ./ (n .* D .* pi .* x))) .* tan(atan((V_inf + v0) ./ (pi .* n .* x .* D)))) ./ ((0.5.*x) + 0.3))) .* pi .* (D./2)) ./ B));
AF = (integral( @(x) dAF(x, V_inf, v0, n, D, cl, cd, B), .15, 1)) .* ((10^5)/16);
dCLdesign = @(x, cl) (((0.5.*x) + 0.3) .* (x.^3));
CLdesign = ((integral( @(x) dCLdesign(x, cl), .15, 1)) .* 4);
beta = beta .* (180./pi)
c = [linspace(.5,.5,72)]
figure(1)
yyaxis left
plot((x),(c),'o')
hold all
ylabel('Chord [ft]')
xlabel('X [Non-Dimensional]')
hold off
figure (1)
yyaxis right
plot(x, (c./D))
ylim([0,.2])
ylabel('c/D [Non-Dimensional]')
title('Design Blade Chord Distribution')
figure(2)
yyaxis left
plot((x),(beta),'o')
hold all
ylabel('Beta [degrees]')
xlabel('x [Non-Dimensional]')
hold off
figure (2)
yyaxis right
plot(x, t_c)
ylabel('Thickness t/c [Non-Dimensional]')
title('Thickness and Beta Distribution')
hold off
figure (3)
plot(x, cl)
xlabel('x [Non-Dimensional')
ylabel('Coefficient of Lift [Non-Dimensional]')
title('Coefficient of Lift Distribution')
