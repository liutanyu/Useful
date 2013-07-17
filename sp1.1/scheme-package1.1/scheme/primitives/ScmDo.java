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
 * The Scheme language 'do' procedure
 *
 * @author  Stephane Hillion
 * @version 1.1 - 1998/12/10
 */
public class ScmDo extends ScmPredefined implements ScmSyntax {

  /**
   * The instance of this class
   */
  public final static ScmDo INSTANCE = new ScmDo ();

  /**
   * The action of the procedure : conditional evaluation
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() < 2)
      error ("2 or more arguments expected");

    ScmArray       vars  = new ScmArray ();
    ScmEnvironment steps = new ScmEnvironment ();
    pushEnv (toPair(args.get(0)), envs, vars, steps);

    ScmPair        clause = toNonNullPair(args.get(1));
    while (ScmKernel.evalAux2 (clause.getCar(), envs) == ScmBoolean.F) {
      // Commands evaluation
      //
      for (int i = 2; i < args.size(); i++)
	ScmKernel.evalAux2 (args.get(i), envs);

      // Actions evaluation
      //
      ScmEnvironment env = new ScmEnvironment ();
      for (int i = 0; i < vars.size(); i++) {
	ScmSymbol symb = (ScmSymbol)vars.get(i);
	ScmObject obj  = steps.find (symb);
	if (obj != null)
	  env.define (symb, ScmKernel.evalAux2 (obj, envs));
        else
	  env.define (symb, ((ScmEnvironment)envs.peek()).find(symb));
      }

	envs.pop();
	envs.push(env);
    }

    if (toPair(clause.getCdr()) == ScmPair.NULL)
      return ScmUndefined.UNDEFINED;

    ScmStack exps = new ScmStack ();
    while ((clause = toPair(clause.getCdr())) != ScmPair.NULL)
      exps.addReusableLast (clause.getCar());

    ScmSubstitution res = new ScmSubstitution (exps, (ScmStack)envs.clone());
    envs.pop();

    return res;
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString () {
    return "#[primitive do]";
  }

  /**
   * 
   */
  private void pushEnv (ScmPair        bind,
			ScmStack       envs,
			ScmArray       vars,
			ScmEnvironment step) throws ScmException {
    ScmPair        pair = bind;
    ScmEnvironment env  = new ScmEnvironment ();
    envs.push (env);

    while (pair != ScmPair.NULL) {
      ScmPair   def  = toNonNullPair (pair.getCar());
      ScmSymbol symb = toSymbol (def.getCar());

      vars.add (symb);

      ScmPair rest = toNonNullPair (def.getCdr());

      if (rest.getCdr() != ScmPair.NULL) {
	ScmPair tmp = toPair (rest.getCdr());
	if (tmp.getCdr() != ScmPair.NULL)
	  error ("Malformed binding"+tmp.getCdr());
	step.define (symb, tmp.getCar());
      }
      env.define (symb, ScmKernel.evalAux2 (rest.getCar(), envs));
      pair = toPair (pair.getCdr());
    }
  }
}
