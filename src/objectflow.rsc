module objectflow
import lang::java::jdt::m3::Core; // Used to recognize M3 datatype
import lang::java::jdt::m3::AST;
import analysis::flow::ObjectFlow; // Used to recognize the FlowProgram datatype
import lang::java::flow::JavaToObjectFlow;
import IO;
import String;

void fixLhsDiamonds() {
	// Add a diamond operator to all LHS object creations of a typed class.
	// In this project we only look at the
	clss = {|java+constructor:///java/util/HashMap/HashMap()|, |java+constructor:///java/util/LinkedList/LinkedList()|}; //http://tutor.rascal-mpl.org/Rascal/Expressions/Values/Location/FieldSelection/FieldSelection.html#/Rascal/Expressions/Values/Location/Location.html
	
	m = createM3();
	decls = m@declarations; //http://tutor.rascal-mpl.org/Rascal/Libraries/analysis/m3/Core/uses/uses.html#/Rascal/Libraries/analysis/m3/Core/Core.html
	//http://tutor.rascal-mpl.org/Rascal/Rascal.html#/Rascal/Libraries/analysis/m3/m3.html
	
	for( cls <- clss ) {
		cls_decls = {c | c <- m@uses,
			c[1]==cls
		};
		outs = {[c[0], "new <replaceLast(cls.file, "()", "")>\u003C\u003E()"] | c <- cls_decls};
		println("Missing diamond operator at:\n<outs>\n");
	}
}

void fixLists() {
	// Finds all usages of lists and checks what types are put in such a object
	clss = {|java+constructor:///java/util/LinkedList/LinkedList()|};
	
	m = createM3();
	usages = {u | u <- m@uses, u[1].scheme == "java+class" && u[1].path == "/java/util/LinkedList"}; // usages of a class
	
	f = createFP();
	atts = {a | attribute(a) <- f.decls};
}



value m3Test(){ 
	m = createM3();
	ms = methods(m);
	// Methods only contains all methods that are litterally typed out in code
	
	p = createFP();
	// Contans the logical model of all functions that are passed to the compiler
	
	implied = {dec | method(dec, params) <- p.decls}
		+ {dec | constructor(dec, params) <- p.decls}
		- methods(m); // implied == all functions - all typed out functions
	
	return implied;
}

FlowProgram createFP() {
	// Creates a FlowProgram from the eLib project
	// It contains '@': extends, implements, 
	return createOFG(|project://eLib|);
}

M3 createM3() {
	// Creates a M3 from the eLib project
	return createM3FromEclipseProject(|project://eLib|);
}
