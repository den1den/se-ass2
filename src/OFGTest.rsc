module OFGTest

import objectflow;
import analysis::flow::ObjectFlow;
import lang::java::flow::JavaToObjectFlow;
import FlowGraphsAndClassDiagrams;
import List;

void testOFG() {
	FlowProgram p;
	p = createOFG(|project://SimpleOFGTest/|);
	p = createOFG(|project://DebugOFGTest/|);
	OFG f = buildGraph(p);
	drawDiagram(f);
}
