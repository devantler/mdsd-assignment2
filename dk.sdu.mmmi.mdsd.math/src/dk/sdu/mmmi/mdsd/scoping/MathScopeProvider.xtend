/*
 * generated by Xtext 2.25.0
 */
package dk.sdu.mmmi.mdsd.scoping

import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.EcoreUtil2
import org.eclipse.xtext.scoping.Scopes
import dk.sdu.mmmi.mdsd.math.Model
import dk.sdu.mmmi.mdsd.math.GlobalVariable
import dk.sdu.mmmi.mdsd.math.LocalVariable
import dk.sdu.mmmi.mdsd.math.MathPackage.Literals
import dk.sdu.mmmi.mdsd.math.Variable

class MathScopeProvider extends AbstractMathScopeProvider {
	
	override IScope getScope(EObject context, EReference reference) {
		switch(reference){
			case Literals.VARIABLE_REFERENCE__VARIABLE:{
				return getVariableReferenceScope(context)
			}
		}
		return super.getScope(context, reference);
	}
	
	def getVariableReferenceScope(EObject context){
		val model = EcoreUtil2.getRootContainer(context) as Model;
		val globalVariable = EcoreUtil2.getContainerOfType(context, GlobalVariable);
		val globalVariables = model.variables.filter[it.name !== globalVariable.name].toList;
		
		var variable = EcoreUtil2.getContainerOfType(context, Variable);
		var localVariables = EcoreUtil2.getAllContainers(variable).filter[it instanceof LocalVariable].map[it as Variable].toList
		localVariables.add(variable);
		
		val variableScope = globalVariables
		variableScope.addAll(localVariables)
		variableScope.add(variable)

    	return Scopes.scopeFor(globalVariables);
	}
}
