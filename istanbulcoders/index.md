---
title       : Data Analysis Applications using R
subtitle    : IstanbulCoders
author      : Mert Nuhoglu
job         : 
framework   : deckjs        # {io2012, html5slides, shower, dzslides, ...}
deckjs:
  theme: web-2.0
  extensions: [goto, hash, menu, navigation, scale, status, automatic]
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : solarized_light # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---



## Introduction

- Learning a language based on examples
	- Foreign language
	- Mind extracts the grammer rules by itself
		- Foreign language learning theory of Stephen Krashen:
			[http://www.sk.com.br/sk-krash-english.html](http://www.sk.com.br/sk-krash-english.html)
	  - Learning is more fun: balance between challenging - difficulty

--- .class #id 

## What is data science?

- Interdisciplinary field
  - Programming
  - Statistics
  - Domain expertise - analysis

--- .class #id 

## What is data science?

![Venn Diagram for Data Science](assets/img/Venn-Diagram-of-Data-Scientist-Skills.png)

--- .class #id 

## Ecommerce: Conversion rate optimization

- Ecommerce site: BallOrange.com 
- Conversion: Collecting the email addresses of visitors of the blog
- For all blog posts
	- Traffic varies
	- Conversion ratio varies
- The value of blog posts:
	- Traffic x conversion ratio
- Example:
	- Page A:
		- 1000 visitors x %5 conversion = 50 emails
	- Page B:
		- 500 visitors x %15 conversion = 75 emails

--- .class #id 

## Conversion rate optimization 2

- Data collected from Google Analytics:

	- Keyword - Visit: The number of visits per search keyword 
	- Keyword - Page: To which blog page does a search keyword send the visitors
	- Page - Conversion Rate: Ratio of visitors that leave their email addresses in each page

--- .class #id 

## Test Data Generation

`ballorange_conversion_optimization()` in test_data.R




```r
	 data
```

```
## $product
##  [1] "p001" "p002" "p003" "p004" "p005" "p006" "p007" "p008" "p009" "p010"
## 
## $company
##  [1] "c001" "c002" "c003" "c004" "c005" "c006" "c007" "c008" "c009" "c010"
## [11] "c011" "c012" "c013" "c014" "c015" "c016" "c017" "c018" "c019" "c020"
## [21] "c021" "c022" "c023" "c024" "c025" "c026" "c027" "c028" "c029" "c030"
## 
## $category
## [1] "g001" "g002" "g003"
## 
## $salesman
## [1] "s001" "s002" "s003" "s004" "s005" "s006"
## 
## $region
## [1] "r001" "r002" "r003" "r004"
## 
## $keyword
##  [1] "kw001" "kw002" "kw003" "kw004" "kw005" "kw006" "kw007" "kw008"
##  [9] "kw009" "kw010" "kw011" "kw012" "kw013" "kw014" "kw015"
## 
## $page
##  [1] "pg001" "pg002" "pg003" "pg004" "pg005" "pg006" "pg007" "pg008"
##  [9] "pg009" "pg010" "pg011" "pg012" "pg013" "pg014" "pg015" "pg016"
## [17] "pg017" "pg018" "pg019" "pg020" "pg021" "pg022" "pg023" "pg024"
## [25] "pg025" "pg026" "pg027" "pg028" "pg029" "pg030" "pg031" "pg032"
## [33] "pg033" "pg034" "pg035" "pg036" "pg037" "pg038" "pg039" "pg040"
## [41] "pg041" "pg042" "pg043" "pg044" "pg045" "pg046" "pg047" "pg048"
## [49] "pg049" "pg050"
## 
## $customer
##  [1] "c001" "c002" "c003" "c004" "c005" "c006" "c007" "c008" "c009" "c010"
## [11] "c011" "c012" "c013" "c014" "c015" "c016" "c017" "c018" "c019" "c020"
## 
## $location
##  [1] "loc001" "loc002" "loc003" "loc004" "loc005" "loc006" "loc007"
##  [8] "loc008" "loc009" "loc010"
## 
## $campaign
## [1] "campaign001" "campaign002" "campaign003" "campaign004" "campaign005"
## [6] "campaign006"
```

--- .class #id 

## Data model

- keyword-page: kp
- page-conversion: pc
- keyword-visit: kv

--- .class #id 

## Generate test data


```r
	set.seed(1)
	n_kw = length(data$keyword)
	n_pg = length(data$page)
	kv = data.table(
		keyword = data$keyword %>% sample,
		visit = (runif(n_kw) * 100) %>% ceiling)
	kp = data.table(
		keyword = kv$keyword %>% sample_with_replace(n_pg),
		page = data$page %>% sample(n_pg))
	pc = data.table(
		page = kp$page %>% sample(n_pg),
		conversion = (runif(n_pg) * 0.05) %>% sample(n_pg) %>% round(3))
```

--- .class #id 

## Generate test data 2


```r
head(kv)
```

```
##    keyword visit
## 1:   kw004    50
## 2:   kw006    72
## 3:   kw008   100
## 4:   kw011    39
## 5:   kw003    78
## 6:   kw009    94
```

```r
head(kp)
```

```
##    keyword  page
## 1:   kw014 pg022
## 2:   kw005 pg035
## 3:   kw014 pg020
## 4:   kw008 pg016
## 5:   kw012 pg049
## 6:   kw002 pg010
```

--- .class #id 

## Generate test data 3


```r
head(pc)
```

```
##     page conversion
## 1: pg021      0.042
## 2: pg016      0.038
## 3: pg035      0.043
## 4: pg030      0.036
## 5: pg024      0.002
## 6: pg004      0.005
```

```r
pc %>% head
```

```
##     page conversion
## 1: pg021      0.042
## 2: pg016      0.038
## 3: pg035      0.043
## 4: pg030      0.036
## 5: pg024      0.002
## 6: pg004      0.005
```

--- .class #id 

## How to generate such test data easily?


```r
dn = read_data_naming()
dn
```

```
##     variable base_name seq_end
##  1:  product         p      10
##  2:  company         c      30
##  3: category         g       3
##  4: salesman         s       6
##  5:   region         r       4
##  6:  keyword        kw      15
##  7:     page        pg      50
##  8: customer         c      20
##  9: location       loc      10
## 10: campaign  campaign       6
```

--- .class #id 

## How to generate such test data easily? 


```r
generate_data("page", 10)
```

```
##  [1] "page001" "page002" "page003" "page004" "page005" "page006" "page007"
##  [8] "page008" "page009" "page010"
```
 

```r
Map( generate_data, "page", 10)
```

```
## $page
##  [1] "page001" "page002" "page003" "page004" "page005" "page006" "page007"
##  [8] "page008" "page009" "page010"
```

--- .class #id 

## How to generate such test data easily? 


```r
Map( generate_data, c("page", "keyword"), 10)
```

```
## $page
##  [1] "page001" "page002" "page003" "page004" "page005" "page006" "page007"
##  [8] "page008" "page009" "page010"
## 
## $keyword
##  [1] "keyword001" "keyword002" "keyword003" "keyword004" "keyword005"
##  [6] "keyword006" "keyword007" "keyword008" "keyword009" "keyword010"
```

--- .class #id 

## How to generate such test data easily? 


```r
Map( generate_data, c("page", "keyword"), c(10, 20))
```

```
## $page
##  [1] "page001" "page002" "page003" "page004" "page005" "page006" "page007"
##  [8] "page008" "page009" "page010"
## 
## $keyword
##  [1] "keyword001" "keyword002" "keyword003" "keyword004" "keyword005"
##  [6] "keyword006" "keyword007" "keyword008" "keyword009" "keyword010"
## [11] "keyword011" "keyword012" "keyword013" "keyword014" "keyword015"
## [16] "keyword016" "keyword017" "keyword018" "keyword019" "keyword020"
```

--- .class #id 

## How to generate such test data easily? 


```r
generate_data %>% 
   Map( c("page", "keyword"), c(10, 20) )
```

```
## $page
##  [1] "page001" "page002" "page003" "page004" "page005" "page006" "page007"
##  [8] "page008" "page009" "page010"
## 
## $keyword
##  [1] "keyword001" "keyword002" "keyword003" "keyword004" "keyword005"
##  [6] "keyword006" "keyword007" "keyword008" "keyword009" "keyword010"
## [11] "keyword011" "keyword012" "keyword013" "keyword014" "keyword015"
## [16] "keyword016" "keyword017" "keyword018" "keyword019" "keyword020"
```

--- .class #id 

## How to generate such test data easily? 


```r
dn$base_name
```

```
##  [1] "p"        "c"        "g"        "s"        "r"        "kw"      
##  [7] "pg"       "c"        "loc"      "campaign"
```

```r
dn$seq_end
```

```
##  [1] 10 30  3  6  4 15 50 20 10  6
```

--- .class #id 

## How to generate such test data easily? 


```r
generate_data %>%
		Map(dn$base_name, dn$seq_end)
```

```
## $p
##  [1] "p001" "p002" "p003" "p004" "p005" "p006" "p007" "p008" "p009" "p010"
## 
## $c
##  [1] "c001" "c002" "c003" "c004" "c005" "c006" "c007" "c008" "c009" "c010"
## [11] "c011" "c012" "c013" "c014" "c015" "c016" "c017" "c018" "c019" "c020"
## [21] "c021" "c022" "c023" "c024" "c025" "c026" "c027" "c028" "c029" "c030"
## 
## $g
## [1] "g001" "g002" "g003"
## 
## $s
## [1] "s001" "s002" "s003" "s004" "s005" "s006"
## 
## $r
## [1] "r001" "r002" "r003" "r004"
## 
## $kw
##  [1] "kw001" "kw002" "kw003" "kw004" "kw005" "kw006" "kw007" "kw008"
##  [9] "kw009" "kw010" "kw011" "kw012" "kw013" "kw014" "kw015"
## 
## $pg
##  [1] "pg001" "pg002" "pg003" "pg004" "pg005" "pg006" "pg007" "pg008"
##  [9] "pg009" "pg010" "pg011" "pg012" "pg013" "pg014" "pg015" "pg016"
## [17] "pg017" "pg018" "pg019" "pg020" "pg021" "pg022" "pg023" "pg024"
## [25] "pg025" "pg026" "pg027" "pg028" "pg029" "pg030" "pg031" "pg032"
## [33] "pg033" "pg034" "pg035" "pg036" "pg037" "pg038" "pg039" "pg040"
## [41] "pg041" "pg042" "pg043" "pg044" "pg045" "pg046" "pg047" "pg048"
## [49] "pg049" "pg050"
## 
## $c
##  [1] "c001" "c002" "c003" "c004" "c005" "c006" "c007" "c008" "c009" "c010"
## [11] "c011" "c012" "c013" "c014" "c015" "c016" "c017" "c018" "c019" "c020"
## 
## $loc
##  [1] "loc001" "loc002" "loc003" "loc004" "loc005" "loc006" "loc007"
##  [8] "loc008" "loc009" "loc010"
## 
## $campaign
## [1] "campaign001" "campaign002" "campaign003" "campaign004" "campaign005"
## [6] "campaign006"
```

--- .class #id 

## How to generate such test data easily? 


```r
data = generate_data %>%
		Map(dn$base_name, dn$seq_end) %>%
		setNames(dn$variable)
data
```

```
## $product
##  [1] "p001" "p002" "p003" "p004" "p005" "p006" "p007" "p008" "p009" "p010"
## 
## $company
##  [1] "c001" "c002" "c003" "c004" "c005" "c006" "c007" "c008" "c009" "c010"
## [11] "c011" "c012" "c013" "c014" "c015" "c016" "c017" "c018" "c019" "c020"
## [21] "c021" "c022" "c023" "c024" "c025" "c026" "c027" "c028" "c029" "c030"
## 
## $category
## [1] "g001" "g002" "g003"
## 
## $salesman
## [1] "s001" "s002" "s003" "s004" "s005" "s006"
## 
## $region
## [1] "r001" "r002" "r003" "r004"
## 
## $keyword
##  [1] "kw001" "kw002" "kw003" "kw004" "kw005" "kw006" "kw007" "kw008"
##  [9] "kw009" "kw010" "kw011" "kw012" "kw013" "kw014" "kw015"
## 
## $page
##  [1] "pg001" "pg002" "pg003" "pg004" "pg005" "pg006" "pg007" "pg008"
##  [9] "pg009" "pg010" "pg011" "pg012" "pg013" "pg014" "pg015" "pg016"
## [17] "pg017" "pg018" "pg019" "pg020" "pg021" "pg022" "pg023" "pg024"
## [25] "pg025" "pg026" "pg027" "pg028" "pg029" "pg030" "pg031" "pg032"
## [33] "pg033" "pg034" "pg035" "pg036" "pg037" "pg038" "pg039" "pg040"
## [41] "pg041" "pg042" "pg043" "pg044" "pg045" "pg046" "pg047" "pg048"
## [49] "pg049" "pg050"
## 
## $customer
##  [1] "c001" "c002" "c003" "c004" "c005" "c006" "c007" "c008" "c009" "c010"
## [11] "c011" "c012" "c013" "c014" "c015" "c016" "c017" "c018" "c019" "c020"
## 
## $location
##  [1] "loc001" "loc002" "loc003" "loc004" "loc005" "loc006" "loc007"
##  [8] "loc008" "loc009" "loc010"
## 
## $campaign
## [1] "campaign001" "campaign002" "campaign003" "campaign004" "campaign005"
## [6] "campaign006"
```

--- .class #id 

## How to generate such test data easily? 


```r
data %>% str
```

```
## List of 10
##  $ product : chr [1:10] "p001" "p002" "p003" "p004" ...
##  $ company : chr [1:30] "c001" "c002" "c003" "c004" ...
##  $ category: chr [1:3] "g001" "g002" "g003"
##  $ salesman: chr [1:6] "s001" "s002" "s003" "s004" ...
##  $ region  : chr [1:4] "r001" "r002" "r003" "r004"
##  $ keyword : chr [1:15] "kw001" "kw002" "kw003" "kw004" ...
##  $ page    : chr [1:50] "pg001" "pg002" "pg003" "pg004" ...
##  $ customer: chr [1:20] "c001" "c002" "c003" "c004" ...
##  $ location: chr [1:10] "loc001" "loc002" "loc003" "loc004" ...
##  $ campaign: chr [1:6] "campaign001" "campaign002" "campaign003" "campaign004" ...
```

--- .class #id 

## Test datatable


```r
	n_kw = length(data$keyword)
	kp = data.table(
		keyword = kv$keyword %>% sample,
		page = data$page %>% sample(n_kw))
kp
```

```
##     keyword  page
##  1:   kw004 pg035
##  2:   kw014 pg005
##  3:   kw013 pg006
##  4:   kw003 pg003
##  5:   kw007 pg043
##  6:   kw006 pg031
##  7:   kw008 pg049
##  8:   kw001 pg022
##  9:   kw002 pg020
## 10:   kw015 pg016
## 11:   kw009 pg040
## 12:   kw010 pg007
## 13:   kw005 pg045
## 14:   kw011 pg047
## 15:   kw012 pg015
```

--- .class #id 

## sample function


```r
set.seed(1)
sample(1:10, 3)
```

```
## [1] 3 4 5
```

```r
set.seed(1)
1:10 %>% sample(3)
```

```
## [1] 3 4 5
```


```r
sample(c("ali", "veli", "can", "cem"), 3)
```

```
## [1] "cem"  "ali"  "veli"
```

--- .class #id 

## Test datatable 


```r
	kv = data.table(
		keyword = data$keyword %>% sample,
		visit = (runif(n_kw) * 100) %>% ceiling)
kv
```

```
##     keyword visit
##  1:   kw015    22
##  2:   kw010    66
##  3:   kw009    13
##  4:   kw001    27
##  5:   kw003    39
##  6:   kw002     2
##  7:   kw007    39
##  8:   kw004    87
##  9:   kw006    35
## 10:   kw011    49
## 11:   kw008    60
## 12:   kw005    50
## 13:   kw014    19
## 14:   kw013    83
## 15:   kw012    67
```

--- .class #id 

## Random number generation


```r
runif(10)
```

```
##  [1] 0.7942399 0.1079436 0.7237109 0.4112744 0.8209463 0.6470602 0.7829328
##  [8] 0.5530363 0.5297196 0.7893562
```
 

```r
runif(10) * 100
```

```
##  [1]  2.333120 47.723007 73.231374 69.273156 47.761962 86.120948 43.809711
##  [8] 24.479728  7.067905  9.946616
```

--- .class #id 

## Generating test data - complete


```r
	dn = read_data_naming()
	data = generate_data %>%
		Map(dn$base_name, dn$seq_end) %>%
		setNames(dn$variable)
	
	set.seed(1)
	n_kw = length(data$keyword)
	kv = data.table(
		keyword = data$keyword %>% sample,
		visit = (runif(n_kw) * 100) %>% ceiling)
	kp = data.table(
		keyword = kv$keyword %>% sample,
		page = data$page %>% sample(n_kw))
	pc = data.table(
		page = kp$page %>% sample,
		conversion = (runif(n_kw) * 0.05) %>% sample(n_kw) %>% round(3))
```

--- .class #id 

## Sorun 

- Find 5 keywords that let us collect the most email addresses

--- .class #id 

## What is the conversion ratio for some keyword?

- How many visitors for keyword "kw003"?


```r
	keyword = 'kw003'
	setkey(kv, keyword)
	kv3 = kv[keyword]
  kv3
```

```
##    keyword visit
## 1:   kw003    78
```

- Let's just get the visitors amount


```r
setkey(kv, keyword)
visits = kv[keyword]$visit
visits
```

```
## [1] 78
```

--- .class #id 

## How much traffic does this keyword bring to which page?


```r
  setkey(kv, keyword)
	setkey(kp, keyword)
	kp3 = kv[keyword]
  kp3
```

```
##    keyword visit
## 1:   kw003    78
```

```r
	page = kp[keyword]$page
  page
```

```
## [1] "pg004"
```

--- .class #id 

## How much is the conversion ration of that page?


```r
setkey(pc, page)
pc3 = pc[page]
pc3
```

```
##     page conversion
## 1: pg004      0.036
```

```r
conversion_rate = pc3$conversion
conversion_rate
```

```
## [1] 0.036
```

--- .class #id 

## What is the amount of total conversions (number of collected emails)?


```r
setkey(kv, keyword)
visits = kv[keyword]$visit
conversions = visits * conversion_rate
conversions
```

```
## [1] 2.808
```

--- .class #id 

## How to generalize this calculation for all keywords and pages?

1. Approach: Imperative approach
- Let's do the above calculation for each keyword
   - for loop of keywords
     - get the pages of that keyword
   - inner loop for pages
		 - get the conversion ration of the page
		 - multiply conversion ratios with visitors amounts
		 - sum up the conversion amounts for all the pages belonging to the same keyword

--- .class #id 

## Generalization of the calculation 2

2. Approach: Declarative approach
	 - Describe what to do instead of how to do it
	 - Sets and relationships
	 - SQL style
- SQL table = a mapping between n variables/sets
	- keyword-page: kp
	- page-conversion: pc
	- keyword-visit: kv

--- .class #id 

## Join operation

- Join the mappings/tables that have common variables/sets
- Example: 
   - keyword-page
   - keyword-visit
- Result:
   - keyword-page-visit

--- .class #id 

## Symbolic thinking

- Ignore how we are going to join
- Focus into what we will do
- Let's join the tables keyword-page and page-conversion
  - keyword-page-conversion
- Add page-visit table to that
  - keyword-page-conversion-visit

--- .class #id 

## Symbolic thinking

- conversion_number = conversion x visit
  - keyword-page-conversion-visit-conversion_number
- remove unnecessary variables:
  - keyword-conversion_number
- there are n rows for each keyword
	- group the rows that have the same keyword (pivoting/grouping)
	- sum conversion_number in each group: total_conversion
- order all the rows by total_conversion
- get the top 5

--- .class #id 

## Let's code this procedure


```r
	r = kp %>%
		inner_join(pc, by="page") %>%
		inner_join(kv, by="keyword") %>%
		mutate( conversion_number = visit * conversion ) %>%
		group_by(keyword) %>%
		summarise(total_conversion = sum(conversion_number)) %>%
		select(keyword, total_conversion) %>%
		arrange(total_conversion) 
r %>% head
```

```
##   keyword total_conversion
## 1   kw013            0.038
## 2   kw007            0.245
## 3   kw004            0.300
## 4   kw010            0.440
## 5   kw005            0.468
## 6   kw012            0.624
```

--- .class #id 

## Reverse the ordering


```r
	r = r %>%
		arrange(desc(total_conversion))
r %>% head
```

```
##   keyword total_conversion
## 1   kw015            4.176
## 2   kw003            2.808
## 3   kw006            2.808
## 4   kw002            1.677
## 5   kw011            1.482
## 6   kw014            1.452
```

--- .class #id 

## What pages are the targets of the best keywords?

- Get the best 3 keywords (filtering)
- What are the pages these keywords provide traffic?


```r
top_keywords = r$keyword[1:3]
top_kp = kp %>%
  filter(keyword %in% top_keywords)
top_kp %>% head
```

```
##    keyword  page
## 1:   kw003 pg004
## 2:   kw006 pg025
## 3:   kw015 pg015
```

```r
top_pages = top_kp$page
top_pages
```

```
## [1] "pg004" "pg025" "pg015"
```

--- .class #id 

## Functional programming in these codes?

- Functional sequence
  - Functional:
    - input: function
    - output: data (vector)
- Higher order functions
  - input: function
  - output: function
- There is no for loop 

--- .class #id 

## Links

- [Data Science Istanbul](https://www.facebook.com/groups/465842350233183/)
- [RStudio Webinars](http://www.rstudio.com/resources/webinars/)
- [Functional Programming Design Patterns](http://fsharpforfunandprofit.com/fppatterns/)
- [Brian Beckman: Don't fear the Monad](https://www.youtube.com/watch?v=ZhuHCtR3xq8)
- [The Lambda Calculus for Absolute Dummies (like myself)](http://palmstroem.blogspot.com.tr/2012/05/lambda-calculus-for-absolute-dummies.html)

--- .class #id 

## Presentation and codes

- Html5 slides: [http://mertnuhoglu.github.io/data_analysis_istanbulcoders/istanbulcoders/index.html](http://mertnuhoglu.github.io/data_analysis_istanbulcoders/istanbulcoders/index.html)
- Source codes: [https://github.com/mertnuhoglu/data_analysis_istanbulcoders/istanbulcoders](https://github.com/mertnuhoglu/data_analysis_istanbulcoders/istanbulcoders)
- Tools (PowerPoint killers): 
	- [slidify](http://ramnathv.github.io/slidify/)
  - [knitr](http://yihui.name/knitr/)
  - [RMarkdown](http://rmarkdown.rstudio.com/)


