## System and security
1 . hostname changed
`after installing the server a most confortable hostname muss be giving'

** avec la commande: hostnamectl set-hostname "newhostname" on change le hostname.

## Securisation du Server
 ## une fois se connecter sur le Server, ouvre avec nano ou bien vim le dossier /etc/ssh/sshd_config
 1. desactiver l access Root
   ````
       PermitRootLogin no
       ````
## desactiver l acces sur le Server par mot de pass. nur les connexions par ssh cles sont autoriser
    ```` PasswordAuthentification  no ````

## activer seulement l access ssh
````
    PubKeyAuthentification  yes ````

## Server Performance Monitoring( CPU, RAM)
monitorer le cpu et la ram reviens a detecter les processus gourmand qui consomment beaucoup de ressources.
 la commande ci-apres permet de monitorer automatiquement le cpu:
 ```
  SEUIL= 80 # Set the threshold for CPU usage
SEUIL_MEM=70
echo "Monitoring server status..."
if [ $(top -bn1 | grep "Cpu(s)" | awk '{print (100 -$5} ') -gt $SEUIL ]; then
    echo "CPU usage is above the threshold. Sending notification..."

    # Here you can add the code to send a notification, such as an email or a message to a monitoring system.
    mail -s "CPU Usage Alert" asmitterandyahoo.fr
else
    echo "CPU usage is within the normal range."
fi
````
###
ici on definis d abord un seuil de % qu on souhaite ne pas depasse. avec la commande "top" on visualise les processus en cours, etant donner que top un interactif(il reste ouvert), on ajoute l option "bn1( non interactif)
c est a dire qu on affiche  le resultat de "top une fois et arrete.
avec `` | grep "Cpu(s)" `` on affiche uniquement laligne commencant par "Cpu(s) car par defaut "top" affiche un ecran avec plusieurs colonnes.
 en affichant plusieurs colonnes, cela n est facile pour faire des calculs, c est pourquoi on utile `` | awk pour extraire des colonnes afin de faciliter les calculs.
 d ou la commande ci-apres:
 `` | awk '{print (100 -$8)}``. $1 ....$8 correspondent aux number de colonnes.pour le calcul du %cpu on a besoin du %id(iddle) et il se trouve a la colonne 8.
 ## le meme principe s applique pour le calcul de la memoire:
 '''
  echo "Checking memory usage..."
if [ "$MEM_UTIL" -gt "$SEUIL_MEM" ]; then
    echo "Memory usage is above the threshold($MEM_UTIL%). Sending notification..."
    mail -s "Memory Usage Alert" asmitterand@yahoo.fr
else
    echo "Memory usage is within the normal range()."
fi
```
concernant les colonnes, $2--> correspond a la ram total, $3--> a la ram utilisee
les autres colonnes se presentent comme suit:

###
   Mem: → juste le label

$2 → total

$3 → utilisé

$4 → libre

$5 → partagé

$6 → buffer/cache

$7 → disponible