USE [This40]
GO
/****** Object:  StoredProcedure [dbo].[usp_cjl_zyzdtj]    Script Date: 2019-08-19 10:45:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER PROCEDURE [dbo].[usp_cjl_zyzdtj]
		(@begin ut_rq8,
		 @end    ut_rq8)

AS
BEGIN


select distinct(b.zddm) '诊断代码',zdmc '诊断名称',count(*) '次数'
from VW_GHZDK a,VW_SF_YS_MZBLZDK b, YY_ZGBMK c
where a.xh = b.ghxh
and a.ghrq between @begin and @end+'24'
and b.ysdm = c.id
and c.ks_id in ('107','301','304','305','306','309')
and b.zddm <>''
group by zddm,zdmc
order by count(*) desc

select @begin,@end

END
