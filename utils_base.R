library(plyr); library(dplyr)
library(gtools)
library(lubridate)
library(data.table)
library(rjson)

sample_with_replace = function(v, n = 100) sample(v, size = n, replace = T)
sample_datatable = function(dt, n = 100) dt[ sample(nrow(dt), size = n) ]

# function parameters modified st. data arg is always the first arg
partialm = function(fun, x) partial(x, fun)
grepm = function(x, pattern, ...) {
	grep(pattern, x, ...)
}
grepv = partial(grepm, value = T)
grepl = function(x, pattern, ...) {
	base::grepl(pattern, x, ...)
}
vgrep = function(x, patterns, ...) {
	x %>% 
		grepm( patterns %>% paste(collapse="|"), ...) %>%
		unique
}
vgrepv = partial(vgrep, value = T)
subm = function(x, pattern, replacement, ...) {
	sub(pattern, replacement, x, ...)
}
gsubm = function(x, pattern, replacement, ...) {
	gsub(pattern, replacement, x, ...)
}

pre0 = function(x, y) paste0(y, x)
"%+%" = function(...) paste0(...,sep="")

count_isna = function(x) { sum(is.na(x)) }
count_unique = function(x) { length(unique(x)) }
cu = count_unique
ci = count_isna

get_us_states = function() {
	states = c("AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "X1", "UT", "VT", "VA", "WA", "WV", "WI", "WY")
}

is.blank <- function(x, false.triggers=FALSE){
    if(is.function(x)) return(FALSE) # Some of the tests below trigger
                                     # warnings when used on functions
    return(
        is.null(x) ||                # Actually this line is unnecessary since
        length(x) == 0 ||            # length(NULL) = 0, but I like to be clear
        all(is.na(x)) ||
        all(x=="") ||
        (false.triggers && all(!x))
    )
}

# Compare vectors while taking NA as value
# http://www.cookbook-r.com/Manipulating_data/Comparing_vectors_or_factors_with_NA/
compareNA <- function(v1,v2) {
    # This function returns TRUE wherever elements are the same, including NA's,
    # and false everywhere else.
    same <- (v1 == v2)  |  (is.na(v1) & is.na(v2))
    same[is.na(same)] <- FALSE
    return(same)
}

is.true  <- function(v) {
	! is.na(v) & v == T
}

# sanitize empty vectors of character() after parsing data
san = function(char) {
	if(length(char)==0) '' else char
}

basename_noext = function(filenames) basename( rtrim_char(".", filenames) )
ltrim_char = function(ch, x) sub( paste0("^.*\\",ch),"",x)
rtrim_char = function(ch, x) sub( paste0("\\",ch,"[^",ch,"]+$"),"",x)
trim.beforecolon = function(x) sub("^.*:\\s+","",x)
trim <- function (x) gsub("^\\s+|\\s+$", "", x)
trimQuotes <- function (x) gsub("^'(.*)'$", "\\1", x)

months.before = function(m) {
	d = m*30
	Sys.Date() - days(d)
}

re = function(regex, x) {
	m = regexpr(regex,x,perl=T)
	regmatches(url,m)
}

log = function( ... ) {
	print( paste0( ... ) )
}

config_filenames = function() { fread('config/filenames.csv', header=T, stringsAsFactors=F) }
config_colclasses = function() { fromJSON(file='config/colclasses.json') }

get_directory = function(name_in, test = F) {
	test_in = test
	filename= config_filenames()[name==name_in & test==test_in]$filename
}                

get_filename2 = function(name_in, from = '', ext = '', test = F) {
	get_filename_from = function(filename, from, ext){
		filename = paste0( filename, from, '.csv' )
		sub( '\\.csv', paste0( ext, '\\.csv' ), filename)
	}
	test_in = test
	filename= config_filenames()[name==name_in & test==test_in]$filename
	get_filename_from(filename, from, ext)
}

get_filename = function(name, from = '', ext = '', test = F) {
	file.name = get.meta.exchange( from )[[name]]
	file.name = sub( '\\.csv', paste0( ext, '\\.csv' ), file.name)
}

.read.dt = function(file.name, cols = NA, ...) {
	if (is.blank(cols)) {
		cols = NA
	}
	dt = data.table( read.csv(file.name, header=T, stringsAsFactors=F, colClasses=cols, ...) )
}
.read.fread = function(file.name, cols = NULL, ...) {
	dt = fread(file.name, colClasses = cols, ...)
}
# todo: deal with edge cases that need use_read_csv
.read.file = function(file.name, var_name, use_read_csv = F, ...){
	colclasses = config_colclasses()
	cols = NULL
	if (var_name %in% names(colclasses)) {
		cols = colclasses[[var_name]]
	}
	if (use_read_csv ) {
		.read.dt(file.name, cols, ...)
	} else {
		.read.fread(file.name, cols, ...)
	}
}
read.file = function(var_name, from = '' , ext = '', test = F, use_read_csv = F, ...) {
	file.name = get_filename2(var_name, from, ext, test)
	.read.file(file.name, var_name, use_read_csv, ...)
}
read_file_with_path = function(file.name, var_name, from = '' , ext = '', test = F, use_read_csv = F, ...) {
	.read.file(file.name, var_name, use_read_csv, ...)
}

.write.file = function( df, file.name, use_table = F, ...) {
	dir.create( dirname(file.name), recursive = T )
	if (use_table) {
		write.table(df, file.name, sep=",", ...)
	} else {
		write.csv(df, file.name, append=F, row.names=F, ...)
	} 
}           

write.file = function( df, var_name, from = '', test = F, use_table = F, ...) {
	file.name = get_filename2(var_name, from, test = test)
	.write.file(df, file.name, use_table, ...)
}
write_file_with_path = function( df, file.name, from = '', test = F, use_table = F, ...) {
	.write.file(df, file.name, use_table, ...)
}

.read_data = function(data) {
	fun_name = paste0('read_', data, '()')
	fun = as.expression(parse(text=fun_name))
	df = eval(fun)
}

.write_data = function(data, df) {
	fun_name = paste0('write_', data, '(df)')
	fun = as.expression(parse(text=fun_name))
	eval(fun)
}

log.progress = function( current.step, total.steps ) {
	is.multiple = function( current.step, step.size ) {
		remainder = current.step %% step.size
		remainder == 0 
	}
	decide.step.no = function( total.steps ) {
		if ( total.steps > 5000000 ) return( 50000 )
		if ( total.steps > 1000000 ) return( 10000 )
		if ( total.steps > 100000 ) return( 500 )
		if ( total.steps > 10000 ) return( 100 )
		return( 50 )
	}
	step.no = decide.step.no( total.steps )
	step.size = ceiling(total.steps/step.no)
	if ( is.multiple( current.step, step.size ) ) {
		print( paste0( format(Sys.time(), "%H:%M:%S"), " total.steps: ", total.steps, " current.step: ", current.step ))
	}
}

profile.fun = function(from = '', trial = '', write.csv = F, fun, ...) {
	extension = paste0( from, trial )
	fun_name = as.character( substitute(fun) )
	fun_name = gsub("\\.",'_',fun_name,perl=T)
	file_profiler_base = paste0( 'profiler/profiler_', fun_name )
	file_profiler = paste0( file_profiler_base, extension )
	csv_profiler = paste0(file_profiler, '.csv')
	Rprof(NULL)

	Rprof(file_profiler)

	result = fun( ... )

	Rprof(NULL)
	profile = summaryRprof(file_profiler)
	total = profile$by.total
	if ( write.csv ) {
		write.table(total, csv_profiler, sep=',', quote=F)
	}
	return(total)
}

log.error = function() {
}

