USE [This40]
GO
/****** Object:  StoredProcedure [dbo].[usp_cjl_zy_mzrz]    Script Date: 2019-08-19 10:43:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[usp_cjl_zy_mzrz]
  (@rq ut_rq8 )
AS
select b.lrrq,a.cardno,a.hzxm,a.sex,e.name,c.ypmc from SF_BRXXK a,VW_MZCFK b, VW_MZCFMXK c, YY_KSBMK d, YY_ZGBMK e
where b.lrrq >= @rq and b.lrrq < @rq+'24' and b.ksdm ='107'
and  b.jlzt=0 and b.jsbz=1
and a.patid=b.patid
and b.xh = c.cfxh
and b.ksdm = d.id
and b.ysdm = e.id
order by b.lrrq,a.cardno,a.hzxm,e.name
