-- 1. Listar todos os clientes que não tenham realizado uma compra
Select 'Id do Cliente' = c.customer_id, 
       'Nome' = c.first_name, 
       'Sobrenome' = c.last_name, 
       'Telefone' = c.phone, 
       'E-mail' = c.email, 
       'Endereço' = c.street, 
       'Cidade' = c.city, 
       'Estado' = c.state, 
       'CEP' = c.zip_code
  From customers c
Where not exists (
    Select 1
    From orders o
    Where c.customer_id = o.customer_id
)

--2. Listar os Produtos que não tenham sido comprados
Select 'Id do Produto' = p.product_id,
       'Nome do Produto' = p.product_name,
       'ID da Marca' = p.brand_id,
       'Nome da Marca' = br.brand_name,
       'ID da Categoria' = p.category_id,
       'Nome da Categoria' = cat.category_name, 
       'Ano Modelo' = p.model_year,
       'Preços' = p.list_price
  From products p 
  Inner Join brands br on p.brand_id = br.brand_id
  Inner join categories cat on p.category_id = cat.category_id
  Where not exists 
  (Select 1 
   From order_itens oi 
   Where p.product_id = oi.product_id)

--3. Listar os Produtos sem Estoque
Select 'ID do Produto' = p.product_id,
       'Nome do Produto' = p.product_name,
       'ID da Marca' = p.brand_id,
       'Nome da Marca' = br.brand_name,
       'ID da Categoria' = p.category_id, 
       'Nome da Categoria' = cat.category_name, 
       'Ano Modelo' = p.model_year,
       'Preços' = p.list_price
  From products p
  Inner Join brands br on p.brand_id = br.brand_id
  Inner join categories cat on p.category_id = cat.category_id
  Where not exists (
    Select 1
    From stocks s
    Where p.product_id = s.product_id)

-- 4.Agrupar a quantidade de vendas que uma determinada Marca por Loja.
Declare @brand_name varchar(70)

Select 'Id da Marca' = resumo.brand_id,
       'Marca' = resumo.brand_name,
       'Id da Loja' = resumo.store_id,
       'Loja' = resumo.store_name,
       'Total de Pedidos' = count(order_id) 
From ( Select  b.brand_id,
               b.brand_name,
               o.store_id,
               so.store_name,
               o.order_id
        From orders o 
        Inner join stores so ON o.store_id = so.store_id
        Inner join order_items oi ON o.order_id = oi.order_id
        Inner join products p ON p.product_id = oi.product_id
        Inner join brands b ON b.brand_id = p.brand_id
        Where b.brand_name = @brand_name
        Group by b.brand_id, b.brand_name, o.store_id, so.store_name, o.order_id
) as resumo
Group by resumo.brand_id, resumo.brand_name,resumo.store_id, resumo.store_name

-- 5. Listar os Funcionarios que não estejam relacionados a um Pedido.
Declare @order_id int

Select distinct 'ID do Staff' = s.staff_id,
                'Nome' = s.first_name,
                'Sobrenome' = s.last_name
From staffs s
Left join orders o on s.staff_id = o.staff_id
Where (o.order_id is null or o.order_id <> @order_id)