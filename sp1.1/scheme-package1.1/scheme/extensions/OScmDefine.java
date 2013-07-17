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
 * This procedure creates a new class variable
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/30
 */
public class OScmDefine extends ScmPredefined implements OScmMethod, ScmSyntax {

  /**
   * The instance of this class
   */
  public final static OScmDefine INSTANCE = new OScmDefine ();

  /**
   * The action of the procedure.
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() < 3)
      error ("3 or more arguments expected");

    if (!(args.get(0) instanceof OScmClass))
      error ("Class expected: "+args.get(0));

    ScmEnvironment sh = ((OScmClass)args.get(0)).getShared();

    if (args.get(1) instanceof ScmSymbol) {
      if (args.size() > 3)
	error ("3 arguments expected");

      sh.define (toSymbol(args.get(1)), ScmKernel.evalAux2 (args.get(2), envs));
    } else if ((args.get(1) instanceof ScmPair) && (args.get(1) != ScmPair.NULL)) {
      ScmPair   pair = (ScmPair)args.get(1);
      ScmSymbol name = toSymbol (pair.getCar());
      ScmArray  lp   = new ScmArray ();

      lp.add (pair.getCdr());

      for (int i = 2; i < args.size(); i++)
	lp.add (args.get(i));
      
      sh.define (name, OScmDefineMethod.INSTANCE.apply (lp, envs));
    } else
      error ("Pair or symbol expected: "+args.get(1));

    return ScmUndefined.UNDEFINED;
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString ()
  {
    return "#[method define]";
  }
}
