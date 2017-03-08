module Flow
// this module contains all code related to flow programs and flow graphs

import analysis::flow::ObjectFlow;
import lang::java::flow::JavaToObjectFlow;
import List;
import Relation;
import lang::java::m3::Core;
import IO;
import vis::Figure; 
import vis::Render;
alias OFG = rel[loc from, loc to];

// Builds a FlowGraph from a flow program, as defined in chapter 2 of the book and as provided in https://gist.github.com/jurgenvinju/8972255
// It also filters out edges generated from return values of void methods
OFG buildGraph(FlowProgram p) 
  = { <as[i], fps[i]> | newAssign(x, cl, c, as) <- p.statements, constructor(c, fps) <- p.decls, i <- index(as) }
  + { <cl + "this", x> | newAssign(x, cl, _, _) <- p.statements }
  + { <s, t> | assign(t, _, s) <- p.statements }
  + { <m + "return", t> | call(t, _, _, m, _) <- p.statements, t != |id:///| }
  + { <as[i], fps[i]> | call(_, _, _, m, as) <- p.statements, method(m, fps) <- p.decls, i <- index(as) }
  + { <r, m + "this"> | call(_, _, r, m, _) <- p.statements }
  ;

// Provided in https://gist.github.com/jurgenvinju/8972255
OFG prop(OFG g, rel[loc,loc] gen, rel[loc,loc] kill, bool back) {
  OFG IN = { };
  OFG OUT = gen + (IN - kill);
  gi = g<to,from>;
  set[loc] pred(loc n) = gi[n];
  set[loc] succ(loc n) = g[n];
  
  solve (IN, OUT) {
    IN = { <n,\o> | n <- carrier(g), p <- (back ? pred(n) : succ(n)), \o <- OUT[p] };
    OUT = gen + (IN - kill);
  }
  
  return OUT;
}

// Provided in https://gist.github.com/jurgenvinju/8972255
public void drawDiagram(M3 m) {
  classFigures = [box(text("<cl.path[1..]>"), id("<cl>")) | cl <- classes(m)]; 
  edges = [edge("<to>", "<from>") | <from,to> <- m@extends ];
  render(scrollable(graph(classFigures, edges, hint("layered"), std(gap(10)), std(font("Bitstream Vera Sans")), std(fontSize(20)))));
}

// Debugging function to graphically show the flow diagram as a graph
public void drawDiagram(OFG g) {
  classFigures =	{box(text("<a.path[1..]>"), id("<a>")) | <a, b> <- g} 
  				  + {box(text("<a.path[1..]>"), id("<a>")) | <b, a> <- g};
  classFigures = [c | c <- classFigures];
  edges = [edge("<from>", "<to>", toArrow(triangle(5))) | <from,to> <- g ];  
  
  render(scrollable(graph(classFigures, edges, hint("layered"), std(gap(10)), std(font("Bitstream Vera Sans")), std(fontSize(20)))));
}

// Provided in https://gist.github.com/jurgenvinju/8972255
public str dotDiagram(M3 m) {
  return "digraph classes {
         '  fontname = \"Bitstream Vera Sans\"
         '  fontsize = 8
         '  node [ fontname = \"Bitstream Vera Sans\" fontsize = 8 shape = \"record\" ]
         '  edge [ fontname = \"Bitstream Vera Sans\" fontsize = 8 ]
         '
         '  <for (cl <- classes(m)) { /* a for loop in a string template, just like PHP */>
         ' \"N<cl>\" [label=\"{<cl.path[1..] /* a Rascal expression between < > brackets is spliced into the string */>||}\"]
         '  <} /* this is the end of the for loop */>
         '
         '  <for (<from, to> <- m@extends) {>
         '  \"N<to>\" -\> \"N<from>\" [arrowhead=\"empty\"]<}>
         '}";
}

// Provided in https://gist.github.com/jurgenvinju/8972255
public void showDot(M3 m) = showDot(m, |home:///<m.id.authority>.dot|);

// Provided in https://gist.github.com/jurgenvinju/8972255
public void showDot(M3 m, loc out) {
  writeFile(out, dotDiagram(m));
}
