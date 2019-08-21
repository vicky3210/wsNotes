USE [This40]
GO
/****** Object:  StoredProcedure [dbo].[usp_cjl_zyzlqktj2]    Script Date: 2019-08-19 10:47:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[usp_cjl_zyzlqktj2]    -----中医药治疗情况统计 （去除中成药人次 中医科人次+中医治疗人次）  usp_cjl_zyzlqktj1_ls '20140910','20140911'
  (@ksrq ut_rq8, @jsrq ut_rq8)
AS
BEGIN

-- declare @zrc int, @zyrc int , @qkrc int



select * into #brjsk from VW_MZBRJSK where sfrq between @ksrq and @jsrq +'24' and ybjszt=2 and jlzt=0



select  c.sfksdm,b.ypmc,b.ylsj,sum(b.ypsl) sl,sum(b.ylsj*b.ypsl) je,3 bz
into #temp
from VW_MZCFK a, VW_MZCFMXK b, #brjsk c, YY_SFXXMK d
where a.xh = b.cfxh
and a.jssjh = c.sjh

and b.ypdm = d.id
and d.zxks_id in (107,306,301,304,309,305)
group by b.ypdm,b.ypmc,b.ylsj,c.sfksdm
order by sum(b.ypsl) desc

--
--
-- select
-- @zrc = count(jssjh)
-- from VW_GHZDK
-- where ghrq >= @ksrq and ghrq < @jsrq+'24'
-- and jlzt = 0
--
-- select
-- @qkrc = count(jssjh)
-- from VW_GHZDK
-- where ghrq >= @ksrq and ghrq < @jsrq+'24'
-- and ksdm='117'
-- and jlzt = 0
--
-- select
-- @zyrc = count(jssjh)
-- from VW_GHZDK
-- where ghrq >= @ksrq and ghrq < @jsrq+'24'
-- and ksdm in (107,306,301,304,309,305)
-- and jlzt = 0

-- insert into #temp
-- select "中医诊查费" "项目",7 "单价",@zyrc "人次",@zyrc*7 "费用",1


insert into #temp
select c.sfksdm,d.name,0,count(distinct(b.cfxh)),
sum((b.ylsj*b.dwxs/b.ykxs)*(b.ypsl/b.dwxs)*b.ts*b.cfts),2
from VW_MZCFK a, VW_MZCFMXK b, #brjsk c, YY_SFDXMK d
where a.xh = b.cfxh
and a.jssjh = c.sjh

and b.dxmdm in ('03')--,'02')
and b.dxmdm = d.id
group by c.sfksdm,d.name
-- select @zyrc=sum(sl) from #temp
-- insert into #temp
-- select 'zz',"合计",0,sum(sl),sum(je),4
-- from #temp


update #temp set sfksdm='115' where sfksdm='113' --全科通4修改挂号通4收费
update #temp set sfksdm='106' where sfksdm='117' --全科医疗修改总院挂号收费
update #temp set sfksdm='106' where sfksdm not in('106','115','705','805') --其余科室全更新总院挂号收费


select  b.name,ypmc "项目",ylsj "单价",sum(sl) "人次",sum(je) "费用"
from #temp a,YY_KSBMK b
where a.sfksdm=b.id
group by b.name,ypmc,ylsj
order by b.name

-- select @ksrq, @jsrq
-- select  @zrc zrc, @zyrc zyrc, @qkrc qkrc,@zrc-@zyrc-@qkrc qtrc

drop table #temp

END
