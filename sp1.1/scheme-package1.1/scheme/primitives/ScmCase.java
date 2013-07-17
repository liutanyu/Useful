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
package scheme.primitives;

import scheme.kernel.*;

/**
 * The Scheme language 'case' procedure
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/19
 */
public class ScmCase extends ScmPredefined implements ScmSyntax {

  /**
   * The instance of this class
   */
  public final static ScmCase INSTANCE = new ScmCase ();

  /**
   * The action of the procedure : conditional evaluation
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() < 2)
      error ("2 or more arguments expected");

    ScmObject key    = ScmKernel.evalAux2 (args.get(0), envs);

    for (int i = 1; i < args.size(); i++) {
      ScmPair   pair = toNonNullPair (args.get(i));
      ScmObject obj  = null;

      if (pair.getCar().isEqual (ScmSymbol.ELSE)) {
	if (i+1 < args.size())
	  error ("'else' clause is not the last");
	else
	  obj = ScmSymbol.ELSE;
	if (pair.getCdr() == ScmPair.NULL)
	  error ("else clause must contain 1 or more expressions");
      } else {
	obj = ScmBoolean.F;
	ScmPair datum = toPair (pair.getCar());

	while (datum != ScmPair.NULL && obj != ScmBoolean.T) {
	  if (key.isEqual (datum.getCar()))
	    obj = ScmBoolean.T;
	  datum = toPair (datum.getCdr());
	}
      }
	
      if (obj != ScmBoolean.F) {
	ScmPair exps   = toNonNullPair (pair.getCdr());
	ScmStack exprs = new ScmStack ();

	while (exps != ScmPair.NULL) {
	  exprs.addReusableLast (exps.getCar());
	  exps = toPair (exps.getCdr());
	}
	return new ScmSubstitution (exprs, envs);
      }
    }

    return ScmUndefined.UNDEFINED;
  }

  /** 
   * The external representation of the procedure
   */
  public String toString ()
  {
    return "#[primitive case]";
  }
}
