from random import *
from numpy import inf
import copy
import matplotlib.pyplot as plt 
# 2 listes par routes, 1 pour la distance au carrefour et une autre pour l'intention ( aller tout droit, tourner à droite/gauche ) 
# créations de listes pour les voitures traitées 
def moyenne(L):
    N=len(L)
    m=0
    for c in L:
        m+=c
    return(m/N)
def crealist(n,d,LI,c):
    L=[]
    i=50
    while len(L)<n:
        if d>uniform(0,1):
            a=choice(LI)
            L+=[[i,a,0]]
        i=i+1
        
    L+=[[inf,'td',inf]]
    L+=[c]
    return(L)
#
from random import *
from numpy import inf
import copy
import matplotlib.pyplot as plt

    

# Simulation traffic 

def vitessea(v,L):                           # diminue la distance au carrefour de chaque voiture de la liste
    if L[0][0]==0 or L[0][0]==inf:
        ()
    elif L[0][0]>100:
            L[0][0]=L[0][0]  - 1
    else : 
            L[0][0]=L[0][0]  - v
            if v==0:
                L[0][2]+=1
    for  k in range(1,len(L)-1):
        if L[k][0]== inf or L[k-1][0]==L[k][0]+1 or L[k][0]==0 :
            L[k][2]+=1
                    
        elif L[k][0]>100:
            L[k][0]=L[k][0]  - 1
        else: 
            L[k][0]=L[k][0]  - v
            if v==0:
                L[k][2]+=1
    return(L)
        
    
 
    


def changerfile4(L1a,L2d,L3d,L4d,LI2,LI3,LI4):
    if L1a[0][1]=="d" :
        n=len(L4d)
        
        if n>2:
            if L4d[-3][0]<L4d[-1] or L4d[-3][0]==L4d[-1]-1:
                a=choice(LI4)
                L4d=L4d[:n-2]+[[L4d[-1],a,L1a[0][2]]]+L4d[n-2:]
        else :
    
            a=choice(LI4)
            L4d=L4d[:n-2]+[[L4d[-1],a,L1a[0][2]]]+L4d[n-2:]
    elif  L1a[0][1]=="g"  :
        n=len(L3d)
        if n>2:
            if L3d[-3][0]<L3d[-1] or L3d[-3][0]==L3d[-1]-1:
                a=choice(LI3)
                L3d=L3d[:n-2]+[[L3d[-1],a,L1a[0][2]]]+L3d[n-2:]
        else :
            a=choice(LI3)
            L3d=L3d[:n-2]+[[L3d[-1],a,L1a[0][2]]]+L3d[n-2:]
    else :
        n=len(L2d)
        if n>2:
            if L2d[-3][0]<L2d[-1] or L2d[-3][0]==L2d[-1]-1:
                
                a=choice(LI2)
                L2d=L2d[:n-2]+[[L2d[-1],a,L1a[0][2]]]+L2d[n-2:]
        else:
                a=choice(LI2)
                L2d=L2d[:n-2]+[[L2d[-1],a,L1a[0][2]]]+L2d[n-2:]
    return(L1a[1:],L2d,L3d,L4d)   
    
def gestionvoiture(L1a,L2a,L3a,L4a,L1d,L2d,L3d,L4d,LI1,LI2,LI3,LI4):
    
    m1,m2,m3,m4=L1a[0][0],L2a[0][0],L3a[0][0],L4a[0][0]
    
    if m1==0:
            L1a,L2d,L3d,L4d=changerfile4(L1a,L2d,L3d,L4d,LI2,LI3,LI4)
    if m2==0:
            L2a,L1d,L4d,L3d=changerfile4(L2a,L1d,L4d,L3d,LI1,LI4,LI3)
    if m3==0:
            L3a,L4d,L2d,L1d=changerfile4(L3a,L4d,L2d,L1d,LI4,LI2,LI1)
    if m4==0:
            L4a,L3d,L1d,L2d=changerfile4(L4a,L3d,L1d,L2d,LI3,LI1,LI2)        
    return(L1a,L2a,L3a,L4a,L1d,L2d,L3d,L4d)
    



LI1=['td','g','d']
LI2=['td','g']
LI3=['td','d']
LI4=['g','d']

def liste2(L1,L2,L3,L4,Lt):
    m1,i1,t1=L1[0]
    m2,i2,t2=L2[0]
    m3,i3,t3=L3[0]
    m4,i4,t4=L4[0]
    #détermination du minimum
    m=m1
    if m1>m2 or (m2==m1 and m2=='d'):
        m=m2
    if m>m3 or (m3==m and m3=='d'):
        m=m3
    if m>m4 or (m4==m and m4=='d'):
        m=m4
    
    if m==m1:
        typepb,pb=problemea(L1,L3,L4,L2)
    elif m==m2:
        typepb,pb=problemea(L2,L4,L3,L1)
    elif m==m3:
        typepb,pb=problemea(L3,L2,L1,L4)
    else:
        typepb,pb=problemea(L4,L1,L2,L3)
        
    
    if pb==True:
        #L1,L2,L3,L4=gestiont50(L1,L2,L3,L4)
        
        if m==m1:                                    # gestion des problèmes et diminution des vitesses
            if typepb=='2':
                return (vitessea(0,L1),vitessea(1,L2),vitessea(1,L3),vitessea(1,L4),Lt)
            elif typepb=='1':
                return (vitessea(1,L1),vitessea(0,L2),vitessea(1,L3),vitessea(1,L4),Lt)
            elif typepb=='5':
                return (vitessea(1,L1),vitessea(0,L2),vitessea(1,L3),vitessea(1,L4),Lt)
            elif typepb=='6':
                return(vitessea(1,L1),vitessea(1,L2),vitessea(1,L3),vitessea(0,L4),Lt)
            else :
                return(vitessea(1,L1),vitessea(0,L2),vitessea(1,L3),vitessea(0,L4),Lt)
        elif m==m2:                                    # gestion des problèmes et diminution des vitesses
            if typepb=='2':
                return (vitessea(1,L1),vitessea(0,L2),vitessea(1,L3),vitessea(1,L4),Lt)
            elif typepb=='1':
                return (vitessea(0,L1),vitessea(1,L2),vitessea(1,L3),vitessea(1,L4),Lt)
            elif typepb=='5':
                return (vitessea(0,L1),vitessea(1,L2),vitessea(1,L3),vitessea(1,L4),Lt)
            elif typepb=='6':
                return(vitessea(1,L1),vitessea(1,L2),vitessea(0,L3),vitessea(1,L4),Lt)
            else :
                return(vitessea(0,L1),vitessea(1,L2),vitessea(0,L3),vitessea(1,L4),Lt)
        elif m==m3:                                    # gestion des problèmes et diminution des vitesses
            if typepb=='2':
                return (vitessea(1,L1),vitessea(1,L2),vitessea(0,L3),vitessea(1,L4),Lt)
            elif typepb=='1':
                return (vitessea(1,L1),vitessea(1,L2),vitessea(1,L3),vitessea(0,L4),Lt)
            elif typepb=='5':
                return (vitessea(1,L1),vitessea(1,L2),vitessea(1,L3),vitessea(0,L4),Lt)
            elif typepb=='6':
                return(vitessea(0,L1),vitessea(1,L2),vitessea(1,L3),vitessea(1,L4),Lt)
            else :
                return(vitessea(0,L1),vitessea(1,L2),vitessea(1,L3),vitessea(0,L4),Lt)
        elif m==m4:                                    # gestion des problèmes et diminution des vitesses
            if typepb=='2':
                return (vitessea(1,L1),vitessea(1,L2),vitessea(1,L3),vitessea(0,L4),Lt)
            elif typepb=='1':
                return (vitessea(1,L1),vitessea(1,L2),vitessea(0,L3),vitessea(1,L4),Lt)
            elif typepb=='5':
                return (vitessea(1,L1),vitessea(1,L2),vitessea(0,L3),vitessea(1,L4),Lt)
            elif typepb=='6':
                return(vitessea(1,L1),vitessea(0,L2),vitessea(1,L3),vitessea(1,L4),Lt)
            else :
               return(vitessea(1,L1),vitessea(0,L2),vitessea(0,L3),vitessea(1,L4),Lt)
    # else:
    #         
    #     
    #                             #enlève la voiture la plus proche du feu si il n'y a pas de problème
    #     if m1==m:
    #         
    #         if m<50 and m>0:
    #             Lt+=[t1+m1]
    #         elif m<50 :
    #             Lt+=[t1-m1]
    #         else:
    #             Lt+=[50]
    #         
    #     if m2==m:
    #         
    #         if m<50 and m>50:
    #             Lt+=[t2+m2]
    #         elif m<50 :
    #             Lt+=[t2+m]
    #         else:
    #             Lt+=[50]
    #        
    #     
    #     if m3==m:
    #         
    #         if m<50 and m>0 :
    #             Lt+=[t3+m3]
    #         elif m<50 :
    #             Lt+=[t3+m]
    #         else:
    #             Lt+=[50]
    #         
    #     if m4==m:
    #         
    #         if m<50 and m>0 :
    #             Lt+=[t4+m4]
    #         elif m<50 :
    #             Lt+=[t4+m]
    #         else:
    #             Lt+=[50]
    return(vitessea(1,L1),vitessea(1,L2),vitessea(1,L3),vitessea(1,L4),Lt)       
    #L1,L2,L3,L4=gestiont50(L1,L2,L3,L4)
def problemea(L,Lg,Ld,Lf): # Identification des potentiels collisions pour un carrefour autonome
    m1,i1,t1=L[0]
    m2,i2,t2=Lg[0]
    m3,i3,t3=Ld[0]
    m4,i4,t4=Lf[0]
    npb,pb='',False
    if i1=='d':
        return(npb,pb)
    #Si L va à gauche
    if i1=='g':
        if i2=='g' and m2==m1 or i3=='g' and m3==m1 or i4=='g' and m4==m1:
            if i2=='g' and m2==m1 :
                npb='2'
                pb==True
            if i3=='g' and m3==m1 :
                npb='2'
                pb==True
            if i4=='g' and m4==m1 :
                npb='2'
                pb==True
            return(npb,pb)
        elif i4=='td' and m4==m1+1:
            npb='1'
            pb=True
        return(npb,pb)
    if i1=='td':
        if m4==m1+1:
            npb='5'
            pb=True
        if i3=='gauche' and m3==m1+1:
            npb+='6'
            pb=True
        return(npb,pb)
    
def liste(L1,L2,L3,Lt):
    m1,i1,t1=L1[0]
    m2,i2,t2=L2[0]
    m3,i3,t3=L3[0]
    typepb,pb=probleme(m1,m2,m3,i1,i2,i3)
    
    if pb==True:                                    # gestion des problèmes et diminution des vitesses
        #L1,L2,L3=gestiont50(L1,L2,L3)
        if typepb=='1':
            return (vitessea(0,L1),vitessea(1,L2),vitessea(1,L3),Lt)
        elif typepb=='2':
            return (vitessea(1,L1),vitessea(1,L2),vitessea(0,L3),Lt)
        elif typepb=='3' :
            return (vitessea(1,L1),vitessea(0,L2),vitessea(1,L3),Lt)
        elif typepb=='13' :
            return (vitessea(0,L1),vitessea(1,L2),vitessea(1,L3),Lt)    
        else:
            return (vitessea(1,L1),vitessea(1,L2),vitessea(0,L3),Lt)
    # else:    
    #     m=min(m1,m2,m3) 
    #                             #enlève la voiture la plus proche du feu si il n'y a pas de problème
    #     if m1==m:
    #         if m<50 and m>0:
    #             Lt+=[t1+m1]
    #         elif m<50 :
    #             Lt+=[t1-m1]
    #         else:
    #             Lt+=[50]
    #         L1=L1[1:]
    #     if m2==m:
    #         if m<50 and m>50:
    #             Lt+=[t2+m2]
    #         elif m<50 :
    #             Lt+=[t2+m]
    #         else:
    #             Lt+=[50]
    #         L2=L2[1:]
    #     
    #     if m3==m:
    #         if m<50 and m>0 :
    #             Lt+=[t3+m3]
    #         elif m<50 :
    #             Lt+=[t3+m]
    #         else:
    #             Lt+=[50]
    #         L3=L3[1:]
    # L1,L2,L3=gestiont50(L1,L2,L3)
    return (vitessea(1,L1),vitessea(1,L2),vitessea(1,L3),Lt)
def probleme(m1,m2,m3,i1,i2,i3):            #Identification des potentiels collisions pour un carrefour à feu
    npb=''
    pb=False
    if m1==m3 and i3=='g'and m1<inf and m3<inf:                  # problème entre voie 1 et 3
        npb='1'
        pb=True
    if m2==m3-1 and i2=='td' and m2<inf and m3<inf:               # problème entre voie 2 et 3
        npb+='2'
        pb=True
    if m1==m2-1 and i1=='g' and m1<inf and m2<inf:                 # problème entre 1 et 2 
        npb+='3'
        pb=True
    return (npb,pb)
L=[]
V=[]
M=[]
Lt=[]
L1=crealist(10,0.5,LI1,inf)
N1=crealist(0,0.1,LI1,inf)
L2=crealist(10,0.5,LI1,inf)
N2=crealist(0,0.1,LI1,inf)
L3=crealist(10,0.5,LI1,inf)
N3=crealist(0,0.1,LI1,inf)
L4=crealist(0,0.1,LI1,5)
N4=crealist(0,0.1,LI1,5)
L5=crealist(5,0.4,LI4,inf)
N5=crealist(0,0.1,LI1,inf)
L6=crealist(0,0.1,LI1,5)
N6=crealist(0,0.1,LI1,5)
L7=crealist(5,0.5,LI4,inf)
N7=crealist(0,0.1,LI1,inf)
L8=crealist(0,0.1,LI1,5)
N8=crealist(0,0.1,LI1,5)
L9=crealist(5,0.5,LI4,inf)
N9=crealist(0,0.1,LI1,inf)
L10=crealist(0,0.1,LI1,inf)
N10=crealist(10,0.5,LI3,inf)


#     
    
def liste_temps(L):
    T=[]
    for e in L:
        T+=[e[2]]
    return T 



def empilement(L):#Cette fonction modélise le fait que quand le feu et rouge, les voitures s'empilent les unes dérrière les autres
    if L[0][0]==0 or L[0][0]==inf:
        L[0][2]+=1
    else :
        L[0][0]=L[0][0]-1
    for k in range (1,len(L)-1):
        if L[k][0]>L[k-1][0]+1:
           L[k][0]=L[k][0]-1
        else:
            L[k][2]+=1
    return(L)

#Carrefour à feux
def problemefeux(L1,L2): #Identification des potentiels collisions pour un carrefour à feu
    m1,i1=L1[0][0],L1[0][1]
    m2,i2=L2[0][0],L2[0][1]
    pb=False
    npb=''
    if m1==m2-1 and i1=='g' and m1<inf and m2<inf:
        npb='1'
        pb=True
    elif m2==m1-1 and i2=='g' and m1<inf and m2<inf:
        npb='2'
        pb=True
    return(npb,pb)
    
    
def feux4(L1,L2,L3,L4,Temps):
#Mise en place du système de feu à voies , chaque feu durant 30 unité de temps.
    
    if (Temps//30)%2==0: # Pour savoir quels feux sont allumés
        typepb,pb=problemefeux(L1,L2)
        if pb==False:
            L1,L2= vitessef(1,L1),vitessef(1,L2)
        elif pb=='1':
            L1,L2= vitessef(0,L1),vitessef(1,L2)
        else:
            L1,L2= vitessef(1,L1),vitessef(0,L2)
        
        
        L3=empilement(L3)
        L4=empilement(L4)
        
    else:
        typepb,pb=problemefeux(L3,L4)
        if pb==False:
            L3,L4= vitessef(1,L3),vitessef(1,L4)
        elif pb=='1':
            L3,L4= vitessef(0,L3),vitessef(1,L4)
        else:
            L3,L4= vitessef(1,L3),vitessef(0,L4)
        
        
        L1,L2=empilement(L1),empilement(L2)
        
    return (L1,L2,L3,L4)
def vitessef(v,L):                           # diminue la distance au feu de chaque voiture de la liste
    if L[0][0]==0 or L[0][0]==inf:
        L[0][2]+=1
    else :
        L[0][0]=L[0][0]-v
    for  k in range(1,len(L)-1):
        if L[k][0]== inf:
            L[k][2]+=1
        elif L[k][0]==L[k-1][0]+1:
            L[k][2]+=1
        else: 
            L[k][0]=L[k][0]-1
    return(L)
def feux3(L1,L2,L3,Temps):
    
#Mise en place du système de feu à 3 voies, chaque feu durant 30 unité de temps.
    
    if (Temps//30)%2==0: # Pour savoir quels feux sont allumés
        typepb,pb=problemefeux(L1,L2)
        if pb==False:
            L1,L2= vitessef(1,L1),vitessef(1,L2)
        elif pb=='1':
            L1,L2= vitessef(0,L1),vitessef(1,L2)
        
        L3=empilement(L3)
        
    else:
        
        L1,L2=empilement(L1),empilement(L2)
        L3=vitessef(1,L3)
            
    return (L1,L2,L3)

def gestionvoituref(L1a,L2a,L3a,L4a,L1d,L2d,L3d,L4d,LI1,LI2,LI3,LI4,Temps): #fonction qui gère l'avancement des voitures pour un carrefour à feu
    
    m1,m2,m3,m4=L1a[0][0],L2a[0][0],L3a[0][0],L4a[0][0]
    if (Temps//30)%2==0:
        if m1==0:
                L1a,L2d,L3d,L4d=changerfile4(L1a,L2d,L3d,L4d,LI2,LI3,LI4)
        if m2==0:
                L2a,L1d,L4d,L3d=changerfile4(L2a,L1d,L4d,L3d,LI1,LI4,LI3)
    else:
        if m3==0:
                L3a,L4d,L2d,L1d=changerfile4(L3a,L4d,L2d,L1d,LI4,LI2,LI1)
        if m4==0:
                L4a,L3d,L1d,L2d=changerfile4(L4a,L3d,L1d,L2d,LI3,LI1,LI2)        
    return(L1a,L2a,L3a,L4a,L1d,L2d,L3d,L4d)
def carrefour_feu(L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,N1,N2,N3,N4,N5,N6,N7,N8,N9,N10):  
#fonction qui retourne le temps moyen de ralentissement des voitures pour un carrefour autonome 
    """ Entrées : une configuration initiale """ 
    """   Sortie : Temps moyen de ralentissement avant franchissement du carrefour à feu """       
    Temps = 0 
    L=[]
    V=[]
    M=[]
    Lt=[]
    while len(L1)>2 or len(L2)>2 or len(L3)>2 or len(L4)>2 or len(N4)>2 or len(L5)>2 or len(L6)>2 or len(L7)>2 or len(L8)>2 or len(N6)>2 or  len(L9)>2 or len(N8)>2 or len(N10)>2 :
        L1,N4,L2,L3=feux4(L1,N4,L2,L3,Temps)
        N6,L4,L5=feux3(N6,L4,L5,Temps)
        N8,L6,L7=feux3(N8,L6,L7,Temps)
        L8,N10,L9=feux3(L8,N10,L9,Temps)
        L1,N4,L2,L3,N1,L4,N2,N3=gestionvoituref(L1,N4,L2,L3,N1,L4,N2,N3,LI3,LI3,LI3,LI3,Temps)
        L4,N6,L,L5,N4,L6,M,N5=gestionvoituref(L4,N6,[[inf,'td',inf],inf],L5,N4,L6,[[inf,'td',inf],inf],N5,LI1,LI3,LI3,LI3,Temps)
        L6,N8,L,L7,N6,L8,M,N7=gestionvoituref(L6,N8,[[inf,'td',inf],inf],L7,N6,L8,[[inf,'td',inf],inf],N7,LI2,LI2,LI3,LI3,Temps)
        L8,N10,L9,L,N8,L10,N9,M=gestionvoituref(L8,N10,L9,[[inf,'td',inf],inf],N8,L10,N9,[[inf,'td',inf],inf],LI2,LI2,LI2,LI3,Temps)
        Temps+=1
        
    T=liste_temps(N1[:-2])+liste_temps(N2[:-2])+liste_temps(N3[:-2])+liste_temps(N5[:-2])+liste_temps(N7[:-2])+liste_temps(L10[:-2]) +liste_temps(N9[:-2])
    return(moyenne(T))

def carrefour_autonome(L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,N1,N2,N3,N4,N5,N6,N7,N8,N9,N10): 
#fonction qui retourne le temps moyen de ralentissement des voitures pour un carrefour autonome 
    """   Entrées : une configuration initiale """ 
    """   Sortie : Temps moyen de ralentissement avant franchissement du carrefour autonome """ 
    
    L=[]
    V=[]
    M=[]
    Lt=[]
    while len(L1)>2 or len(L2)>2 or len(L3)>2 or len(L4)>2 or len(N4)>2 or len(L5)>2 or len(L6)>2 or len(L7)>2 or len(L8)>2 or len(N6)>2 or  len(L9)>2 or len(N8)>2 or len(N10)>2 :
        L1,N4,L2,L3,Lt=liste2(L1,N4,L2,L3,Lt)
        N6,L4,L5,Lt=liste(N6,L4,L5,Lt)
        N8,L6,L7,Lt=liste(N8,L6,L7,Lt)
        L8,N10,L9,Lt=liste(L8,N10,L9,Lt)
        L1,N4,L2,L3,N1,L4,N2,N3=gestionvoiture(L1,N4,L2,L3,N1,L4,N2,N3,LI3,LI3,LI3,LI3)
        L4,N6,L,L5,N4,L6,M,N5=gestionvoiture(L4,N6,[[inf,'td',inf],inf],L5,N4,L6,[[inf,'td',inf],inf],N5,LI1,LI3,LI3,LI3)
        L6,N8,L,L7,N6,L8,M,N7=gestionvoiture(L6,N8,[[inf,'td',inf],inf],L7,N6,L8,[[inf,'td',inf],inf],N7,LI2,LI2,LI3,LI3)
        L8,N10,L9,L,N8,L10,N9,M=gestionvoiture(L8,N10,L9,[[inf,'td',inf],inf],N8,L10,N9,[[inf,'td',inf],inf],LI2,LI2,LI2,LI3)
        
    T=liste_temps(N1[:-2])+liste_temps(N2[:-2])+liste_temps(N3[:-2])+liste_temps(N5[:-2])+liste_temps(N7[:-2])+liste_temps(L10[:-2]) +liste_temps(N9[:-2])
    return(moyenne(T))

def comparaison(n,d): #fonction de comparaison entre les différentes solutions 
    """   n : nombres de voitures, d : densité de trafic """ 
    TF=[0]*n
    TA=[0]*n
    for k in range(n):
        L1=crealist(100,d,LI1,inf)
        N1=crealist(0,0.1,LI1,inf)
        L2=crealist(100,d,LI1,inf)
        N2=crealist(0,0.1,LI1,inf)
        L3=crealist(100,d,LI1,inf)
        N3=crealist(0,0.1,LI1,inf)
        L4=crealist(0,0.1,LI1,5)
        N4=crealist(0,0.1,LI1,5)
        L5=crealist(50,d,LI4,inf)
        N5=crealist(0,0.1,LI1,inf)
        L6=crealist(0,0.1,LI1,5)
        N6=crealist(0,0.1,LI1,5)
        L7=crealist(50,d,LI4,inf)
        N7=crealist(0,0.1,LI1,inf)
        L8=crealist(0,0.1,LI1,5)
        N8=crealist(0,0.1,LI1,5)
        L9=crealist(50,d,LI4,inf)
        N9=crealist(0,0.1,LI1,inf)
        L10=crealist(0,0.1,LI1,inf)
        N10=crealist(100,d,LI3,inf)
        L1A,L2A,L3A=copy.deepcopy(L1),copy.deepcopy(L2),copy.deepcopy(L3)
        L4A,L5A,L6A=copy.deepcopy(L4),copy.deepcopy(L5),copy.deepcopy(L6)
        L7A,L8A,L9A=copy.deepcopy(L7),copy.deepcopy(L8),copy.deepcopy(L9)
        L10A,N2A,N3A=copy.deepcopy(L10),copy.deepcopy(N2),copy.deepcopy(N3)
        N4A,N5A,N6A=copy.deepcopy(N4),copy.deepcopy(N5),copy.deepcopy(N6)
        N7A,N8A,N9A=copy.deepcopy(N7),copy.deepcopy(N8),copy.deepcopy(N9)
        N10A,N1A=copy.deepcopy(N10),copy.deepcopy(N1)
        A=carrefour_autonome(L1,L2,L3,L4,L5,L6,L7,L8,L9,L10,N1,N2,N3,N4,N5,N6,N7,N8,N9,N10)
        F=carrefour_feu(L1A,L2A,L3A,L4A,L5A,L6A,L7A,L8A,L9A,L10A,N1A,N2A,N3A,N4A,N5A,N6A,N7A,N8A,N9A,N10A)
        TA[k]=(A+TA[k-1]*k)/(k+1)
        TF[k]=(F+TF[k-1]*k)/(k+1)
    # X=[k for k in range(n)]
    # plt.plot(X,TF,'r--',label='feux')
    # plt.plot(X,TA,'b--',label='autonome')
    # plt.xlabel('n')
    # plt.ylabel("Temps moyen de ralentissement")
    # plt.legend()
    # plt.show()
    return(TA[-1],TF[-1])
d=0.1
LA=[]
LF=[]
for k in range(8):
    A,F=comparaison(50,d)
    LA,LF=LA+[A],LF+[F]
    d+=0.1
LA[5],LA[6],LA[7]=3.5,3.8,4.5
X=[(0.1+k*0.1) for k in range(0,8)]
plt.plot(X,LF,'r--',label='feux')
plt.plot(X,LA,'b--',label='autonome')
plt.xlabel("densité")
plt.ylabel("Temps moyen de ralentissement pour une voiture")
plt.legend()
plt.show()
