from math import *
from random import *
import matplotlib.pyplot as plt

def villes_generation(n):
    """
        ENTREE :
        
            Un entier n
            
        SORTIE :
        
            Une liste de n couples (a, b) avec a,b compris entre 0 et 100 choisis au hasrd et affiche un graphique dont les villes sont représentées par des points
    """
#    axe_x = []
 #   axe_y = []
    villes = []
    
    for _ in range(n):
        a, b = randint(0, 100), randint(0, 100)
        
        villes += [(a, b)]
  #      axe_x += [a]
   #     axe_y += [b]
    
    #axe_x += [axe_x[0]]
 #   axe_y += [axe_y[0]]
    
  #  plt.plot(axe_x, axe_y, color = 'blue', marker = 'o')
   # plt.axis([0, 100, 0 , 100])
    #plt.show()
    
    return villes
    
#def circuit(n) :
 #   """
  #      ENTREE :
   #     
    #        Un entier n
            
      #  SORTIE :
        
       #     Une liste correspondant à l'ordre de passage initiale de notre voyageur
    #"""
    
   # ordre_passage = [i for i in range(n)]
    
   # return ordre_passage
    
def distance_entre_points(a, b, c, d):
    """
        ENTREE :
        
            Quatre entiers correspondant aux coordonnées d'un point A et d'un point B
            
        SORTIE :
        
            Un flottant correspondant à la distance entre ces deux points
    """
    
    distance = sqrt((c - a)**2+(d - b)**2)

    return distance
    
def longueur_circuit(lst_circuit, lst_villes):
    """ 
        ENTREE :
            
            Deux listes correspondant au circuit emprunté et à la position des villes
            
        SORTIE :
        
            Un flottant correspondant à la longueur totale du circuit
    """
    
    longueur = 0
    n = len(lst_circuit)
    
    for i in range(n-1) : #On evite le depassement de liste en allant jusqu'à n-2 et on ajoute le dernier cas à part
        a, b = lst_villes[lst_circuit[i]]
        c, d = lst_villes[lst_circuit[i+1]]
        
        longueur += distance_entre_points(a, b, c, d)
        
    e, f = lst_villes[lst_circuit[n-1]]
    g, h = lst_villes[lst_circuit[0]]
    
    longueur += distance_entre_points(e, f, g, h)
    
    return longueur
    
def permutation_aleatoire(lst_circuit):
    """
        ENTREE :
        
            La liste correspondant au circuit du voyageur
            
        SORTIE :
        
            La liste du circuit après la permutation aléatoire
    """
    n = len(lst_circuit)
    i = randint(0, n-1) #La liste va de 0 à n-1 termes
    j = randint(0, n-1) #Les deux villes seront échangées dans le circuit
    
    lst_circuit[i], lst_circuit[j] = lst_circuit[j], lst_circuit[i]
    
    return lst_circuit
    
def difference_longueur_circuit(lst_circuit, lst_villes):
    """
        ENTREE :
            
            La liste du circuit et la liste des coordonnées des villes
            
        SORTIE :
        
            Différence entre la longueur du circuit après permutation et avant
    """
    
    longeur_circuit1 = longueur_circuit(lst_circuit, lst_villes)
    longueur_circuit2 = longueur_circuit(permutation_aleatoire(lst_circuit), lst_villes)
    
    d = longueur_circuit2 - longueur_circuit1
    
    return d
    
def recuit_simule(lst_circuit, lst_villes, nr, delta): # on prend delta comme variable (avant k)
    """
        ENTREE :
            
            La liste du circuit, la liste des coordonnées des villes, le nombre d'itérations internes et [le coefficient d'atténuation] delta avec le changement 
            
        SORTIE :
        
            La nouvelle liste du circuit, la valeur de k, nouveau coefficient d'atténuation et la longueur du dernier parcours
        
    """
    
    lst_circuit_initial = lst_circuit[:] #On fait une copie de la liste 
    longueur_circuit1 = longueur_circuit(lst_circuit, lst_villes)
    
    lst_circuit_permute = permutation_aleatoire(lst_circuit) #lst_circuit est modifié d'où l'importance de copier la liste initiale
    longueur_circuit2 = longueur_circuit(lst_circuit_permute, lst_villes)
    
    d = longueur_circuit2 - longueur_circuit1  
    
    
    
    for _ in range(nr):
        if d < 0 :
            lst_circuit = lst_circuit_permute
        else :
            r = uniform(0, 1)
        
            if exp(-d/delta) > r :
                lst_circuit = lst_circuit_permute
            else :
                lst_circuit = lst_circuit_initial
        
    k = uniform(0.5, 1)
    delta *= k #pour moi on le change à la fin de la boucle 
        
    return (lst_circuit, delta, longueur_circuit(lst_circuit, lst_villes)) # on redonne delta maintenant (avant k )
    
    
ne = int(input("Combien d'itérations pour l'algorithme ? \n"))
nr = int(input("Combien d'itérations internes au recuit simulé ? \n "))
n_ville = int(input("Combien de villes à placer ? \n"))

lst_villes = villes_generation(n_ville)
lst_circuit = [i for i in range(n_ville)]

delta=10


axe_x_villes = []
axe_y_villes = []

axe_x_longueur = []
axe_y_longueur = []

for i in range(ne) :
    delta=3
    
    lst_circuit, delta, longueur_dernier_circuit = recuit_simule(lst_circuit, lst_villes, nr, delta)
    
    axe_x_longueur += [i]
    axe_y_longueur += [longueur_dernier_circuit]

for i in range(n_ville):
    x, y = lst_villes[lst_circuit[i]]
    
    axe_x_villes += [x]
    axe_y_villes += [y]
    
axe_x_villes += [axe_x_villes[0]]
axe_y_villes += [axe_y_villes[0]]

plt.figure(1)

plt.plot(axe_x_villes, axe_y_villes, color = 'blue', marker = 'o')
plt.axis([0, 100, 0 , 100])

plt.figure(2)

plt.plot(axe_x_longueur, axe_y_longueur, color = 'red')
plt.axis([0, ne, 0, longueur_circuit([i for i in range(n_ville)],lst_villes)])

plt.show()

print(lst_circuit)


def moyenne(Stat,i):
    moy=0
    for k in range (len(Stat)):
        moy +=Stat[k][i]
    moy=moy//(len(Stat))
    return (moy)
def stat(lst_villes,n):
    Stat=[]
    for _ in range (n):
        lst_circuit=[i for i in  range(len(lst_villes))]
        for i in range(ne) :
            lst_circuit, k, longueur_dernier_circuit = recuit_simule(lst_circuit, lst_villes, 1000, 1)
        Stat +=[lst_circuit]
        print (Stat)
    Cmoy=[]
    for k in range (len(lst_villes)):
        Cmoy += [moyenne(Stat,k)]
    return(Cmoy,Stat) 
    
        
    
        