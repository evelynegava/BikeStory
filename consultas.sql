--Listar todos os clientes que não tenham realizado uma compra
Select *
From customers c
Where not exists (
    Select 1
    From orders o
    Where c.customer_id = o.customer_id
)

--Listar os Produtos que não tenham sido comprados
Select * 
  From products p 
  Where not exists 
  (Select 1 
   From order_itens oi 
   Where p.product_id = oi.product_id)

--Listar os Produtos sem Estoque
Select *
  From products p
 Where not exists (
    Select 1
    From stocks s
    Where p.product_id = s.product_id)