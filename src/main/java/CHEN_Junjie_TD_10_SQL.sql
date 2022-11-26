--Stucture DDL
--1.le mail est unique
alter table employees add constraint UN_MAIL UNIQUE(email);
--2. le salaire est positif, non nul
alter table employees add constraint po_salaire CHECK ( salary>0 );
alter table employees alter column  salary set not null ;
--3. le salaire max est supérieur au salaire min
alter table jobs add constraint legal check ( jobs.max_salary > jobs.min_salary );
--4.un employe ne peut être son propre manager
alter table employees add constraint non_egale check ( employee_id != employees.manager_id );

--Requêtes sur les données  DML(SELECT)

--1.Extraire le nombre d'employe par departement
select count(*) from employees;
--2. afficher le nom du departement et des salaires sous-total
select department_name,sum(salary) as sous_total from employees  e  join departments d on e.department_id = d.department_id group by d.department_id having sum(salary)>30000;
--3.Extraire toutes les informations de l'employe qui gagne le moins
--version 1
select * from employees where (salary in (select min(e.salary) from employees e));
--version 2
select * from employees order by salary asc limit 1;
/*
  4.Extraire le plus gros salaire de chaque département en spécifiant le nom du département
  et en triant le résultat du plus gros au plus petit mais uniquement pour les salaires supérieurs à 5 000 €.
*/
select department_name,max(salary) from employees,departments where employees.department_id=departments.department_id and employees.salary>5000 group by departments.department_id order by max(salary) desc;

--5. Comptez le nombre de pays dans lesquels il y a un département, sans doublon en affichant le nom du pays et celui de la région.
select distinct r.region_name,c.country_name,count(*) as nombre_departement from countries c,locations l,departments d,regions r where c.country_id=l.country_id and l.location_id = d.location_id and r.region_id=c.region_id group by r.region_id,c.country_id having count(*)=1;

--6. le salaire moyen dans cette entreprise
select avg(salary) as avg_salaire from employees;

--7. Quel est le salaire moyen par catégorie d’emploi en ne considérant que les types d’emploi de la catégorie « manager »
-- et trié du plus petit au plus grand salaire moyen.
--utiliser ilike pour ignorer majuscule et minuscule
select job_title,(sum(min_salary)+sum(max_salary))/2 as moyenn_salare from jobs where job_title ilike '%manager%' group by job_title order by moyenn_salare asc;

--8.Extraire tous les employés qui sont liés à « dependents »

select e.* from dependents left outer join employees e on e.employee_id = dependents.employee_id;

--9.Extraire tous les employés qui ne sont pas liés à « dependents » en utilisant NOT
--  EXISTS et une requête imbriquée.
select * from employees e where not exists(SELECT * from dependents d where e.employee_id=d.employee_id);

--10. • Afficher pour chaque employé, son salaire net (sans modifier l’information stockée) :
-- on considérera que le salaire net est égal à 75 % du salaire (brut) vous indiquerez les colonnes salaire brut et salaire net pour chaque employé.

select e.employee_id,e.salary*0.75 as salaire_net, e.salary as salaire_brut from employees e;

--11. pour aller plus loin
-- Extraire tous les employés dont la rémunération est plus petite que le salaire moyen de leur département,
--   trié en fonction du montant de la rémunération.

-- select avg(salary) as avg_salaire from employees e group by e.department_id order by department_id asc;
select e2.* from employees e2,(select avg(salary) as avg_salaire,department_id from employees e group by e.department_id order by department_id asc) as avg_table where e2.department_id=avg_table.department_id and salary<avg_table.avg_salaire order by e2.salary;



--                      FIN DU sujet de gestion de parc informatique                --
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

