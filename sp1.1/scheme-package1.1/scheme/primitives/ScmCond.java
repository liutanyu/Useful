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
 * The Scheme language 'cond' procedure
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/13
 */
public class ScmCond extends ScmPredefined implements ScmSyntax {

  /**
   * The instance of this class
   */
  public final static ScmCond INSTANCE = new ScmCond ();

  /**
   * The action of the procedure
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() < 1)
      error ("1 or more arguments expected");

    for (int i = 0; i < args.size(); i++) {
      ScmPair   clause = toNonNullPair(args.get(i));
      ScmObject obj    = null;

      if (clause.getCar().isEqual(ScmSymbol.ELSE)) {
	if (i+1 < args.size())
	  error ("else clause must be the last");
	else
	  obj = ScmSymbol.ELSE;
	if (clause.getCdr() == ScmPair.NULL)
	  error ("else clause must contain 1 or more expressions");
      } else
	obj = ScmKernel.evalAux2 (clause.getCar(), envs);

      if (obj != ScmBoolean.F) {
	ScmPair exps = toPair(clause.getCdr());
	if (exps == ScmPair.NULL)
	  return obj;

	if (!obj.isEqual(ScmSymbol.ELSE) &&
	    exps.getCar().isEqual(ScmSymbol.IMPLIES)) {
	  ScmPair exp =
	      new ScmPair(toNonNullPair(exps.getCdr()).getCar(),
			  new ScmPair(new ScmPair(ScmQuote.INSTANCE,
						  new ScmPair (obj, ScmPair.NULL)),
				      ScmPair.NULL));
	  ScmStack exprs = new ScmStack ();
	  exprs.pushReusable (exp);
	  return new ScmSubstitution (exprs, envs);
	} else {
	  ScmStack exprs = new ScmStack ();
	  while (exps != ScmPair.NULL) {
	    exprs.addReusableLast (exps.getCar());
	    exps = toPair(exps.getCdr());
	  }
	  return new ScmSubstitution (exprs, envs);
	}
      }
    }
    return ScmUndefined.UNDEFINED;
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString ()
  {
    return "#[primitive cond]";
  }
}
