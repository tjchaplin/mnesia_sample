-module(sample_repository_tests).

-include_lib("eunit/include/eunit.hrl").

when_installing_mnesia_repository_should_install_test() ->
	Result = sample_repository:install(),
	?assert(Result == ok).

when_starting_mnesia_repository_should_start_test() ->
	Result = sample_repository:start(),
	?assert(Result == ok).

when_adding_data_should_add_data_test() ->
	Result = sample_repository:add_data({1,<<"Some Detail">>}),
	?assert(Result == ok).

when_inserting_and_getting_all_data_should_get_data_test() ->
	ExpectedData = {1,<<"Some Detail">>},
	sample_repository:add_data(ExpectedData),
	Result = sample_repository:get_data(),
	?assert(Result == [ExpectedData]).	

when_inserting_and_getting_by_id_should_get_data_test() ->
	ExpectedData = {1,<<"Some Detail">>},
	sample_repository:add_data(ExpectedData),
	Result = sample_repository:get_id(1),
	?assert(Result == [ExpectedData]).	