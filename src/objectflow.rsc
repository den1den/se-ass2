module objectflow
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import lang::java::flow::JavaToObjectFlow;
import analysis::flow::ObjectFlow;
import IO;

value m3Test(){ 
	m = createM3FromEclipseProject(|project://eLib|);
	p = createOFG(|project://eLib|);
	
	ms = methods(m);
	//dcls = p.decals;
	
	return ms;
}