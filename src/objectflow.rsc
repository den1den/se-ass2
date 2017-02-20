module objectflow
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import analysis::flow::ObjectFlow; // Used to recognize the FlowProgram datatype
import lang::java::flow::JavaToObjectFlow;
import IO;

value m3Test(){ 
	m = createM3();
	ms = methods(m);
	
	p = createFP();
	
	return p;
}

FlowProgram createFP() {
	// Creates a FlowProgram from the eLib project
	return createOFG(|project://eLib|);
}

M3 createM3() {
	// Creates a M3 from the eLib project
	return createM3FromEclipseProject(|project://eLib|);
}
