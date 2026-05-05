-- Criação tabela
create table users  (
id serial primary key,
nome varchar(100),
email varchar(100),
active boolean 
);
-- Inserção de Dados
insert into users (nome, email, active) 
values 
('Diná', 'dina@gmail.com', true),
('Maria',' maria@gmail.com', false),
('Daniel', 'dan@gmail.com', true);
 
-- View 
create or replace view active_users_view as select 
id,
nome,
email
from users 
where active = true;

--Exemplo de uso
select * from active_users_view;

--Function

-- DROP FUNCTION public.check_user_status(int4);

CREATE OR REPLACE FUNCTION public.check_user_status(p_id integer)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
declare
v_active boolean;
v_exists boolean; 
	BEGIN
select active into v_active from users where id = p_id;
if not found then 
	return 'Usuário não encontrado';
elseif v_active = true then
	return 'Usuário Ativo';
else return 'Usuário Inativo';
end if; 
	END;
$function$
;
-- Exemplo de uso
SELECT check_user_status(1); 
SELECT check_user_status(2); 
SELECT check_user_status(99); 
