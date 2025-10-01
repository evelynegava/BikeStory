--Listar todos os clientes que não tenham realizado uma compra
Select c.customer_id, 
       c.first_name, 
       c.last_name, 
       c.phone, 
       c.email, 
       c.street, 
       c.city, 
       c.state, 
       c.zip_code
  From customers c
Where not exists (
    Select 1
    From orders o
    Where c.customer_id = o.customer_id
)

--Listar os Produtos que não tenham sido comprados
Select p.product_id,
       p.product_name,
       p.brand_id,
       br.brand_name,
       p.category_id,
       cat.category_name, 
       p.model_year,
       p.list_price
  From products p 
  Inner Join brands br on p.brand_id = br.brand_id
  Inner join categories cat on p.category_id = cat.category_id
  Where not exists 
  (Select 1 
   From order_itens oi 
   Where p.product_id = oi.product_id)

--Listar os Produtos sem Estoque
Select p.product_id,
       p.product_name,
       p.brand_id,
       br.brand_name,
       p.category_id, 
       cat.category_name, 
       p.model_year,
       p.list_price
  From products p
  Inner Join brands br on p.brand_id = br.brand_id
  Inner join categories cat on p.category_id = cat.category_id
  Where not exists (
    Select 1
    From stocks s
    Where p.product_id = s.product_id)

-- Agrupar a quantidade de vendas que uma determinada Marca por Loja.
Select so.store_name, 
       b.brand_name,
       count(distinct order_id)
From orders o 
Inner join stores so on o.store_id = so.store_id
Inner join order_items oi on o.order_id = oi.order_id
Inner join products p on p.product_id = oi.product_id
Inner Join brands b on b.brand_id = p.brand_id
Where b.brand_name = 'Brand 1'
Group by so.store_name, b.brand_name

-- Listar os Funcionarios que não estejam relacionados a um Pedido.
Select s.staff_id,
       s.first_name,
       s.last_name
From staffs s
Left join orders o on s.staff_id = o.staff_id
Where o.order_id is null