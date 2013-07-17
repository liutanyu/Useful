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
 * The Scheme language definition (define)
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/10
 */
public class ScmDefine extends ScmPredefined implements ScmSyntax {

  /**
   * The instance of this class
   */
  public final static ScmDefine INSTANCE = new ScmDefine ();

  /**
   * The action of the procedure : binds a symbol to an object in
   * the current environment
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() < 2)
      error ("2 or more arguments expected");

    ScmObject arg = args.get(0);

    if (arg instanceof ScmSymbol) {
      if (args.size() > 2)
	error ("2 arguments expected");

      ScmEnvironment env = (ScmEnvironment)envs.peek();
      env.define ((ScmSymbol)arg, ScmKernel.evalAux2(args.get(1), envs));      
    } else if ((arg instanceof ScmPair) && (arg != ScmPair.NULL)) {
      ScmPair pair = (ScmPair)arg;
      ScmSymbol fname = toSymbol(pair.getCar());
      ScmArray lp       = new ScmArray ();

      lp.add (pair.getCdr ());
            
      for (int i = 1; i < args.size (); i++)
	lp.add (args.get (i));

      ScmEnvironment env = (ScmEnvironment)envs.peek();
      env.define(fname, ScmLambda.INSTANCE.apply (lp, envs));
    } else
      error (args.get(0)+" must be a pair or a symbol");

    return ScmUndefined.UNDEFINED;
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString ()
  {
    return "#[primitive define]";
  }
}
