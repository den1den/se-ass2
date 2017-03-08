module Main
// Here refractoring suggestions are calculated

import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import analysis::flow::ObjectFlow;
import lang::java::flow::JavaToObjectFlow;
import IO;
import String;
import Set;
import List;
import Flow;
import Util;

void main(){
	project = |project://eLib|;
	printFixRhsDiamonds(project);
	printFixCollections(project);
	fixMap(project);
}

// This function searches for missing diamond operators in the right hand side of a assignment.
// For example: List a = new List() <- List a = new List<>();
void printFixRhsDiamonds(project) {
	// The following constructors can be identified:
	clss = {|java+constructor:///java/util/HashMap/HashMap()|, |java+constructor:///java/util/LinkedList/LinkedList()|};
	
	m = createM3FromEclipseProject(project);
	for( cls <- clss ) {
		// find all usages of these constructors
		cls_decls = {c | c <- m@uses, c[1]==cls};
		for (c <- cls_decls){
			println("Missing right hand side diamond operator at:");
			println(" - Location: <c[0]>");
			println(" - Replace:  new <replaceLast(cls.file, "()", "")>()");
			println(" - By:       new <replaceLast(cls.file, "()", "")>\u003C\u003E()\n");
		}
	}
}

// This function searches for stronger classes for the Collection type parameters.
void printFixCollections(loc project) {
	f = createOFG(project);
	ofg = buildGraph(f);
	m = createM3FromEclipseProject(project);
	
	// Find all possible places where this could be applied
	atts = {a | attribute(a) <- f.decls}; // TOOD: this leaves out variables like the Iterator in Libary:95
	for( att <- atts ) {
		// For every attribute that has the Collection type
		col_types = { t | <x, t> <- m@types, x == att, t[0] == |java+interface:///java/util/Collection| };
		if(size(col_types) > 0) {
			// Find all the ancestors in the flow graph that have a class scheme
			gen = {<from, to> | <from, to> <- ofg, to == att};
			kill = {};
			source_classes = {from | <from, to> <- prop(ofg, gen, kill, false), from.scheme == "java+class"};
			
			if(size(source_classes) > 0) {
				// If these ancestors are found the Collection should contain a type parameters
				println("Missing type parameter at left hand side for Collection:");
				most_generic = findSuperClass(source_classes, m);
				println(" - Location: <att>");
				println(" - Replace:  Collection");
				println(" - By:       Collection\<<toJava(most_generic)>\>\n");
			}
		}
	}
}

// This method searches for missing types in the Map collection
void fixMap(loc project) {
	f = createOFG(project);
	ofg = buildGraph(f);
	m = createM3FromEclipseProject(project);
	
	// Find all usages of Maps
	atts = {a | attribute(a) <- f.decls}; // TOOD: this leaves out variables like the Iterator in Libary:95
	for( att <- atts ) {
		// For every attribute that has the Map type
		// We assume the Maps are all using Integer as keys
		map_types = { t | <x, t> <- m@types, x == att, t[0] == |java+interface:///java/util/Map|};
		if(size(map_types) > 0) {
			// Find all the ancestors in the flow graph that have a class scheme
			gen = {<from, to> | <from, to> <- ofg, to == att};
			kill = {};
			source_classes = {from | <from, to> <- prop(ofg, gen, kill, false), from.scheme == "java+class"};
			
			if(size(source_classes) > 0){
				// If these ancestors are found the Collection should contain a type parameters
				println("Missing type parameter at left hand side for Map:");
				most_generic = findSuperClass(source_classes, m);
				println(" - Location: <att>");
				println(" - Replace:  Map");
				println(" - By:       Map\<Integer, <toJava(most_generic)>\>\n");
			}
		}
	}
}
