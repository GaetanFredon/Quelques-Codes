#importation des modules nécessaires 
from math import *
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import odeint

#solution trouvée à la main 

def aperiodique(t,Q):
    r1=-1/(2*Q)-sqrt(-1+1/(4*Q*Q))
    r2=-1/(2*Q)+sqrt(-1+1/(4*Q*Q))
    return( r1/(r1-r2)*exp(r2*t)+r2/(r2-r1)*exp(r1*t))
def critique(t):
    return(exp(-t)*(1+t))
def pseudo(Q,t):
    X=sqrt(1/(4*Q*Q-1)+1)
    w=sqrt(1-1/(4*Q*Q))
    return(X*exp(-1/(2*Q)*t)*cos(w*t+acos(1/X)))
    
#permet d'avoir les listes de solutions pour ensuite les exploiter

def trace_sol(t_min,t_max,N,Q):   
    """
        ENTREE :
        
            t_min,t_max,N,Q
            
        SORTIE :
        
            Deux listes, une correspondant aux temps et l'autres aux valeurs prises par la solution.
    """ 
    h=(t_max-t_min)/N                                #discrétise le temps
    T=[0]
    t=t_min
    S=[1]
    
    for k in range (1,N):                               
        t+=h
        T+=[t]
        if Q<0.5:                               #suivant la valeur de Q on est dans un type de solution
            S+=[aperiodique(t,Q)]
        elif Q==0.5:
            S+=[critique(t)]
        else:
            S+=[pseudo(Q,t)]
    
    
    return(T,S)
    
    
#recherche de tau
    
def trouve_tau(T,S):
    """
        ENTREE :
        
            T et S les deux listes définies au dessus
            
        SORTIE :
        
            La valeur de tau
    """ 
    
    tau=0  
    lim=0.01         # c'est la conditon donnée dans l'énoncé et vu que j'ai adimensionné par u0, on a plus que <1/100
    for k in range (len(S)):
        if abs(S[k])>lim:
            tau=T[k]
    return tau

#Juste une fonction qui permet de tracer les courbes pour voir l'idée
def trace__tau(t_min,t_max,N,Q):
    T,S=trace_sol(t_min,t_max,N,Q)
    tau1=0
    tau1=trouve_tau(T,S)
    plt.plot(T,S,label='solution')
    plt.plot([0.0, t_max], [0.01, 0.01], 'b--', lw=1)
    plt.plot([0.0, t_max], [-0.01, -0.01], 'b--', lw=1,label='limite')
    plt.axvline(x=tau1, linewidth=1, color='black',label='tau')
    plt.legend()
    plt.show()
    
    
    
    
#tracé de tau(Q)
 
def courbe_tau(Q_min,Q_max,N):
    """
        ENTREE :
        
            La gamme de Q pour laquelle on veut tau et N le nombre de points de la courbe.
            
        SORTIE :
        
            Deux listes, une correspondant aux valeurs et l'autres aux valeurs prises par tau pour ces valeurs de Q
    """
    
    T0=[]
    
    t_min=0
    t_max=100
    N1=5000
    h=(Q_max-Q_min)/N
    Q=Q_min
    lstQ=[]
    for k in range (N):
       Q+=h
       T,S=trace_sol(t_min,t_max,N1,Q)
       lstQ+=[Q]
       T0+=[trouve_tau(T,S)] # 1 car la variable adimensionné à pour CI u=1
    plt.plot(lstQ,T0)
    plt.show()
    return(lstQ,T0)

#trouve la valeur de Q pour laquelle tau est minimum
    
def minimum(T0, lstQ):
    """
        ENTREE :
        
            Deux listes, une correspondant aux temps et l'autres aux valeurs prises par la solution.
            
        SORTIE :
            La valeur de t0 minimum et la valeur de Q associée.
            
    """ 
    
    m=inf
    qmin=0
    for k in range (len(T0)):
        if T0[k]<m:
            m=T0[k]
            qmin=lstQ[k]
    return(m, qmin)




#équation non linéaire adimensionnée par 1/wo

def system_diff(X,t,Q,u0):
    u,phi=X
    return(np.array([phi,-1/Q*phi-np.sin(u)]))
#donne la solution non linéaire adimensionnée
   
def sol_nn_lin(u0,Q): 
    """
        ENTREE :
        
            u0 et Q les paramètres de l'équation différentielle.
            
        SORTIE :
        
            Deux tableaux, un contenant les temps et l'autres les valeurs prises par la solution.
            
    """ 
    
    t_min=0
    t_max=50
    n_t=500
    tab_t=np.linspace(t_min,t_max,n_t)
    tab_X=odeint(system_diff,[u0,0],tab_t,args=(Q,u0))
    tab_y=tab_X[:,0]
    # plt.plot(tab_t,tab_y)
    # plt.show()
    return(tab_t,tab_y)

    
def trouve_tau2(T,S,u0):
    """
        ENTREE :
        
            Deux listes, une correspondant aux temps et l'autres aux valeurs prises par la solution, et u0
            
        SORTIE :
        
            La valeur de tau minimum et la valeur de Q associée.
            
    """ 
    
    tau=0  
    lim=0.01*u0
    qmin = 0
    for k in range (len(S)):
        if abs(S[k])>lim:
            tau=T[k]
    return tau
    
    
  
    
def courbe_tau2(Q_min,Q_max,u0,N):
    """
        ENTREE :
        
            La gamme de Q pour laquelle on veut tau et N le nombre de points de la courbe.
            
        SORTIE :
        
            Deux listes, une correspondant aux valeurs et l'autres aux valeurs prises par tau pour ces valeurs de Q
    """ 
    
    T0=[]
    h=(Q_max-Q_min)/N
    Q=Q_min
    lstQ=[]
    for k in range (N):
        Q+=h
        T,S=sol_nn_lin(u0,Q)
        m=valeurfinale(S)
        lstQ+=[Q]
        T0+=[trouve_tau2(T,S-m,u0)]
    #plt.plot(lstQ,T0)
    #plt.show()
    return(T0,lstQ)
    
    

def valeurfinale(S): # on sait que c'est multiple de pi en passant à la limite
    """
        ENTREE :
        
            La liste des valeurs prises par la solution
            
        SORTIE :
        
           La valeur finale (prise à l'infini) de la solution
    """ 
    m=S[-1]/np.pi 
     
    if floor(m-1/2)==floor(m):
        m=floor(m)+1
    else:
        m=floor(m)
    return m*np.pi
    

def tau_fct_u0():
    """ Trace les courbes Tau_min(u0) et Q_min(u0)"""
    
    N = 100
    Q_min = 0.01
    Q_max = 2
    lst_t_min = []
    lst_q_min = []
    lst_u0 = [0.1 + i * 0.5 for i in range(200)]
    
    for i in lst_u0 :
        lst_tau, lst_Q = courbe_tau2(Q_min,Q_max,i,N)
        t_min, q_min = minimum(lst_tau, lst_Q)
        lst_t_min += [t_min]
        lst_q_min += [q_min]
    
    plt.plot(lst_u0, lst_t_min, label="Tau(u0)")
    plt.plot(lst_u0, lst_q_min, label="Qmin(u0)")
    plt.legend()
    plt.show()
        
    return None
         