module objectflow
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::flow::JavaToObjectFlow;
import analysis::flow::ObjectFlow;
import IO;
alias OFG = rel[loc from, loc to];

value m3Test(){ 
	m = createM3FromEclipseProject(|project://eLib|);
	p = createOFG(|project://eLib|);
	
	ms = methods(m);
	//dcls = p.decals;
	
	return ms;
}

value createFP() {
	// Creates a FlowProgram
	return createOFG(|project://eLib|);
}