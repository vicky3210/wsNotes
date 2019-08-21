USE [This40]
GO
/*********************************************************/
/**  Object:  StoredProcedure [dbo].[usp_wssq_zygzltj]  **/
/*********************************************************/

-- history
-- Script Date: 2019-08-21

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[usp_wssq_zygzltj]
  @ksrq ut_rq8,
  @jsrq ut_rq8
AS
BEGIN
  declare  @zrc float ,
           @zyrc float,
           @qtrc float,
           @zcfs float,  -- 总处方数   
           @zcycfs float, -- 中药饮片处方数
           @zccycfs float,
           @fyrc float,  -- 中医非药物治疗人次数
           @fyrc2 float,
           @zykzcycfs float
-- 中医治疗项目统计
select id into #temp  from  YY_SFXXMK  where SUBSTRING(id,1,1)='4' -- and sybz ='1'

select @fyrc = sum(b.ypsl)
from VW_MZCFK a, VW_MZCFMXK b, VW_MZBRJSK c, YY_SFXXMK d
where a.xh = b.cfxh
and a.jssjh = c.sjh
and c.sfrq >=@ksrq and c.sfrq < @jsrq+'24'
and c.ybjszt = 2
and c.jlzt = 0
and b.ypdm = d.id
and b.dxmdm not in ('01','02','03')
and b.ypdm in ( select id from  #temp )

select @fyrc2 = count(distinct ghsjh)
from VW_MZCFK a, VW_MZCFMXK b, VW_MZBRJSK c, YY_SFXXMK d
where a.xh = b.cfxh
and a.jssjh = c.sjh
and c.sfrq >=@ksrq and c.sfrq < @jsrq+'24'
and c.ybjszt = 2
and c.jlzt = 0
and b.ypdm = d.id
and b.dxmdm not in ('01','02','03')
and b.ypdm in ( select id from  #temp )

--  处方数统计
select xh,ysdm,yfdm,lrrq,jlzt,cflx,ksdm    into #MZCFK   from VW_MZCFK a (nolock)
where a.lrrq between @ksrq and @jsrq+'24'
and a.jlzt in (0,1,2)
 and a.jsbz=1
 and a.cflx in (1,2,3)

select xh,cfxh,cd_idm,dxmdm
into #MZCFMXK
from VW_MZCFMXK b (nolock) where cfxh in (select xh from #MZCFK)

-- select  cfxh,dxmdm,count(*) sl  into #cftemp   from #MZCFMXK group by  cfxh,dxmdm order by cfxh,dxmdm
-- select cfxh,count(*) lx into #cftemp2 from #cftemp group by cfxh   having count(*)>1

update #MZCFK set cflx=9 from #MZCFK where cflx<>'2' and xh in (
select cfxh from #MZCFMXK where dxmdm ='02')


select @zrc=sum(case when jlzt in (0,1,9) then 1 else -1 end)   from VW_GHZDK where ghrq between @ksrq   and @jsrq+'24' and  jlzt in(0,1,9)   and ghlb<>'1'
select @zyrc=sum(case when jlzt in (0,1,9) then 1 else -1 end)   from VW_GHZDK where ghrq between @ksrq   and @jsrq+'24'  and  jlzt in(0,1,9)   and ksdm in('107','702','802','118')  and ghlb<>'1'
select  @qtrc = SUm(Case when jlzt in (0,1) and cflx in (2,3,9) then 1 when jlzt in (2) and cflx in (2) then -1 else 0 end)  from #MZCFK   where ksdm not in('107','702','802','118')
select  @zcfs= Sum(Case when jlzt in (0,1)  then 1 when jlzt in(2) then -1 else 0 end ) from #MZCFK
select @zcycfs= SUm(Case when jlzt in (0,1) and cflx in (3) then 1 when jlzt in (2) and cflx in (3) then -1 else 0 end)  from #MZCFK
--select  @zccycfs = SUm(Case when jlzt in (0,1) and cflx in (2,9) then 1 when jlzt in (2) and cflx in (2) then -1 else 0 end)   from #MZCFK
select  @zccycfs = convert(numeric(10,0),1.2*SUm(Case when jlzt in (0,1) and cflx in (2,9) then 1  else 0 end))   from #MZCFK
select  @zykzcycfs = SUm(Case when jlzt in (0,1) and cflx in (2,9) then 1 when jlzt in (2) and cflx in (2) then -1 else 0 end)   from #MZCFK where ksdm in('107','702','802','118')

 select  '总挂号人次' 指标,cast(@zrc as varchar) 统计数值
 union all
 select  '中医挂号人次' ,cast(@zyrc as varchar)
 union all
 select  '其他科中医诊疗人次',cast(@zccycfs- @zykzcycfs as varchar)   --@qtrc
 union all
 select '中医诊疗人次占比(>30%)' ,cast( cast((@zyrc+@zccycfs- @zykzcycfs)*100/@zrc as decimal(18,2) )  as varchar)+'%'
 union all
 select  '总处方数', cast(@zcfs  as varchar)
 union all
 select  '中药饮片处方数',cast(@zcycfs as varchar)
 union all
 select  '中成药处方数（含混）',cast(@zccycfs as varchar)
-- union all
-- select '中医科中成药处方数（含混）',@zykzcycfs
 union all
 select  '中医处方占比(>30%)',cast( cast((@zcycfs+@zccycfs)*100/@zcfs as decimal(18,2)) as varchar)+ '%'
 union all
 select  '中药饮片处方占比(>5%)', cast(cast(@zcycfs*100/@zcfs as decimal(18,2)) as varchar) + '%'
  union all
 select '中医非药物治疗人次数',cast(@fyrc as varchar)
union all
select '中医非药物治疗占比(>10%)',CONVERT(varchar(9), cast(((@fyrc / (@zrc + @fyrc - @fyrc2))*100) as decimal(18,2))  ) + '%'
END
