##########################################REQUËTES SQL #############################################################################################
# Récupérer les heure de début et de fin des animations qui correspondent à un type_animation aquatique
# (1) On récupère l'ID_TYPE_ANIMATION correspondant au NOM_TYPE_ANIMATION aquatique
SELECT ID_TYPE_ANIMATION FROM TYPE_ANIMATION WHERE NOM_TYPE_ANIMATION="aquatique";
# R1 ← Π{ID_TYPE_ANIMATION} (σ{NOM_TYPE_ANIMATION="aquatique"}(TYPE_ANIMATION))
# (2) On séléctionne les ID_ANIMATION des animations qui ont ID_TYPE_ANIMATION = (1)
SELECT ID_ANIMATION FROM ANIMATION WHERE ID_TYPE_ANIMATION IN(SELECT ID_TYPE_ANIMATION FROM TYPE_ANIMATION WHERE NOM_TYPE_ANIMATION="aquatique");
# R2 ← Π{ID_ANIMATION} (σ{ID_TYPE_ANIMATION=R1}(ANIMATION))
# (3) On sélectionne les ID_SESSION des sessions qui ont pour ID_ANIMATION = (2)
SELECT ID_SESSION FROM SESSION WHERE ID_ANIMATION IN (SELECT ID_ANIMATION FROM ANIMATION WHERE ID_TYPE_ANIMATION IN (SELECT ID_TYPE_ANIMATION FROM TYPE_ANIMATION WHERE NOM_TYPE_ANIMATION="aquatique"));
# R3 ← Π{ID_SESSION} (σ{ID_ANIMATION=R3}(SESSION))
# (4) On sélectionne les date_debut_session et date_fin_session des SESSIONS qui ont pour ID_SESSION = (4)
SELECT HEURE_DEBUT_SESSION, HEURE_FIN_SESSION FROM SESSION WHERE ID_SESSION IN (SELECT ID_SESSION FROM SESSION WHERE ID_ANIMATION IN (SELECT ID_ANIMATION FROM ANIMATION WHERE ID_TYPE_ANIMATION IN (SELECT ID_TYPE_ANIMATION FROM TYPE_ANIMATION WHERE NOM_TYPE_ANIMATION="aquatique")));
# R4 ← Π{HEURE_DEBUT_SESSION, HEURE_FIN_SESSION} (σ{ID_SESSION=R4}(SESSION))
######################################################################################################################################################################################################################
# Récupérer les date de début et de fin des sessions des animations des acteurs aquatiques 
# (1) On récupère les id_acteur de ACTEUR qui sont animateurs aquatiques
SELECT ID_ACTEUR FROM ACTEUR WHERE METIER_ACTEUR ="animateur aquatique";
# R1 ← Π{ID_ACTEUR} (σ{METIER_ACTEUR="animateur aquatique"}(ACTEUR))
# (2) On récupère les ID_ANIMATION de ANIMATION qui ont ID_ACTEUR = (1)
SELECT ID_ANIMATION FROM ANIMATION WHERE ID_ACTEUR IN (SELECT ID_ACTEUR FROM ACTEUR WHERE METIER_ACTEUR ="animateur aquatique");
# R2 ← Π{ID_ANIMATION} (σ{ID_ACTEUR=R1}(ANIMATION))
# (3) On sélectionne les ID_SESSION des sessions qui ont pour ID_ANIMATION = (2)
SELECT ID_SESSION FROM SESSION WHERE ID_ANIMATION IN (SELECT ID_ANIMATION FROM ANIMATION WHERE ID_ACTEUR IN (SELECT ID_ACTEUR FROM ACTEUR WHERE METIER_ACTEUR ="animateur aquatique"));
# R3 ← Π{ID_SESSION} (σ{ID_ANIMATION=R2}(SESSION))
# (4) On sélectionne les date_debut_session et date_fin_session des SESSIONS qui ont pour ID_SESSION = (4)
SELECT DATE_DEBUT_SESSION, DATE_FIN_SESSION FROM SESSION WHERE ID_SESSION IN (SELECT ID_SESSION FROM SESSION WHERE ID_ANIMATION IN (SELECT ID_ANIMATION FROM ANIMATION WHERE ID_ACTEUR IN (SELECT ID_ACTEUR FROM ACTEUR WHERE METIER_ACTEUR ="animateur aquatique")));
# R4 ← Π{DATE_DEBUT_SESSION, DATE_FIN_SESSION} (σ{ID_SESSION=R3}(SESSION))
######################################################################################################################################################################################################################
# Toutes les sessions d’animations proposés le 2018-01-01 à 14h00 et prenant fin a 16h
SELECT ID_ANIMATION FROM SESSION WHERE DATE_DEBUT_SESSION="2018-01-01 14:00:00" AND exists (SELECT ID_ANIMATION FROM SESSION WHERE HEURE_FIN_SESSION="16:00:00") ;
# R1 ← Π{ID_ANIMATION} (σ{DATE_DEBUT_SESSION="2018-01-01 14:00:00"}(SESSION))
# R2 ← Π{ID_ANIMATION} (σ{HEURE_FIN_SESSION="16:00:00"}(SESSION))
# R3 ← Π{ID_ANIMATION} (σ{HEURE_FIN_SESSION="16:00:00"}(R1⋈R2))
######################################################################################################################################################################################################################
# nom_client et prénom_client qui ont souscrit au animation et dont les TYPE_LOCATION sont != tente et != mobil-home, dont la taille de l'emplacement est > 100m² et comportant un équipement de type jardin avec un label 'barbecue'
# (1) On récupère les ID_TYPE_EQUIPEMENT de TYPE_EQUIPEMENT de type jardin
SELECT ID_TYPE_EQUIPEMENT FROM TYPE_EQUIPEMENT WHERE NOM_TYPE_EQUIPEMENT="jardin";
# R1 ← Π{ID_TYPE_EQUIPEMENT} (σ{NOM_TYPE_EQUIPEMENT="jardin"}(TYPE_EQUIPEMENT))
# (2) On récupère les ID_EMPLACEMENT de EQUIPEMENTS de ID_TYPE_EQUIPEMENT = (1) et que le LABEL_EQUIPEMENT="barbecue"
SELECT ID_EMPLACEMENT FROM EQUIPEMENT WHERE ID_TYPE_EQUIPEMENT IN(SELECT ID_TYPE_EQUIPEMENT FROM TYPE_EQUIPEMENT WHERE NOM_TYPE_EQUIPEMENT="jardin") AND LABEL_EQUIPEMENT="barbecue";
# R2 ← Π{ID_TYPE_EQUIPEMENT} (σ{NOM_TYPE_EQUIPEMENT="jardin" ∧ LABEL_EQUIPEMENT="barbecue"}(TYPE_EQUIPEMENT))
# (3) On récupère les ID_EMPLACEMENT de EMPLACEMENTS dont la TAILLE_EMPLACEMENT > 100
SELECT ID_EMPLACEMENT FROM EMPLACEMENT WHERE TAILLE_EMPLACEMENT > 100;
# R3 ← Π{ID_EMPLACEMENT} (σ{TAILLE_EMPLACEMENT > 100}(EMPLACEMENT))
# (3.1) on récupère les ID_LOCATION de LOCATION dont les ID_EMPLACEMENT = (3)
SELECT ID_LOCATION FROM LOCATION WHERE ID_EMPLACEMENT IN(SELECT ID_EMPLACEMENT FROM EMPLACEMENT WHERE TAILLE_EMPLACEMENT > 100);
# R3.1 ← Π{ID_LOCATION} (σ{ID_EMPLACEMENT=R3}(LOCATION))
# (4) On récupère les ID_LOCATION de LOCATION dont le TYPE_LOCATION ne sont pas tente et ne sont pas mobil-home et font parti de (3.1)
SELECT ID_LOCATION FROM LOCATION WHERE ID_TYPE_LOCATION NOT IN((SELECT ID_TYPE_LOCATION FROM TYPE_LOCATION WHERE NOM_TYPE_LOCATION="tente") AND (SELECT ID_TYPE_LOCATION FROM TYPE_LOCATION WHERE NOM_TYPE_LOCATION="mobilhome")); 
# R4 ← Π{ID_LOCATION} (σ{ID_TYPE_LOCATION=R3.1 ∧ ID_TYPE_LOCATION≠"tente" ∧ ID_TYPE_LOCATION≠"mobil-home"}(LOCATION))
# (4.1) On récupère les ID_LOCATION qui sont dans (3.1) et (4)
SELECT DISTINCT ID_LOCATION FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM LOCATION WHERE ID_EMPLACEMENT IN(SELECT ID_EMPLACEMENT FROM EMPLACEMENT WHERE TAILLE_EMPLACEMENT > 100) AND ID_LOCATION IN(
	SELECT ID_LOCATION FROM LOCATION WHERE ID_TYPE_LOCATION NOT IN((SELECT ID_TYPE_LOCATION FROM TYPE_LOCATION WHERE NOM_TYPE_LOCATION="tente") AND (SELECT ID_TYPE_LOCATION FROM TYPE_LOCATION WHERE NOM_TYPE_LOCATION="mobilhome"))
	));
# R4.1 ← Π{ID_LOCATION} (σ{ID_LOCATION = R4}(LOCATION))
# (5) On récupère les ID_FORMULE de FORMULE qui ont un ID_LOCATION = (4.1)
SELECT ID_FORMULE FROM FORMULE WHERE ID_LOCATION IN(
	SELECT DISTINCT ID_LOCATION FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM LOCATION WHERE ID_EMPLACEMENT IN(SELECT ID_EMPLACEMENT FROM EMPLACEMENT WHERE TAILLE_EMPLACEMENT > 100) AND ID_LOCATION IN(
	SELECT ID_LOCATION FROM LOCATION WHERE ID_TYPE_LOCATION NOT IN((SELECT ID_TYPE_LOCATION FROM TYPE_LOCATION WHERE NOM_TYPE_LOCATION="tente") AND (SELECT ID_TYPE_LOCATION FROM TYPE_LOCATION WHERE NOM_TYPE_LOCATION="mobilhome"))
	))
	);
# R5 ← Π{ID_FORMULE} (σ{ID_LOCATION = R4.1}(FORMULE))
# (6) On récupère les ID_DEVIS qui ont ID_FORMULE = (5)
SELECT ID_DEVIS FROM SOUSCRIT_FORMULE WHERE ID_FORMULE IN(
	SELECT ID_FORMULE FROM FORMULE WHERE ID_LOCATION IN(
	SELECT DISTINCT ID_LOCATION FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM LOCATION WHERE ID_EMPLACEMENT IN(SELECT ID_EMPLACEMENT FROM EMPLACEMENT WHERE TAILLE_EMPLACEMENT > 100) AND ID_LOCATION IN(
	SELECT ID_LOCATION FROM LOCATION WHERE ID_TYPE_LOCATION NOT IN((SELECT ID_TYPE_LOCATION FROM TYPE_LOCATION WHERE NOM_TYPE_LOCATION="tente") AND (SELECT ID_TYPE_LOCATION FROM TYPE_LOCATION WHERE NOM_TYPE_LOCATION="mobilhome"))
	)))
	);
# R6 ← Π{ID_DEVIS} (σ{ID_FORMULE = R5}(ID_DEVIS))
# (7) On récupère les ID_CLIENT de DEVIS qui ont ID_DEVIS=(6)
SELECT ID_CLIENT FROM DEVIS WHERE ID_DEVIS IN(
	SELECT ID_DEVIS FROM SOUSCRIT_FORMULE WHERE ID_FORMULE IN(
	SELECT ID_FORMULE FROM FORMULE WHERE ID_LOCATION IN(
	SELECT DISTINCT ID_LOCATION FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM LOCATION WHERE ID_EMPLACEMENT IN(SELECT ID_EMPLACEMENT FROM EMPLACEMENT WHERE TAILLE_EMPLACEMENT > 100) AND ID_LOCATION IN(
	SELECT ID_LOCATION FROM LOCATION WHERE ID_TYPE_LOCATION NOT IN((SELECT ID_TYPE_LOCATION FROM TYPE_LOCATION WHERE NOM_TYPE_LOCATION="tente") AND (SELECT ID_TYPE_LOCATION FROM TYPE_LOCATION WHERE NOM_TYPE_LOCATION="mobilhome"))
	))))
	);
# R7 ← Π{ID_CLIENT} (σ{ID_DEVIS = R6}(DEVIS))
# (8) On récupère les nom et prénom des clients de CLIENT qui ont ID_CLIENT = (7)
SELECT NOM_CLIENT, PRENOM_CLIENT FROM CLIENT WHERE ID_CLIENT IN(
	SELECT ID_CLIENT FROM DEVIS WHERE ID_DEVIS IN(
	SELECT ID_DEVIS FROM SOUSCRIT_FORMULE WHERE ID_FORMULE IN(
	SELECT ID_FORMULE FROM FORMULE WHERE ID_LOCATION IN(
	SELECT DISTINCT ID_LOCATION FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM LOCATION WHERE ID_EMPLACEMENT IN(SELECT ID_EMPLACEMENT FROM EMPLACEMENT WHERE TAILLE_EMPLACEMENT > 100) AND ID_LOCATION IN(
	SELECT ID_LOCATION FROM LOCATION WHERE ID_TYPE_LOCATION NOT IN((SELECT ID_TYPE_LOCATION FROM TYPE_LOCATION WHERE NOM_TYPE_LOCATION="tente") AND (SELECT ID_TYPE_LOCATION FROM TYPE_LOCATION WHERE NOM_TYPE_LOCATION="mobilhome"))
	)))))
	);
# R8 ← Π{NOM_CLIENT, PRENOM_CLIENT} (σ{ID_CLIENT = R7}(CLIENT))
######################################################################################################################################################################################################################
# Facture du client de nom 'Armand'
# TOTAL_A_PAYER_0 = tarif_location + tarif_emplacement
# TOTAL_A_PAYER_1 = TOTAL_A_PAYER_0 + tarif_equipement/equipement
# TOTAL_A_PAYER_2 = TOTAL_A_PAYER_1 + caution_location
# TOTAL_A_PAYER_DEVIS = TOTAL_A_PAYER_2 + (TOTAL_A_PAYER_2*POURCENTAGE_TYPE_SAISON/100)
# CLIENT 1 = 700 + 140 | + 3*10 | +500 | +0% = 1370
# On déclare une variable pour stocker les différents  élements de la facture
declare @tarif_location: int;
declare @tarif_equipement: int;
declare @nb_equipement: int;
declare @tarif_equipement: int;
declare @caution_location: int;
declare @pourcentage_type_saison: int;
declare @total: int;
# (1) on récupère l'ID_CLIENT de CLIENT dont le NOM_CLIENT="Armand"
SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand";
# R1 ← Π{ID_CLIENT} (σ{NOM_CLIENT="Armand"}(CLIENT))
# (2) on récupère l'ID_DEVIS de DEVIS dont l'ID_CLIENT = (1)
SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand");
# R2 ← Π{ID_DEVIS} (σ{ID_DEVIS=R1}(DEVIS))
# (3) on récupère l'ID_FORMULE de SOUSCRIT_FORMULE dont l'ID_DEVIS = (2)
SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand"));
# R3 ← Π{ID_FORMULE} (σ{ID_DEVIS=R2}(SOUSCRIT_FORMULE))
# (3.1) on récupère le POURCENTAGE_TYPE_SAISON DU TYPE_SAISON de FORMULE dont ID_FORMULE = (3)
@pourcentage_type_saison = SELECT POURCENTAGE_TYPE_SAISON FROM TYPE_SAISON WHERE ID_TYPE_SAISON IN(SELECT ID_TYPE_SAISON FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand"))));
# R3.1 ← Π{POURCENTAGE_TYPE_SAISON} (σ{ID_TYPE_SAISON=R3}(TYPE_SAISON))
# (4) on récupère l'ID_LOCATION de FORMULE dont l'ID_FORMULE = (3)
SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand")));
# R4 ← Π{ID_LOCATION} (σ{ID_FORMULE=R3}(FORMULE))
# (4.1) on récupère et stocke la caution_location de LOCATION dont ID_LOCATION = (4)
SELECT caution_location FROM LOCATION WHERE ID_LOCATION IN(SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand"))));
# R4.1 ← Π{caution_location} (σ{ID_LOCATION=R4}(LOCATION))
# (5) on stocke et récupère le tarif_location de LOCATION dont l'ID_LOCATION = (4) dans @tarif_location
@tarif_location = SELECT tarif_location FROM LOCATION WHERE ID_LOCATION IN(SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand"))));
# R5 ← Π{tarif_location} (σ{ID_LOCATION=R4}(LOCATION))
# (6) on récupère l'ID_EMPLACEMENT de LOCATION dont l'ID_LOCATION = (4)
SELECT ID_EMPLACEMENT FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand")))
	);
# R6 ← Π{ID_EMPLACEMENT} (σ{ID_LOCATION=R4}(LOCATION))
# (7) on stocke et récupère le TARIF_EMPLACEMENT de EMPLACEMENT dont l'ID_EMPLACEMENT = (6)
@tarif_emplacement = SELECT tarif_emplacement FROM EMPLACEMENT WHERE ID_EMPLACEMENT IN(
	SELECT ID_EMPLACEMENT FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand")))
	)
	);
# R7 ← Π{tarif_emplacement} (σ{ID_EMPLACEMENT=R6}(EMPLACEMENT))
# (8) on récupère les ID_EQUIPEMENT de EQUIPEMENT dont l'ID_EMPLACEMENT = (6)
SELECT ID_EQUIPEMENT FROM EQUIPEMENT WHERE ID_EMPLACEMENT IN(
	SELECT ID_EMPLACEMENT FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand")))
	)
	);
# R8 ← Π{ID_EQUIPEMENT} (σ{ID_EMPLACEMENT=R6}(EQUIPEMENT))
# (9) On récupère et on stocke le nombre d'équipement de (8)
@nb_equipement = SELECT COUNT(*) FROM (
	SELECT ID_EQUIPEMENT FROM EQUIPEMENT WHERE ID_EMPLACEMENT IN(
	SELECT ID_EMPLACEMENT FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand")))
	))
	);
# R9 ← Π{count(*)} (σ{ID_EMPLACEMENT=R8}(EQUIPEMENT))
# (10) on récupère le TARIF_EQUIPEMENT de EQUIPEMENT dont ID_EQUIPEMENT = (8)
@tarif_equipement = SELECT DISTINCT tarif_equipement FROM EQUIPEMENT WHERE ID_EQUIPEMENT IN(
	SELECT ID_EQUIPEMENT FROM EQUIPEMENT WHERE ID_EMPLACEMENT IN(
	SELECT ID_EMPLACEMENT FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand")))
	))
	);
# R10 ← Π{tarif_equipement} (σ{ID_EQUIPEMENT=R8}(EQUIPEMENT))
# (11) on fait le calcul du total
@total = @tarif_location + @tarif_emplacement + @tarif_equipement*@nb_equipement + @caution_location;
@total = @total + (@total*@pourcentage_type_saison/100);

### @tarif_location + @tarif_emplacement + @tarif_equipement*@nb_equipement + @caution_location
# (12) TOTAL LOCATION = SOMME DE TARIF_LOCATION et de CAUTION_LOCATION
SELECT sum(DISTINCT tarif_location+caution_location) AS _TOTAL_LOCATION FROM LOCATION WHERE tarif_location AND caution_location IN(
SELECT tarif_location FROM LOCATION WHERE ID_LOCATION IN(SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand"))))
);
# R12 ← Π{tarif_location+caution_location} (σ{tarif_location=R5 ∧ caution_location=R4.1}(LOCATION))
# (13) TOTAL_EMPLACEMENT = SOMME DE TARIF_EMPLACEMENT(7)
SELECT sum(DISTINCT tarif_emplacement) FROM EMPLACEMENT AS _TOTAL_EMPLACEMENT WHERE tarif_emplacement IN(SELECT tarif_emplacement FROM EMPLACEMENT WHERE ID_EMPLACEMENT IN(
	SELECT ID_EMPLACEMENT FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand")))
	))
);
# R13 ← Π{tarif_emplacement} (σ{tarif_emplacement=R7}(EMPLACEMENT))
# (14) TOTAL_EQUIPEMENT = SOMME DE TARIF_EQUIPEMENT(10)
SELECT sum(DISTINCT tarif_equipement*3) FROM EQUIPEMENT AS _TOTAL_EQUIPEMENT WHERE tarif_equipement IN(SELECT DISTINCT tarif_equipement FROM EQUIPEMENT WHERE ID_EQUIPEMENT IN(
	SELECT ID_EQUIPEMENT FROM EQUIPEMENT WHERE ID_EMPLACEMENT IN(
	SELECT ID_EMPLACEMENT FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand")))
	)))
);
# R14 ← Π{tarif_equipement*3} (σ{tarif_equipement=R10}(EQUIPEMENT))
# TOTAL_A = TOTAL_LOCATION(12) + TOTAL_EMPLACEMENT(13) + TOTAL_EQUIPEMENT(14)
# R15 ← Π{tarif_location+caution_location+tarif_emplacement+tarif_equipement*3} (σ{ (tarif_location ∧ caution_location)=R12 ∧  tarif_emplacement=R13 ∧  tarif_equipement=R14}(LOCATION × EMPLACEMENT × EQUIPEMENT))
# essai 1
select sum(
(SELECT sum(DISTINCT tarif_location+caution_location) AS _TOTAL_LOCATION FROM LOCATION WHERE tarif_location AND caution_location IN(
SELECT tarif_location FROM LOCATION WHERE ID_LOCATION IN(SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand"))))
)) JOIN
(SELECT sum(DISTINCT tarif_emplacement) FROM EMPLACEMENT AS _TOTAL_EMPLACEMENT WHERE tarif_emplacement IN(SELECT tarif_emplacement FROM EMPLACEMENT WHERE ID_EMPLACEMENT IN(
	SELECT ID_EMPLACEMENT FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand")))
	))
)) JOIN
(SELECT sum(DISTINCT tarif_equipement*3) FROM EQUIPEMENT AS _TOTAL_EQUIPEMENT WHERE tarif_equipement IN(SELECT DISTINCT tarif_equipement FROM EQUIPEMENT WHERE ID_EQUIPEMENT IN(
	SELECT ID_EQUIPEMENT FROM EQUIPEMENT WHERE ID_EMPLACEMENT IN(
	SELECT ID_EMPLACEMENT FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand")))
	)))
))
);	
# essai 2
select sum(
SELECT sum(DISTINCT tarif_location+caution_location) AS _TOTAL_LOCATION FROM LOCATION WHERE tarif_location AND caution_location IN(
SELECT tarif_location FROM LOCATION WHERE ID_LOCATION IN(SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand"))))
),
SELECT sum(DISTINCT tarif_emplacement) FROM EMPLACEMENT AS _TOTAL_EMPLACEMENT WHERE tarif_emplacement IN(SELECT tarif_emplacement FROM EMPLACEMENT WHERE ID_EMPLACEMENT IN(
	SELECT ID_EMPLACEMENT FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand")))
	))
),
SELECT sum(DISTINCT tarif_equipement*3) FROM EQUIPEMENT AS _TOTAL_EQUIPEMENT WHERE tarif_equipement IN(SELECT DISTINCT tarif_equipement FROM EQUIPEMENT WHERE ID_EQUIPEMENT IN(
	SELECT ID_EQUIPEMENT FROM EQUIPEMENT WHERE ID_EMPLACEMENT IN(
	SELECT ID_EMPLACEMENT FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand")))
	)))
)	
) FROM LOCATION, EMPLACEMENT, EQUIPEMENT; 

# essai 3
SELECT sum(DISTINCT tarif_location+caution_location) AS _TOTAL_LOCATION FROM LOCATION WHERE tarif_location AND caution_location IN(
SELECT tarif_location FROM LOCATION WHERE ID_LOCATION IN(SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand"))))) AS TOTAL_LOCATION
+
SELECT sum(DISTINCT tarif_emplacement) FROM EMPLACEMENT AS TOTAL_EMPLACEMENT WHERE tarif_emplacement IN(SELECT tarif_emplacement FROM EMPLACEMENT WHERE ID_EMPLACEMENT IN(
	SELECT ID_EMPLACEMENT FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand")))
	))) AS TOTAL_EMPLACEMENT
+
SELECT sum(DISTINCT tarif_equipement*3) FROM EQUIPEMENT AS TOTAL_EQUIPEMENT WHERE tarif_equipement IN(SELECT DISTINCT tarif_equipement FROM EQUIPEMENT WHERE ID_EQUIPEMENT IN(
	SELECT ID_EQUIPEMENT FROM EQUIPEMENT WHERE ID_EMPLACEMENT IN(
	SELECT ID_EMPLACEMENT FROM LOCATION WHERE ID_LOCATION IN(
	SELECT ID_LOCATION FROM FORMULE WHERE ID_FORMULE IN(SELECT ID_FORMULE FROM SOUSCRIT_FORMULE WHERE ID_DEVIS IN(SELECT ID_DEVIS FROM DEVIS WHERE ID_DEVIS IN(SELECT ID_CLIENT FROM CLIENT WHERE NOM_CLIENT="Armand")))
	)))) AS TOTAL_EQUIPEMENT
) 
# R16 ← Π{tarif_location+caution_location+tarif_emplacement+tarif_equipement*3+R15*R3.1} (σ{ (tarif_location ∧ caution_location)=R12 ∧  tarif_emplacement=R13 ∧  tarif_equipement=R14 ∧ }(LOCATION × EMPLACEMENT × EQUIPEMENT))
# TOTAL_B = TOTAL_A + (TOTAL_A*pourcentage_type_saison(3.1))
######################################################################################################################################################################################################################