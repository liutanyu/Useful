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
 * The predefined procedure 'lambda'
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/12
 */

public class ScmLambda extends ScmPredefined implements ScmSyntax {
  /** 
   * The instance of this class
   */
  public final static ScmLambda INSTANCE = new ScmLambda ();

  /**
   * The action of the procedure : create a new closure
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() < 2)
      error ("2 or more arguments expected");

    ScmArray  params  = new ScmArray ();
    ScmSymbol lparams = null;

    ScmObject obj = args.get(0);

    if (obj instanceof ScmPair) {
      while ((obj instanceof ScmPair) &&
	     obj != ScmPair.NULL &&
	     (((ScmPair)obj).getCar() instanceof ScmSymbol)) {
	params.add (((ScmPair)obj).getCar());
	obj = ((ScmPair)obj).getCdr();
      }

      if (obj != ScmPair.NULL)
	lparams = toSymbol(obj);
    } else if (obj instanceof ScmSymbol)
      lparams = (ScmSymbol)obj;
    else
      error("Bad arguments list");

    ScmArray exps = new ScmArray();

    for (int i = 1; i < args.size(); i++)
      exps.add (args.get(i));

    return new ScmClosure (params, lparams, exps, envs);
  }

  /** 
   * External representation
   */
  public String toString () {
    return "#[primitive lambda]";
  }
}
