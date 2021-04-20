function [outputs] = fct_model_transfo(parameters,variables)
% Thermo-electric model of the transformer

%% Parameters
V2 = parameters(1);
V1 = parameters(2);
f = parameters(3);
fp2 = parameters(4);
I2 = parameters(5);
Text = parameters(6);
q = parameters(7);
kr = parameters(8);
h = parameters(9);
lambda_iso = parameters(10);
e_iso = parameters(11);
mvfer = parameters(12);
mvcuivre = parameters(13);
rhocuivre = parameters(14);
alphacuivre = parameters(15);
mu0 = parameters(16);

%% Variables
a = variables(1);
b = variables(2);
c = variables(3);
d = variables(4);
n1 = variables(5);
S1 = variables(6);
S2 = variables(7);

%% Equations

% 1er system explicite
Scuivreair = b*(4*a+2*pi*c);
Rcuivreair = 1/(h*Scuivreair);
l1spire = 2*d+4*a+pi*c/2;
Mfer = mvfer*4*a*d*(2*a+b+c);
l2spire = 2*d+4*a+pi*3*c/2;
Sferair = 4*a*(4*a+b+2*c)+2*d*(6*a+b+2*c);
Rferair = 1/(h*Sferair);
Bm = 1/4*V1*sqrt(2)/(n1*a*d*pi*f);
Pfer = q*Mfer*f/50*(Bm)^2;
Rfercuivre = e_iso/(lambda_iso*b*(4*a+2*d));

% 2nd system implicite
X0 = [0; 0; 0; 0; 0; 0; 0; 0];
[X,Fval,exitflag] = fsolve(@sys_equa,X0);

if (exitflag>0) %convergence criteria fulfilled
    residu = norm(sys_equa(X));
else
    residu = 1e6;
end

r2 = X(1);
X2 = X(2);
n2 = X(3);
DV2 = X(4);
Pj = X(5);
Tcuivre = X(6);
r1 = X(7);
R2 = X(8);

% 3rd system explicit
Tfer = Text+Rferair*(Rcuivreair*Pj+(Rcuivreair+Rfercuivre)*Pfer)/(Rcuivreair+Rferair+Rfercuivre);
mur = (1/(2.12E-4+((1-2.12E-4)*(Bm/1)^(2*7.358))/((Bm/1)^(2*7.358)+1.18E+6)));
Lmu=mu0*mur*n1^2*a*d/(2*a+b+c);
Mcuivre = mvcuivre*(n1*S1*l1spire+n2*S2*l2spire);
ren = V2*I2*fp2/(V2*I2*fp2+Pfer+Pj);
P1 = Pfer+Pj+V2*I2*fp2;
Q1 = V1^2/(Lmu*2*pi*f)+X2*I2^2+V2*I2*sin(acos(fp2));
I1 = sqrt(P1^2+Q1^2)/V1;
I10 = sqrt((Pfer/V1)^2+(V1/(Lmu*2*pi*f))^2);
f1=2*n1*S1/(kr*b*c);
f2=2*n2*S2/(kr*b*c);
M_tot = Mcuivre+Mfer;

%% Output

outputs(1) = M_tot;
outputs(2) = ren;

outputs(3) = Tcuivre-120; %Tcuivre < 120°C
outputs(4) = Tfer-100; %Tfer < 100°C
outputs(5) = DV2/V2-0.1; %DV2/V2 < 0.1
outputs(6) = I10/I1-0.1; %I10/I1 < 0.1
outputs(7) = f1-1; %f1 < 1
outputs(8) = f2-1; %f2 < 1

outputs(9) = residu-1e-6; %residu < 1e-6

%% Nested function

    function [F] = sys_equa(X)
        
        r2=X(1);
        X2=X(2);
        n2=X(3);
        DV2=X(4);
        Pj=X(5);
        Tcuivre=X(6);
        r1=X(7);
        R2=X(8);
        
        % Residu du systeme implicite
        F = [r2 - rhocuivre*(1+alphacuivre*Tcuivre)*n2*l2spire/S2;
            X2 - 1/3*mu0*n2^2*c*(4*a+2*d+pi*c)/b*2*pi*f;
            n2 - n1*(V2+DV2)/V1;
            DV2 - (R2*fp2+X2*sin(acos(fp2)))*I2;
            Pj - R2*I2^2;
            Tcuivre - Text-Rcuivreair*(Rferair*Pfer+(Rferair+Rfercuivre)*Pj)/(Rcuivreair+Rferair+Rfercuivre);
            r1 - rhocuivre*(1+alphacuivre*Tcuivre)*n1*l1spire/S1;
            R2 - r2-(n2/n1)^2*r1];
    end

end
