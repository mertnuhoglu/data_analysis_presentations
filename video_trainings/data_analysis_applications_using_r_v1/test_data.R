library("pryr")
library("gtools")
library("lubridate")
library("data.table")
library("pipeR")
library("plyr")
library("dplyr")
library("tidyr")
library("magrittr")
library("rlist")
library("XML")
library("reshape2")
source('utils.R')

grapefruit_telecom_campaign_offers = function() {
	dn = read_data_naming()
	data = generate_data %>%
		Map(dn$base_name, dn$seq_end) %>%
		setNames(dn$variable)
	
	# test data
	set.seed(1)
	n_cs = length(data$customer)
	n_cm = length(data$customer)
}

ballorange_conversion_optimization = function() {
	dn = read_data_naming()
	data = generate_data %>%
		Map(dn$base_name, dn$seq_end) %>%
		setNames(dn$variable)
	
	# test data
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

	# calculate conversion number for just a single keyword
	keyword = 'kw003'
	setkey(kv, keyword)
	visits = kv[keyword]$visit
	setkey(kp, keyword)
	page = kp[keyword]$page
	setkey(pc, page)
	conversion_rate = pc[page]$conversion
	conversions = visits * conversion_rate

	# calculate conversion numbers for all keywords
	r = kp %>%
		inner_join(pc, by="page") %>%
		inner_join(kv, by="keyword") %>%
		mutate( conversion_number = visit * conversion ) %>%
		group_by(keyword) %>%
		summarise(total_conversion = sum(conversion_number)) %>%
		select(keyword, total_conversion) %>%
		arrange(total_conversion) 
	
	r = r %>%
		arrange(desc(total_conversion))
	top_keywords = r$keyword[1:3]

	top_kp = kp %>%
		filter(keyword %in% top_keywords)
	# or filter using datatable subsetting (equivalent)
	setkey(kp, keyword)
	top_kp = kp[top_keywords]

	top_pages = top_kp$page %>%
		unique 
}

study_test_data = function() {
	products = paste0('p', 1:3)
	categories = paste0('g', 1:3)
	companies = paste0('c', 1:4)
	salesmen = paste0('s', 1:3)

	# parameterized
	product_base = 'p'
	product_seq = 1:3
	products = paste0(product_base, product_seq)

	# make it function
	generate_data = function(base_name, end) {
		1:end %>%
			sprintm("%03s") %>%
			pre0(base_name)
	}

	# try for different variable types
	# how to externalize base and seq definitions
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
}

study_sample_fun = function() {
	# init
	s = auction_data %>% sample_datatable(5)

	dn = read_data_naming()
	data = generate_data %>%
		Map(dn$base_name, dn$seq_end) %>%
		setNames(dn$variable)

	# example1
	auction_data = data.table(
		Price = 1:100 %>% sample_with_replace)

	# 1
	kw = data.table(
		product = data$product %>% sample_with_replace,
		company = data$company %>% sample_with_replace)

	# b: datatable sampling
	sample_datatable(kw, 3)
}

study_dataframe_apply = function() {
	# init
	df = read_data_naming()

	# 1: Map
	data = generate_data %>%
		Map(df$base_name, df$seq_end) %>%
		setNames(df$variable)

	# 2: lapply equivalent to Map
	dl = split(df, rownames(df))
	data2 = dl %>% 
		lapply(function(x) generate_data(x$base_name, x$seq_end)) %>%
		setNames(df$variable)
}

study_dataframe_convert_list = function() {
	# init
	df = read_data_naming()

	# 1: split rows into list elements. elements are dataframe
	dl = split(df, rownames(df))

	# 2: transpose and as.list. elements are vectors
	dl2 = as.list(as.data.frame(t(df)))

	dl2 = df %>%
		t %>%
		as.data.frame %>%
		as.list

	# 3: unlist. elements are vectors
	dl3 = unlist(apply(df, 1, list), recursive = F)

	dl3 = df %>%
		apply(1, list) %>%
		unlist(recursive = F)
}
