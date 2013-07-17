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
package scheme.extensions;

import scheme.kernel.*;

/** 
 * User defined method
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/12
 */
public class OScmClosure extends ScmProcedure implements OScmMethod {
  // Private members
  //
  public ScmArray  parameters;
  public ScmSymbol lparameters;
  public ScmArray  expressions;
  public ScmStack  envDef;

  /** 
   * Create a new method
   */
  public OScmClosure (ScmArray  params,
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
    // TODO
    return false;
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
    
    if (!(args.get(0) instanceof OScmObject))
      error ("First argument must be an object: "+args.get(0));

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
    
    envDef.push (((OScmObject)args.get(0)).getFieldEnvironment());
    envDef.push (localEnv);
    ScmObject result = new ScmSubstitution (exps, (ScmStack)envDef.clone());
    envDef.pop();
    envDef.pop();
    return result;
  }

  /**
   * External representation
   */
  public String toString () {
    return "#[method "+hashCode()+"]";
  }
}
