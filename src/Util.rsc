module Util
// This module only contains some utility functions

import lang::java::jdt::m3::Core;
import Set;
import List;
import String;

// This function removes the last part of the path of a location
// It only works on locations with scheme "java+class"
loc getParentJavaClassLocation(loc child){
	if(child.scheme != "java+class") throw "getParentJavaClassLocation can only be called with locations that have the java+class scheme";
	i = findLast(child.path, "/");
	parent = |java+class:///| + substring(child.path, 0, i);
	return parent;
}

// This function finds the lowest common superclass of a set of classes, using the m3@extends relation
// It is simplified to return:
// - a single class when only one class is provided
// - a single common direct parent shared by all provided classes
// - |java+class:///Object| otherwise
// note: so it will not be correct with an input {LinkedList, List} for example.
loc findSuperClass(set[loc] classes, M3 m){
	if(size(classes) > 1){
		parents = [prnt | cls <- {getParentJavaClassLocation(pclass) | pclass <- classes}, <cls, prnt> <- m@extends ];
		if(size(toSet(parents)) == 1){
			// Special case: only one common class
			return parents[0] + "this";
		}
		// TODO: Not able to detect the following cases:
		// LinkedList + Collection = Collection
		// LinkedList + ArrayList = List
		return |java+class:///Object|;
	}
	return getOneFrom(classes);
}

// Translates a java class location a valid Java identifier
value toJava(loc l){
	if(l.scheme != "java+class") throw "toJava can only be called with locations that have the java+class scheme";
	id = replaceAll(substring(l.path, 1), "/", ".");
	if(endsWith(id, ".this")){
		return substring(id, 0, size(id) - 5);
	}
	return id;
}