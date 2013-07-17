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
 * The Scheme language 'let' procedure
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/12
 */
public class ScmLet extends ScmPredefined implements ScmSyntax {

  /**
   * The instance of this class
   */
  public final static ScmLet INSTANCE = new ScmLet ();

  /**
   * The action of the procedure
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() < 2)
      error ("2 or more arguments expected");

    ScmStack  exps = new ScmStack ();

    if (args.get(0) instanceof ScmSymbol) {
      if (args.size() < 3)
	error ("3 or more arguments expected");
      
      ScmPair  bindings = toPair(args.get(1));
      ScmStack evs      = (ScmStack)envs.clone();

      evs.push (buildLambda ((ScmSymbol)args.get(0),
			     bindings,
			     args.subArray (2, args.size()),
			     evs));
      evs.push (buildEnv (bindings, evs));

      for (int i = args.size()-1; i >= 2; i --)
	exps.pushReusable (args.get(i));

      return new ScmSubstitution (exps, evs);
    } else {
      ScmStack evs = (ScmStack)envs.clone();
      
      evs.push (buildEnv (toPair(args.get(0)), evs));

      for (int i = args.size()-1; i >= 1; i --)
	exps.pushReusable (args.get(i));
      
      return new ScmSubstitution (exps, evs);
    }
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString ()
  {
    return "#[primitive let]";
  }

  /**
   * Build the lambda equivalent to a named let
   */
  private ScmEnvironment buildLambda (ScmSymbol  label,
				      ScmPair    bind,
				      ScmArray   body,
				      ScmStack   envs) throws ScmException {
    ScmPair tmp = bind;
    ScmEnvironment env = new ScmEnvironment ();

    ScmArray symbs = new ScmArray ();

    while (tmp != ScmPair.NULL) {
      symbs.add (toSymbol(toNonNullPair(tmp.getCar()).getCar()));
      tmp = toPair(tmp.getCdr ());	
    }

    envs.push  (env);
    env.define (label, new ScmClosure (symbs, null, body, envs));
    envs.pop   ();

    return env;
  }

  /**
   * Create the local environment of the let
   */
  private ScmEnvironment buildEnv (ScmPair defs, ScmStack envs) throws ScmException
  {
    ScmPair tmp = defs;
    ScmEnvironment env = new ScmEnvironment ();

    while (tmp != ScmPair.NULL)
      {
        ScmPair   def  = toNonNullPair(tmp.getCar());
        ScmSymbol symb = toSymbol(def.getCar());
	ScmPair   rest = toNonNullPair(def.getCdr());

        if (rest.getCdr() != ScmPair.NULL)
          error ("Malformed binding");

        ScmObject obj = ScmKernel.evalAux2 (rest.getCar(), envs);
	env.define (symb, obj);

        tmp = toPair(tmp.getCdr());
      }
    return env;
  }
}
