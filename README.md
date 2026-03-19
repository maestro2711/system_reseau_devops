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
