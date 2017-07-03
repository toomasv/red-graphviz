Red [
	Title: {`grapviz` dot language}
	Started: "2017-06-01"
	Needs: View
]
graph-ctx: context [
	out: 	no
	output: clear ""
	blk: clear []
	num: 1
	open-curly: [insert (#"{") (num: num + 1)]
	close-curly: [
		insert (rejoin [#"^/" pad/left/with copy "}" num #"^-"])
		(num: num - 1) 
	]
	indent: [insert (rejoin [#"^/" pad/with clear "" num #"^-"])]
	graph_:		[
		opt ['strict insert (space)]
		['graph | 'digraph] insert (space)
		opt [ahead ID1 ID insert (space)] 
		insert "{"
		stmt_list
		insert "^/}"
	]
	stmt_list:	[into [any stmt]]
	stmt:		[
		indent
		[
			attr_stmt 
		| 	edge_stmt
		| 	subgraph
		| 	attr ahead ID1 insert #"=" ID
		| 	node_stmt
		] 
	]
	attr_stmt:	[
		'graph insert #"[" into [some [g-attr insert #"=" ID]] insert #"]"
	| 	'node  insert #"[" into [some [n-attr insert #"=" ID]] insert #"]"
	| 	'edge  insert #"[" into [some [e-attr insert #"=" ID]] insert #"]"
	]
	edge_stmt:	[
		ahead edge-stmt1 [subgraph | ID] edgeRHS 
		opt [ahead block! insert #"[" into [some [e-attr insert #"=" ID]] insert #"]"]
	]
	edge-stmt1:	[[ID1 any get-word! | subgraph1] edgeRHS1]
	edgeRHS1:	[edgeop [subgraph1 | ID1 ]]
	edgeRHS:	[some [edgeop [subgraph | ID]]]
	edgeop:		['-> | '--]
	node_stmt:	[ahead ID1 ID opt [ahead block! insert #"[" into [some [n-attr insert #"=" ID]] insert #"]"]]
	subgraph1:	[opt ['subgraph opt ID1] block!]
	subgraph:	[
		['subgraph opt ID | ahead block!];remove 'sg] 
		open-curly
		stmt_list 
		close-curly
	]
	;compass_pt:	['n | 'ne | 'e | 'se | 's | 'sw | 'w | 'nw | 'c | '_]
	ID-char:	charset compose [#"a" - #"z" #"A" - #"Z" #"_" (to-char #{0200}) - (to-char #{0377})]
	digit:		charset [#"0" - #"9"]
	numeral: 	[opt #"-" [#"." some digit | some digit opt [#"." any digit]]]
	ID1: 		[ID2 any get-word! | url!]
	ID2:		[lit-word! | number! | string! | tag!]
	ID3: [
		set _ lit-word! if (
			parse to-string _ [ID-char any [ID-char | digit]]
		) 
		| 	number! 
		| 	change set _ string! (rejoin [#"^"" _ #"^""])  
		| 	tag!
	]
	ID:	[
		ahead [ID2 some get-word!]
		change [copy _id ID3 copy _comp some get-word!]
			(
				either string? _id [print _id][_id: to-string _id]
				forall _comp [append _id rejoin [#":" first _comp]]
			)
		|	ahead ID2 ID3
		| 	url!
	]
	;;; Attributes ;;;
	C:	[ 'pencolor]
	E:	[ 'arrowhead 
		| 'arrowsize 
		| 'arrowtail 
		| 'constraint 
		| 'decorate 
		| 'dir 
		| 'edgehref 
		| 'edgetarget 
		| 'edgetooltip 
		| 'edgeURL 
		| 'head_lp 
		| 'headclip 
		| 'headhref 
		| 'headlabel 
		| 'headport 
		| 'headtarget 
		| 'headtooltip 
		| 'headURL 
		| 'labelangle 
		| 'labeldistance 
		| 'labelfloat 
		| 'labelfontcolor 
		| 'labelfontname 
		| 'labelfontsize 
		| 'labelhref 
		| 'labeltarget 
		| 'labeltooltip 
		| 'labelURL 
		| 'len 
		| 'lhead 
		| 'ltail 
		| 'minlen 
		| 'samehead 
		| 'sametail 
		| 'tail_lp 
		| 'tailclip 
		| 'tailhref 
		| 'taillabel 
		| 'tailport 
		| 'tailtarget 
		| 'tailtooltip 
		| 'tailURL 
		| 'weight]
	G:	[ '_background 
		| 'bb 
		| 'center 
		| 'charset 
		| 'clusterrank 
		| 'compound 
		| 'concentrate 
		| 'Damping 
		| 'defaultdist 
		| 'dim 
		| 'dimen 
		| 'diredgeconstraints 
		| 'dpi 
		| 'epsilon 
		| 'esep 
		| 'fontnames 
		| 'fontpath 
		| 'forcelabels 
		| 'imagepath 
		| 'inputscale 
		| 'label_scheme 
		| 'landscape 
		| 'layerlistsep 
		| 'layers 
		| 'layerselect 
		| 'layersep 
		| 'layout 
		| 'levels 
		| 'levelsgap 
		| 'maxiter 
		| 'mclimit 
		| 'mindist 
		| 'mode 
		| 'model 
		| 'mosek 
		| 'newrank 
		| 'nodesep 
		| 'normalize 
		| 'notranslate 
		| 'nslimit
		| 'nslimit1 
		| 'orientation 
		| 'outputorder 
		| 'overlap 
		| 'overlap_scaling 
		| 'overlap_shrink 
		| 'pack 
		| 'packmode 
		| 'pad 
		| 'page 
		| 'pagedir 
		| 'quadtree 
		| 'quantum 
		| 'rankdir 
		| 'ranksep 
		| 'ratio 
		| 'remincross 
		| 'repulsiveforce 
		| 'resolution 
		| 'rotate 
		| 'rotation 
		| 'scale 
		| 'searchsize 
		| 'sep 
		| 'size 
		| 'smoothing 
		| 'splines 
		| 'start 
		| 'stylesheet 
		| 'truecolor 
		| 'viewport 
		| 'voro_margin 
		| 'xdotversion]
	S:	[ 'rank] 
	N:	[ 'distortion 
		| 'fixedsize 
		| 'group 
		| 'height 
		| 'image 
		| 'imagepos 
		| 'imagescale 
		| 'orientation 
		| 'pin 
		| 'rects 
		| 'regular 
		| 'samplepoints 
		| 'shape 
		| 'shapefile 
		| 'sides 
		| 'skew 
		| 'vertices 
		| 'width 
		| 'z]
	EN:	[ 'pos 
		| 'xlabel;]NE:	[
		| 'xlp]
	GC:	[ 'bgcolor 
		| 'K 
		| 'labeljust 
		| 'lheight 
		| 'lwidth]
	GN:	[ 'ordering 
		| 'root]
	NC:	[ 'area 
		| 'peripheries]
	EGC:	[ 'lp]
	ENC:	[ 'color 
		| 'layer;]NEC:	[
		| 'fillcolor 
		| 'tooltip;]CNE:	[
		| 'penwidth]
	ENG:	[ 'comment 
		| 'showboxes]
	GCN:	[ 'sortv;]NCG:	[
		| 'gradientangle 
		| 'margin;]NGC:	[
		| 'labelloc]
	ENCG:	[ 'colorscheme 
		| 'style;]ENGC:	[
		| 'fontcolor 
		| 'fontname 
		| 'fontsize 
		| 'label 
		| 'target 
		| 'URL;]GCNE:	[ 
		| 'href 
		| 'id 
		| 'nojustify]
	g-attr:	[G | GC | GN | EGC | ENG | GCN | ENCG]
	n-attr: [N | EN | GN | NC | ENC | ENG | GCN | ENCG]
	e-attr: [E | EN | EGC | ENC | ENG | ENCG]
	c-attr: [C | GC | NC | EGC | ENC | GCN | ENCG]
	attr: 	[G | N | E | C | S | GC | GN | EN | NC | EGC | ENG | GCN | ENC | ENCG]

	set 'graph func [dot-block /out outfile /local gr correct? fname gv png][
		gr: none
		num: 1
		fname: either out [outfile][%out]
		set [gv png] reduce [
			to-file compose [(fname) ".gv"] 
			to-file compose [(fname) ".png"]
		]
		correct?: parse dot-block graph_
		write gv append clear "" dot-block
		either correct? [
			result: call/error/wait rejoin [
				{dot -Tpng } to-string gv " -o" to-string png
			] %out.err
			either 1 = result [
				probe read gv
				probe read %out.err
			][load png]
		][	
			print correct?
			also none print read gv
		]
	]
]
