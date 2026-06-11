# Étape 1 : Utilisation d'une image de base Java compatible avec votre environnement
FROM eclipse-temurin:21-jre-jammy

# Définition du dossier de travail dans le conteneur
WORKDIR /app

# Copie du fichier binaire (JAR) généré par Maven dans le conteneur
COPY target/*.jar app.jar

# Commande d'exécution de l'application
CMD ["java", "-jar", "app.jar"]
