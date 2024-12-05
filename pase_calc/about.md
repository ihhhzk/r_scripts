# Physical Activity Scale for the Elderly (PASE)

## 参考信息

- [PASE-handl](https://meetinstrumentenzorg.nl/wp-content/uploads/instrumenten/PASE-handl.pdf)
- [stRoke docs](https://agdamsbo.github.io/stRoke/reference/pase_calc.html)
- [github stRoke pase_calc](https://github.com/agdamsbo/stRoke/blob/main/R/pase_calc.R)

> **_NOTE:_**  针对问题7-9，需要使用`1. Ja`和`2. Nej`的格式（Ja和Nej是丹麦语），否则无法计算分数，stRoke中的代码计算逻辑如下：

```
  pase_score_79 <-
    data.frame(t(t(
      sapply(Reduce(cbind,pase_list[7:9]),function(j){
        grepl("[Jj]a",j)
      }) + 0 # short hand logic to numeric
    ) * pase_multip_79))
```
