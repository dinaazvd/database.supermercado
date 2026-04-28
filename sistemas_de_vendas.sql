-- Modelagem do Banco
DROP TABLE IF EXISTS produtos CASCADE;
DROP TABLE IF EXISTS vendas CASCADE;

create table produtos(
id serial primary key,
nome varchar(100)not null,
preco decimal(10,2) not null,
estoque int not null 
);

create table vendas (
id serial primary key,
produto_id int references produtos(id),
quantidade int not null,
valor_total decimal(10,2),
data_venda timestamp default current_timestamp
);

-- Inserção de Dados
insert into produtos (nome, preco, estoque) values
('Arroz', 7.00, 100),
('Feijão', 5.00, 70),
('Macarrão', 3.00, 200);


-- Procedure de Venda

-- DROP PROCEDURE public.realizar_venda();

CREATE OR REPLACE PROCEDURE public.realizar_venda(p_produto_id int, p_quantidade int)
	LANGUAGE plpgsql
AS $procedure$
declare
v_preco decimal(10,2);
v_estoque_atual int;
v_valor_total decimal(10,2);

	BEGIN
select preco, estoque into v_preco, v_estoque_atual
from produtos
where id = p_produto_id;

if not found then 
	raise exception 'ERRO: produto com ID % não encontrado.', p_produto_id;
end if;

if  v_estoque_atual < p_quantidade then
        raise exception 'ERRO: Estoque insuficiente. Disponível: %', v_estoque_atual;
    end if;

  v_valor_total := v_preco * p_quantidade;

  insert into vendas (produto_id, quantidade, valor_total)
   values (p_produto_id, p_quantidade, v_valor_total);

update produtos
   set estoque = estoque - p_quantidade
   where id = p_produto_id;

	END;
$procedure$
;

-- Execução, chamada da Procedure
call realizar_venda(1,2);
call realizar_venda(1, 5);
call realizar_venda(99, 1);
call realizar_venda(2, 80);
call realizar_venda(3, 50);

SELECT * FROM produtos;
SELECT * FROM vendas;
