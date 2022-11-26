--EX 3-2 group by
-- Trouver les vitesses du processeur le plus performant et
-- le moins performant dans chaque groupe d'unités centrales ayant la même quantité de mémoire.
select memoire as group_memoire,max(vitesse) as p_performant, min(vitesse) as m_performant from uc group by memoire;
-- EX 3-3 Having
-- Donner les tailles de mémoire et le nombre d'unités centrales ayant la même taille de mémoire avec une vitesse du processeur supérieure
-- ou égale à 3,8GHz,à condition que ce nombre soit supérieur ou égale à deux.
select memoire,count(*) as nbre_processeur from uc where vitesse>=3.8 group by memoire having count(*)>=2;

-- Requête imbriquée (sous_requête)
-- Quelles sont les unités centrales ayant la vitesse du processeur le moins performant.
select * from uc where vitesse=(select min(vitesse) from uc);
-- Donner les informations concernant les objets en panne et leur fournisseur, en utilisant une requête imbriquée.
select panne.*,nom_fournisseur from panne,founisseur where panne.date_reservice is null and no_invent in (select obj_inventaire.no_invent from obj_inventaire
   where fournisseur = founisseur.no_fouri);
-- Trouver une requête équivalente sans utiliser la requête imbriquée.
select panne.*,nom_fournisseur from panne,founisseur,obj_inventaire where panne.date_reservice is null and panne.no_invent=obj_inventaire.no_invent and no_fouri = obj_inventaire.fournisseur;