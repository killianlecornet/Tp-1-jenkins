# Utiliser Nginx comme image de base
FROM nginx:alpine

# Copier les fichiers statiques dans le dossier de Nginx pour les servir
COPY ./website_karma-main /usr/share/nginx/html

# Exposer le port 80 pour le trafic HTTP
EXPOSE 80

# Utiliser le fichier de configuration par défaut de Nginx
# Aucun CMD requis car nous utilisons le CMD par défaut de l'image nginx qui lance Nginx
