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
 * The Scheme language 'make-vector' procedure
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/11/24
 */
public class ScmMakeVector extends ScmPredefined {

  /**
   * The instance of this class
   */
  public final static ScmMakeVector INSTANCE = new ScmMakeVector ();

  /**
   * The action of the procedure
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    ScmVector res = null;

    if (args.size() == 1) {
      int n = toInteger(args.get(0)).getValue();
      if (n < 0)
	error ("Out of bound argument: "+n);

      res = new ScmVector (n);
    } else if (args.size() == 2) {
      int n = toInteger(args.get(0)).getValue();
      if (n < 0)
	error ("Out of bound argument: "+n);

      res = new ScmVector (n, args.get(1));
    } else
      error ("1 or 2 arguments expected");

    return res;
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString () {
    return "#[primitive make-vector]";
  }
}
