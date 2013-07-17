/*                This file is part of the scheme package.
            Copyright (C) 1998-99 Stephane HILLION - hillion@essi.fr
                 http://www.essi.fr/~hillion/scheme-package
   scheme package is free software. You can redistribute it and/or modify it 
  under the terms of the GNU General Public License as published by the Free
  Software  Foundation;  either  version  2, or (at your option)  any  later 
  version. The  scheme package  is distributed in the hope that  it will  be
  useful, but  WITHOUT ANY WARRANTY;  without  even  the implied warranty of
  MERCHANTABILITY or  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
  Public License for  more  details.   You  should  have  received a copy of
  the GNU General Public  License  along  with the scheme package;   see the
  file COPYING.  If not,  write to the Free  Software  Foundation,  Inc., 59
  Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/
package scheme.kernel;

import java.util.*;

/**
 * This class represents scheme language kernels.
 * No symbol is defined in the environment.
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/09
 */
public class ScmKernel {
  /** The environment */
  private ScmStack environments;
  
  /**
   * Creates a new kernel with an empty environment
   */
  public ScmKernel () {
    environments = new ScmStack ();
    environments.push (new ScmEnvironment (211));
  }
 
  /**
   * Create a new kernel with the given environment
   */
  public ScmKernel (ScmStack envs) {
    environments = envs;
  }
 
  /**
   * Scheme expression evaluation
   * @param  exp The expression to evaluate
   * @return the result of the evaluation
   */
  public ScmObject eval (ScmObject exp) throws ScmException {
    try {
      return evalAux2 (exp, environments);
    } catch (ScmCallCCException e) {
      return e.getResult();
    }
  }

  /**
   * Scheme expression evaluation auxiliary function 1
   */
  public static ScmObject evalAux1 (ScmObject exp, ScmStack envirs)
    throws ScmException {
    ScmObject       expression = exp;
    ScmStack        envs       = envirs;
    ScmObject       result     = ScmUndefined.UNDEFINED;
    ScmStack        substs     = new ScmStack ();
    ScmSubstitution subst;

    if (expression instanceof ScmSubstitution)
      subst = (ScmSubstitution)expression;
    else {
      ScmStack exprs = new ScmStack ();
      exprs.pushReusable (expression);
      subst = new ScmSubstitution (exprs, envs);
    }

    substs.pushReusable (subst);

    while (!substs.empty()) {
      subst = (ScmSubstitution)substs.pop();
      
      while (!subst.getExpressions().empty()) {
	expression = (ScmObject)subst.getExpressions().pop();
	envs       = subst.getEnvironments();

	if (expression instanceof ScmSymbol) // Symbol
	  result = find ((ScmSymbol)expression, envs);

	else if (expression instanceof ScmPair) { // Pair
	  ScmPair pair = (ScmPair)expression;

	  if (pair == ScmPair.NULL)
	    error ("Cannot evaluate ()");
	  
	  ScmObject obj = evalAux2 (pair.getCar(), envs);
	  if (!(obj instanceof ScmProcedure))
	    error (pair.getCar()+" is not a procedure");

	  ScmProcedure proc = (ScmProcedure)obj;
	  
	  if (obj instanceof ScmSyntax) {
	    // Construction of argument vector without evaluation
	    //
	    obj = pair.getCdr();
	    ScmArray args = new ScmArray();

	    while ((obj != ScmPair.NULL) && (obj instanceof ScmPair)) {
	      args.add (((ScmPair)obj).getCar());
	      obj = ((ScmPair)obj).getCdr();
	    }
    
	    if (obj != ScmPair.NULL)
	      error ("Malformed params :"+pair.getCdr());

	    result = proc.call (args, envs);	    
	  } else {
	    // Construction of argument vector with evaluation of each
	    // argument
	    //
	    obj = pair.getCdr();
	    ScmArray args = new ScmArray();

	    while ((obj != ScmPair.NULL) && (obj instanceof ScmPair)) {
	      args.add (evalAux2(((ScmPair)obj).getCar(), envs));
	      obj = ((ScmPair)obj).getCdr();
	    }
    
	    if (obj != ScmPair.NULL)
	      error ("Malformed params :"+pair.getCdr());

	    result = proc.call (args, envs);
	  }
	} else // Other
	  result = expression;
	
        if (result instanceof ScmSubstitution) {
          if (!subst.getExpressions().empty())
            substs.pushReusable (subst);
          subst = (ScmSubstitution)result;
        }

      } // while
    } // while
    return result;
  }
  
  /**
   * Scheme expression evaluation auxiliary function 2
   */
  public static ScmObject evalAux2 (ScmObject exp, ScmStack envs)
    throws ScmException {
    if (exp instanceof ScmSymbol)
      return find ((ScmSymbol)exp, envs);

    else if ((exp instanceof ScmPair) || (exp instanceof ScmSubstitution))
      return evalAux1 (exp, envs);

    else
      return exp;
  }

  /**
   * Binds a symbol to an object in the global environment
   * @param name The representation of the symbol
   * @param obj  The object to bind
   */
  public void define (String name, ScmObject obj) {
    ((ScmEnvironment)environments.firstElement()).define (new ScmSymbol (name), obj);
  }
 
  /**
   * Finds the definition of a symbol in the environment
   * @param symb The symbol
   * @param envs The environment where to find the definition
   * @return the object binded to symb
   */
  public static ScmObject find (ScmSymbol symb, ScmStack envs)
    throws ScmException {
    ScmEnvironment env;
    ScmObject      result = null;
    ScmStack       tmp = (ScmStack)envs.clone();

    while (result == null && !tmp.empty()) {
      env = (ScmEnvironment)tmp.pop();
      result = env.find (symb);
    }

    if (result == null)
      throw new ScmException (symb+" undefined");
    else
      return result;    
  }

  /**
   * Error procedure
   */
  private static void error (String mess) throws ScmException {
    ScmUndefined.UNDEFINED.error (mess);
  }
}
