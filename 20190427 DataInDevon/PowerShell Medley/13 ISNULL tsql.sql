declare @var varchar(12)
set @var = 'Valid value'
select ISNULL (@var, '@var is null') as [result]
go

declare @var varchar(12)
select ISNULL (@var, '@var is null') as [result]
go


-- why have you chosen varchar(12) ???
-- let's try with 10
declare @var varchar(10)
set @var = 'Valid value'
select ISNULL (@var, '@var is null') as [result]
go

declare @var varchar(10)
select ISNULL (@var, '@var is null') as [result]
go