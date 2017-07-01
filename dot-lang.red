Red [
    Title: {`grapviz` dot languaga}
	Needs: View
]
graph-ctx: context [
	out: 	no
	output: clear ""
	blk: clear []
	n: 1
	open-curly: [insert (#"{") (n: n + 1)]
	close-curly: [
		insert (rejoin [#"^/" pad/left/with copy "}" n #"^-"])
		(n: n - 1) 
	]
	indent: [insert (rejoin [#"^/" pad/with clear "" n #"^-"])]
	graph_:		[
		opt ['strict insert (space)]
		['graph | 'digraph] insert (space)
		opt [ID insert (space)] 
		insert "{"
		stmt_list
		insert "^/}"
	]
	stmt_list:	[into [any stmt]]
	stmt:		[
		indent;insert (rejoin [#"^/" pad/with clear "" n #"^-"])
		[
			attr_stmt 
		| 	subgraph
		| 	edge_stmt
		| 	ahead a_list1 [ID '= ID]
		| 	node_stmt
		] 
	]
	attr_stmt:	[['graph | 'node | 'edge] attr_list]
	attr_list1:	[into [some a_list1]]
	attr_list:	[some [ahead attr_list1 into [insert #"[" a_list insert #"]"]]]
	a_list1:	[ID1 '= ID1]
	a_list:		[some [ID '= ID]]
	edge-stmt1:	[[node_id1 | subgraph1] edgeRHS1]; opt attr_list]
	edge_stmt:	[ahead edge-stmt1 [node_id | subgraph] edgeRHS opt attr_list]
	edgeRHS1:	[edgeop [node_id1 | subgraph1]]
	edgeRHS:	[some [edgeop [node_id | subgraph]]];[edgeop [node_id | subgraph] opt edgeRHS]
	edgeop:		['-> | '--]
	node_stmt:	[[node_id] opt attr_list]
	node_id1:	[ID1 opt port1]
	node_id:	[ID opt port]
	port1:		[":" ID1 opt [":" compass_pt] | ":" compass_pt]
	port:		[":" ID	opt [":" compass_pt] | ":" compass_pt]
	subgraph1:	[['subgraph opt ID1 | 'sg] block!]
	subgraph:	[
		['subgraph opt ID | remove 'sg] 
		open-curly
		stmt_list 
		close-curly
	]
	compass_pt:	['n | 'ne | 'e | 'se | 's | 'sw | 'w | 'nw | 'c | '_]
	ID-char:	charset compose [#"a" - #"z" #"A" - #"Z" #"_" (to-char #{0200}) - (to-char #{0377})]
	digit:		charset [#"0" - #"9"]
	numeral: 	[opt #"-" [#"." some digit | some digit opt [#"." any digit]]]
	ID1: 		[lit-word! | number! | string! | ahead block! into [tag! | url! | string!]]
	ID:			[
		ahead lit-word! set id_ skip if (
			_id: to-string id_ parse _id [ID-char any [ID-char | digit]]
		) 
		| 	number! 
		| 	change copy _ string! (rejoin [#"^"" _ #"^""])
		| 	ahead block! into [tag! | url! | change copy _ string! (rejoin [#"^"" _ #"^""])]
	]
	
	set 'graph func [dot-block /check /out outfile /local gr correct?][
		output: clear ""
		gr: none
		n: 1
		blk: dot-block
		fname: either out [outfile][%out]
		set [gv png] reduce [
			to-file compose [(fname) ".gv"] 
			to-file compose [(fname) ".png"]
		]
		out: either check [no][yes]
		correct?: parse dot-block graph_
		append output dot-block
		write gv output
		either check [
			print correct?
			print read gv
		][
			result: call/error/wait rejoin [
				{dot -Tpng } to-string gv " -o" to-string png
			] %out.err
			either -1 = result [print read %out.err] [load png]
		]
	]
]
