%Sistema Intercambiador de calor
function [sys,x0,str,ts] = Tank_01(t,x,u,flag)
switch flag,

 case 0
    [sys,x0,str,ts]=mdlInitializeSizes; % Initialization

 case 1
    sys = mdlDerivatives(t,x,u); % Calculate derivatives


 case 3
    sys = mdlOutputs(t,x,u); % Calculate outputs
 
  case { 2, 4, 9 },
    sys = [];
  otherwise
    error(['Unhandled flag = ',num2str(flag)]); % Error handling

end
% end csfunc

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes

sizes = simsizes;
sizes.NumContStates  = 1;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 9;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);
x0  = [20];
str = [];
ts  = [0 0];

% end mdlInitializeSizes
%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u)

V= u(6);            %Volumen 0.0261 [m^3]
den=u(7);           %Densidad Especifica del agua [1000 Kg/m^3] 
Cp= u(8);           %Calor especifico do líquido  [4.176 kJ/kg.K]
Cpared= u(9);       %Capacidad de Calor del acero inox [16.3 (W/(m·K))] 
Ti=u(1);            %Temperatura inicial del Tanque [°C]        
T=x(1);             %Temperatura interna del Tanque [°C]
Qelect=u(3);        %Cantidad de Energía Suministrada 4 [KJ]
Alpha_Isol=u(5);    %Coef de transferecnia de Calor insolamiento [80 W/m^2K]
Tref=u(4);          %Temperatura Ambiente 23 [°C]
Fi=u(2)             %Flujo de entrada   [0.0000439 m^3/seg]
For01=(V*den*Cp+Cpared)

sys(1)=((Fi*Cp*(Ti-T))/For01)+(Qelect/For01)-((Alpha_Isol*(T-Tref))/For01)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% B=4e-3;
% A=7e-3;
% k=48;
% cp=4.19e3;
% l=4;
% r1=1.5;
% r2=0.5;
% den=1000;
% m1=den*pi*(r1-r2)^2*l;
% m2=den*pi*(r2)^2*l;
% Thi=u(1);
% Fest=u(2)/3600;
% Tci=u(3);
% Fagua=u(4)/3600;
% Tho=x(1);
% Tco=x(2);
% 
% deltaTl=(abs(Thi-Tho)-abs(Tci-Tco))/log(abs(Thi-Tho)/abs(Tci-Tco))+273;
% 
% sys(1)=(den*Fest*cp*(Thi-Tho)-(k*A*deltaTl)/B)/(cp*m1);
% sys(2)=(den*Fagua*cp*(Tci-Tco)-(k*A*deltaTl)/B)/(cp*m2);

% end mdlDerivatives
%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)
sys(1) = x(1);
%
% end mdlOutputs
