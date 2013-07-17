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
 * The Scheme language 'letstar' procedure
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/13
 */
public class ScmLetstar extends ScmPredefined implements ScmSyntax {

  /**
   * The instance of this class
   */
  public final static ScmLetstar INSTANCE = new ScmLetstar ();

  /**
   * The action of the procedure
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() < 2)
      error ("2 or more arguments expected");

    ScmPair  defs = toPair(args.get(0));
    ScmStack senv = (ScmStack)envs.clone();
    ScmPair  tmp  = defs;

    // first push an empty environment to allow local definitions
    // even if binding list is empty
    senv.push (new ScmEnvironment ());
    
    while (tmp != ScmPair.NULL) {
      ScmPair   def  = toNonNullPair(tmp.getCar());
      ScmSymbol symb = toSymbol(def.getCar());
      ScmPair   rest = toNonNullPair(def.getCdr());

      if (rest.getCdr() != ScmPair.NULL)
	error ("Malformed binding");

      ScmObject obj = ScmKernel.evalAux2 (rest.getCar(), senv);

      ScmEnvironment env = new ScmEnvironment ();
      senv.push (env);
      env.define (symb, obj);

      tmp = toPair(tmp.getCdr());
    }

    ScmStack exps = new ScmStack ();

    for (int i = args.size()-1; i >= 1; i --)
      exps.pushReusable (args.get(i));
      
    return new ScmSubstitution (exps, senv);
  }

  /** 
   * The external representation of the procedure
   */
  public String toString ()
  {
    return "#[primitive let*]";
  }
}
