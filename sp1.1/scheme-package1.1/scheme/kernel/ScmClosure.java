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

/** 
 * User defined procedure (closure created by <code>lambda</code>)
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/12
 */
public class ScmClosure extends ScmProcedure {
  /** The list of named parameters */
  protected ScmArray  parameters;
  /** Optional parameters */
  protected ScmSymbol lparameters;
  /** Body of the procedure */
  protected ScmArray  expressions;
  /** Procedure's environment of definition */
  protected ScmStack  envDef;

  /** 
   * Creates a new closure.
   * @param params  the list of named parameters (symbols)
   * @param lparams the optional parameters or <code>null</code>
   * @param exps    the body of the procedure
   * @param envs    the definition environment
   */
  public ScmClosure (ScmArray  params,
		     ScmSymbol lparams,
		     ScmArray  exps,
		     ScmStack  envs) {
    parameters  = params;
    lparameters = lparams;
    expressions = exps;
    envDef      = (ScmStack)envs.clone();
  }

  /**
   * Object structural equality
   *
   * @param      obj - The object to test
   * @return     true if this and obj have the same structure
   */
  public boolean isEqual (ScmObject other) {
    return isEq (other);
  }

  /**
   * The action of the procedure
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    ScmEnvironment localEnv = new ScmEnvironment ();

    if (lparameters == null) {
      if (args.size () != parameters.size ())
	error("Bad number of parameters");
    } else if (args.size () < parameters.size ())
        error("Bad number of parameters");
    
    int i;
    for (i = 0; i < parameters.size(); i++)
      localEnv.define ((ScmSymbol)parameters.get(i), args.get(i));

    if (lparameters != null) {
      ScmPair varArgs = ScmPair.NULL;

      for (int j = args.size()-1; j >= i; j--)
	varArgs = new ScmPair (args.get(j), varArgs);

      localEnv.define (lparameters, varArgs);
    }

    ScmStack exps = new ScmStack ();

    for (i = expressions.size()-1; i >= 0; i--)
      exps.pushReusable (expressions.get(i));

    envDef.push (localEnv);
    ScmObject result = new ScmSubstitution (exps, (ScmStack)envDef.clone());
    envDef.pop();
    return result;
  }

  /**
   * External representation
   */
  public String toString () {
    return "#[closure "+hashCode()+"]";
  }
}
