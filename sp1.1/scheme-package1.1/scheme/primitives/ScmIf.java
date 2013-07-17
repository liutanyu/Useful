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
 * The Scheme language 'if' procedure
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/10
 */
public class ScmIf extends ScmPredefined implements ScmSyntax {

  /**
   * The instance of this class
   */
  public final static ScmIf INSTANCE = new ScmIf ();

  /**
   * The action of the procedure : conditional evaluation
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() != 2 && args.size() != 3)
      error ("2 or 3 arguments expected");

    ScmStack exps = new ScmStack ();

    if (ScmKernel.evalAux2(args.get(0), envs) == ScmBoolean.F) {
      if (args.size() == 3) {
	exps.pushReusable (args.get(2));
	return new ScmSubstitution (exps, envs);
      } else
	return ScmUndefined.UNDEFINED;
    } else {
      exps.pushReusable (args.get(1));
      return new ScmSubstitution (exps, envs);      
    }
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString ()
  {
    return "#[primitive if]";
  }
}
