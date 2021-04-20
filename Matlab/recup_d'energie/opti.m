function [] = opti()
%OPTI Summary of this function goes here
%   variables : rmag , hmag, efer, hfer, eguide, hcoil, ecoil, n 
%lb=[0.5,0.5,0.5,0.5,0.5,0.1,0.1,500];

openfemm;
lb=[0.1,3]
%ub=[1.5,7,11,2,10,1,1,1500];
ub=[3,8]
x0= rand(size(lb)).*(ub-lb)+lb;
% options = optimoptions('fmincon','Algorithm','active-set','Display','iter-detailed');  
% x_opti= fmincon(@myfun,x0,[],[],[],[],lb,ub,[],options)
% nvars = 2 ;
% options = optimoptions('gamultiobj','ConstraintTolerance',1e-6,'PlotFcn', @gaplotbestf);
% x = gamultiobj(@myfun,nvars,[],[],[],[],lb,ub,[],options)
% plot(x(:,1),x(:,2),'ko')
% xlabel('x(1)')
% ylabel('x(2)')
% title('Pareto Points in Parameter Space')
%% epsilon contrainte
global eps
epsilon=3:10
m=[]
ke=[]
%for e = epsilon
    eps=3.5
	options = optimoptions('patternsearch','Display','iter','PlotFcn',@psplotbestf,'MaxIteration',2);
    results = patternsearch(@myfun,x0,[],[],[],[],lb,ub,@mycon,options) ;
    m(end+1)=results(1);
    ke(end+1)=-results(2);
%end
plot(m,ke)
%% Nested Function

    function [f]=myfun(variables)
        result=femm_axisym_trace(variables);
        [f]=[result(2)];
    end
    function [g,h]=mycon(variables)
        result=femm_axisym_trace(variables);
        g=result(3:end);
        h=[];
    end
end

