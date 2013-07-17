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
 * The Scheme language 'map' procedure
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/10
 */
public class ScmMap extends ScmPredefined {

  /**
   * The instance of this class
   */
  public final static ScmMap INSTANCE = new ScmMap ();

  /**
   * The action of the procedure
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    if (args.size() < 2)
      error ("2 or more arguments expected");
    ScmProcedure p   = toProcedure (args.get(0));
    ScmObject    res = ScmPair.NULL;

    ScmPair [] lists = new ScmPair [args.size()-1];
    for (int i = 0; i < args.size()-1; i++)
      lists [i] = toPair(args.get(i+1));

    ScmObject [] ptab  = new ScmObject [lists.length];
    ScmArray     pargs = new ScmArray (ptab);
    boolean      done  = false;
    ScmPair      curs = ScmPair.NULL;

    while (!done) {
      for (int i = 0; i < lists.length; i++)
	if (lists [i] == ScmPair.NULL) {
	  done = true;
	  break;
        } else {
	  ptab  [i] = lists [i].getCar();
	  lists [i] = toPair(lists [i].getCdr());
	}

      if (!done) {
	ScmObject pres  = p.call (pargs, envs);
	if (pres instanceof ScmSubstitution)
	  pres = ScmKernel.evalAux1 (pres, envs);
	  
	if (res == ScmPair.NULL) {
	  curs = new ScmPair (pres, ScmPair.NULL);
	  res = curs;
	} else {
	  ScmPair mres = new ScmPair (pres, ScmPair.NULL);
	  curs.setCdr (mres);
	  curs = mres;
	}
      }
    }
    return res;
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString () {
    return "#[primitive map]";
  }
}
