--Listar todos os clientes que não tenham realizado uma compra
Select *
From customers c
Where not exists (
    Select 1
    From orders o
    Where c.customer_id = o.customer_id
)