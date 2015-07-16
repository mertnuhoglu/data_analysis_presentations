source('utils_base.R')

# own
sprintm = function(x, fmt, ...) sprintf(fmt, x, ...)
# filter blank values out
compact = partial(Filter, Negate(is.null))

# test
generate_data = function(base_name, end) {
	1:end %>%
		sprintm("%03s") %>%
		pre0(base_name)
}

read_data_naming = function( from = '', test = F ) { read.file('data_naming', from = from, test = test) }
write_data_naming = function( df, from = '', test = F ) { write.file(df, 'data_naming', from = from, test = test) }
