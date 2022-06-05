create table #t
(
   ID int identity(1,1)
  ,ListOfNums varchar(50)
)
insert #t
values ('279,37,972,15,175')
      ,('17,72')
      ,('672,52,19,23')
      ,('153,798,266,52,29')
      ,('77,349,14')
select * from #t


select ID
      ,ListOfNums,
	  convert(int,substring(ListOfNums+',,,,',charindex(',',ListOfNums+',,,,',
		  charindex(',',ListOfNums+',,,,',charindex(',',ListOfNums+',,,,')+1)+1)+1,
		  (charindex(',',ListOfNums+',,,,',charindex(',',ListOfNums+',,,,',
		  charindex(',',ListOfNums+',,,,',charindex(',',ListOfNums+',,,,')+1)+1)+1)-
		  charindex(',',ListOfNums+',,,,',charindex(',',ListOfNums+',,,,',
		  charindex(',',ListOfNums+',,,,')+1)+1))-1))
from #t
where convert(int,substring(ListOfNums+',,,,',charindex(',',ListOfNums+',,,,',
		  charindex(',',ListOfNums+',,,,',charindex(',',ListOfNums+',,,,')+1)+1)+1,
		  (charindex(',',ListOfNums+',,,,',charindex(',',ListOfNums+',,,,',
		  charindex(',',ListOfNums+',,,,',charindex(',',ListOfNums+',,,,')+1)+1)+1)-
		  charindex(',',ListOfNums+',,,,',charindex(',',ListOfNums+',,,,',
		  charindex(',',ListOfNums+',,,,')+1)+1))-1)) < 50
order by convert(int,substring(ListOfNums+',,,,',charindex(',',ListOfNums+',,,,',
         charindex(',',ListOfNums+',,,,')+1)+1,(charindex(',',ListOfNums+',,,,',
         charindex(',',ListOfNums+',,,,',charindex(',',ListOfNums+',,,,')+1)+1)-
         charindex(',',ListOfNums+',,,,',charindex(',',ListOfNums+',,,,')+1))-1))


select ID,
	Num4,
	ListOfNums
from #t
cross apply (select WorkString=ListOfNums+',,,,') F_Str
cross apply (select p1=charindex(',',WorkString)) F_P1
cross apply (select p2=charindex(',',WorkString,p1+1)) F_P2
cross apply (select p3=charindex(',',WorkString,p2+1)) F_P3
cross apply (select p4=charindex(',',WorkString,p3+1)) F_P4      
cross apply (select Num3=convert(int,substring(WorkString,p2+1,p3-p2-1))
                   ,Num4=convert(int,substring(WorkString,p3+1,p4-p3-1))) F_Nums
where Num4<50
order by Num3