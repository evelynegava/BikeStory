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
Select resumo.brand_id,
       resumo.store_id,
       count(order_id) as total_pedidos
From ( Select  b.brand_id,
               o.store_id,
               o.order_id
        From orders o 
        Inner join stores so ON o.store_id = so.store_id
        Inner join order_items oi ON o.order_id = oi.order_id
        Inner join products p ON p.product_id = oi.product_id
        Inner join brands b ON b.brand_id = p.brand_id
        Where b.brand_name = 'Brand 1'
        Group by b.brand_id, o.store_id, o.order_id
) as resumo
Group by resumo.brand_id, resumo.store_id

-- 5. Listar os Funcionarios que não estejam relacionados a um Pedido.
Select s.staff_id,
       s.first_name,
       s.last_name
From staffs s
Left join orders o on s.staff_id = o.staff_id
Where o.order_id is null