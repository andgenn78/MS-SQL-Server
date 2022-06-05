select * 
from Sales.Orders
where PickedByPersonID in
(4, 3, null)
order by PickedByPersonID

select * 
from Sales.Orders
where PickedByPersonID in
(4, 3) or PickedByPersonID  is null
order by PickedByPersonID


