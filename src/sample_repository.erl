-module(sample_repository).

-export ([install/0,install/1,start/0,add_data/1,get_data/0,get_id/1]).

-include_lib("stdlib/include/qlc.hrl" ).

-record(data, {id, detail}).

install() ->
	install([node()]).

install(Nodes) ->
	mnesia:create_schema(Nodes),
	rpc:multicall(Nodes, application, start, [mnesia]),
	mnesia:start(),
	mnesia:create_table(data, [{attributes, record_info(fields, data)},
							   {disc_copies, Nodes},
							   {type, set}]),
	rpc:multicall(Nodes, application, stop, [mnesia]),
	ok.

start() ->
	mnesia:start(),
	mnesia:wait_for_tables([data], 20000),
	ok.

add_data({Id,Detail}) ->
	F = fun() ->
		mnesia:write(#data{id=Id,detail=Detail})
	end,
	mnesia:activity(transaction, F).

get_data() ->
	do(qlc:q([{X#data.id,X#data.detail} || X <- mnesia:table(data)])).

get_id(Id) ->
	do(qlc:q([{X#data.id,X#data.detail} || X <- mnesia:table(data),
												X#data.id==Id])).	

do(Query) ->
	F = fun() -> qlc:e(Query) end,
	{atomic, Value} = mnesia:transaction(F),
	Value.