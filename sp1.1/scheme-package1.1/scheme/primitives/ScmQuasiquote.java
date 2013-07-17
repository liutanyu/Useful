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
 * The Scheme language 'quasiquote' procedure
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/12
 */
public class ScmQuasiquote extends ScmPredefined implements ScmSyntax {
  /**
   * The instance of this class
   */
  public final static ScmQuasiquote INSTANCE = new ScmQuasiquote ();

  /**
   * The action of the procedure
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() != 1)
      error ("1 argument expected");

    return backquotify (args.get(0), envs, 1);
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString () {
    return "#[primitive quasiquote]";
  }

  /**
   * Recursive backquotation
   */
  private ScmObject backquotify (ScmObject obj,
				 ScmStack  envs,
				 int       level) throws ScmException {
    if (obj instanceof ScmVector) {
      ScmObject [] vect = ((ScmVector)obj).getValue();
      ScmPair      pair = ScmPair.NULL;

      for (int i = vect.length-1; i >= 0; i--) {
	pair = new ScmPair (vect [i], pair);
      }

      pair = (ScmPair)backquotify (pair, envs, level);

      int pl = 0;
      ScmPair tmp = pair;
      while (tmp != ScmPair.NULL) {
	pl++;
	tmp = (ScmPair)tmp.getCdr();
      }

      vect = new ScmObject [pl];

      for (int i = 0; i < vect.length; i++) {
	vect [i] = pair.getCar();
	pair = (ScmPair)pair.getCdr();
      }
      return new ScmVector (vect);
    }
    
    if (!(obj instanceof ScmPair) || obj == ScmPair.NULL)
      return obj;

    ScmPair pair = (ScmPair)obj;
    
    if (pair.getCar().isEqual(ScmSymbol.QUASIQUOTE) || pair.getCar() == INSTANCE) {
      pair = toNonNullPair(pair.getCdr());
      return new ScmPair (ScmSymbol.QUASIQUOTE,
			  new ScmPair (backquotify(pair.getCar(), envs, level+1),
				       ScmPair.NULL));
      }

    if (pair.getCar().isEqual(ScmSymbol.UNQUOTE) ||
	pair.getCar() == ScmUnquote.INSTANCE) {
      pair = toNonNullPair(pair.getCdr());

      if (level == 1)
	return ScmKernel.evalAux2 (pair.getCar(), envs);
      else
	return new ScmPair (ScmSymbol.UNQUOTE,
			    new ScmPair (backquotify(pair.getCar(), envs, level-1),
					 ScmPair.NULL));
    }

    if ((pair.getCar() instanceof ScmPair) && pair.getCar() != ScmPair.NULL &&
	(((ScmPair)pair.getCar()).getCar().isEqual(ScmSymbol.UNQUOTE_SPLICING) ||
	 ((ScmPair)pair.getCar()).getCar() == ScmUnquoteSplicing.INSTANCE)) {
      if (pair.getCdr() == ScmPair.NULL)
	return ScmKernel.evalAux2 
	    (((ScmPair)((ScmPair)pair.getCar()).getCdr()).getCar(), envs);
      else {
	ScmPair tmp = toNonNullPair(((ScmPair)pair.getCar()).getCdr());
	if (tmp.getCar() == ScmPair.NULL)
	  return backquotify (pair.getCdr(), envs, level);
	else
	  return append (ScmKernel.evalAux2 (tmp.getCar(), envs),
			 backquotify (pair.getCdr(), envs, level));
	}
      } 

    return new ScmPair (backquotify (pair.getCar(), envs, level),
			backquotify (pair.getCdr(), envs, level));
  }

  /**
   * Appends two lists
   */
  private ScmObject append (ScmObject obj1, ScmObject obj2) throws ScmException {
    if (!(obj1 instanceof ScmPair))
      error ("List expected: "+obj1);

    ScmPair   p1  = (ScmPair)obj1;
    ScmPair   p2  = ScmPair.NULL;
    ScmPair   p3;
    ScmObject res = obj2;

    while (p1 != ScmPair.NULL) {
      if (p2 == ScmPair.NULL) {
	p2 = new ScmPair (p1.getCar(), obj2);
	res = p2;
      } else {
	p3 = new ScmPair (p1.getCar(), obj2);
	p2.setCdr (p3);
	p2 = p3;
      }

      p1 = toPair(p1.getCdr());
    }
    return res;
  }
}
