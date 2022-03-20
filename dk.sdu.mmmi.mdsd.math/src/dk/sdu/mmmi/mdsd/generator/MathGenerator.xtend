/*
 * generated by Xtext 2.25.0
 */
package dk.sdu.mmmi.mdsd.generator

import java.util.HashMap
import java.util.Map
import javax.swing.JOptionPane
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import dk.sdu.mmmi.mdsd.math.Model
import dk.sdu.mmmi.mdsd.math.Expression
import dk.sdu.mmmi.mdsd.math.Addition
import dk.sdu.mmmi.mdsd.math.Subtraction
import dk.sdu.mmmi.mdsd.math.Multiplication
import dk.sdu.mmmi.mdsd.math.Division
import dk.sdu.mmmi.mdsd.math.Number
import dk.sdu.mmmi.mdsd.math.Reference

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class MathGenerator extends AbstractGenerator {

	static Map<String, Integer> variables = new HashMap();
	
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		val model = resource.allContents.filter(Model).next
		val result = model.compute
		
		// You can replace with hovering, see Bettini Chapter 8
		result.displayPanel
	}
	
	//
	// Compute function: computes value of expression
	// Note: written according to illegal left-recursive grammar, requires fix
	//
	
	def static compute(Model model) {
		for (variable : model.variables) {
			variables.put(variable.name, variable.expression.compute)
		}
		return variables
	}
	
	def static int compute(Expression expression) {
		switch expression {
			Addition: expression.left.compute+expression.right.compute
			Subtraction: expression.left.compute-expression.right.compute
			Multiplication: expression.left.compute*expression.right.compute
			Division: expression.left.compute/expression.right.compute
			Number: expression.value
			Reference: variables.get(expression.reference.name)
			default: throw new Error("Invalid expression")
		}
	}

	def void displayPanel(Map<String, Integer> result) {
		var resultString = ""
		for (entry : result.entrySet()) {
         	resultString += "var " + entry.getKey() + " = " + entry.getValue() + "\n"
        }
		
		JOptionPane.showMessageDialog(null, resultString ,"Math Language", JOptionPane.INFORMATION_MESSAGE)
	}

}
