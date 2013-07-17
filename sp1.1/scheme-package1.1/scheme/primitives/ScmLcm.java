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
 * The Scheme language lcm procedure
 *
 * @author  Stephane Hillion
 * @version 1.0 - 1998/12/10
 */
public class ScmLcm extends ScmPredefined {

  /**
   * The instance of this class
   */
  public final static ScmLcm INSTANCE = new ScmLcm ();

  /**
   * The action of the procedure
   */
  protected ScmObject apply (ScmArray args, ScmStack envs) throws ScmException {
    ScmNumber n1  = ScmInteger.ONE;
    int       i  = 0;

    if (args.size() > 0) {
      n1 = toNumber (args.get(0));
      i++;
    }

    for (; i < args.size(); i++) {
      ScmNumber n2 = toNumber (args.get(i));
      
      if (n2.isEqual(ScmInteger.ZERO)) {
	n1 = n2;
	break;
      } else
	n1 = (n1.mul(n2.abs())).quotient(n1.gcd(n2.abs()));
    }

    return n1;
  }

  /** 
   * @return The external representation of the procedure
   */
  public String toString () {
    return "#[primitive lcm]";
  }
}
